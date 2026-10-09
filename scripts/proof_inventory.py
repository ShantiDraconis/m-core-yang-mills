#!/usr/bin/env python3
"""Kernel-derived proof inventory for a Lake project.

Builds every module of the project's Lean library (not only the modules the
root file imports), then asks the Lean kernel, for every theorem, which axioms
it depends on.  It also lists every closed `Prop` definition, which theorems
inhabit or refute it, and flags vacuous `Prop` definitions whose body is
`... -> True`.

Nothing here is edited by hand: the JSON and Markdown outputs are regenerated
from the kernel on every run.

usage:
  python3 scripts/proof_inventory.py [--out inventory] [--strict] [--check-committed]

--strict           exit 1 if a module in the default build fails, a theorem
                   depends on sorryAx, or a theorem depends on an axiom declared
                   inside this project.
--check-committed  warn (GitHub annotation) when the committed inventory differs
                   from the regenerated one.
"""

import argparse
import json
import os
import re
import subprocess
import sys
from pathlib import Path

STANDARD_AXIOMS = ["Classical.choice", "Quot.sound", "propext"]
SCHEMA = "proof-inventory.v1"

LEAN_META = r'''
open Lean

namespace ProofInventoryTool

partial def peelForall : Expr → Expr
  | .forallE _ _ b _ => peelForall b
  | .mdata _ e => peelForall e
  | e => e

partial def peelLam : Expr → Expr
  | .lam _ _ b _ => peelLam b
  | .mdata _ e => peelLam e
  | e => e

partial def stripMData : Expr → Expr
  | .mdata _ e => stripMData e
  | e => e

def deps (ci : ConstantInfo) : Array Name :=
  let t := ci.type.getUsedConstants
  match ci with
  | .defnInfo v => t ++ v.value.getUsedConstants
  | .thmInfo v => t ++ v.value.getUsedConstants
  | .opaqueInfo v => t ++ v.value.getUsedConstants
  | .inductInfo v => t ++ v.ctors.toArray
  | _ => t

def generatedSuffixes : List String :=
  ["eq_def", "injEq", "inj", "sizeOf_spec", "below", "ibelow", "ctorIdx",
   "noConfusionType", "brecOn", "binductionOn", "casesOn", "recOn", "ofNat_ctorIdx",
   "toCtorIdx", "ofNat_toCtorIdx"]

def userName (env : Environment) (n : Name) : Option Name :=
  let u := (privateToUserName? n).getD n
  if u.isInternalDetail then none
  else if isAuxRecursor env n || isNoConfusion env n || Meta.isMatcherCore env n then none
  else match u with
    | .str _ s => if generatedSuffixes.contains s then none else some u
    | _ => some u

def moduleOf (env : Environment) (n : Name) : Option Name :=
  match env.getModuleIdxFor? n with
  | some idx => env.header.moduleNames[idx.toNat]?
  | none => some env.mainModule

def run (roots : List String) (onlyModule : Option String) : CoreM String := do
  let env ← getEnv
  let inPackage : Name → Bool := fun m =>
    roots.contains m.getRoot.toString &&
      match onlyModule with
      | some om => m.toString == om
      | none => true
  -- package constants
  let pkg : Array (Name × Name × ConstantInfo) :=
    env.constants.fold (fun acc n ci =>
      match moduleOf env n with
      | some m => if inPackage m then acc.push (n, m, ci) else acc
      | none => acc) #[]
  let thmRoots : Array Name := pkg.filterMap fun (n, _, ci) =>
    match ci with
    | .thmInfo _ => some n
    | _ => none
  -- iterative DFS postorder over everything reachable from package theorems
  let mut visited : Std.HashSet Name := {}
  let mut depMap : Std.HashMap Name (Array Name) := {}
  let mut order : Array Name := #[]
  for r in thmRoots do
    if visited.contains r then continue
    visited := visited.insert r
    let rds := match env.find? r with | some ci => deps ci | none => #[]
    depMap := depMap.insert r rds
    let mut stack : Array (Name × Nat) := #[(r, 0)]
    while stack.size > 0 do
      let (n, i) := stack.back!
      let ds := depMap.getD n #[]
      if i < ds.size then
        stack := stack.set! (stack.size - 1) (n, i + 1)
        let d := ds[i]!
        if !visited.contains d then
          visited := visited.insert d
          let dds := match env.find? d with | some ci => deps ci | none => #[]
          depMap := depMap.insert d dds
          stack := stack.push (d, 0)
      else
        stack := stack.pop
        order := order.push n
  -- axiom bitmasks, propagated to a fixpoint (handles mutual cycles)
  let mut axIdx : Std.HashMap Name Nat := {}
  let mut axNames : Array Name := #[]
  for n in order do
    if let some (.axiomInfo _) := env.find? n then
      axIdx := axIdx.insert n axNames.size
      axNames := axNames.push n
  let mut mask : Std.HashMap Name Nat := {}
  let mut changed := true
  while changed do
    changed := false
    for n in order do
      let own := match axIdx[n]? with | some i => 1 <<< i | none => 0
      let m := (depMap.getD n #[]).foldl (fun acc d => acc ||| mask.getD d 0) own
      if m != mask.getD n 0 then
        mask := mask.insert n m
        changed := true
  let axiomsOf : Name → Array Name := fun n =>
    let m := mask.getD n 0
    (List.range axNames.size).toArray.filterMap fun i =>
      if (m >>> i) % 2 == 1 then some axNames[i]! else none
  -- closed Prop definitions and vacuous Prop-valued definitions
  let mut propDefs : Std.HashMap Name (Name × Bool × Bool) := {}
  for (n, m, ci) in pkg do
    if let .defnInfo v := ci then
      if (peelForall v.type).isProp then
        let vac := (peelForall (peelLam v.value)).isConstOf ``True
        propDefs := propDefs.insert n (m, v.type.isProp, vac)
  let mut inhabit : Std.HashMap Name (Array Name) := {}
  let mut refute : Std.HashMap Name (Array Name) := {}
  for (n, _, ci) in pkg do
    if let .thmInfo v := ci then
      let t := stripMData v.type
      if t.isConst && propDefs.contains t.constName! then
        inhabit := inhabit.insert t.constName! ((inhabit.getD t.constName! #[]).push n)
      let neg? : Option Name :=
        if t.isAppOfArity ``Not 1 && (stripMData t.appArg!).isConst then
          some (stripMData t.appArg!).constName!
        else match t with
          | .forallE _ a b _ =>
              if (stripMData a).isConst && (stripMData b).isConstOf ``False then
                some (stripMData a).constName!
              else none
          | _ => none
      if let some g := neg? then
        if propDefs.contains g then
          refute := refute.insert g ((refute.getD g #[]).push n)
  let showNames : Array Name → String := fun xs =>
    ",".intercalate (xs.toList.map toString)
  let mut out : Array String := #[]
  for (n, m, ci) in pkg do
    match ci with
    | .thmInfo _ =>
        if let some u := userName env n then
          out := out.push s!"THM\t{u}\t{m}\t{showNames (axiomsOf n)}"
    | .axiomInfo _ =>
        if let some u := userName env n then
          out := out.push s!"AXDECL\t{u}\t{m}"
    | _ => pure ()
  for (n, (m, arity0, vac)) in propDefs.toList do
    if let some u := userName env n then
      if arity0 || vac then
        let inh := (inhabit.getD n #[]).filterMap (userName env)
        let ref := (refute.getD n #[]).filterMap (userName env)
        out := out.push s!"PROP\t{u}\t{m}\t{if arity0 then 1 else 0}\t{if vac then 1 else 0}\t{showNames inh}\t{showNames ref}"
  return "\n".intercalate out.toList

end ProofInventoryTool

#eval show CoreM Unit from do
  let roots := ((← IO.getEnv "INVENTORY_ROOTS").getD "").splitOn ","
  let only := (← IO.getEnv "INVENTORY_MODULE")
  let outPath := (← IO.getEnv "INVENTORY_OUT").getD "inventory.tsv"
  let text ← ProofInventoryTool.run roots only
  IO.FS.writeFile outPath text
'''


