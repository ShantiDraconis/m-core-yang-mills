# Stabilization Kernel / Exact Crossing Line — preserved ATK hypothesis

## Question

What is the exact mathematical kernel at which the observed dynamics changes from unstable/growing/undetermined behavior to stable/compressed/terminal behavior, and what is the first exact transition that crosses it?

This is an experimental question, not an asserted universal theorem.

## Required record

For every tested chain X_0 -> X_1 -> ... preserve:

- PRE_KERNEL: last state before the candidate kernel.
- KERNEL: exact typed object/predicate/operator/threshold/stratum.
- POST_KERNEL: first state after it.
- CROSSING_MAP: exact transformation PRE_KERNEL -> KERNEL -> POST_KERNEL.
- FIRST_CROSSING_INDEX: minimal index if a discrete chain exists.
- LEFT_BEHAVIOR / CENTER_BEHAVIOR / RIGHT_BEHAVIOR.
- STABILITY_MEASURE: norm, residual, spectrum, rank, energy, defect, complexity, or problem-native quantity.
- STABILITY_CRITERION: exact predicate defining stabilization.
- INVARIANTS_PRESERVED / INFORMATION_LOST.
- COMPLEX_DATA: Re/Im, modulus, phase when genuinely defined.
- MATRIX_DATA: matrix/operator, trace, determinant, rank, eigen/singular values, spectral radius when genuinely defined.
- BASE_REPRESENTATIONS: raw value plus base 2, 10, 60 only when representation is meaningful.
- HARAPPAN_DATA: observed numeric/symbolic values with repository provenance; never treated as mathematical equivalence without a proved bridge.
- ZERO_LOCUS: exact quantities that vanish and path information.
- OMEGA_CANDIDATE: exact object and definition if a limit/fixed point/critical parameter is detected.
- PROVENANCE: repo, V, file, declaration, SHA, run/job/target where available.

## Detection rules

Emit STABILIZATION_KERNEL_DETECTED only if a typed kernel and a stability criterion are both identified.

Emit EXACT_CROSSING_DETECTED only if the first transition across the kernel is proved/observed with explicit before/after objects.

Emit OMEGA_STABILIZER_DETECTED only if an independently defined omega-like object actually satisfies a stated stabilization property.

Do not identify division by zero with a number. A 0/0 signature requires two concrete quantities degenerating and an explicit limiting/regularizing path.

Do not infer a universal kernel from shared vocabulary. Cross-problem matches are classified as numerical, structural, logical, dynamical, or formal equivalence.

## ATK preservation rule

Every future ATK preserves this line even when the result is negative. A failed candidate kernel, non-stabilizing crossing, path dependence, incompatible spectrum, or Harappan mismatch is first-class evidence and must remain auditable.
