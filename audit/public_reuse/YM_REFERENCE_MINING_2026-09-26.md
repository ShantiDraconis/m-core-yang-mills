# YM Public Reference Mining — 2026-09-26

Status: REFERENCE_ONLY  
YM_CLAIMS: 0  
PROOF_CREDIT: 0  
FROZEN: IMMUTABLE  
Purpose: public-source mining to support the remaining Yang–Mills OPEN_MATH frontier without importing external endpoint claims into the GREEN/frozen proof path.

## Promotion firewall

Nothing listed here closes OPEN_MATH by citation alone. A referenced result may reduce work only after:
1. exact-statement matching to the local target,
2. same physical model / Hamiltonian / sector compatibility,
3. local reimplementation or dependency integration under compatible license,
4. zero `sorry` / `admit` / project-local scientific axioms,
5. no circular dependency,
6. local build + axiom audit GREEN.

The external SHA is provenance, not proof credit.

## Exact local target

Current compressed target:

```
YM_B60_UNCONDITIONAL_TARGET
  := existence of one genuine B60ConcretePhysicalAdapter
```

A genuine B60 inhabitant transports through:

```
B60ConcretePhysicalAdapter
→ B6RealOpenMath
→ YMUnconditionalClosureCertificate
→ YM_UNCONDITIONAL_CLAIM
→ K14MassGap
```

The public repositories below are mined only to supply references or candidate lemmas for fields of B60.

---

## 1. consensusframework/yang-mills-mass-gap

- License: Apache-2.0
- Pinned SHA: `ead481456bc8637b2b7c22e867cc49f99f4ab375`
- Policy: permissive reference/dependency candidate; attribution required; no endpoint proof credit.

High-value files:
- `Phase3/LatticeGauge/KPClusterExpansion.lean`
  - `typedPolymerGas_eq_exp_tsum`
  - `typedPolymerGas_eq_exp_tsum_of_KP`
  - `typedPolymerGas_pos_of_KP`
  - `typedPolymerGas_ne_zero_of_KP`
- `Phase3/LatticeGauge/CovarianceDecay.lean`
  - finite-volume exponential covariance decay in a small-beta regime.
  - source comments explicitly do **not** claim thermodynamic limit, continuum limit, or Clay mass gap.
- `Phase3/LatticeGauge/WilsonLoop.lean`
  - `holonomy_gaugeAct`
  - `wilsonLoop_gauge_invariant`
- `Phase3/LatticeGauge/HaarUnitary.lean`
  - compact/unitary Haar infrastructure and gauge-expectation machinery.
- Additional mined families:
  - `KP*`, `Polymer*`, `Covariance*`, `Gauge*`, `Gibbs*`, `Wilson*`, `Haar*`, `Holonomy*`.

Best local use:
- B60 infrared support,
- lattice observable / gauge invariance support,
- finite-volume cluster-expansion infrastructure,
- candidate input to `K22InfraredBlock`.

Scientific boundary:
- does not itself supply continuum YM4 reconstruction, thermodynamic limit, or a same-H physical spectral gap.

---

## 2. ColinBundschu/mass-gap

- License: Apache-2.0
- Pinned SHA: `9a93f328885f0c6336bd3552e497f731bf07ec54`
- Policy: permissive; audit theorem-by-theorem before any local port.

High-value mined families:
- `lean/MassGap/Continuum.lean`
- `lean/MassGap/Reconstruct.lean`
- `lean/MassGap/Gappos.lean`
- `lean/MassGap/Closing.lean`
- `lean/MassGap/Speccut.lean`
- `lean/MassGap/Statespace.lean`
- `lean/MassGap/Lattice.lean`
- `lean/MassGap/Casimir.lean`
- `lean/MassGap/Weylchar.lean`
- `lean/MassGap/Transfer/bridge-like files where present in dependency graph`.

Best local use:
- search for reusable compact-group spectral algebra,
- representation/Casimir lower-bound lemmas,
- candidate bridge pieces for positive-gap certification.

Scientific boundary:
- a theorem name containing “Continuum”, “Closing”, or “MassGap” is not sufficient for local promotion. Exact assumptions and model identity must be audited against YM4 SU(3) and B60.

---

## 3. mrdouglasny/OSforGFF

