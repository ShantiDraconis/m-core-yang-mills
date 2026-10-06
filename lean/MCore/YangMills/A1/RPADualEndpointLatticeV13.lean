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
def open : FreeEndpointState := ⟨1, 0⟩
def closed : FreeEndpointState := ⟨0, 1⟩
def dual : FreeEndpointState := ⟨1, 1⟩

def add (a b : FreeEndpointState) : FreeEndpointState :=
  ⟨a.openMultiplicity + b.openMultiplicity,
   a.closedMultiplicity + b.closedMultiplicity⟩

instance : Add FreeEndpointState := ⟨add⟩

theorem open_add_open :
    open + open = ⟨2, 0⟩ := rfl

theorem closed_add_closed :
    closed + closed = ⟨0, 2⟩ := rfl

theorem open_add_closed :
    open + closed = dual := rfl

theorem two_open_one_closed :
    open + open + closed = ⟨2, 1⟩ := rfl

theorem one_open_two_closed :
    open + closed + closed = ⟨1, 2⟩ := rfl

theorem two_open_two_closed :
    open + open + closed + closed = ⟨2, 2⟩ := rfl

/-- Complete ordered words through length 3 in the free lattice. -/
theorem closed_add_open :
    closed + open = dual := rfl

theorem open_open_open :
    open + open + open = ⟨3, 0⟩ := rfl

theorem closed_closed_closed :
    closed + closed + closed = ⟨0, 3⟩ := rfl

theorem open_open_closed :
    open + open + closed = ⟨2, 1⟩ := rfl

theorem open_closed_open :
    open + closed + open = ⟨2, 1⟩ := rfl

theorem closed_open_open :
    closed + open + open = ⟨2, 1⟩ := rfl

theorem open_closed_closed :
    open + closed + closed = ⟨1, 2⟩ := rfl

theorem closed_open_closed :
    closed + open + closed = ⟨1, 2⟩ := rfl

theorem closed_closed_open :
    closed + closed + open = ⟨1, 2⟩ := rfl

/-- Maximal four-term free word requested by the RPA audit. -/
def fullFree : FreeEndpointState :=
  open + open + closed + closed

theorem fullFree_eq :
    fullFree = ⟨2, 2⟩ := rfl

end FreeEndpointState

/-- Four canonical idempotent endpoint states. -/
inductive CanonicalEndpointState where
  | empty
  | open
  | closed
  | full
deriving DecidableEq, Repr

namespace CanonicalEndpointState

def hasOpen : CanonicalEndpointState → Bool
  | .empty => false
  | .open => true
  | .closed => false
  | .full => true

def hasClosed : CanonicalEndpointState → Bool
  | .empty => false
  | .open => false
  | .closed => true
  | .full => true

def ofSupport (o c : Bool) : CanonicalEndpointState :=
  match o, c with
  | false, false => .empty
  | true, false => .open
  | false, true => .closed
  | true, true => .full

def join (a b : CanonicalEndpointState) : CanonicalEndpointState :=
  ofSupport (a.hasOpen || b.hasOpen) (a.hasClosed || b.hasClosed)

instance : Add CanonicalEndpointState := ⟨join⟩

theorem open_idempotent :
    open + open = open := rfl

theorem closed_idempotent :
    closed + closed = closed := rfl

theorem open_closed_full :
    open + closed = full := rfl

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
    normalize FreeEndpointState.open = open := rfl

theorem normalize_closed :
    normalize FreeEndpointState.closed = closed := rfl

theorem normalize_dual :
    normalize FreeEndpointState.dual = full := rfl

theorem normalize_two_open_two_closed :
    normalize ⟨2, 2⟩ = full := rfl

/-- Every ordered mixed word of length 2 or 3 normalizes to FULL. -/
theorem closed_open_full :
    closed + open = full := rfl

theorem open_open_open_normalizes :
    open + open + open = open := rfl

theorem closed_closed_closed_normalizes :
    closed + closed + closed = closed := rfl

theorem open_open_closed_full :
    open + open + closed = full := rfl

theorem open_closed_open_full :
    open + closed + open = full := rfl

theorem closed_open_open_full :
    closed + open + open = full := rfl

theorem open_closed_closed_full :
    open + closed + closed = full := rfl

