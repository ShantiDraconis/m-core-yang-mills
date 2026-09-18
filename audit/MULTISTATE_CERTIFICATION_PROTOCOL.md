# Multistate Proof / Refutation Certification Protocol v1

## Non-negotiable state machine

Every research chain is represented independently as:

`OPEN -> MEIO_TERMO -> { FECHADO | REFUTADO | INDETERMINADO_WITH_RESIDUE }`

A prefix may be certified while its next frontier remains open, partial, refuted, or indeterminate. Therefore records use pairs such as `FECHADO/FECHADO`, `FECHADO/ABERTO`, `FECHADO/MEIO_TERMO`, and `FECHADO/INDETERMINADO`.

## Two independent axes

Never collapse these fields:

- `MECHANICAL_STATUS`: build/test/CI result.
- `MATHEMATICAL_STATUS`: OPEN, MEIO_TERMO, CLOSED_DEFINITION, CLOSED_COMPRESSION, TARGET_CERTIFICATE, REFUTED, or INDETERMINATE_WITH_RESIDUE.

`CI GREEN != mathematical proof`.

## Bidirectional gate

For every real frontier Gi run two logically separate searches:

1. PROOF_SEARCH: derive Gi from admissible prior hypotheses.
2. FALSIFICATION_SEARCH: seek a model/counterexample satisfying the prior hypotheses and violating Gi.

Outcomes:
- proof closes -> TARGET_CERTIFICATE only if Gi is literally the target;
- counterexample closes -> REFUTED for that proposition/bridge;
- partial derivation -> MEIO_TERMO plus exact residue;
- neither -> INDETERMINATE_WITH_RESIDUE.

Do not turn failure to prove into refutation or failure to refute into proof.

## Semantic gate

Before promotion, record all six dimensions:
`HYPOTHESIS_MATCH`, `CONCLUSION_MATCH`, `QUANTIFIER_MATCH`, `SCALING_MATCH`, `CONSTANT_MATCH`, `AXIOM_AUDIT`.

Any mismatch remains explicit. No assumption laundering through interfaces, structures, Prop fields, axioms, placeholders, `sorry`, `admit`, or circular endpoint hypotheses.

## Provenance / isolation

Every certificate records source repository, frozen source SHA, source path/theorem, target repository, target path/theorem, dependencies, CI run/job when available, and exact residue. Existing main history and prior branches are immutable evidence: no force-push, destructive merge, or deletion.

Cross-repository results are imported theorem-by-theorem from frozen SHAs. Similar-looking chains in different research programs are never merged merely because they share notation or architecture.

## Dense backward workflow

1. State the literal FINAL target(s) without circularity.
2. Compress wiring and external classical results away from REAL_FRONTIER nodes.
3. Audit each REAL_FRONTIER in the six semantic dimensions.
4. Produce one dense reproduction for the frontier.
5. Run the minimum decisive build/test gate.
6. Freeze a genuine certificate or publish the exact residue.
7. Continue backward until the first unresolved mathematical frontier.

## Required ledger fields

`CERT_ID | BASE_SHA | HEAD_SHA | SOURCE_SHA | THEOREM | PROOF_SEARCH | FALSIFICATION_SEARCH | MECHANICAL_STATUS | MATHEMATICAL_STATUS | SIX_DIMENSIONS | RESIDUE | RUN | JOB`

## Problem-specific directive

**Research line:** Yang–Mills mass gap

Existence and mass-gap obligations remain explicit and separate; computational evidence is not a target certificate.

## Branch scope

This protocol is introduced only on `audit/multistate-proof-refutation-v1`. It does not alter or promote any theorem on `main`. Each repository keeps its own certificate chain and its own terminal propositions.
