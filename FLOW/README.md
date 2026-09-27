# ATK Flow Separation

Repository: `ShantiDraconis/m-core-yang-mills`

This directory is the canonical routing layer for ATK work.

- `REAL/`: kernel-checkable mathematical and proof-engineering evidence only.
- `HYPOTHETICAL/`: counterfactual assumptions, toy worlds, oracle experiments, and saturation studies.
- `MINED/`: normalized observations extracted from REAL or HYPOTHETICAL, with provenance preserved.

## Non-contamination rule

`HYPOTHETICAL -> REAL` is forbidden as a proof dependency.

A hypothetical result may generate a candidate pattern or research question, but it may not generate GREEN, FROZEN, CERTIFIED, or a terminal inhabitant.

Promotion in REAL requires all of:
1. exact terminal type match;
2. kernel build success;
3. no `sorry` / `admit` / `sorryAx`;
4. no theorem-carrying custom axiom/oracle;
5. provenance to SHA/run;
6. no semantic weakening.

Existing Lean paths are not moved in this cleanup branch, so certified imports remain intact. Legacy mixed-location files are listed in `LEGACY_QUARANTINE.json` and are treated according to their declared class.
