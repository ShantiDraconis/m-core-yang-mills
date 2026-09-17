# Cross-Repository Certified Import Protocol

This repository keeps its Yang--Mills proof chain independent. Results from another repository may reduce a local gap, but they never transfer a conclusion merely because the formulas look similar.

## Required import record

Every imported result must record: SOURCE_REPOSITORY, SOURCE_SHA (40 hex), FROZEN_REF, CERTIFICATE, SOURCE_CREATED_AT, CERTIFIED_AT, SOURCE_GATE, SOURCE_THEOREM, SOURCE_CLASSIFICATION, TARGET_REPOSITORY, TARGET_GATE, TARGET_GAP, IMPORT_MODE, HYPOTHESES_MATCH, SEMANTIC_MATCH, and DEPENDENCY_HASH.

## Import modes

- `EXACT`: source theorem and target obligation have the same relevant types, hypotheses and semantics. The dependency may be reused formally after the provenance checks pass.
- `ADAPTED`: a proved adapter maps the target hypotheses/types into the certified source theorem and maps its conclusion back to the target obligation. The adapter is part of the proof obligation.
- `ANALOGY_ONLY`: useful strategy, operator, estimate, counterexample pattern or test design; it is not evidence that the target conclusion holds.
- `CROSS_REPO_INCOMPATIBLE`: hypotheses, types, scale, domain or semantics do not match. No proof edge is created.

## Fail-closed rule

An import with missing provenance or unproved semantic/hypothesis compatibility cannot participate in the formal endpoint. Similar notation, identical algebraic shape, or a GREEN certificate in another problem is insufficient.

## Minimal-gate rule

Before creating a new mathematical child, search the frozen global corpus. Reuse only the smallest certified theorem that reduces the current target gap. Do not merge problem chains. A shared lemma may be a dependency of several independent chains, but each chain retains its own target, hypotheses, provenance and certificate.

## Yang--Mills current operational frontier

Historical K0--K30 remains immutable provenance. `MCore.FinalCore` compresses the operational chain to construction/reconstruction, infrared/uniform clustering, limit control and spectral realization. Mechanically derivable edges are CORE, not new scientific gates.