def sh(cmd, cwd, env=None, timeout=None):
    return subprocess.run(cmd, cwd=cwd, env=env, capture_output=True, text=True, timeout=timeout)


def read_libs(root: Path):
    libs = []
    toml = root / "lakefile.toml"
    lean = root / "lakefile.lean"
    if toml.exists():
        import tomllib
        data = tomllib.loads(toml.read_text())
        for lib in data.get("lean_lib", []):
            libs.append((lib["name"], lib.get("srcDir", ".")))
    elif lean.exists():
        text = lean.read_text()
        for m in re.finditer(r"lean_lib\s+«?([\w.]+)»?(?:\s+where)?([\s\S]*?)(?=\n(?:@\[|lean_lib|lean_exe|require|package|\Z))", text + "\n"):
            src = re.search(r'srcDir\s*:=\s*"([^"]+)"', m.group(2))
            libs.append((m.group(1), src.group(1) if src else "."))
    if not libs:
        sys.exit("no lean_lib found in lakefile")
    return libs


def discover(root: Path, libs):
    mods = {}
    for name, src in libs:
        base = root / src
        top = base / f"{name}.lean"
        files = [top] if top.exists() else []
        if (base / name).is_dir():
            files += sorted((base / name).rglob("*.lean"))
        for f in files:
            if ".lake" in f.parts:
                continue
            mod = ".".join(f.relative_to(base).with_suffix("").parts)
            imports = re.findall(r"^import\s+(\S+)", f.read_text(errors="replace"), re.M)
            mods[mod] = {"path": str(f.relative_to(root)), "imports": imports, "lib": name}
    return mods


