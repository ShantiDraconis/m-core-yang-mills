import MCore.YangMills.A1.RPADualConfirmationV13

namespace MCore.YangMills.A1.Final

/-!
Dual-endpoint lattice.

Free layer:
  n·OPEN + m·CLOSED  ≅  Nat × Nat.

Idempotent quotient:
  support of the two multiplicities  ≅  Bool × Bool,
with four canonical states:
  empty, open, closed, full.

FULL is the maximal dual-endpoint state.  Its logical payload is FINAL_ROOT.
This file does not manufacture a GlobalExternalCertificate from FINAL_ROOT.
-/

/-- Free non-idempotent multiplicity state: n OPEN copies and m CLOSED copies. -/
structure FreeEndpointState where
  openMultiplicity : Nat
  closedMultiplicity : Nat
deriving DecidableEq, Repr

namespace FreeEndpointState

def empty : FreeEndpointState := ⟨0, 0⟩
def openState : FreeEndpointState := ⟨1, 0⟩
def closedState : FreeEndpointState := ⟨0, 1⟩
def dual : FreeEndpointState := ⟨1, 1⟩

def add (a b : FreeEndpointState) : FreeEndpointState :=
  ⟨a.openMultiplicity + b.openMultiplicity,
   a.closedMultiplicity + b.closedMultiplicity⟩

instance : Add FreeEndpointState := ⟨add⟩

theorem open_add_open :
    openState + openState = ⟨2, 0⟩ := rfl

theorem closed_add_closed :
    closedState + closedState = ⟨0, 2⟩ := rfl

theorem open_add_closed :
    openState + closedState = dual := rfl

theorem two_open_one_closed :
    openState + openState + closed = ⟨2, 1⟩ := rfl

theorem one_open_two_closed :
    openState + closedStateState + closedState = ⟨1, 2⟩ := rfl

theorem two_open_two_closed :
    openState + openState + closedState + closedState = ⟨2, 2⟩ := rfl

/-- Complete ordered words through length 3 in the free lattice. -/
theorem closed_add_open :
    closedState + openState = dual := rfl

theorem open_open_open :
    openState + openState + open = ⟨3, 0⟩ := rfl

theorem closed_closed_closed :
    closedState + closedState + closed = ⟨0, 3⟩ := rfl

theorem open_open_closed :
    openState + openState + closed = ⟨2, 1⟩ := rfl

theorem open_closed_open :
    openState + closedState + open = ⟨2, 1⟩ := rfl

theorem closed_open_open :
    closedState + openStateState + openState = ⟨2, 1⟩ := rfl

theorem open_closed_closed :
    openState + closedStateState + closedState = ⟨1, 2⟩ := rfl

theorem closed_open_closed :
    closedState + openStateState + closedState = ⟨1, 2⟩ := rfl

theorem closed_closed_open :
    closedState + closedState + open = ⟨1, 2⟩ := rfl

/-- Maximal four-term free word requested by the RPA audit. -/
def fullFree : FreeEndpointState :=
  openState + openState + closedState + closedState

theorem fullFree_eq :
    fullFree = ⟨2, 2⟩ := rfl

end FreeEndpointState

/-- Four canonical idempotent endpoint states. -/
inductive CanonicalEndpointState where
  | empty
  | openState
  | closedState
  | full
deriving DecidableEq, Repr

namespace CanonicalEndpointState

def hasOpen : CanonicalEndpointState → Bool
  | .empty => false
  | .openState => true
  | .closedState => false
  | .full => true

def hasClosed : CanonicalEndpointState → Bool
  | .empty => false
  | .openState => false
  | .closedState => true
  | .full => true

def ofSupport (o c : Bool) : CanonicalEndpointState :=
  match o, c with
  | false, false => .empty
  | true, false => .openState
  | false, true => .closedState
  | true, true => .full

def join (a b : CanonicalEndpointState) : CanonicalEndpointState :=
  ofSupport (a.hasOpen || b.hasOpen) (a.hasClosed || b.hasClosed)

instance : Add CanonicalEndpointState := ⟨join⟩