- License: Apache-2.0
- Pinned SHA: `fef84a82937dfd2bb7f672108a72da329d3ef0fd`
- Policy: permissive generic-OS reference; GFF-specific results cannot be treated as YM results.

High-value files:
- `OSforGFF/OS/OS3_ReflectionPositivity.lean`
- `OSforGFF/OS/OS4_Clustering.lean`
- `OSforGFF/General/PositiveDefinite.lean`
- `OSforGFF/Spacetime/PositiveTimeTestFunction.lean`
- Bessel/Green-function support under `OSforGFF/General/`.

Best local use:
- B60 `physicalHilbertRealization` architecture,
- reflection-positivity abstractions,
- generic OS quotient/reconstruction patterns,
- clustering interfaces.

Scientific boundary:
- GFF is not Yang–Mills. Only genuinely generic theorems or independently reimplemented abstractions are candidates for reuse.

---

## 4. mrdouglasny/lgt

- License: Apache-2.0
- Pinned SHA: `b8793ccf6a51e00e9e2b1685ba191b8626e37137`
- Policy: permissive lattice-gauge reference.

High-value files:
- `LGT/MassGap/StrongCoupling.lean`
- `LGT/MassGap/TransferMatrix.lean`
- `LGT/MassGap/YMMeasure.lean`
- `LGT/MassGap/DobrushinVerification.lean`
- `LGT/MassGap/DoeblinCondition.lean`
- `LGT/MassGap/SingleSiteKernel.lean`
- `LGT/MassGap/GaugeFixing.lean`
- `LGT/MassGap/Locality.lean`
- `LGT/Bridge/ScaleTransfer.lean`
- `LGT/GaugeField/Connection.lean`
- `LGT/GaugeField/Holonomy.lean`
- `LGT/WilsonAction/GaugeInvariance.lean`
- `LGT/WilsonAction/WilsonLoop.lean`.

Best local use:
- regulated construction,
- lattice measure,
- transfer matrix,
- strong-coupling IR candidate,
- scale-transfer architecture.

Scientific boundary:
- dimensional/model specialization must be checked exactly; a 2D/3D lattice result cannot be promoted to 4D SU(3).

---

## 5. mrdouglasny/spectral-positivity

- License: Apache-2.0
- Pinned SHA: `9af3c3a7d9146c92a0ecae5ad269848bd4c25fca`
- Policy: permissive spectral-analysis reference.

High-value files:
- `SpectralPositivity/Operator/Jentzsch.lean`
- `SpectralPositivity/Operator/JentzschProof.lean`
- `SpectralPositivity/Operator/KernelPositivity.lean`
- `SpectralPositivity/Operator/PositivityPreserving.lean`
- `SpectralPositivity/Operator/SpectralRadius.lean`
- `SpectralPositivity/Matrix/PerronFrobenius.lean`
- `SpectralPositivity/Matrix/MetzlerExp.lean`.

Best local use:
- B60/K30 same-H spectral-transfer support,
- positivity-preserving transfer operators,
- Perron–Frobenius/Jentzsch style spectral separation.

Scientific boundary:
- generic operator positivity does not identify the operator with the reconstructed YM Hamiltonian. Same-model/same-H proof remains mandatory.

---

## 6. DavidFox998/yang-mills-gap

- License: MIT
- Pinned SHA: `9872ddba9cf0072eb9cb6ce1ca0c20027aff29ad`
- Policy: permissive by license; **semantic audit mandatory before reuse**.

High-value files:
- `Towers/YM/ClusterExpansion.lean`
- `Towers/YM/ReflectionPositivityCore.lean`
- `Towers/YM/ReflectionPositivityMeasure.lean`
- `Towers/YM/OSReconstruction.lean`
- `Towers/YM/TransferOperator.lean`
- `Towers/YM/TransferOperatorBound.lean`
- `Towers/YM/TransferOperatorOS.lean`
- `Towers/YM/SpectralGapCore.lean`
- `Towers/YM/SpectralGapOS.lean`
- `Towers/YM/SU3.lean`
- `Towers/YM/BesselBounds.lean`
- `Towers/YM/CasimirGap.lean`.

