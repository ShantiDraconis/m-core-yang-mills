# ATK Terminal Producer Index

Status: CANONICAL LOCATION AUDIT
Date: 2026-09-21

Purpose: canonical cross-repository map of the files that define, consume, or audit the seven remaining terminal mathematical frontiers. This index is navigational evidence only; it does not promote any OPEN_MATH node.

## BEAL — ShantiDraconis/m-core-beal
Pinned attack HEAD: `d039136fe260d626fbf0974a3413d222e13d43f8`
- `FRONTIER.yaml` — declares BEAL-COMMON-PRIME-ENDPOINT as OPEN_BRIDGE.
- `lean/MCore/BealSpecification.lean` — semantic Beal/CommonPrime specification.
- `lean/MCore/K8.lean` — downstream CommonPrime consumer.
- `lean/MCore/GCDSignature.lean` — proved GCD-signature infrastructure; not the missing producer.
- `lean/MCore/BackwardAudit/WithoutOracle.lean` — CommonPrimeWitnessContract and fail-closed no-oracle audit.
Terminal producer: `∀ d : BealData, CommonPrime d.a d.b d.c`.

## HODGE — ShantiDraconis/m-core-hodge
Pinned attack HEAD: `f0fffbe0eed8bfaf0bd060317fa13f648b3790fd`
- `FRONTIER.yaml` — HODGE-ALGEBRAICITY-SURJECTIVITY = OPEN_BRIDGE.
- `lean/MCore/Hodge.lean` — RationalHodgeConjecture, HodgeBridge, semantic interface.
- `lean/MCore/HodgeReduction.lean` — reduction layer.
- `audit/ALGEBRAICITY_SURJECTIVITY_RESIDUE.md` — explicit residue audit.
- `audit/EndpointCompression.lean` and `audit/FinalEndpoint.lean` — endpoint compression/consumer layer.
- `lean/MCore/ATK_HARD_HODGE_GENERAL.lean` — HARD sentinel.
Terminal producer: arbitrary-codimension algebraicity/surjectivity, i.e. `RationalHodgeConjecture D`.

## YANG–MILLS — ShantiDraconis/m-core-yang-mills
Pinned attack HEAD: `645b299959f02902c7e6245855d3b5da9a951139`
- `FRONTIER.yaml` — repository frontier.
- `lean/MCore/PureMathFrontier.md` — pure-math frontier description.
- `lean/MCore/K13.lean`, `lean/MCore/K14.lean` — typed downstream stages.
- `lean/MCore/PhysicalGapScaling.lean` — physical gap/scaling layer.
- `lean/MCore/YangMills/A1/FrontierDecomposition.lean`
- `lean/MCore/YangMills/A1/FrontierDecompositionV2.lean`
- `lean/MCore/YangMills/A1/B60ConcretePhysicalAdapter.lean`
Terminal producer: genuine 4D physical mass/reconstruction input yielding a positive spectral gap; trivial/phantom physical interfaces do not count.

## RIEMANN — ShantiDraconis/m-core-riemann
Pinned attack HEAD: `ad3011f14bdab32161205e053fa925bc8c851ad4`
K8 GREEN evidence: run `35565114760`, job `106225268018`.
- `lean/MCore/K8.lean` — GREEN endpoint API; do not redo.
- `research/r2/DNLimitZeroAttack.md` — direct DNLimit=0 attack record.
- `lean/MCore/RH/NB/ZeroLimitFrontier.lean` — zero-limit formal frontier.
- `audit/R2_ZERO_RESIDUE_OBSTRUCTION.md` — zero-residue obstruction audit.
- `audit/R1_BAEZ_DUARTE_INTERFACE.json` — R1 interface audit.
- `FRONTIER.yaml` — repository frontier.
Terminal producer: unconditional concrete DN vanishing estimate → `DNLimit = 0` → R1ExternalBridge → RH.

## P vs NP — ShantiDraconis/m-core-p-vs-np
Pinned attack HEAD: `95963a2f6408606f4f691f49647b2dc75f156289`
- `audit/ORIENTED_WITNESS_BOUNDARY.md` — exact Type A / Type B boundary.
- `lean/MCore/BackwardAudit/OrientedWitnessBoundary.lean` — `LowerBoundWitness` with fields `language`, `in_np`, `not_in_p`.
- `audit/EndpointCompression.lean`, `audit/FinalEndpoint.lean` — downstream endpoint composition.
- `audit/PNP_RESIDUE.md` and `audit/PNP_FRONTIERS_SEMANTIC_AUDIT.json` — residue/semantic audits.
- `lean/MCore/Real/CanonicalSATWitness.lean` — concrete SAT witness layer.
Terminal producer for separation lane: a concrete language with `in_np` and a genuine proof of `not_in_p`.

## BSD — ShantiDraconis/m-core-bsd
Pinned attack HEAD: `dfa710de6a8646640db8b7010e3e00d439091d31`
- `lean/MCore/K13.lean` — `BSDOpenCore d := BSDRankPart d`; exact alias, not new mathematics.
- `lean/MCore/BackwardAudit/WithoutOracle.lean` — `RankPartWitnessContract` and fail-closed no-oracle audit.
- `lean/MCore/K14.lean` — final typed audit preserving OPEN_BRIDGE.
- `CERTIFICATES/K14_GREEN.md` — K14 GREEN audit certificate; explicitly not a BSD proof.
- `FRONTIER.yaml` — repository frontier.
Terminal producer: `∀ d : BSDArithmeticAnalyticData, BSDRankPart d`, followed by any remaining full-BSD coefficient/arithmetic obligations not already encoded by that abstraction.

## NAVIER–STOKES — ShantiDraconis/navier-stokes-critical-barrier-audit
Pinned attack HEAD: `bdf538c84076cece7aae52e9d35d68c226e968d1`
- `audit/65_exact_failure_and_minimal_closure_obligations.md` — canonical four-gap reduction G1–G4.
- `audit/66_G1_maximal_closure_audit.md` — G1A/G1B/G1C genealogy and promotion rule.
- `G1_KAdmissible_to_SignedDepletion.lean` — signed-depletion composition.
- `formal/G1/G1_DynamicCriticalGeometry.lean` — dynamic-geometry formal layer.
- `formal/lean/CriticalBarrier/B2_8_SignedFlux_GapIsolation.lean` — signed-flux gap isolation.
- `formal/lean/CriticalBarrier/B2_DeterministicParameterChain.lean` — proved conditional algebraic decay/interpolation chain.
- `formal/lean/CriticalBarrier/CriticalTailBridge.lean` — critical-tail bridge.
- `formal/lean/CriticalBarrier/EndpointInterfaces.lean` — endpoint interface.
- `formal/lean/CriticalBarrier/G1G4ClosureBlueprint.lean` — G1–G4 composition blueprint.
- `formal/lean/CriticalBarrier/GlobalRegularityFromG1.lean` — downstream conditional composition.
Terminal independent gaps: G1 signed nonlinear control; G2 critical high-frequency control; G3 fixed-scale reconstruction; G4 exact ESS hypothesis map.

## Fail-closed rule
No path above is evidence of a final proof merely because it exists or compiles. OPEN_MATH is promoted only by a kernel-checked proof of the exact producer statement with zero `sorry`, zero `admit`, no hidden oracle/axiom, no circular import, no trivial witness, and no semantic weakening. GREEN downstream consumers are reused and never counted as producer closure.