def closure(start, mods):
    seen, stack = set(), [start]
    while stack:
        m = stack.pop()
        if m in seen or m not in mods:
            continue
        seen.add(m)
        stack.extend(mods[m]["imports"])
    return seen


def build(root: Path, mods):
    names = sorted(mods)
    r = sh(["lake", "build", *names], root)
    log = r.stdout + r.stderr
    failed = {}
    for m in re.finditer(r"✖ \[\d+/\d+\] (?:Building|Compiling|Running) ([\w.«»']+)", log):
        if m.group(1) in mods:
            failed.setdefault(m.group(1), "")
    by_path = {v["path"]: k for k, v in mods.items()}
    for m in re.finditer(r"^error: (?:\./)*([^:\n]+\.lean):(\d+):(\d+): (.*)$", log, re.M):
        mod = by_path.get(m.group(1))
        if mod is not None:
            failed.setdefault(mod, "")
            if not failed[mod]:
                failed[mod] = f"{m.group(1)}:{m.group(2)}:{m.group(3)}: {m.group(4)}"[:300]
    return failed, r.returncode, log


def run_lean_inventory(root: Path, imports, roots, tmp: Path):
    tmp.mkdir(parents=True, exist_ok=True)
    src = tmp / "Inventory.lean"
    out = tmp / "inventory.tsv"
    src.write_text("import Lean\n" + "".join(f"import {m}\n" for m in sorted(imports)) + LEAN_META)
    env = dict(os.environ, INVENTORY_ROOTS=",".join(roots), INVENTORY_OUT=str(out))
    env.pop("INVENTORY_MODULE", None)
    if out.exists():
        out.unlink()
    r = sh(["lake", "env", "lean", str(src)], root, env=env)
    if r.returncode != 0 or not out.exists():
        return None, (r.stdout + r.stderr)[-3000:]
    return out.read_text(), ""


CLASH = re.compile(r"import (\S+) failed, environment already contains '([^']+)' from (\S+)")


def run_grouped(root: Path, ok, mods, roots, tmp: Path):
    """Import the maximal compiled modules together.  Modules that define the
    same declaration name cannot share one environment, so on a name clash the
    offending modules are moved to a later group.  Returns (texts, groups, clashes)."""
    okset = set(ok)
    clos = {m: closure(m, mods) & okset for m in ok}
    imported = set()
    for m in ok:
        imported |= {i for i in mods[m]["imports"] if i in okset}
    pending = sorted(m for m in ok if m not in imported)
    # the root module is always analysed (it may itself be imported by nothing)
    texts, groups, clashes = [], [], []
    while pending:
        group, deferred = list(pending), []
        while True:
            text, err = run_lean_inventory(root, group, roots, tmp)
            if text is not None:
                texts.append(text)
                groups.append(sorted(group))
                break
            m = CLASH.search(err)
            if not m:
                sys.exit(f"inventory extraction failed:\n{err}")
            x, name, y = m.group(1), m.group(2), m.group(3).rstrip(".,;")
            clashes.append({"module": x, "declaration": name, "already_defined_in": y})
            move = [l for l in group if x in clos[l] and y not in clos[l]]
            if not move:
                move = [l for l in group if y in clos[l] and x not in clos[l]]
            if not move or len(move) == len(group):
                sys.exit(f"cannot separate name clash {x} / {y} on {name}")
            group = [l for l in group if l not in move]
            deferred += move
        pending = deferred
    return texts, groups, clashes


