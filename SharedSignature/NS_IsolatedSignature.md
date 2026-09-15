# NS Isolated Signature — shared candidate

Status: SHARED_CANDIDATE / UNPROVED_ADAPTER
Source track: frozen Navier–Stokes audit; this file does not modify that source.

## NS signature being tested

For a smooth Navier–Stokes field, write

I(u) = (∫ ω · Sω) / (ν ‖∇ω‖²₂) = V/(ν Z).

The isolated obstruction package has four distinct properties:

1. Amplitude: under u ↦ A u, numerator V is cubic and Z quadratic, hence I(Au)=A I(u) where defined. A universal fixed gap I≤1−δ cannot follow from an amplitude-uniform claim if a positive witness exists.
2. Quotient/self-reference surface: I=G/H; any downstream coefficient constructed from the same evolving state must be audited for cycles rather than assumed independent.
3. Zero/degenerate locus: numerator and denominator can vanish together; a quotient value at H=0 requires an explicit extension/regularization theorem. Direction-dependent paths are an obstruction to a common continuous extension.
4. Critical PDE scaling: under the Navier–Stokes scaling u_λ(x,t)=λu(λx,λ²t), numerator and denominator have the same scaling degree, so I is scale invariant where defined.

These four statements are NS-specific until an adapter theorem proves a counterpart in another problem. Numerical constants such as Φ=0.609 and any τ-rigidity claim are intentionally excluded.

## Global structural signature

Statement → Dependencies → Bridge → Certificate → Endpoint.

An OPEN_BRIDGE or NUMERICAL_EVIDENCE node cannot be promoted to a proof certificate merely by this architecture.

## Yang–Mills adapter obligation

No Yang–Mills mathematical equivalence is asserted here. Required before reuse: define a Yang–Mills obstruction I_YM and prove, separately, the relevant amplitude/quotient/zero/scaling laws plus both directions for any claimed equivalence. Until then relation = SHARED_CANDIDATE / OPEN_BRIDGE.
