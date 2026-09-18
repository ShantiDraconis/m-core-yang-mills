# Massive Gate Architecture — YangMills

STATUS: SOURCE_CATALOG_ONLY / NO_MATHEMATICAL_PROMOTION

## Fixed macro-gates

G0 INITIAL_CONTRACT
G1 DOMAIN_ADMISSIBILITY
G2 FORWARD_MAX_PREFIX
G3 BACKWARD_MAX_SUFFIX
G4 COLLISION_FRONTIER
G5 COLLISION_DECOMPOSITION
G6 PROOF_SEARCH
G7 FALSIFICATION_SEARCH
G8 SEMANTIC_ARBITER
G9 LEAN_KERNEL_AND_AXIOMS
G10 MINIMAL_RESIDUE
G11 FINAL_TARGET

These 12 macro-gates are architectural. G5 expands into N repository-local
micro-gates C1..CN discovered from the actual mathematics/evidence. N is not
predeclared: inventing a fixed N would hide or manufacture obligations.

## Minimum no-cheating decisive tests per gate

Each real mathematical micro-gate receives exactly 8 mandatory decisive tests:
1 PROVENANCE_LOCK
2 HYPOTHESIS_CONCLUSION_MATCH
3 QUANTIFIER_MATCH
4 SCALING_CONSTANT_MATCH
5 AXIOM_NONCIRCULARITY
6 PROOF_SEARCH
7 FALSIFICATION_SEARCH
8 LEAN_BUILD_AND_PRINT_AXIOMS

The earlier 18-test matrix remains the expanded forensic form. The 8-test form
is the minimum dense form and may be used only when its combined tests retain
all 18 obligations and evidence fields.

## Count

Let N = number of real mathematical micro-gates after wiring compression.
Core decisive mathematical tests = 8*N.
Add 12 macro-gate state checks and 5 endpoint/certificate checks.
Canonical minimum total = 8*N + 17.

No file-count target is imposed. Prefer massive coherent files with named
sections and theorem-local #print axioms over many tiny files, provided source
provenance and residues remain individually addressable.

## No-cheating invariants

- zero sorry/admit
- zero hidden research axioms
- target/equivalent target never appears as an admissibility hypothesis
- structure Prop fields count as assumptions until independently discharged
- EXTERNAL_CLASSICAL is named and hypothesis-matched
- CI GREEN is mechanical only
- proof-search and falsification-search are independent
- no finite search is promoted to a universal theorem
- constants must have explicit uniform dependencies
- quantifier order is literal
- cross-repo theorems require frozen source SHA/path/theorem
- HYPOTHETICAL_CLOSED can guide search but can never promote a certificate
- TARGET_CERTIFICATE requires zero unresolved research assumptions on the literal route

## Promotion

A micro-gate may promote only after all 8 decisive tests have evidence.
Otherwise it is MEIO_TERMO, REFUTED, or INDETERMINATE_WITH_RESIDUE.
