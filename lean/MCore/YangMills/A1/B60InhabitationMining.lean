import Lean
import MCore.YangMills.A1.B60ConcretePhysicalAdapter

open Lean Elab Command Meta

private partial def resultHeadName (e : Expr) : MetaM (Option Name) := do
  let e ← whnf e
  match e with
  | .forallE _ domain body _ =>
      let x ← mkFreshExprMVar domain
      resultHeadName (body.instantiate1 x)
  | _ =>
      return e.getAppFn.constName?

private def headMatches (target cand : Expr) : MetaM Bool := do
  let ht ← resultHeadName target
  let hc ← resultHeadName cand
  return ht.isSome && ht == hc

elab "#mine_structure " n:ident : command => do
  let env ← getEnv
  let structName ← resolveGlobalConstNoOverload n
  let some info := getStructureInfo? env structName
    | throwError "not a structure: {structName}"
  logInfo m!"[MINING STRUCTURE] {structName}"
  for field in info.fieldNames do
    let projName := Name.str structName field.toString
    let finfo ← getConstInfo projName
    let ftype := finfo.type
    let mut hits : Array Name := #[]
    for (declName, declInfo) in env.constants.toList do
      if declName != projName && !(declName.toString.startsWith "_") then
        let ok ← liftTermElabM do
          headMatches ftype declInfo.type
        if ok then
          hits := hits.push declName
    let preview := hits.toList.take 24
    logInfo m!"[FIELD] {field}"
    logInfo m!"  TYPE: {ftype}"
    if hits.isEmpty then
      logInfo m!"  STATUS: NO_PRODUCER_HEAD"
    else
      logInfo m!"  STATUS: COMPOSABLE_HEAD_CANDIDATES ({hits.size})"
      logInfo m!"  CANDIDATES: {preview}"

#mine_structure MCore.YangMills.A1.B60ConcretePhysicalAdapter
