# Dense Backward Test Chain — YangMills

STATUS: SOURCE_CATALOG_ONLY / NO_MATHEMATICAL_PROMOTION

## Canonical 18 tests per real gate

T01 PROVENANCE_LOCK — source repo/SHA/path/theorem frozen.
T02 TYPE_DOMAIN — objects inhabit the intended domain.
T03 ADMISSIBILITY — exact admissible class is matched.
T04 HYPOTHESIS_MATCH — no strengthening/weakening is hidden.
T05 CONCLUSION_MATCH — conclusion is literally the required edge.
T06 QUANTIFIER_MATCH — order and uniformity of quantifiers match.
T07 SCALING_MATCH — dimensions/scaling/normalization match.
T08 CONSTANT_MATCH — constants are uniform with explicit dependencies.
T09 AXIOM_AUDIT — no sorry/admit/hidden axiom/interface laundering.
T10 NONCIRCULARITY — target/equivalent target is not an input.
T11 EXTERNAL_CLASSICAL — exact external theorem and hypothesis map recorded.
T12 PROOF_SEARCH — independent positive derivation attempt.
T13 FALSIFICATION_SEARCH — independent exact counterexample attempt.
T14 EDGE_COMPOSITION — output of previous gate is valid input here.
T15 BACKWARD_NECESSITY — determine whether this edge is real frontier or removable wiring.
T16 MECHANICAL_BUILD — minimum decisive Lean build/test.
T17 AXIOMS_PRINT — inspect theorem dependency/axiom footprint where applicable.
T18 STATE_PROMOTION — promote only to CLOSED/REFUTED/PARTIAL/INDETERMINATE according to evidence.

## Endpoint tests

E01 INITIAL_SPEC — initial system is fully specified without target circularity.
E02 FINAL_LITERAL — final proposition is literal and definition-only until proved.
E03 ENDPOINT_COMPRESSION — compressed DAG preserves the real route.
E04 MINIMAL_RESIDUE — all removable hypothetical assumptions have been eliminated.
E05 TARGET_CERTIFICATE — only literal target proof may receive TARGET_CERTIFICATE.

## Count

For G real gates/frontiers, the canonical audit has 18*G + 5 test obligations.
Proof and falsification are separate tests and may never discharge each other.
Mechanical GREEN cannot discharge a mathematical test.

## State transition

OPEN -> MEIO_TERMO -> CLOSED | REFUTED | INDETERMINATE_WITH_RESIDUE

Every test record must contain:
TEST_ID | GATE_ID | SOURCE_SHA | INPUTS | EXPECTED | OBSERVED | MECHANICAL_STATUS | MATHEMATICAL_STATUS | RESIDUE | EVIDENCE.
