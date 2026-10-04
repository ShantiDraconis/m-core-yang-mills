import MCore.YangMills.A1.K14HamiltonianConcreteRealizationV13
import Mathlib.Analysis.InnerProductSpace.Spectrum

noncomputable section

namespace MCore.YangMills.A1

open scoped ComplexConjugate

/--
Finite-dimensional regulated realization.  This is the part of the V13
spectral layer that Mathlib currently supports constructively via
self-adjoint diagonalization.
-/
structure FiniteRegulatedHamiltonianV13
    (HSpace : Type*)
    [NormedAddCommGroup HSpace]
    [InnerProductSpace ℂ HSpace]
    [CompleteSpace HSpace]
    [FiniteDimensional ℂ HSpace] extends
    K14HamiltonianConcreteRealizationV13 HSpace where

namespace FiniteRegulatedHamiltonianV13

variable
  {HSpace : Type*}
  [NormedAddCommGroup HSpace]
  [InnerProductSpace ℂ HSpace]
  [CompleteSpace HSpace]
  [FiniteDimensional ℂ HSpace]

variable (C : FiniteRegulatedHamiltonianV13 HSpace)

/-- The underlying linear map used by the finite-dimensional spectral theorem. -/
def linearHamiltonian : HSpace →ₗ[ℂ] HSpace :=
  C.toK14HamiltonianConcreteRealizationV13.H_op.toLinearMap

theorem linearHamiltonian_isSymmetric :
    C.linearHamiltonian.IsSymmetric := by
  exact
    (ContinuousLinearMap.isSelfAdjoint_iff_isSymmetric.mp
      C.toK14HamiltonianConcreteRealizationV13.selfAdjoint_concrete)

/--
An orthonormal eigenbasis exists in the finite-dimensional regulated model.
The dimension index is chosen from the actual module finrank.
-/
def eigenbasis :
    OrthonormalBasis
      (Fin (Module.finrank ℂ HSpace)) ℂ HSpace :=
  (C.linearHamiltonian_isSymmetric).eigenvectorBasis rfl

/-- Real eigenvalues associated with the eigenbasis. -/
def eigenvalue (i : Fin (Module.finrank ℂ HSpace)) : ℝ :=
  (C.linearHamiltonian_isSymmetric).eigenvalues rfl i

theorem apply_eigenbasis
    (i : Fin (Module.finrank ℂ HSpace)) :
    C.linearHamiltonian (C.eigenbasis i) =
      (C.eigenvalue i : ℂ) • C.eigenbasis i := by
  simpa [eigenbasis, eigenvalue, linearHamiltonian] using
    (C.linearHamiltonian_isSymmetric).apply_eigenvectorBasis rfl i

/--
Discrete spectral weight of a state at the i-th eigenvalue.
-/
def spectralWeight
    (psi : HSpace)
    (i : Fin (Module.finrank ℂ HSpace)) : ℝ :=
  ‖(C.eigenbasis.repr psi) i‖ ^ 2

theorem spectralWeight_nonneg
    (psi : HSpace)
    (i : Fin (Module.finrank ℂ HSpace)) :
    0 ≤ C.spectralWeight psi i := by
  exact sq_nonneg _

/--
Finite low-energy spectral mass.  This is deliberately a finite sum rather than
an abstract Measure: it is the regulator-level object supported by the
available Mathlib spectral theorem.
-/
def massBelowFinite
    (psi : HSpace)
    (r : ℝ) : ℝ :=
  ∑ i : Fin (Module.finrank ℂ HSpace),
    if C.eigenvalue i ≤ r then C.spectralWeight psi i else 0

theorem massBelowFinite_nonneg
    (psi : HSpace)
    (r : ℝ) :
    0 ≤ C.massBelowFinite psi r := by
  unfold massBelowFinite
  exact Finset.sum_nonneg (fun i hi => by
    by_cases h : C.eigenvalue i ≤ r
    · simp [h, C.spectralWeight_nonneg psi i]
    · simp [h])


/-- Finite Parseval identity for the spectral weights. -/
theorem spectralWeight_sum
    (psi : HSpace) :
    ∑ i : Fin (Module.finrank ℂ HSpace), C.spectralWeight psi i =
      ‖psi‖ ^ 2 := by
  unfold spectralWeight
  have h :=
    EuclideanSpace.norm_sq_eq (C.eigenbasis.repr psi)
  simpa using h.symm


/-- Finite spectral expectation identity. -/
theorem spectralWeight_expectation
    (psi : HSpace) :
    ∑ i : Fin (Module.finrank ℂ HSpace),
        C.eigenvalue i * C.spectralWeight psi i =
      Complex.re (inner psi (C.linearHamiltonian psi)) := by
  rw [← C.eigenbasis.repr.inner_map_map psi (C.linearHamiltonian psi)]
  simp only [PiLp.inner_apply]
  rw [map_sum]
  apply Finset.sum_congr rfl
  intro i hi
  have hdiag :
      C.eigenbasis.repr (C.linearHamiltonian psi) i =
        (C.eigenvalue i : ℂ) * (C.eigenbasis.repr psi) i := by
    simpa [eigenbasis, eigenvalue, linearHamiltonian] using
      (C.linearHamiltonian_isSymmetric).eigenvectorBasis_apply_self_apply rfl psi i
  rw [hdiag]
  simp [spectralWeight, RCLike.inner_apply, Complex.mul_re]

#print axioms MCore.YangMills.A1.FiniteRegulatedHamiltonianV13.linearHamiltonian_isSymmetric
#print axioms MCore.YangMills.A1.FiniteRegulatedHamiltonianV13.apply_eigenbasis
#print axioms MCore.YangMills.A1.FiniteRegulatedHamiltonianV13.spectralWeight_nonneg
#print axioms MCore.YangMills.A1.FiniteRegulatedHamiltonianV13.massBelowFinite_nonneg

end FiniteRegulatedHamiltonianV13

end MCore.YangMills.A1
