import MCore.YangMills.A1.B6YM4PhysicalHarden
import Mathlib.Analysis.SpecialFunctions.Exp

/-!
Fail-closed infrared producer decomposition for four-dimensional SU(3)
Yang--Mills.

This file does not construct a Yang--Mills mass gap.  It isolates one common
certificate type and four independent producer lanes.  Each producer carries
an explicit bridge to the certificate; those bridge fields are the scientific
OPEN_MATH obligations.  The final theorem is transport only.

The cutoff is taken from the physical side, a > 0, so all a -> 0 limits use
`nhdsWithin 0 (Set.Ioi 0)`.
-/

namespace MCore.YangMills.A1

open Filter Topology

/-- Restrict the already-hardened physical regime to the requested SU(3), R^4
case.  The ambient `YM4PhysicalRegime` already records dimension = 4; this
predicate fixes the gauge rank to 3. -/
def IsSU3R4 (R : YM4RegulatedGapFamily) : Prop :=
  R.regime.gaugeRank = 3 ∧ R.regime.spacetimeDimension = 4

/-- Canonical cutoff-error certificate for a positive physical mass scale.

The substantive content is:
* one fixed `mass > 0`;
* one cutoff error `eps a >= 0` with `eps a -> 0` as `a -> 0+`;
* a regulator/volume estimate tying that same mass to the physical gap.

This is intentionally weaker than directly postulating
`YM4UniformPhysicalLowerBound`; the separate `eventualUniform` field is the
precise place where an analytic producer must convert vanishing cutoff error
into a uniform positive lower bound on a sufficiently small cutoff window.
-/
structure MassGapControlCertificate (R : YM4RegulatedGapFamily) where
  mass : ℝ
  mass_pos : 0 < mass
  a0 : ℝ
  a0_pos : 0 < a0
  eps : ℝ → ℝ
  eps_nonneg : ∀ a, 0 ≤ eps a
  eps_tendsto_zero :
    Tendsto eps (nhdsWithin 0 (Set.Ioi 0)) (nhds 0)
  regulated_bound :
    ∀ (a : ℝ), 0 < a → a < a0 →
      ∀ L : YM4PhysicalVolume,
        mass - eps a ≤
          R.physicalGap
            ⟨a, by exact ⟨‹0 < a›, ‹a < a0›⟩⟩ L
  /-- Exact nontrivial analytic closure condition.  It is not derived here. -/
  eventualUniform :
    ∃ a1 : ℝ, 0 < a1 ∧ a1 ≤ a0 ∧
      ∀ (a : ℝ), 0 < a → a < a1 →
        ∀ L : YM4PhysicalVolume,
          mass / 2 ≤
            R.physicalGap
              ⟨a, by
                refine ⟨‹0 < a›, ?_⟩
                exact lt_of_lt_of_le ‹a < a1› ‹a1 ≤ a0›⟩ L

/-- The certificate exposes a concrete positive uniform mass on a smaller
physical cutoff window.  This is pure projection of the explicitly supplied
`eventualUniform` field; no Yang--Mills analysis is manufactured here. -/
theorem massGapControl_has_positive_uniform_window
    {R : YM4RegulatedGapFamily}
    (C : MassGapControlCertificate R) :
    ∃ a1 : ℝ, 0 < a1 ∧ a1 ≤ C.a0 ∧ 0 < C.mass / 2 ∧
      ∀ (a : ℝ), 0 < a → a < a1 →
        ∀ L : YM4PhysicalVolume,
          C.mass / 2 ≤
            R.physicalGap
              ⟨a, by
                refine ⟨‹0 < a›, ?_⟩
                exact lt_of_lt_of_le ‹a < a1› ‹a1 ≤ C.a0›⟩ L := by
  rcases C.eventualUniform with ⟨a1, ha1, ha10, hU⟩
  refine ⟨a1, ha1, ha10, ?_, hU⟩
  linarith [C.mass_pos]

