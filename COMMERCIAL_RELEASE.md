# Commercial Release Profile

## Product mapping
**M-Core Millennium Suite — Yang–Mills Module**

Commercial role: research module; sell only inside the Millennium Formal Research Suite.

## Packaging rule
This repository is a source component. Buyers should receive a curated release archive, documentation, examples, reproducibility metadata, and an explicit status manifest rather than raw development history.

## Mandatory status separation
Every theorem/claim/artifact shipped to customers must be classified as one of:
- CERTIFIED_FORMALIZATION
- VERIFIED_ENGINEERING
- NUMERICAL_EXPERIMENT
- CONDITIONAL_RESULT
- OPEN_MATH
- EXPERIMENTAL

Compilation of supporting infrastructure is not evidence that an OPEN_MATH mathematical producer exists.

## Release gates
- [ ] ownership/third-party review
- [ ] license/EULA selected
- [ ] secrets/private-data audit
- [ ] clean build
- [ ] zero unintended sorry/admit/axiom in advertised certified surface
- [ ] #print axioms / dependency audit where applicable
- [ ] reproducible example
- [ ] release tag and checksum
- [ ] README + QUICKSTART + status manifest
- [ ] Gumroad copy derived from verified status only

## Distribution
Do not ship working branches, credentials, personal evidence, CI secrets, or unrelated research drafts. Export a versioned release package from a frozen commit.
