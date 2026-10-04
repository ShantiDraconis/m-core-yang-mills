import MCore.YangMills.A1.FiniteRegulatedSpectralV13
import MCore.YangMills.A1.HardeningV2

noncomputable section

namespace MCore.YangMills.A1

open scoped ComplexConjugate

/--
Same-regulator semantic binding between the finite Hamiltonian and the B4
transfer operator.

This does not store a lower spectral edge or a mass-gap conclusion.  It only
states that the same regulated state is seen in both realizations, preserves
norm-square, and that the transfer operator acts on each Hamiltonian eigenmode
with the expected exponential coefficient exp(-a * lambda / 2).
-/
structure SameRegulatorHamiltonianTransferBindingV13
    {C : RegulatedYM4Construction}
    {P : A1PhysicalData C}
    (B4 : PositiveTransferDataV2 C P)
    {HSpace : Type*}
    [NormedAddCommGroup HSpace]
    [InnerProductSpace ℂ HSpace]
    [CompleteSpace HSpace]
    [FiniteDimensional ℂ HSpace]
    (F : FiniteRegulatedHamiltonianV13 HSpace)
    (a : C.Signature.Regulator)
    (L : C.Signature.Volume) where
  toRegulated : HSpace → RegulatedL2Vector C a L
  normSq_preserved :
    ∀ psi, regulatedNormSq (toRegulated psi) = ‖psi‖ ^ 2
  vacuumOrthogonal_of_eigenmode :
    ∀ i : Fin (Module.finrank ℂ HSpace),
      regulatedInner
        (toRegulated (F.eigenbasis i))
        (B4.vacuum a L) = 0
  transfer_on_eigenmode :
    ∀ i : Fin (Module.finrank ℂ HSpace),
      B4.transferOp a L (toRegulated (F.eigenbasis i)) =
        ((Real.exp
            (-P.cutoffValue a * F.eigenvalue i / 2) : ℝ) : ℂ) •
          toRegulated (F.eigenbasis i)

/--
The B4 transfer estimate forces every finite Hamiltonian eigenvalue above the
B4 spectral-gap parameter, provided the regulator cutoff is strictly positive.
-/
theorem same_regulator_eigenvalue_ge_transferGap_V13
    {C : RegulatedYM4Construction}
    {P : A1PhysicalData C}
    {B4 : PositiveTransferDataV2 C P}
    {HSpace : Type*}
    [NormedAddCommGroup HSpace]
    [InnerProductSpace ℂ HSpace]
    [CompleteSpace HSpace]
    [FiniteDimensional ℂ HSpace]
    (F : FiniteRegulatedHamiltonianV13 HSpace)
    {a : C.Signature.Regulator}
    {L : C.Signature.Volume}
    (B : SameRegulatorHamiltonianTransferBindingV13 B4 F a L)
    (hcut : 0 < P.cutoffValue a)
    (i : Fin (Module.finrank ℂ HSpace)) :
    B4.spectralGap a L ≤ F.eigenvalue i := by
  have htransfer :=
    B4.h_spectral_gap_controls_transfer
      a L
      (B.toRegulated (F.eigenbasis i))
      (B.vacuumOrthogonal_of_eigenmode i)
  rw [B.transfer_on_eigenmode i] at htransfer
  rw [B.normSq_preserved] at htransfer
  have hnorm : ‖F.eigenbasis i‖ ^ 2 = (1 : ℝ) := by
    simp
  simp [regulatedNormSq, norm_smul, hnorm] at htransfer
  have hexp :
      Real.exp (-P.cutoffValue a * F.eigenvalue i) ≤
        Real.exp (-P.cutoffValue a * B4.spectralGap a L) := by
    simpa [Real.exp_div, sq, mul_assoc] using htransfer
  have hlog :=
    (Real.exp_le_exp).mp hexp
  nlinarith

/--
Combining the already-existing uniform B5 lower bound with the same-regulator
Hamiltonian/transfer binding yields the actual finite spectral lower edge.
-/
theorem same_regulator_eigenvalue_ge_uniformMass_V13
    {C : RegulatedYM4Construction}
    {P : A1PhysicalData C}
    {B3 : ReflectionPositivityDataV2 C P}
    {B4 : PositiveTransferDataV2 C P}
    (U : UniformRegulatorControlV2 C P B3 B4)
    {HSpace : Type*}
    [NormedAddCommGroup HSpace]
    [InnerProductSpace ℂ HSpace]
    [CompleteSpace HSpace]
    [FiniteDimensional ℂ HSpace]
    (F : FiniteRegulatedHamiltonianV13 HSpace)
    {a : C.Signature.Regulator}
    {L : C.Signature.Volume}
    (B : SameRegulatorHamiltonianTransferBindingV13 B4 F a L)
    (hadm : C.admissible a L)
    (hcutPos : 0 < P.cutoffValue a)
    (hcutLt : P.cutoffValue a < U.a0)
    (i : Fin (Module.finrank ℂ HSpace)) :
    U.m0 ≤ F.eigenvalue i := by
  exact le_trans
    (uniform_v2_spectral_gap_ge_m0 U hadm hcutPos hcutLt)
    (same_regulator_eigenvalue_ge_transferGap_V13 F B hcutPos i)

end MCore.YangMills.A1