/-- Wilson-area-law producer.  `areaLawToCertificate` is deliberately an
explicit field: proving area law plus the required spectral/clustering bridge
for the same physical realization is OPEN_MATH, not transport logic. -/
structure AreaLawData (R : YM4RegulatedGapFamily) where
  stringTension : ℝ
  stringTension_pos : 0 < stringTension
  areaLaw : Prop
  sameModel : Prop
  areaLawToCertificate :
    areaLaw → sameModel → MassGapControlCertificate R

/-- Polymer/cluster-expansion producer.  The exponential decay statement is
kept abstract at this layer; a concrete adapter must tie it to the same
regulated YM4 family. -/
structure ClusterData (R : YM4RegulatedGapFamily) where
  decayMass : ℝ
  decayMass_pos : 0 < decayMass
  exponentialDecay : Prop
  uniformInVolume : Prop
  sameModel : Prop
  clusterToCertificate :
    exponentialDecay → uniformInVolume → sameModel →
      MassGapControlCertificate R

/-- Dual-superconductor producer.  No monopole-condensation theorem is assumed
or proved here. -/
structure MonopoleCondensationData (R : YM4RegulatedGapFamily) where
  monopoleVEV : Prop
  dualMeissner : Prop
  sameModel : Prop
  condensationToMeissner : monopoleVEV → dualMeissner
  meissnerToCertificate :
    dualMeissner → sameModel → MassGapControlCertificate R

/-- Vacuum-wave-functional producer.  The variational ansatz is not accepted
unless its estimate is tied to the same physical YM4 Hamiltonian/model. -/
structure VacuumWaveFunctionalData (R : YM4RegulatedGapFamily) where
  variationalBound : Prop
  sameHamiltonian : Prop
  variationalToCertificate :
    variationalBound → sameHamiltonian →
      MassGapControlCertificate R

/-- Four independent attack lanes.  Inhabitants are scientific evidence; this
sum type itself is only routing infrastructure. -/
inductive InfraredProducer (R : YM4RegulatedGapFamily) where
  | areaLawWilsonLoop (d : AreaLawData R)
      (hArea : d.areaLaw) (hSame : d.sameModel)
  | clusterExpansion (d : ClusterData R)
      (hDecay : d.exponentialDecay)
      (hUniform : d.uniformInVolume)
      (hSame : d.sameModel)
  | dualSuperconductor (d : MonopoleCondensationData R)
      (hMonopole : d.monopoleVEV) (hSame : d.sameModel)
  | newVacuumFunctional (d : VacuumWaveFunctionalData R)
      (hVar : d.variationalBound) (hSameH : d.sameHamiltonian)

/-- Single frozen transport theorem.  All mathematical difficulty remains in
constructing one unconditional producer inhabitant for the physical SU(3), R^4
family. -/
def producer_closes_mass_gap
    {R : YM4RegulatedGapFamily}
    (P : InfraredProducer R) :
    MassGapControlCertificate R :=
  match P with
  | .areaLawWilsonLoop d hArea hSame =>
      d.areaLawToCertificate hArea hSame
  | .clusterExpansion d hDecay hUniform hSame =>
      d.clusterToCertificate hDecay hUniform hSame
  | .dualSuperconductor d hMonopole hSame =>
      d.meissnerToCertificate (d.condensationToMeissner hMonopole) hSame
  | .newVacuumFunctional d hVar hSameH =>
      d.variationalToCertificate hVar hSameH

/-- Canonical OPEN_MATH target after the producer decomposition. -/
def YM4_SU3_INFRARED_PRODUCER_OPEN_MATH : Prop :=
  ∃ R : YM4RegulatedGapFamily,
    IsSU3R4 R ∧ Nonempty (InfraredProducer R)

#print axioms MCore.YangMills.A1.massGapControl_has_positive_uniform_window
#print axioms MCore.YangMills.A1.producer_closes_mass_gap

end MCore.YangMills.A1
