import MCore.YangMills.A1.GapConcreteV13
import Mathlib.Analysis.InnerProductSpace.Spectrum
import Mathlib.Analysis.InnerProductSpace.Adjoint

noncomputable section

namespace MCore.YangMills.A1

open scoped ComplexConjugate

/--
Concrete bounded Hamiltonian realization for the V13 analytic layer.

This carries actual Hilbert-space/operator data usable by Mathlib.  It does not
contain a gap bound and it does not assume the final spectral inequality.
-/
structure K14HamiltonianConcreteRealizationV13
    (HSpace : Type)
    [NormedAddCommGroup HSpace]
    [InnerProductSpace ℂ HSpace]
    [CompleteSpace HSpace] where
  vacuum : HSpace
  physical : HSpace → Prop
  orthogonalToVacuum : HSpace → Prop
  H_op : HSpace →L[ℂ] HSpace
  selfAdjoint_concrete : IsSelfAdjoint H_op
  vacuum_normalized : ‖vacuum‖ ^ 2 = (1 : ℝ)

/-- The concrete Hilbert model induces the real-energy K14 state model. -/
def K14HamiltonianConcreteRealizationV13.toRealEnergyModel
    {HSpace : Type*}
    [NormedAddCommGroup HSpace]
    [InnerProductSpace ℂ HSpace]
    [CompleteSpace HSpace]
    (C : K14HamiltonianConcreteRealizationV13 HSpace) :
    RealEnergyModelV13 where
  State := HSpace
  vacuum := C.vacuum
  zeroState := 0
  physical := C.physical
  orthogonalToVacuum := C.orthogonalToVacuum
  normSq := fun psi => ‖psi‖ ^ 2
  energyPairing := fun psi Hpsi => Complex.re (inner psi Hpsi)
  unitNorm := 1
  vacuum_normalized := C.vacuum_normalized

/--
The bounded concrete operator maps to K14 without postulating self-adjointness
as an unrelated proposition.  K14's proposition-valued flags are instantiated
by the actual Mathlib predicates.
-/
def K14HamiltonianConcreteRealizationV13.toK14Hamiltonian
    {HSpace : Type*}
    [NormedAddCommGroup HSpace]
    [InnerProductSpace ℂ HSpace]
    [CompleteSpace HSpace]
    (C : K14HamiltonianConcreteRealizationV13 HSpace) :
    MCore.K14HamiltonianOperator C.toRealEnergyModel.toK14 where
  domain := fun _ => True
  act := fun psi _ => C.H_op psi
  denselyDefined := True
  symmetric := (C.H_op : HSpace →ₗ[ℂ] HSpace).IsSymmetric
  selfAdjoint := IsSelfAdjoint C.H_op

theorem K14HamiltonianConcreteRealizationV13.toK14_selfAdjoint
    {HSpace : Type*}
    [NormedAddCommGroup HSpace]
    [InnerProductSpace ℂ HSpace]
    [CompleteSpace HSpace]
    (C : K14HamiltonianConcreteRealizationV13 HSpace) :
    C.toK14Hamiltonian.selfAdjoint :=
  C.selfAdjoint_concrete

theorem K14HamiltonianConcreteRealizationV13.toK14_symmetric
    {HSpace : Type*}
    [NormedAddCommGroup HSpace]
    [InnerProductSpace ℂ HSpace]
    [CompleteSpace HSpace]
    (C : K14HamiltonianConcreteRealizationV13 HSpace) :
    C.toK14Hamiltonian.symmetric := by
  exact
    (ContinuousLinearMap.isSelfAdjoint_iff_isSymmetric.mp
      C.selfAdjoint_concrete)

@[simp] theorem K14HamiltonianConcreteRealizationV13.toK14_act
    {HSpace : Type*}
    [NormedAddCommGroup HSpace]
    [InnerProductSpace ℂ HSpace]
    [CompleteSpace HSpace]
    (C : K14HamiltonianConcreteRealizationV13 HSpace)
    (psi : HSpace)
    (hpsi : C.toK14Hamiltonian.domain psi) :
    C.toK14Hamiltonian.act psi hpsi = C.H_op psi :=
  rfl

#print axioms MCore.YangMills.A1.K14HamiltonianConcreteRealizationV13.toK14_selfAdjoint
#print axioms MCore.YangMills.A1.K14HamiltonianConcreteRealizationV13.toK14_symmetric
#print axioms MCore.YangMills.A1.K14HamiltonianConcreteRealizationV13.toK14_act

end MCore.YangMills.A1
