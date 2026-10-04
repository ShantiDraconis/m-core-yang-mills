# P02-YM V13 — Exact Remaining OPEN_MATH

Base checkpoint:

- FROZEN branch: `frozen/ym-v10-green-6e8f74c9`
- SOURCE: `6e8f74c9b51465bb5a227a88362d094f3fd64b4f`
- CERTIFICATE: `bb0bc3f2abcf247f3a942097c91416c8ce56fab7`
- VALIDATED RUN: `37163576421` (SUCCESS)
- Lean: `leanprover/lean4:v4.19.0`
- mathlib: `c44e0c8ee63ca166450922a373c7409c5d26b00b`

## Rule

This branch starts only from the certified V10 checkpoint. Experimental V11/V12 work is isolated on separate branches and must not be merged here unless independently re-proved and kernel-validated.

No `sorry`, `admit`, new axiom, endpoint-equivalent wrapper, or extra hypothesis may be promoted from `open_math/` into `lean/`.

## OPEN_MATH = 1

The only material producer remaining in the current typed interfaces is the same-model semantic bridge from derived low-spectrum exclusion to the concrete K14 gap predicate.

Current exact polymorphic target:

```lean
exclusionToGapBound :
  (∀ r : ℝ,
    0 ≤ r →
    r < S.decay.m →
    S.spectral.massBelow r = 0)
  →
  ∀ (psi : D.State) (hpsi : H.domain psi),
    D.physical psi →
    D.orthogonalToVacuum psi →
    G.gapBound rate psi (H.act psi hpsi)
```

where:

```lean
S    : MCore.SpectralExclusionRealization
rate : D.Scale
D    : MCore.K14PhysicalHilbertData
H    : MCore.K14HamiltonianOperator D
G    : MCore.K14GapScale D
```

Important typing constraint: `S.decay.m : ℝ`, while `rate : D.Scale`. They become literally the same quantity only after V13 supplies a concrete realization with `D.Scale = ℝ` (or an explicit map from the real spectral rate into `D.Scale`).

## V13 concrete target

V13 must define an actual analytic realization in which `gapBound` is not opaque. The intended real-valued specialization is of the form

```lean
D.Scale := ℝ

G.gapBound m psi Hpsi :=
  m * normSq psi ≤ energyPairing psi Hpsi
```

with concrete definitions for:

- the Hilbert state space,
- inner product / norm-square,
- Hamiltonian domain and action,
- self-adjointness / positivity required by the spectral theorem,
- the spectral measure of the same Hamiltonian and state,
- `massBelow` as that measure on the low-energy interval,
- the spectral integral identity for the energy pairing.

The analytic proof then has the shape

```text
massBelow(r) = 0 for every 0 ≤ r < m
        ↓
spectral measure supported in [m,∞) on the vacuum-orthogonal sector
        ↓
∫ λ dμ_psi(λ) ≥ m * ∫ 1 dμ_psi(λ)
        ↓
⟪psi, H psi⟫ ≥ m * ‖psi‖²
        ↓
G.gapBound m psi (H.act psi hpsi)
```

Any missing premise exposed by Lean must become a named lemma in V13, not an added field that merely restates `gapBound`.
