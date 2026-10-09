# ATK source provenance — YM

- Original source: `lean/MCore/Material/Closure.lean`
- Original blob SHA: `fa9645e0d2bab5c2601fdca00a86a37d2f7a0972`
- Finding: YMClosure requires spectralGap, surjectivePhysical, and continuumControl proofs.
- Classification: SOURCE; material terminal proof not established by this source alone.
- Action: migrate exact declarations and transitive dependencies into `lean/ATK/YM_MaterialDense.lean` before kernel certification.
- No OPEN_MATH/CLOSED_MATH flag is promoted by this record.
