# YM Multistate Claim Protocol

Status: SOURCE / FAIL-CLOSED
Base branch: atk/ym-q-core
Q-core commit: c400565d70e50b43ae647f480daedc0c9a89a759

## Scope

This protocol tests a multistate formalism against the repository's Yang--Mills endpoint.
It does not promote the formal state I00 to a physical Yang--Mills state without a
kernel-checked, nontrivial physical bridge.

## State model

proofSector <-> I00 <-> refutationSector

I00 is a primitive formal state label. It is not arithmetic division 0/0 in Nat,
Real, or Complex.

## Claim lanes

### P — proof lane

Required producer:
1. genuine four-dimensional Yang--Mills realization;
2. reconstruction satisfying the repository's physical hypotheses;
3. positive spectral gap;
4. exact compatibility with the official endpoint.

Promotion:
HABITABILITY = PROVED only after a kernel-checked inhabitant of the exact producer.

### R — exclusion/refutation lane

Required producer:
1. same semantic base and physical domain as P;
2. concrete nondegenerate countermodel or obstruction;
3. proof that the required endpoint consequence fails;
4. exact statement identifying the formulation contradicted.

Promotion:
PROVED_EXCLUSION = PROVED only after a kernel-checked exclusion theorem.
Failure of an attempted proof is not evidence of refutation.

### Q — multistate lane

Required producer:
1. Q-core algebra;
2. contraction/tension/repulsion laws;
3. bidirectional sector/core transitions;
4. fixed-point theorem for I00;
5. nontrivial physical interpretation map;
6. proof that the interpretation preserves the required Yang--Mills semantics.

The first four items are formal algebra only. Items 5--6 are the scientific boundary.

## Meeting gate

The lanes may be compared only after they share the same:
- Yang--Mills statement;
- domain/dimension;
- hypotheses;
- reconstruction semantics;
- spectral-gap observable.

A mismatch is FAIL_CLOSED, not a scientific result.

## Outcomes

READY requires all applicable lane artifacts, exact provenance, kernel/axiom audit,
CI evidence, and the scientific-boundary comparison.

Possible internally certified outcomes:
- PROOF_LANE_SURVIVES
- REFUTATION_LANE_SURVIVES
- Q_PHYSICAL_BRIDGE_SURVIVES
- INCONCLUSIVE / OPEN_MATH

No outcome is inferred merely because another lane fails.

## FINAL FAIL rule

FINAL_FAIL records the first exact obligation that cannot pass its gate.
It is diagnostic evidence. It is not by itself a proof of the opposite lane.

## Promotion protocol

For each material gate:

SOURCE -> BUILD_PENDING -> GREEN -> CERTIFIED -> FROZEN -> NEXT_GATE

Promotion is forbidden if any material theorem depends on:
- sorry;
- admit;
- theorem-carrying custom axioms;
- vacuous True;
- placeholder/phantom physical interfaces;
- circular dependencies;
- finite/numerical tests substituted for a universal theorem;
- semantic weakening of the target.

## READY manifest

READY may be emitted only with:
- base_sha
- proof_lane_sha/status
- refutation_lane_sha/status
- q_lane_sha/status
- physical_bridge_sha/status
- meeting_gate_sha/status
- scientific_boundary_sha/status
- axiom_audit_sha/status
- ci_run_ids
- frozen certificate roots
- final_fail_sha, if any
- final_root

Until those fields are backed by real artifacts:
READY = false
FINAL_ROOT = null
SCIENTIFIC_ENDPOINT_PROVED = false
