import MCore.YangMills.A1.FiniteRegulatedSpectralV13
import MCore.SpectralExclusion

namespace MCore.YangMills.A1

/--
P02-YM V13 continuum frontier.

Everything below the continuum transition is already finite-dimensional and
proved in MCore:
  finite spectral decomposition
  Parseval
  spectral expectation
  finite mass gap from low-spectrum vanishing

The only remaining material producer is a genuine regulator-to-continuum
binding.  This file is intentionally kept under open_math/.
-/
structure ContinuumGapBridgeV13 where
  Regulator : Type
  State : Type
  finiteModel :
    Regulator →
    Type
  massBelowFinite :
    Regulator → State → ℝ → ℝ
  massBelowContinuum :
    State → ℝ → ℝ
  normSqFinite :
    Regulator → State → ℝ
  energyFinite :
    Regulator → State → ℝ
  normSqContinuum :
    State → ℝ
  energyContinuum :
    State → ℝ

/--
Exact open-math producer: uniform passage of the finite regulated spectral
quantities to the same continuum state/energy model.

No mass-gap conclusion is stored as a field.
-/
def ContinuumLimitProducerV13 (B : ContinuumGapBridgeV13) : Prop :=
  (∀ psi r,
    Tendsto
      (fun R => B.massBelowFinite R psi r)
      Filter.atTop
      (𝓝 (B.massBelowContinuum psi r))) ∧
  (∀ psi,
    Tendsto
      (fun R => B.normSqFinite R psi)
      Filter.atTop
      (𝓝 (B.normSqContinuum psi))) ∧
  (∀ psi,
    Tendsto
      (fun R => B.energyFinite R psi)
      Filter.atTop
      (𝓝 (B.energyContinuum psi)))

/--
Continuum mass-gap transfer.  The proof is exactly the remaining analytic
frontier: combine the finite regulated gap with a uniform/same-state limit.
-/
theorem continuum_mass_gap_of_finite_limits_V13
    (B : ContinuumGapBridgeV13)
    (m : ℝ)
    (hlimit : ContinuumLimitProducerV13 B)
    (hvanContinuum :
      ∀ psi r, r < m → B.massBelowContinuum psi r = 0)
    (hfiniteGap :
      ∀ R psi,
        (∀ r, r < m → B.massBelowFinite R psi r = 0) →
        m * B.normSqFinite R psi ≤ B.energyFinite R psi) :
    ∀ psi,
      m * B.normSqContinuum psi ≤ B.energyContinuum psi := by
  /-
  OPEN_MATH:
  the missing content is the regulator-to-continuum control strong enough to
  transport low-spectrum vanishing backwards to finite regulators (or an
  equivalent uniform estimate), then pass the finite inequality to the limit.
  Pointwise convergence of massBelow alone is not sufficient.
  -/
  sorry

end MCore.YangMills.A1