theorem open_idempotent :
    openState + openState = openState := rfl

theorem closed_idempotent :
    closedState + closedState = closedState := rfl

theorem open_closed_full :
    openState + closedState = full := rfl

theorem full_open_full :
    full + open = full := rfl

theorem full_closed_full :
    full + closed = full := rfl

theorem full_idempotent :
    full + full = full := rfl

/-- Projection from the free multiplicity lattice to the idempotent four-state lattice. -/
def normalize (s : FreeEndpointState) : CanonicalEndpointState :=
  ofSupport (s.openMultiplicity != 0) (s.closedMultiplicity != 0)

theorem normalize_empty :
    normalize FreeEndpointState.empty = empty := rfl

theorem normalize_open :
    normalize FreeEndpointState.openState = openState := rfl

theorem normalize_closed :
    normalize FreeEndpointState.closedState = closedState := rfl

theorem normalize_dual :
    normalize FreeEndpointState.dual = full := rfl

theorem normalize_two_open_two_closed :
    normalize ⟨2, 2⟩ = full := rfl

/-- Every ordered mixed word of length 2 or 3 normalizes to FULL. -/
theorem closed_open_full :
    closedState + openState = full := rfl

theorem open_open_open_normalizes :
    openState + openState + open = openState := rfl

theorem closed_closed_closed_normalizes :
    closedState + closedState + closed = closedState := rfl

theorem open_open_closed_full :
    openState + openState + closed = full := rfl

theorem open_closed_open_full :
    openState + closedState + open = full := rfl

theorem closed_open_open_full :
    closedState + openStateState + openState = full := rfl

theorem open_closed_closed_full :
    openState + closedStateState + closedState = full := rfl

theorem closed_open_closed_full :
    closedState + openStateState + closedState = full := rfl

theorem closed_closed_open_full :
    closedState + closedState + open = full := rfl

theorem open_open_closed_closed_full :
    openState + openState + closedState + closedState = full := rfl

theorem normalize_closed_open :
    normalize (FreeEndpointState.closedState + FreeEndpointState.openState) = full := rfl

theorem normalize_open_open_open :
    normalize (FreeEndpointState.openState + FreeEndpointState.openState + FreeEndpointState.openState) = openState := rfl

theorem normalize_closed_closed_closed :
    normalize (FreeEndpointState.closedState + FreeEndpointState.closedState + FreeEndpointState.closedState) = closedState := rfl

theorem normalize_open_open_closed :
    normalize (FreeEndpointState.openState + FreeEndpointState.openState + FreeEndpointState.closedState) = full := rfl

theorem normalize_open_closed_open :
    normalize (FreeEndpointState.openState + FreeEndpointState.closedState + FreeEndpointState.openState) = full := rfl

theorem normalize_closed_open_open :
    normalize (FreeEndpointState.closedState + FreeEndpointState.openState + FreeEndpointState.openState) = full := rfl

theorem normalize_open_closed_closed :
    normalize (FreeEndpointState.openState + FreeEndpointState.closedState + FreeEndpointState.closedState) = full := rfl

theorem normalize_closed_open_closed :
    normalize (FreeEndpointState.closedState + FreeEndpointState.openState + FreeEndpointState.closedState) = full := rfl

theorem normalize_closed_closed_open :
    normalize (FreeEndpointState.closedState + FreeEndpointState.closedState + FreeEndpointState.openState) = full := rfl

theorem normalize_fullFree :
    normalize FreeEndpointState.fullFree = full := rfl