theorem closed_open_closed_full :
    closed + open + closed = full := rfl

theorem closed_closed_open_full :
    closed + closed + open = full := rfl

theorem open_open_closed_closed_full :
    open + open + closed + closed = full := rfl

theorem normalize_closed_open :
    normalize (FreeEndpointState.closed + FreeEndpointState.open) = full := rfl

theorem normalize_open_open_open :
    normalize (FreeEndpointState.open + FreeEndpointState.open + FreeEndpointState.open) = open := rfl

theorem normalize_closed_closed_closed :
    normalize (FreeEndpointState.closed + FreeEndpointState.closed + FreeEndpointState.closed) = closed := rfl

theorem normalize_open_open_closed :
    normalize (FreeEndpointState.open + FreeEndpointState.open + FreeEndpointState.closed) = full := rfl

theorem normalize_open_closed_open :
    normalize (FreeEndpointState.open + FreeEndpointState.closed + FreeEndpointState.open) = full := rfl

theorem normalize_closed_open_open :
    normalize (FreeEndpointState.closed + FreeEndpointState.open + FreeEndpointState.open) = full := rfl

theorem normalize_open_closed_closed :
    normalize (FreeEndpointState.open + FreeEndpointState.closed + FreeEndpointState.closed) = full := rfl

theorem normalize_closed_open_closed :
    normalize (FreeEndpointState.closed + FreeEndpointState.open + FreeEndpointState.closed) = full := rfl

theorem normalize_closed_closed_open :
    normalize (FreeEndpointState.closed + FreeEndpointState.closed + FreeEndpointState.open) = full := rfl

theorem normalize_fullFree :
    normalize FreeEndpointState.fullFree = full := rfl

/-- Kernel certificate that all 14 ordered words through length 3 are covered. -/
structure CubeUpTo3Certificate : Prop where
  open1 : normalize FreeEndpointState.open = open
  closed1 : normalize FreeEndpointState.closed = closed
  openClosed2 : normalize (FreeEndpointState.open + FreeEndpointState.closed) = full
  closedOpen2 : normalize (FreeEndpointState.closed + FreeEndpointState.open) = full
  openOpen2 : normalize (FreeEndpointState.open + FreeEndpointState.open) = open
  closedClosed2 : normalize (FreeEndpointState.closed + FreeEndpointState.closed) = closed
  openOpenOpen3 :
    normalize (FreeEndpointState.open + FreeEndpointState.open + FreeEndpointState.open) = open
  closedClosedClosed3 :
    normalize (FreeEndpointState.closed + FreeEndpointState.closed + FreeEndpointState.closed) = closed
  openOpenClosed3 :
    normalize (FreeEndpointState.open + FreeEndpointState.open + FreeEndpointState.closed) = full
  openClosedOpen3 :
    normalize (FreeEndpointState.open + FreeEndpointState.closed + FreeEndpointState.open) = full
  closedOpenOpen3 :
    normalize (FreeEndpointState.closed + FreeEndpointState.open + FreeEndpointState.open) = full
  openClosedClosed3 :
    normalize (FreeEndpointState.open + FreeEndpointState.closed + FreeEndpointState.closed) = full
  closedOpenClosed3 :
    normalize (FreeEndpointState.closed + FreeEndpointState.open + FreeEndpointState.closed) = full
  closedClosedOpen3 :
    normalize (FreeEndpointState.closed + FreeEndpointState.closed + FreeEndpointState.open) = full

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

#print axioms MCore.YangMills.A1.Final.FreeEndpointState.closed_add_open
#print axioms MCore.YangMills.A1.Final.FreeEndpointState.open_open_open
#print axioms MCore.YangMills.A1.Final.FreeEndpointState.closed_closed_closed
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.CUBE_UP_TO_3_CLOSED
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.normalize_fullFree
#print axioms MCore.YangMills.A1.Final.FreeEndpointState.open_add_open
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.open_idempotent
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.open_closed_full
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.normalize_dual
#print axioms MCore.YangMills.A1.Final.fullEndpointPayload_iff_dualEndpointState
#print axioms MCore.YangMills.A1.Final.fullEndpointPayload_iff_finalRoot
#print axioms MCore.YangMills.A1.Final.globalExternalCertificate_to_fullEndpointPayload

end MCore.YangMills.A1.Final