Important audit finding:
- `Towers/YM/ClusteringImpliesGap.lean` explicitly labels its key construction as a **STAND-IN**, using a degenerate zero correlator/operator and stating that the genuine YM surface remains OPEN.
- `Towers/YM/OSReconstruction.lean` explicitly describes an abstract skeleton with named Prop fields; it does not construct the concrete Wilson SU(3) OS Hilbert space.
- Several files contain `Stub`, `Standin`, `Hookup`, or placeholder surfaces and must never be imported as proof evidence merely because they compile.

Best local use:
- SU(3), Bessel, Casimir, lattice algebra, operator interfaces,
- negative/audit examples that sharpen local firewalls,
- independently verified non-placeholder lemmas only.

---

## 7. Shariq81/yang-mills-mass-gap

- License: MIT
- Pinned SHA: `3987402539deb5d039c5627ea304728ee61bcda0`
- Language: Coq; local reuse would require reimplementation/translation into Lean.
- Policy: permissive reference; no automatic proof credit.

High-value files:
- `coq/rg/cluster_expansion.v`
- `coq/rg/polymer_algebra.v`
- `coq/rg/polymer_norms.v`
- `coq/reflection_positivity.v`
- `coq/rp_to_transfer.v`
- `coq/ym/reflection_positivity.v`
- `coq/ym/transfer_matrix.v`
- `coq/ym/spectral_gap_bridge.v`
- `coq/ym/continuum_os_bridge_v4.v`
- `coq/ym/continuum_construction.v`
- `coq/ym/lattice.v`
- `coq/ym/wilson_action.v`
- `coq/ym/cluster_bounds_bridge.v`.

Best local use:
- independent cross-check of theorem decomposition,
- cluster/KP and RP→transfer proof patterns,
- continuum/OS bridge statement comparison.

Scientific boundary:
- every Coq theorem must be inspected for assumptions before translation. A conditional bridge remains conditional after porting.

---

# B60 blocker-to-source routing

## construction / constructiveYM4
Primary references:
1. `mrdouglasny/lgt` — gauge field, YM measure, Wilson action.
2. `consensusframework/yang-mills-mass-gap` — finite lattice, Haar, gauge invariance.
3. `Shariq81/yang-mills-mass-gap` — independent Coq construction decomposition.

## reflectionPositiveReconstruction / physicalHilbertRealization
Primary references:
1. `mrdouglasny/OSforGFF` — generic OS machinery.
2. `mrdouglasny/lgt` — transfer matrix / lattice side.
3. `Shariq81/yang-mills-mass-gap` — RP→transfer and continuum OS bridge.
4. `DavidFox998/yang-mills-gap` — architecture/audit only unless concrete non-placeholder theorem is verified.

## uniformExponentialClustering
Primary references:
1. `consensusframework/yang-mills-mass-gap` — explicit finite-volume covariance decay.
2. `mrdouglasny/lgt` — strong-coupling / Dobrushin / Doeblin candidates.
3. `Shariq81/yang-mills-mass-gap` — cluster expansion / cluster bounds.
4. `DavidFox998/yang-mills-gap` — only non-stand-in cluster lemmas after audit.

## continuumLimitControl / thermodynamicLimitControl / gapPreservedUnderLimits
Primary references:
1. `ColinBundschu/mass-gap` — continuum/reconstruction-related files for theorem mining.
2. `Shariq81/yang-mills-mass-gap` — continuum and OS bridge statements for comparison.
3. `mrdouglasny/lgt` — scale-transfer architecture.
4. None of these receive proof credit until exact 4D SU(3) assumptions are verified.

## spectralTransfer / same-H
Primary references:
1. `mrdouglasny/spectral-positivity`.
2. `mrdouglasny/lgt` transfer-matrix layer.
3. local certified `SpectralCore`, `SpectralConcreteAdapter`, `SpectralExclusion`, `K30`.
4. `Shariq81/yang-mills-mass-gap` spectral-gap bridge for independent statement comparison.

# Reference-only conclusion

The external repositories materially reduce search and formalization effort, but none is credited here as an unconditional YM4 theorem. The correct use is:

```
external theorem/reference
→ exact hypothesis audit
→ local independent adapter/reimplementation
→ same-model/same-H check
→ local Lean build
→ axiom audit
→ eligible reusable lemma
```

Until that full route succeeds, every external item in this document remains REFERENCE_ONLY.
