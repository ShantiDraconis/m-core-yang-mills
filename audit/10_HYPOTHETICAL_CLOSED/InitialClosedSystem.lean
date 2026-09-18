import Mathlib

/-! INITIAL CLOSED SYSTEM — YangMills
HYPOTHETICAL / AUDIT-ONLY. This specifies what a fully characterized initial
state would require. It does not prove the target or an open bridge. -/

namespace MultistateAudit.YangMills.Initial

inductive EpistemicStatus
  | sourceCatalogOnly | hypotheticalClosed | conditionallyClosed
  | actuallyClosed | refuted | indeterminateWithResidue
  deriving Repr, DecidableEq

structure InitialClosedSystem where
  Domain : Type
  State : Type
  Admissible : State → Prop
  InitialState : State
  initial_admissible : Admissible InitialState
  Laws : Prop
  Conditions : Prop
  ParametersWellTyped : Prop
  QuantifiersFixed : Prop
  ConventionsFixed : Prop
  ProvenanceFrozen : Prop
  NoTargetCircularity : Prop
  ExternalInterfacesExplicit : Prop

structure HypotheticalInitialClosure where
  system : InitialClosedSystem
  assumedClosed : system.Laws ∧ system.Conditions ∧
    system.ParametersWellTyped ∧ system.QuantifiersFixed ∧
    system.ConventionsFixed ∧ system.ProvenanceFrozen ∧
    system.NoTargetCircularity ∧ system.ExternalInterfacesExplicit

def initialStatus : EpistemicStatus := .sourceCatalogOnly

end MultistateAudit.YangMills.Initial
