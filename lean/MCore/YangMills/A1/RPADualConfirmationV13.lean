import MCore.YangMills.A1.TerminalSignatureCycleV13
import MCore.YangMills.A1.FinalClosureCertificateV13

namespace MCore.YangMills.A1.Final

/-!
RPA dual-confirmation certificate.

OPEN_MATH and CLOSED_MATH are two views of the same terminal proposition.
OPEN_BRIDGE and CLOSED_BRIDGE are the same identity seen at the bridge layer.
MATH and FINAL_ROOT are the canonical fixed-point/root views.

The actual external certificate remains a material input.  The theorem below
proves that such a certificate closes every internal view simultaneously.
-/

abbrev OPEN_MATH
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D) : Prop :=
  FINAL_ROOT D H G

abbrev CLOSED_MATH
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D) : Prop :=
  FINAL_ROOT D H G

abbrev OPEN_BRIDGE
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D) : Prop :=
  FINAL_ROOT D H G

abbrev CLOSED_BRIDGE
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D) : Prop :=
  FINAL_ROOT D H G

abbrev MATH
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D) : Prop :=
  FINAL_ROOT D H G

theorem open_closed_math_identity
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D} :
    OPEN_MATH D H G ↔ CLOSED_MATH D H G :=
  Iff.rfl

theorem open_closed_bridge_identity
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D} :
    OPEN_BRIDGE D H G ↔ CLOSED_BRIDGE D H G :=
  Iff.rfl

theorem math_iff_final_root
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D} :
    MATH D H G ↔ FINAL_ROOT D H G :=
  Iff.rfl

/-- Both sides of the dual transition coexist exactly when the root is inhabited. -/
theorem dual_math_coexistence_iff_final_root
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D} :
    (OPEN_MATH D H G ∧ CLOSED_MATH D H G) ↔ FINAL_ROOT D H G := by
  constructor
  · rintro ⟨h, _⟩
    exact h
  · intro h
    exact ⟨h, h⟩

/-- The bridge duality is the same terminal identity. -/
theorem dual_bridge_coexistence_iff_final_root
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D} :
    (OPEN_BRIDGE D H G ∧ CLOSED_BRIDGE D H G) ↔ FINAL_ROOT D H G := by
  constructor
  · rintro ⟨h, _⟩
    exact h
  · intro h
    exact ⟨h, h⟩

/-- Five internal views collapse to one canonical root. -/
theorem rpa_internal_five_views
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D} :
    ((OPEN_MATH D H G ∧ CLOSED_MATH D H G) ∧
      (OPEN_BRIDGE D H G ∧ CLOSED_BRIDGE D H G) ∧
      MATH D H G) ↔ FINAL_ROOT D H G := by
  constructor
  · rintro ⟨⟨h, _⟩, _, _⟩
    exact h
  · intro h
    exact ⟨⟨h, h⟩, ⟨h, h⟩, h⟩

/-- A genuine external certificate closes all five internal RPA views at once. -/
theorem global_external_certificate_closes_rpa
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}
    (E : FinalExternalCertificate C F D H G O) :
    (OPEN_MATH D H G ∧ CLOSED_MATH D H G) ∧
      (OPEN_BRIDGE D H G ∧ CLOSED_BRIDGE D H G) ∧
      MATH D H G ∧ FINAL_ROOT D H G := by
  have hroot : FINAL_ROOT D H G := finalExternal_to_FINAL_ROOT E
  exact ⟨⟨hroot, hroot⟩, ⟨hroot, hroot⟩, hroot, hroot⟩

/-- RPA certification is a certificate of the transition, not one isolated side. -/
structure RPADualConfirmation
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D) : Prop where
  openMath : OPEN_MATH D H G
  closedMath : CLOSED_MATH D H G
  openBridge : OPEN_BRIDGE D H G
  closedBridge : CLOSED_BRIDGE D H G
  math : MATH D H G
  finalRoot : FINAL_ROOT D H G

theorem rpa_confirmation_iff_final_root
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D} :
    RPADualConfirmation D H G ↔ FINAL_ROOT D H G := by
  constructor
  · intro R
    exact R.finalRoot
  · intro h
    exact ⟨h, h, h, h, h, h⟩

theorem finalExternal_to_rpa_confirmation
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}
    (E : FinalExternalCertificate C F D H G O) :
    RPADualConfirmation D H G := by
  exact (rpa_confirmation_iff_final_root).2 (finalExternal_to_FINAL_ROOT E)

#print axioms MCore.YangMills.A1.Final.open_closed_math_identity
#print axioms MCore.YangMills.A1.Final.dual_math_coexistence_iff_final_root
#print axioms MCore.YangMills.A1.Final.dual_bridge_coexistence_iff_final_root
#print axioms MCore.YangMills.A1.Final.rpa_internal_five_views
#print axioms MCore.YangMills.A1.Final.global_external_certificate_closes_rpa
#print axioms MCore.YangMills.A1.Final.rpa_confirmation_iff_final_root
#print axioms MCore.YangMills.A1.Final.finalExternal_to_rpa_confirmation

end MCore.YangMills.A1.Final
