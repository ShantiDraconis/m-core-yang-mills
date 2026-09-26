# ATL v3 implementation contract

Status: SOURCE

## Canonical state
Persist only node primitives and append-only log.  All proof/build/kernel/axiom/
semantic/certificate states, dependencies, consumers, replacement paths and
cut values are recomputed from the graph, source tree, build evidence and
certificate evidence.

## Router
Only OPEN_MATH_ATTACKABLE nodes enter the active proof cut.
OPEN_MATH_RESEARCH and OPEN_MATH_EXTERNAL are emitted as explicit
conditionalOn dependencies and do not consume retry cycles.

Primary heuristic after calibration:
`cut_value = sum(cost(n) / downstream_unlock(n))`.
Before 20 observations per useful node class, cost is marked heuristic.

## Reuse resolver
Bounded order:
exact hash -> alpha equivalence -> normalized expression -> bounded unfolding
(k=5) -> curated equiv_set -> stronger local theorem -> composition ->
cross-area research candidate.

No unbounded semantic-equivalence search.  A stronger theorem is promoted only
when a local checked implication discharges the target. External structural
matching is discovery evidence only.

## Gate batcher
Collect all independent failures on the active cut. Classify TYPE, BUILD, AXIOM,
SEMANTIC, OPEN_MATH. Canonical errors are all minimal upstream failures in the
DAG; ties are retained.

## Five firewalls
1. AXIOM: theorem axioms subset of declared logical base; sorryAx/custom
scientific axioms fail.
2. CIRCULARITY: acyclic dependency graph keyed by frozen statement identity.
3. SEMANTIC: frozen formal/semantic identity and allowed adapters unchanged.
4. INTERFACE: no Prop/Nonempty/placeholder standing in for required data-bearing
scientific witness.
5. VACUITY: reject empty-domain/False-hypothesis/trivial-conclusion shortcuts;
non-vacuity evidence is obligation-specific, not inferred from Inhabited alone.

## Promotion
SOURCE -> BUILD -> KERNEL -> SEMANTIC -> SCIENTIFIC.
No layer skipping. A changed statement is a new version with supersession,
not mutation of prior certified history. FORMULATION_FALSIFIED is router log,
not a positive promotion state. OPEN_MATH is classification.

## Swarm
PLANNER / RECOVERY / PROVER / AUDITOR / CERTIFIER.
PROVER retry budget = 3 bounded attempts; then PLANNER reclassifies the node.

## EGC
FINAL_PROOF, FINAL_ROOT and EXTERNAL_CERTIFICATE are views of one canonical EGC
object rather than three independently mutable truth states. Historical names
may remain compatibility projections.

## Proof mining
Mining artifacts are separate from theorem certificates. MINING_NOT_APPLICABLE
is classification, not failure. An EGC_MINED may certify an already-proved
fragment and extracted quantitative content, but cannot promote an open
Millennium statement.

## Current YM application
The hardened fast-gate currently isolates `B6UniformLowerBound` as a
research-class producer candidate. Certified SpectralExclusion remains reusable
downstream. Neither pointwise lattice gaps nor strong-coupling fragments are
promoted to the full YM4 uniform continuum gap without an exact implication.
