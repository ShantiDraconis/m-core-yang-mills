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

#print axioms MCore.YangMills.A1.Final.FreeEndpointState.open_add_open
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.open_idempotent
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.open_closed_full
#print axioms MCore.YangMills.A1.Final.CanonicalEndpointState.normalize_dual
#print axioms MCore.YangMills.A1.Final.fullEndpointPayload_iff_dualEndpointState
#print axioms MCore.YangMills.A1.Final.fullEndpointPayload_iff_finalRoot
#print axioms MCore.YangMills.A1.Final.globalExternalCertificate_to_fullEndpointPayload

end MCore.YangMills.A1.Final