/-- Kernel certificate that all 14 ordered words through length 3 are covered. -/
structure CubeUpTo3Certificate : Prop where
  open1 : normalize FreeEndpointState.openState = openState
  closed1 : normalize FreeEndpointState.closedState = closedState
  openClosed2 : normalize (FreeEndpointState.openState + FreeEndpointState.closedState) = full
  closedOpen2 : normalize (FreeEndpointState.closedState + FreeEndpointState.openState) = full
  openOpen2 : normalize (FreeEndpointState.openState + FreeEndpointState.openState) = openState
  closedClosed2 : normalize (FreeEndpointState.closedState + FreeEndpointState.closedState) = closedState
  openOpenOpen3 :
    normalize (FreeEndpointState.openState + FreeEndpointState.openState + FreeEndpointState.openState) = openState
  closedClosedClosed3 :
    normalize (FreeEndpointState.closedState + FreeEndpointState.closedState + FreeEndpointState.closedState) = closedState
  openOpenClosed3 :
    normalize (FreeEndpointState.openState + FreeEndpointState.openState + FreeEndpointState.closedState) = full
  openClosedOpen3 :
    normalize (FreeEndpointState.openState + FreeEndpointState.closedState + FreeEndpointState.openState) = full
  closedOpenOpen3 :
    normalize (FreeEndpointState.closedState + FreeEndpointState.openState + FreeEndpointState.openState) = full
  openClosedClosed3 :
    normalize (FreeEndpointState.openState + FreeEndpointState.closedState + FreeEndpointState.closedState) = full
  closedOpenClosed3 :
    normalize (FreeEndpointState.closedState + FreeEndpointState.openState + FreeEndpointState.closedState) = full
  closedClosedOpen3 :
    normalize (FreeEndpointState.closedState + FreeEndpointState.closedState + FreeEndpointState.openState) = full

def cubeUpTo3Certificate : CubeUpTo3Certificate where
  open1 := rfl
  closed1 := rfl
  openClosed2 := rfl
  closedOpen2 := rfl
  openOpen2 := rfl
  closedClosed2 := rfl
  openOpenOpen3 := rfl
  closedClosedClosed3 := rfl
  openOpenClosed3 := rfl
  openClosedOpen3 := rfl
  closedOpenOpen3 := rfl
  openClosedClosed3 := rfl
  closedOpenClosed3 := rfl
  closedClosedOpen3 := rfl

theorem CUBE_UP_TO_3_CLOSED :
    Nonempty CubeUpTo3Certificate :=
  ⟨cubeUpTo3Certificate⟩

end CanonicalEndpointState

/-- FULL carries both endpoint positions simultaneously. -/
def FullEndpointPayload
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D) : Prop :=
  OPEN_ENDPOINT D H G ∧ CLOSED_ENDPOINT D H G

theorem fullEndpointPayload_iff_dualEndpointState
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D} :
    FullEndpointPayload D H G ↔ DualEndpointState D H G := by
  constructor
  · rintro ⟨ho, hc⟩
    exact ⟨ho, hc, openEndpoint_iff_closedEndpoint⟩
  · intro S
    exact ⟨S.openEndpoint, S.closedEndpoint⟩

theorem fullEndpointPayload_iff_finalRoot
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D} :
    FullEndpointPayload D H G ↔ FINAL_ROOT D H G := by
  constructor
  · rintro ⟨ho, _⟩
    exact ho
  · intro h
    exact ⟨h, h⟩

/-- A genuine external certificate inhabits the maximal FULL endpoint payload. -/
theorem globalExternalCertificate_to_fullEndpointPayload
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}
    (E : FinalExternalCertificate C F D H G O) :
    FullEndpointPayload D H G := by
  have hroot := finalExternal_to_FINAL_ROOT E
  exact ⟨hroot, hroot⟩

#print axioms MCore.YangMills.A1.Final.FreeEndpointState.closedState_add_open
#print axioms MCore.YangMills.A1.Final.FreeEndpointState.openState_open_open
#print axioms MCore.YangMills.A1.Final.FreeEndpointState.closedState_closed_closed
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.CUBE_UP_TO_3_CLOSED
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.normalize_fullFree
#print axioms MCore.YangMills.A1.Final.FreeEndpointState.openState_add_open
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.open_idempotent
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.open_closed_full
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.normalize_dual
#print axioms MCore.YangMills.A1.Final.fullEndpointPayload_iff_dualEndpointState
#print axioms MCore.YangMills.A1.Final.fullEndpointPayload_iff_finalRoot
#print axioms MCore.YangMills.A1.Final.globalExternalCertificate_to_fullEndpointPayload

end MCore.YangMills.A1.Final
