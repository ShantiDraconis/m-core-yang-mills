# A1 B3/B4/B5 Hardening v2 — GREEN certificate

- Source branch: `attack/a1-b3-b5-hardening-v2`
- Frozen source SHA: `c7ff632d3617678d06e38a880644150d2e8a6817`
- Frozen branch: `frozen/A1-B3-B5-hardening-v2-green-c7ff632d`
- Certificate run: `35533760415`
- Job: `106138983849`
- Conclusion: `SUCCESS`
- Evidence artifact: `g6b-axiom-evidence-35533760415`
- Artifact id: `10612337615`
- Artifact SHA-256: `cc55b145b26b753f97fa04290e9cc022f67946d4ef5987ef0f1a32bc0c1a3bf6`

## Scope certified

This certificate covers **formal interface hardening only**.  It does not
assert construction of four-dimensional quantum Yang--Mills theory and does
not assert the Clay mass-gap theorem.

The hardened layer is in:

`lean/MCore/YangMills/A1/HardeningV2.lean`

The legacy K21--K30 chain is preserved unchanged by this attack.

## Hardened interfaces

### B3 — ReflectionPositivityDataV2

The pairing is required to equal a reflected observable integral against the
exact regulated measure `(C.fiber a L).measure`:

`ReflectionPositivityDataV2.h_pairing_def`

A legacy B3 constructor omitting this field is an explicit negative control and
is rejected by Lean.

### B4 — PositiveTransferDataV2

The transfer operator acts on `RegulatedL2Vector C a L`, whose square
integrability is measured against the exact regulated measure of `C`.

The pointwise transfer law is required to equal the integral operator built
from `A1PhysicalData.transferKernel` and the same measure:

`PositiveTransferDataV2.h_transfer_from_C`

The physical-data package also supplies the actual regulated action used to
construct the kernel, rather than treating `C.Signature.Action` as a phantom
type only.

### B5 — UniformRegulatorControlV2

The witness contains:

- `m0 : ℝ`
- `hm0 : 0 < m0`
- `a0 : ℝ`
- `ha0 : 0 < a0`
- `h_gap_eq : gapAt a L = B4.spectralGap a L`
- a uniform lower bound `m0 ≤ gapAt a L` on every admissible model below
  the fixed cutoff threshold.

`A1PhysicalData.cutoffCofinal` supplies arbitrarily small admissible cutoffs,
and `A1PhysicalData.volumeCofinal` records an unbounded volume direction.

Certified consequences:

- `uniform_v2_mass_nonzero`
- `uniform_v2_gap_not_identically_zero`
- `uniform_v2_gap_is_transfer_gap`

Hence the previous `estimate := fun _ _ => 0` shortcut cannot serve as a v2
uniform-mass witness.

## Hardened A1 endpoint

`A1ScientificWitnessV2 C` contains dependent B1--B5 data.

The theorem

`a1_v2_open_bridge_exposes_B1_B2_B3_B4_B5`

proves that a witness of `A1ScientificOpenBridgeV2 C` exposes:

1. `MeasureInvariance C`;
2. `ObservableInvariance C`;
3. an actual `A1PhysicalData C`;
4. dependent B3 reflection-positivity data;
5. dependent B4 transfer-operator data;
6. dependent B5 positive uniform mass data.

B3--B5 are packaged existentially because they are dependent data in `Type`,
not bare propositions.

## CI gates

Run `35533760415`:

- G0 pinned manifest: PASS
- G1 spectral infrastructure: PASS
- G2 fail-closed hygiene: PASS
- G3 frozen K30 boundary: PASS
- G4 spectral core: PASS
- G5 axiom closure: PASS
- G6 endpoint/frontier firewall: PASS
- G7 targeted reproduction: PASS
- G6b negative controls: PASS
- G6b physical scaling audit: PASS
- G6b legacy positive control: PASS
- G6b A1 hardening-v2 axiom audit: PASS
- G6c A1 hardening-v2 negative controls: PASS

The four audited v2 theorems have axiom footprint within the explicit allow-list:

- `propext`
- `Classical.choice`
- `Quot.sound`

No `sorryAx` was admitted.

## Prior RED provenance

The preceding adversarial branch
`attack/a1-b5-triviality-red` demonstrated that the legacy B3/B4/B5
interfaces were too weak: B5 admitted an identically-zero estimate and B3/B4
had phantom dependence on `C`.  That RED motivated this v2 hardening and is
not relabeled as a Yang--Mills proof.

## Promotion status

`A1_INTERFACE_HARDENING_V2 = CERTIFIED`

`YANG_MILLS_SCIENTIFIC_ENDPOINT = OPEN_BRIDGE`

`FULL_YANG_MILLS_PROOF = REFUSED_FAIL_CLOSED`

The next legitimate scientific task is to construct the concrete
`A1PhysicalData`, B1/B2, B3, B4 and B5 witnesses for the actual regulated
Yang--Mills model and then connect them to the already frozen K30 spectral
transfer endpoint.
