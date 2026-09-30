import MCore.YangMills.A1.FinalExternal
import MCore.K23
import MCore.K25
import MCore.K27
import MCore.K30

namespace MCore.YangMills.A1
namespace Final

/-- Exact field-by-field constructor for B6.0.  Every block that can already be
    assembled by a certified kernel theorem is built here.  The remaining
    arguments are the genuine physical realization data. -/
def finalExternal_of_fields
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}
    {S : K25ClusteringSystem}
    {U : K25UniformExponentialClustering S}
    {GS : K27RegulatedGapSystem}
    {GU : K27UniformPositiveGap GS}
    {GL : K27LimitControl GS}
    {GW : K27LimitWitness GS GU GL}
    (stateMap :
      ∀ (a : C.Signature.Regulator) (V : C.Signature.Volume),
        (C.fiber a V).State → D.State)
    (observableState :
      ∀ (a : C.Signature.Regulator) (V : C.Signature.Volume),
        C.Signature.Observable → D.State)
    (mappedStatesPhysical :
      ∀ (a : C.Signature.Regulator) (V : C.Signature.Volume)
        (ψ : (C.fiber a V).State),
        C.admissible a V → D.physical (stateMap a V ψ))
    (observableStatesPhysical :
      ∀ (a : C.Signature.Regulator) (V : C.Signature.Volume)
        (A : C.Signature.Observable),
        C.admissible a V → D.physical (observableState a V A))
    (K23 : K23ConstructiveYM4Data F)
    (K23inputs : K23ConstructionInputsHold K23)
    (constructionFromA1 :
      MeasureInvariance C →
      ObservableInvariance C →
      F.constructiveYM4 ∧
        F.reflectionPositiveReconstruction ∧
        F.physicalHilbertRealization)
    (K25 : K25ClusteringToInfraredBridge F S U)
    (cyclicity : K25.observableCyclicityStillRequired)
    (semigroup : K25.semigroupTransferStillRequired)
    (K27 : K27ToFrontierBridge F GS GU GL GW)
    (excitation : D.State)
    (excitationInDomain : H.domain excitation)
    (excitationPhysical : D.physical excitation)
    (excitationOrthogonalVacuum : D.orthogonalToVacuum excitation)
    (physicalSector : O.physicalSectorControlled)
    (density : O.observableStatesDense)
    (clusteringToSemigroup : O.clusteringTransfersToSemigroup)
    (spectralExclusion : O.semigroupExcludesLowSpectrum) :
    FinalExternalCertificate C F D H G O :=
  {
    stateMap := stateMap
    observableState := observableState
    mappedStatesPhysical := mappedStatesPhysical
    observableStatesPhysical := observableStatesPhysical
    constructionBlock := k23_inputs_build_construction_block K23 K23inputs
    constructionFromA1 := constructionFromA1
    infraredBlock :=
      k25_uniform_clustering_builds_infrared_block K25 cyclicity semigroup
    limitBlock := k27_bridge_builds_limit_block K27
    excitation := excitation
    excitationInDomain := excitationInDomain
    excitationPhysical := excitationPhysical
    excitationOrthogonalVacuum := excitationOrthogonalVacuum
    transferWitness := {
      physicalSector := physicalSector
      density := density
      clusteringToSemigroup := clusteringToSemigroup
      spectralExclusion := spectralExclusion
    }
  }

/-- All fieldwise data above reaches the final mass-gap root mechanically. -/
theorem FINAL_ROOT_of_fields
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}
    {S : K25ClusteringSystem}
    {U : K25UniformExponentialClustering S}
    {GS : K27RegulatedGapSystem}
    {GU : K27UniformPositiveGap GS}
    {GL : K27LimitControl GS}
    {GW : K27LimitWitness GS GU GL}
    (stateMap :
      ∀ (a : C.Signature.Regulator) (V : C.Signature.Volume),
        (C.fiber a V).State → D.State)
    (observableState :
      ∀ (a : C.Signature.Regulator) (V : C.Signature.Volume),
        C.Signature.Observable → D.State)
    (mappedStatesPhysical :
      ∀ (a : C.Signature.Regulator) (V : C.Signature.Volume)
        (ψ : (C.fiber a V).State),
        C.admissible a V → D.physical (stateMap a V ψ))
    (observableStatesPhysical :
      ∀ (a : C.Signature.Regulator) (V : C.Signature.Volume)
        (A : C.Signature.Observable),
        C.admissible a V → D.physical (observableState a V A))
    (K23 : K23ConstructiveYM4Data F)
    (K23inputs : K23ConstructionInputsHold K23)
    (constructionFromA1 :
      MeasureInvariance C →
      ObservableInvariance C →
      F.constructiveYM4 ∧
        F.reflectionPositiveReconstruction ∧
        F.physicalHilbertRealization)
    (K25 : K25ClusteringToInfraredBridge F S U)
    (cyclicity : K25.observableCyclicityStillRequired)
    (semigroup : K25.semigroupTransferStillRequired)
    (K27 : K27ToFrontierBridge F GS GU GL GW)
    (excitation : D.State)
    (excitationInDomain : H.domain excitation)
    (excitationPhysical : D.physical excitation)
    (excitationOrthogonalVacuum : D.orthogonalToVacuum excitation)
    (physicalSector : O.physicalSectorControlled)
    (density : O.observableStatesDense)
    (clusteringToSemigroup : O.clusteringTransfersToSemigroup)
    (spectralExclusion : O.semigroupExcludesLowSpectrum) :
    FINAL_ROOT D H G :=
  finalExternal_to_FINAL_ROOT
    (finalExternal_of_fields
      stateMap observableState
      mappedStatesPhysical observableStatesPhysical
      K23 K23inputs constructionFromA1
      K25 cyclicity semigroup K27
      excitation excitationInDomain excitationPhysical
      excitationOrthogonalVacuum
      physicalSector density clusteringToSemigroup spectralExclusion)

#print axioms MCore.YangMills.A1.Final.finalExternal_of_fields
#print axioms MCore.YangMills.A1.Final.FINAL_ROOT_of_fields

end Final
end MCore.YangMills.A1
