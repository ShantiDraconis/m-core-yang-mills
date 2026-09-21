# ATK Immutable Progression Rule

This repository follows the ATK fail-closed progression rule.

## Non-stop rule

ATK MUST NOT stop at GREEN.

For every gate:

`GREEN -> CERTIFY -> FREEZE -> ADVANCE IMMEDIATELY TO NEXT GATE`

The repository continues independently from every other repository.

ATK may stop only when the current repository reaches one of:

- `RED` — a real failing gate that requires diagnosis/correction.
- `OPEN_MATH` — the next material theorem/estimate/object is genuinely unproved.
- `EXTERNAL_EVIDENCE_REQUIRED` — an external artifact/evidence is strictly required.

A GREEN result, successful CI run, certificate, or frozen checkpoint is never a stopping condition.

After GREEN, certification and freeze are part of the transition itself, not a terminal state.

No repository waits for another repository before advancing.

This rule is fail-closed: no `sorry`, `admit`, theorem-carrying custom axiom, vacuous `True`, placeholder interface, conditional wrapper, finite test, or numerical evidence may be promoted as a material TheoremKernel.


## Repository isolation and auditability

Each repository is an independent proof line.

There is no cross-repository theorem dependency, shared gate, synchronized certification requirement, or coupled promotion condition between these repositories.

For every repository independently:

`CURRENT FROZEN CHECKPOINT -> NEXT GATE -> GREEN -> CERTIFY -> FREEZE -> ADVANCE`

Audit requirements:

- preserve exact parent SHA for every promoted gate;
- record the exact gate SHA and CI run used for certification;
- keep theorem scope local to this repository;
- do not import proof claims, certificates, interfaces, or theorem assumptions from another ATK repository;
- do not merge unrelated mathematical fronts into one certificate;
- keep RED states and failed attempts preserved and identifiable;
- keep OPEN_MATH explicit instead of hiding it behind wrappers;
- every freeze must be reproducible from the repository's own dependency graph.

Parallelism is allowed and expected: repositories advance independently and simultaneously, but their proof chains remain separate, clean, and auditable.
