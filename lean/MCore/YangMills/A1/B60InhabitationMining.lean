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

private partial def instantiateForalls (e : Expr) : MetaM Expr := do
  let e ← whnf e
  match e with
  | .forallE _ domain body _ =>
      let x ← mkFreshExprMVar domain
      instantiateForalls (body.instantiate1 x)
  | _ => pure e

private def typeUnifies (target cand : Expr) : MetaM Bool := do
  try
    withoutModifyingState do
      let t ← instantiateForalls target
      let c ← instantiateForalls cand
      isDefEq t c
  catch _ =>
    pure false

elab "#mine_producers " n:ident : command => do
  let env ← getEnv
  let targetName ← resolveGlobalConstNoOverload n
  let mut hits : Array (Name × Expr) := #[]
  for (declName, declInfo) in env.constants.toList do
    if declName != targetName && !(declName.toString.startsWith "_") then
      let h? ← liftTermElabM do resultHeadName declInfo.type
      if h? == some targetName then
        hits := hits.push (declName, declInfo.type)
  logInfo m!"[PRODUCER TARGET] {targetName}"
  if hits.isEmpty then
    logInfo m!"  PRODUCERS: NONE"
  else
    for (declName, ty) in hits.toList.take 40 do
      logInfo m!"  PRODUCER: {declName}"
      logInfo m!"    TYPE: {ty}"

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
      logInfo m!"  STATUS: NO_PRODUCER_TYPE"
    else
      logInfo m!"  STATUS: COMPOSABLE_TYPE_CANDIDATES ({hits.size})"
      logInfo m!"  CANDIDATES: {preview}"

#mine_structure MCore.YangMills.A1.B60ConcretePhysicalAdapter

#mine_producers MCore.YangMills.A1.B60ConcretePhysicalAdapter
