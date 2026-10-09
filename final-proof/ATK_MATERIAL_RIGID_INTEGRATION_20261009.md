# ATK rigid material integration — m-core-yang-mills

Branch: atk/material-rigid-integration-20261009

Policy: forward-only; preserve existing proofs and frozen commits.

Certification requirements:
- Import only existing verified Lean declarations with exact types.
- Preserve concrete mathematical definitions, witnesses, operators, and laws.
- Audit transitive dependencies and `#print axioms` for terminal theorems.
- Do not promote conditional proofs, `Nonempty` wrappers, or placeholders to unconditional results.
- Set OPEN_MATH=false only after every terminal obligation is discharged.
- Kernel status: NOT_RUN. Material certification: PENDING.

Next: inventory all relevant source paths and immutable commit/blob SHAs, then build an importable compiler from actual declarations.