def parse_tsv(texts):
    thms, props, axdecls = {}, {}, {}
    for text in texts:
        for line in text.splitlines():
            parts = line.split("\t")
            if parts[0] == "THM":
                thms[(parts[1], parts[2])] = sorted(a for a in parts[3].split(",") if a)
            elif parts[0] == "PROP":
                key = (parts[1], parts[2])
                row = props.setdefault(key, {"closed_prop": parts[3] == "1", "vacuous": parts[4] == "1",
                                             "inhabited_by": set(), "refuted_by": set()})
                row["inhabited_by"] |= {x for x in parts[5].split(",") if x}
                row["refuted_by"] |= {x for x in parts[6].split(",") if x}
            elif parts[0] == "AXDECL":
                axdecls[(parts[1], parts[2])] = True
    return thms, props, axdecls


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--root", default=".")
    ap.add_argument("--out", default="inventory")
    ap.add_argument("--strict", action="store_true")
    ap.add_argument("--check-committed", action="store_true")
    ap.add_argument("--loose-dir", action="append", default=None,
                    help="directory of stand-alone .lean files to compile with lake env lean (default: audit)")
    a = ap.parse_args()
    root = Path(a.root).resolve()
    gh = os.environ.get("GITHUB_ACTIONS") == "true"

    libs = read_libs(root)
    roots = sorted({n.split(".")[0] for n, _ in libs})
    mods = discover(root, libs)
    default_build = set()
    for name, _ in libs:
        default_build |= closure(name, mods)

    print(f"[inventory] {len(mods)} modules; building all of them")
    failed, rc, log = build(root, mods)
    blocked = {}
    for m in mods:
        if m in failed:
            continue
        bad = sorted(d for d in closure(m, mods) if d in failed and d != m)
        if bad:
            blocked[m] = bad[0]
    ok = sorted(m for m in mods if m not in failed and m not in blocked)
    if rc != 0 and not failed:
        print(log[-4000:])
        sys.exit("lake build failed but no failing module could be identified")
    print(f"[inventory] ok={len(ok)} failed={len(failed)} blocked={len(blocked)}")

    loose = []
    for d in (a.loose_dir if a.loose_dir is not None else ["audit"]):
        base = root / d
        if not base.is_dir():
            continue
        for f in sorted(base.rglob("*.lean")):
            if ".lake" in f.parts:
                continue
            r = sh(["lake", "env", "lean", str(f.relative_to(root))], root)
            errs = [l for l in (r.stdout + r.stderr).splitlines() if ": error:" in l or l.startswith("error:")]
            loose.append({"path": str(f.relative_to(root)), "status": "OK" if r.returncode == 0 else "FAILED",
                          **({"first_error": errs[0][:300]} if errs else {})})
    print(f"[inventory] stand-alone files: {sum(1 for x in loose if x['status'] == 'OK')}/{len(loose)} compile")

    tmp = root / ".lake" / "proof-inventory"
    texts, groups, clashes = run_grouped(root, ok, mods, roots, tmp) if ok else ([], [], [])
    print(f"[inventory] kernel extraction: {len(groups)} environment group(s), {len(clashes)} name clash(es)")
    thms, props, axdecls = parse_tsv(texts)

    pkg_axioms = {n for n, _ in axdecls}
    theorems = []
    for (n, mod) in sorted(thms):
        ax = thms[(n, mod)]
        if "sorryAx" in ax:
            st = "USES_SORRY"
        elif any(x in pkg_axioms for x in ax):
            st = "USES_PROJECT_AXIOM"
        elif any(x not in STANDARD_AXIOMS for x in ax):
            st = "NONSTANDARD_AXIOMS"
        else:
            st = "CLEAN"
        theorems.append({"name": n, "module": mod, "axioms": ax, "status": st})
    thm_status = {}
    for t in theorems:
        thm_status.setdefault(t["name"], set()).add(t["status"])

    prop_rows = []
    for (n, mod) in sorted(props):
        p = dict(props[(n, mod)], module=mod)
        p["inhabited_by"] = sorted(p["inhabited_by"])
        p["refuted_by"] = sorted(p["refuted_by"])
        clean_inh = [t for t in p["inhabited_by"] if thm_status.get(t) == {"CLEAN"}]
        clean_ref = [t for t in p["refuted_by"] if thm_status.get(t) == {"CLEAN"}]
        if p["vacuous"]:
            st = "VACUOUS"
        elif clean_inh and clean_ref:
            st = "INCONSISTENT"
        elif clean_inh:
            st = "PROVED"
        elif clean_ref:
            st = "REFUTED"
        elif p["inhabited_by"] or p["refuted_by"]:
            st = "ONLY_UNCLEAN_EVIDENCE"
        else:
            st = "NO_PROOF_IN_LIBRARY"
        prop_rows.append({"name": n, "module": p["module"], "closed_prop": p["closed_prop"],
                          "status": st, "inhabited_by": p["inhabited_by"], "refuted_by": p["refuted_by"]})

    modules = []
    for m in sorted(mods):
        st = "FAILED" if m in failed else "BLOCKED" if m in blocked else "OK"
        row = {"module": m, "path": mods[m]["path"], "status": st, "in_default_build": m in default_build}
        if m in failed:
            row["first_error"] = failed[m]
        if m in blocked:
            row["blocked_by"] = blocked[m]
        modules.append(row)

    def count(rows, key, val):
        return sum(1 for r in rows if r[key] == val)

    summary = {
        "modules_total": len(modules),
        "modules_ok": count(modules, "status", "OK"),
        "modules_failed": count(modules, "status", "FAILED"),
        "modules_blocked": count(modules, "status", "BLOCKED"),
        "modules_outside_default_build": sum(1 for r in modules if not r["in_default_build"]),
        "standalone_files_total": len(loose),
        "standalone_files_failed": sum(1 for x in loose if x["status"] != "OK"),
        "theorems_total": len(theorems),
        "theorems_clean": count(theorems, "status", "CLEAN"),
        "theorems_using_sorry": count(theorems, "status", "USES_SORRY"),
        "theorems_using_project_axiom": count(theorems, "status", "USES_PROJECT_AXIOM"),
        "theorems_nonstandard_axioms": count(theorems, "status", "NONSTANDARD_AXIOMS"),
        "project_axioms_declared": len(axdecls),
        "props_reported": len(prop_rows),
        "props_proved": count(prop_rows, "status", "PROVED"),
        "props_refuted": count(prop_rows, "status", "REFUTED"),
        "props_vacuous": count(prop_rows, "status", "VACUOUS"),
        "props_no_proof_in_library": count(prop_rows, "status", "NO_PROOF_IN_LIBRARY"),
    }
    toolchain = (root / "lean-toolchain").read_text().strip() if (root / "lean-toolchain").exists() else None
    inv = {
        "schema": SCHEMA,
        "generated_by": "scripts/proof_inventory.py (kernel-derived; do not edit by hand)",
        "toolchain": toolchain,
        "libraries": [{"name": n, "srcDir": s} for n, s in libs],
        "policy": {
            "standard_axioms": STANDARD_AXIOMS,
            "theorem_status": "CLEAN = only standard axioms; USES_SORRY = depends on sorryAx; "
                              "USES_PROJECT_AXIOM = depends on an axiom declared in this library",
            "prop_status": "PROVED/REFUTED = a CLEAN theorem has exactly that Prop (or its negation) as its type; "
                           "VACUOUS = the definition body ends in True; NO_PROOF_IN_LIBRARY = no theorem of that "
                           "exact type exists here (this is not a claim that it is open mathematics)",
            "scope": "closed (arity-0) Prop definitions, plus any Prop-valued definition that is vacuous",
        },
        "summary": summary,
        "project_axioms": [{"name": n, "module": m} for n, m in sorted(axdecls)],
        "environment_groups": len(groups),
        "name_clashes": clashes,
        "modules": modules,
        "standalone_files": loose,
        "props": prop_rows,
        "theorems": theorems,
    }

    out = root / a.out
    out.mkdir(parents=True, exist_ok=True)
    jpath = out / "PROOF_INVENTORY.json"
    new_json = json.dumps(inv, indent=1, ensure_ascii=False) + "\n"
    old_json = jpath.read_text() if jpath.exists() else None
    jpath.write_text(new_json)
    md = render_md(inv)
    (out / "PROOF_INVENTORY.md").write_text(md)
    print(f"[inventory] wrote {jpath} and PROOF_INVENTORY.md")
    print(json.dumps(summary, indent=1))

    if gh:
        with open(os.environ.get("GITHUB_STEP_SUMMARY", os.devnull), "a") as f:
            f.write(md)
        for r in modules:
            if r["status"] != "OK" and not r["in_default_build"]:
                print(f"::warning file={r['path']}::module outside default build is {r['status']}: "
                      f"{r.get('first_error') or r.get('blocked_by')}")
        for p in prop_rows:
            if p["status"] == "VACUOUS":
                print(f"::warning::vacuous Prop definition {p['name']} ({p['module']}) ends in True")
    if a.check_committed and old_json is not None and old_json != new_json:
        msg = "committed inventory/PROOF_INVENTORY.json is out of date; regenerate with scripts/proof_inventory.py"
        print(f"::warning::{msg}" if gh else f"[inventory] WARNING: {msg}")

    if a.strict:
        problems = []
        problems += [f"default-build module {r['module']} is {r['status']}" for r in modules
                     if r["status"] != "OK" and r["in_default_build"]]
        problems += [f"{t['name']} uses sorryAx" for t in theorems if t["status"] == "USES_SORRY"]
        problems += [f"{t['name']} uses a project axiom" for t in theorems if t["status"] == "USES_PROJECT_AXIOM"]
        if problems:
            for p in problems[:50]:
                print(f"::error::{p}" if gh else f"[inventory] ERROR: {p}")
            sys.exit(1)


