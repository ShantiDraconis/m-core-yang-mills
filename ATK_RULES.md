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
