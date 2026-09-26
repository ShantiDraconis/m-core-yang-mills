# B6 spectral reduction — FAST-GATE

Status: SOURCE_REDUCED / OPEN_MATH

## Certified reusable theorems

- SpectralExclusion `eedcf794`: `spectral_exclusion_at_subrate` and `realized_exclusion`.
- SpectralConcrete `2db15914`: `concrete_adapter_mass_gap`.
- K30 `9aecfca6`: `k30_witness_closes_conditional_chain`.

## Exact reduction

The spectral end of B6 does not require reproving the abstract exponential-decay contradiction.

It is sufficient to construct, for the same physical Yang–Mills Hamiltonian and observable sector:

1. `PositiveSpectralLaplaceData` with a genuine spectral-measure lower bound.
2. `ExponentialDecayData spectral.laplace` from the YM clustering theorem.
3. Nonnegativity of `massBelow`.
4. A semantics-preserving map from `massBelow r = 0` for every `0 <= r < m` to the K14/K30 low-spectrum exclusion predicate.
5. Coverage/density of all physical vacuum-orthogonal domain states required by `ConcreteHilbertAdapter`.

Then the certified chain supplies:
`realized_exclusion -> ConcreteHilbertAdapter.spectralLowerBound -> concrete_adapter_mass_gap`
or equivalently the K30 witness route.

## Remaining OPEN_MATH edge

`YM4 physical reconstruction + same-H semigroup/spectral-measure identification + uniform exponential clustering + physical-sector coverage`.

No abstract spectral exclusion theorem needs to be reproved.

## Firewall

This reduction is not an inhabitant of `B6RealOpenMath`. The missing YM-specific realization cannot be replaced by an arbitrary Laplace function, an arbitrary Hilbert adapter, finite-volume data, or a carried proposition.
