import MCore.SpectralConcreteAdapter
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic

namespace MCore

/-!
# Spectral exclusion core

This file isolates and proves the arithmetic/measure-theoretic heart of S1.
It deliberately does not assume a C₀-semigroup, a spectral theorem for
unbounded operators, or a projection-valued measure.  Those are separate
analytic realization obligations.
-/

/-- Abstract positive spectral state measure.  `laplace t` is intended to be
`⟨ψ, exp (-tH) ψ⟩`; `massBelow r` is intended to be `μψ([0,r])`.
The lower-bound law is exactly the consequence of positivity of the spectral
measure needed by the asymptotic argument. -/
structure PositiveSpectralLaplaceData where
  laplace : ℝ → ℝ
  massBelow : ℝ → ℝ
  lowerBound : ∀ t r : ℝ, 0 ≤ t → 0 ≤ r →
    Real.exp (-t * r) * massBelow r ≤ laplace t

/-- Exponential decay package. -/
structure ExponentialDecayData (L : ℝ → ℝ) where
  C : ℝ
  m : ℝ
  C_nonneg : 0 ≤ C
  m_pos : 0 < m
  upperBound : ∀ t : ℝ, 0 ≤ t → L t ≤ C * Real.exp (-m * t)

/-- Quantitative contradiction threshold.  If positive mass `q` lies below
`r < m`, then any `t` with `C < q * exp ((m-r)t)` contradicts decay rate `m`.
This formulation avoids logarithms and is the minimal algebraic core. -/
theorem positive_mass_below_rate_contradiction
    (q C m r t : ℝ)
    (hq : 0 < q)
    (hC : 0 ≤ C)
    (hgap : r < m)
    (ht : 0 ≤ t)
    (hlower : Real.exp (-t * r) * q ≤ C * Real.exp (-m * t))
    (hlarge : C < q * Real.exp ((m - r) * t)) : False := by
  have hem : 0 < Real.exp (m * t) := Real.exp_pos _
  have hmul := mul_le_mul_of_nonneg_right hlower (le_of_lt hem)
  have hid1 : Real.exp (-t * r) * Real.exp (m * t) =
      Real.exp ((m - r) * t) := by
    rw [← Real.exp_add]
    congr 1
    ring
  have hid2 : Real.exp (-m * t) * Real.exp (m * t) = 1 := by
    rw [← Real.exp_add]
    simp
  rw [mul_assoc, hid1, mul_assoc, hid2, mul_one] at hmul
  exact (not_lt_of_ge hmul) hlarge

/-- Dense S1 law: decay plus the positive-measure lower bound excludes any
positive spectral mass at every strict sub-rate `r < m`, provided the elementary
Archimedean growth witness is supplied.  The witness is pure real analysis and
is intentionally visible rather than hidden as a spectral assumption. -/
theorem spectral_exclusion_at_subrate
    (S : PositiveSpectralLaplaceData)
    (D : ExponentialDecayData S.laplace)
    (r : ℝ)
    (hr0 : 0 ≤ r)
    (hrm : r < D.m)
    (growth : ∀ q : ℝ, 0 < q → ∃ t : ℝ,
      0 ≤ t ∧ D.C < q * Real.exp ((D.m - r) * t)) :
    S.massBelow r ≤ 0 := by
  by_contra h
  have hq : 0 < S.massBelow r := lt_of_not_ge h
  obtain ⟨t, ht, hlarge⟩ := growth (S.massBelow r) hq
  have hlower := S.lowerBound t r ht hr0
  have hupper := D.upperBound t ht
  have hchain : Real.exp (-t * r) * S.massBelow r ≤
      D.C * Real.exp (-D.m * t) := le_trans hlower hupper
  exact positive_mass_below_rate_contradiction
    (S.massBelow r) D.C D.m r t hq D.C_nonneg hrm ht hchain hlarge

/-- The exact remaining analytic interface for S1.  A concrete spectral theorem
must produce the lower-bound law; real analysis must produce exponential growth.
No Yang–Mills conclusion is assumed here. -/
structure SpectralExclusionRealization where
  spectral : PositiveSpectralLaplaceData
  decay : ExponentialDecayData spectral.laplace
  growth : ∀ r : ℝ, 0 ≤ r → r < decay.m → ∀ q : ℝ, 0 < q → ∃ t : ℝ,
    0 ≤ t ∧ decay.C < q * Real.exp ((decay.m - r) * t)

/-- Once the realization exists, every nonnegative strict sub-rate has zero
positive spectral mass (assuming mass itself is nonnegative). -/
theorem realized_exclusion
    (R : SpectralExclusionRealization)
    (mass_nonneg : ∀ r : ℝ, 0 ≤ r → 0 ≤ R.spectral.massBelow r)
    (r : ℝ) (hr0 : 0 ≤ r) (hrm : r < R.decay.m) :
    R.spectral.massBelow r = 0 := by
  apply le_antisymm
  · exact spectral_exclusion_at_subrate R.spectral R.decay r hr0 hrm
      (R.growth r hr0 hrm)
  · exact mass_nonneg r hr0

end MCore
