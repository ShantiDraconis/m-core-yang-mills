import MCore.YangMills.A1.FinalExternal
import MCore.K23
import MCore.K25
import MCore.K27

namespace MCore.YangMills.A1
namespace Final

/-- K30 witness assembled field-by-field from the four material transfer facts. -/
def k30Witness_of_fields
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    (O : K30SpectralTransferObligations F D H G)
    (physicalSector : O.physicalSectorControlled)
    (density : O.observableStatesDense)
    (clusteringToSemigroup : O.clusteringTransfersToSemigroup)
    (spectralExclusion : O.semigroupExcludesLowSpectrum) :
    K30SpectralTransferWitness O :=
  {
    physicalSector := physicalSector
    density := density
    clusteringToSemigroup := clusteringToSemigroup
    spectralExclusion := spectralExclusion
  }

/-- Exact B60 constructor after consuming the certified K23/K25/K27 builders.
    Every argument below is either genuinely physical data or an already-typed
    mathematical obligation; no status metadata occurs in this constructor. -/
def finalExternal_of_fields
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}

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

    (C23 : K23ConstructiveYM4Data F)
    (h23 : K23ConstructionInputsHold C23)
    (constructionFromA1 :
      MeasureInvariance C →
      ObservableInvariance C →
      F.constructiveYM4 ∧
        F.reflectionPositiveReconstruction ∧
        F.physicalHilbertRealization)

    {S25 : K25ClusteringSystem}
    {U25 : K25UniformExponentialClustering S25}
    (B25 : K25ClusteringToInfraredBridge F S25 U25)
    (cyclicity25 : B25.observableCyclicityStillRequired)
    (semigroup25 : B25.semigroupTransferStillRequired)

    {S27 : K27RegulatedGapSystem}
    {U27 : K27UniformPositiveGap S27}
    {L27 : K27LimitControl S27}
    {W27 : K27LimitWitness S27 U27 L27}
    (B27 : K27ToFrontierBridge F S27 U27 L27 W27)

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
    constructionBlock := k23_inputs_build_construction_block C23 h23
    constructionFromA1 := constructionFromA1
    infraredBlock :=
      k25_uniform_clustering_builds_infrared_block
        B25 cyclicity25 semigroup25
    limitBlock := k27_bridge_builds_limit_block B27
    excitation := excitation
    excitationInDomain := excitationInDomain
    excitationPhysical := excitationPhysical
    excitationOrthogonalVacuum := excitationOrthogonalVacuum
    transferWitness :=
      k30Witness_of_fields O physicalSector density
        clusteringToSemigroup spectralExclusion
  }

/-- The exact field-level producer reaches the mass-gap root mechanically. -/
theorem FINAL_ROOT_of_fields
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}
    (E : FinalExternalCertificate C F D H G O) :
    FINAL_ROOT D H G :=
  finalExternal_to_FINAL_ROOT E

#print axioms MCore.YangMills.A1.Final.k30Witness_of_fields
#print axioms MCore.YangMills.A1.Final.finalExternal_of_fields
#print axioms MCore.YangMills.A1.Final.FINAL_ROOT_of_fields

end Final
end MCore.YangMills.A1