def render_md(inv):
    s = inv["summary"]
    L = ["# Proof inventory (kernel-derived)", "",
         "Generated by `scripts/proof_inventory.py` from the Lean kernel. Do not edit by hand.", "",
         f"Toolchain: `{inv['toolchain']}`", "",
         "| Item | Count |", "| --- | ---: |"]
    for k, v in s.items():
        L.append(f"| {k.replace('_', ' ')} | {v} |")
    bad = [m for m in inv["modules"] if m["status"] != "OK"]
    L += ["", "## Modules that do not compile", ""]
    if bad:
        L += ["| Module | Status | In default build | Detail |", "| --- | --- | --- | --- |"]
        for m in bad:
            d = (m.get("first_error") or m.get("blocked_by") or "").replace("|", "\\|")
            L.append(f"| `{m['module']}` | {m['status']} | {'yes' if m['in_default_build'] else 'no'} | {d[:160]} |")
    else:
        L.append("None. Every module of the library compiles.")
    badl = [x for x in inv.get("standalone_files", []) if x["status"] != "OK"]
    L += ["", "## Stand-alone files that do not compile", ""]
    if badl:
        L += ["| File | Detail |", "| --- | --- |"]
        for x in badl:
            detail = x.get("first_error", "").replace("|", "\\|")[:160]
            L.append(f"| `{x['path']}` | {detail} |")
    else:
        L.append("None.")
    unclean = [t for t in inv["theorems"] if t["status"] != "CLEAN"]
    L += ["", "## Theorems with non-standard axioms", ""]
    if unclean:
        L += ["| Theorem | Status | Axioms |", "| --- | --- | --- |"]
        for t in unclean[:200]:
            L.append(f"| `{t['name']}` | {t['status']} | {', '.join(t['axioms'])} |")
    else:
        L.append("None. Every theorem uses at most propext, Classical.choice and Quot.sound.")
    vac = [p for p in inv["props"] if p["status"] == "VACUOUS"]
    L += ["", "## Vacuous Prop definitions (body ends in `True`)", ""]
    L += [f"- `{p['name']}` ({p['module']})" for p in vac] or ["None."]
    gaps = [p for p in inv["props"] if p["closed_prop"] and re.search(r"(Gap|Producer|Obligation|Frontier|Transfer|Calibration)$", p["name"].split(".")[-1])]
    L += ["", "## Gap-style Prop definitions", "",
          "Status is derived from whether a CLEAN theorem has exactly this type. "
          "`NO_PROOF_IN_LIBRARY` only means no such theorem exists in this library.", "",
          "| Prop | Status | Evidence |", "| --- | --- | --- |"]
    for p in gaps:
        ev = ", ".join(f"`{x}`" for x in (p["inhabited_by"] or p["refuted_by"])[:3])
        L.append(f"| `{p['name']}` | {p['status']} | {ev} |")
    return "\n".join(L) + "\n"


if __name__ == "__main__":
    main()
