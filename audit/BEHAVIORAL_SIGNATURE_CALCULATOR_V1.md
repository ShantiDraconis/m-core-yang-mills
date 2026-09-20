# Behavioral Signature Calculator — V protocol

This repository participates in the M-Core behavioral-signature experiment.

This is an observational calculator/detector, not a proof oracle. It MUST NOT assume the target theorem, a 2->1 implication, a universal point-care law, or a common cross-problem signature.

## Input record for every V

Collect raw data before interpretation:

- STATE: typed mathematical objects, values, restrictions and domains.
- LOGIC: exact hypotheses, conclusion, quantifier order and direction.
- POSITION: START / APPROACH / CENTER / DEPARTURE / END / CROSSING.
- TRANSFORM: input, operation, output, pre/postconditions, reversibility.
- BEHAVIOR: monotonicity, stabilization, oscillation, branching, reconvergence, symmetry, saturation, collapse/compression, terminal behavior.
- INVARIANTS.
- INFORMATION_PRESERVED / INFORMATION_LOST.
- EXTREMA: min/max/sup/inf, attainment, uniqueness, boundedness.
- CENTER: exact independently defined state-2 predicate/object and reachability.
- ZERO_ZERO: two concrete typed quantities, path, rates and resolution transform.
- OMEGA: exact meaning and family/sequence; never infer infinity from a label.
- COUNTEREXAMPLES and near misses.
- MINIMAL_HYPOTHESES.
- DEPENDENCY_DAG / circularity / endpoint leakage.
- PROVENANCE: V, path, theorem/object, SHA, parent SHA, branch, run, job, target, toolchain, axioms, artifact/hash.

## State-2 calculator

For a problem P define only after its own objects are typed:

SIGMA2(P) = (size, position, residual, endpoint-distance-if-defined,
             invariants, information-loss, transition-2-to-1-if-proved).

Pairwise comparisons may emit:
- EXACT_MATCH
- NORMALIZED_MATCH
- STRUCTURAL_MATCH
- LOGICAL_MATCH
- DYNAMICAL_MATCH
- DIVERGENCE
- NOT_COMPARABLE
- NOVEL_STRUCTURE

Percent error/difference is permitted only for dimensionally/semantically compatible quantities or a justified dimensionless normalization. Otherwise emit NOT_COMPARABLE.

## Detectors

PATTERN_DETECTED
INVARIANT_DETECTED
CENTER_SIGNATURE_DETECTED
0_0_SIGNATURE_DETECTED
OMEGA_BEHAVIOR_DETECTED
M_CORE_STRUCTURE_DETECTED
M_CORE_CROSSING_DETECTED
NOVEL_STRUCTURE_DETECTED
NO_0_0_SIGNATURE

0_0_SIGNATURE_DETECTED requires two identified typed quantities and evidence that both vanish/degenerate under an explicit path. The text "0/0" alone is not evidence.

## Proof firewall

A generic proposition of the form

    IsMaximalMiddle(d) -> Property(d)

is a CENTER_COMPRESSION_TARGET unless independently proved from the mathematics of this repository. It MUST NOT be introduced as an axiom to close FinalProof.

Audit status (GREEN/RED/FROZEN/CERTIFIED/OPEN_EXACT) is metadata, not mathematical behavior.

## Cross-repository objective

The repositories act as calculators of their own behavior. The M-Core comparison layer may compare their emitted records, but similarity is not formal equivalence. Preserve mismatches and negative results: they are first-class experimental data.
