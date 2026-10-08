# ATK V15 material endpoint qualification (2026-10-08)

Source: `lean/MCore/YangMills/A1/RecoveredContinuumK14V15.lean`.

## Recovered mathematical chain

1. `normSqContinuum_eq_normSq` identifies the continuum norm-square with the Hilbert norm-square, using uniqueness of limits for a constant approximating sequence.
2. `recovered_gapBound_V15` proves the K14 quadratic-form gap **conditional on** `ContinuumHamiltonianIdentificationV15 U R K`.
3. `recovered_K14MassGap_V15` packages that conditional gap with `U.hm0`.
4. `recovered_FINAL_ROOT_V15` produces the corresponding **K14** existential gap, not an unconditional four-dimensional Yang–Mills existence-and-mass-gap theorem.

## Exact material frontier

`ContinuumHamiltonianIdentificationV15.energy_eq` requires

```lean
∀ psi : HSpace,
  R.energyContinuum psi = Complex.re (inner psi (K.H_op psi))
```

The theorem currently **takes this identification as an input**. The surrounding realization also assumes `UniformRegulatorControlV2`, a `RegulatedContinuumRealizationV13`, and a `K14HamiltonianConcreteRealizationV13`. The file explicitly requires `[FiniteDimensional ℂ HSpace]`; this is not by itself the physical infinite-dimensional continuum Hilbert space.

## Promotion rule

Do not promote this route to an unconditional physical Yang–Mills certificate until all physical model existence, identification, continuum limit, and nontriviality requirements are discharged in concrete typed definitions and checked by the Lean kernel with an axiom audit. No `sorry`, `axiom`, arbitrary `Prop` inhabitants, or redefinition of the endpoint may substitute for those proofs.

Status: `OPEN_MATH`. This note changes no certified theorem.
