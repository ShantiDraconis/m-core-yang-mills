#!/usr/bin/env python3
import json, pathlib, re, sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
G=json.loads((ROOT/"audit/ATL_GRAPH.json").read_text())
FORBIDDEN=(r"\bsorry\b",r"\badmit\b",r"\baxiom\s+")
def result(kind,passed,detail): return {"kind":kind,"passed":passed,"detail":detail}
def main():
 nodes={n["primitive"]["id"]:n for n in G["nodes"]}; edges=G.get("edges",[])
 out=[]
 # AXIOM/source hygiene is a pre-kernel firewall; kernel #print axioms remains authoritative.
 bad=[]
 for n in nodes.values():
  for rel in n["primitive"]["source_files"]:
   f=ROOT/rel
   if f.exists():
    txt=f.read_text(errors="replace")
    for pat in FORBIDDEN:
     if re.search(pat,txt): bad.append(f"{rel}:{pat}")
 out.append(result("AXIOM_SOURCE",not bad,bad or "no forbidden source tokens"))
 # CIRCULARITY
 adj={k:[] for k in nodes}
 missing=[]
 for e in edges:
  if e["from"] not in nodes or e["to"] not in nodes: missing.append(e)
  else: adj[e["from"]].append(e["to"])
 temp=set();done=set();cycle=[]
 def dfs(k):
  if k in temp: cycle.append(k); return
  if k in done:return
  temp.add(k)
  for q in adj[k]: dfs(q)
  temp.remove(k);done.add(k)
 for k in nodes: dfs(k)
 out.append(result("CIRCULARITY",not missing and not cycle,{"missing":missing,"cycle":cycle}))
 # SEMANTIC: persisted statement identities must be nonempty and versioned.
 sem=[k for k,n in nodes.items() if not n["primitive"].get("formal_statement") or not n["primitive"].get("semantic_statement") or not isinstance(n["primitive"].get("version"),int)]
 out.append(result("SEMANTIC",not sem,sem or "statement identities/version present"))
 # INTERFACE: reject known placeholder forms in scientific producer statements.
 iface=[]
 for k,n in nodes.items():
  if n["primitive"]["kind"]=="scientific_producer":
   fs=n["primitive"]["formal_statement"]
   if fs.strip() in {"True","Prop","Nonempty"}: iface.append(k)
 out.append(result("INTERFACE",not iface,iface or "no trivial producer interface"))
 # VACUITY: conservative static sentinels; full non-vacuity remains obligation-specific.
 vac=[]
 for k,n in nodes.items():
  ss=n["primitive"]["semantic_statement"].strip().lower()
  if ss in {"true","trivial","vacuous"}: vac.append(k)
 out.append(result("VACUITY_STATIC",not vac,vac or "no declared trivial semantics"))
 ok=all(x["passed"] for x in out)
 print(json.dumps({"passed":ok,"firewalls":out},indent=2))
 return 0 if ok else 1
if __name__=="__main__": raise SystemExit(main())
