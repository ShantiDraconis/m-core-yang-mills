import MCore.YangMills.A1.FinalExternal
import MCore.K23
import MCore.K25
import MCore.K27

namespace MCore.YangMills.A1
namespace Final

def finalExternal_of_exact_fields
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
      ∀ a V ψ, C.admissible a V → D.physical (stateMap a V ψ))
    (observableStatesPhysical :
      ∀ a V A, C.admissible a V → D.physical (observableState a V A))
    (C23 : K23ConstructiveYM4Data F)
    (hC23 : K23ConstructionInputsHold C23)
    (constructionFromA1 :
      MeasureInvariance C → ObservableInvariance C →
        F.constructiveYM4 ∧
        F.reflectionPositiveReconstruction ∧
        F.physicalHilbertRealization)
    {S25 : K25ClusteringSystem}
    {U25 : K25UniformExponentialClustering S25}
    (B25 : K25ClusteringToInfraredBridge F S25 U25)
    (hc25 : B25.observableCyclicityStillRequired)
    (hs25 : B25.semigroupTransferStillRequired)
    {S27 : K27RegulatedGapSystem}
    {U27 : K27UniformPositiveGap S27}
    {L27 : K27LimitControl S27}
    {W27 : K27LimitWitness S27 U27 L27}
    (B27 : K27ToFrontierBridge F S27 U27 L27 W27)
    (excitation : D.State)
    (excitationInDomain : H.domain excitation)
    (excitationPhysical : D.physical excitation)
    (excitationOrthogonalVacuum : D.orthogonalToVacuum excitation)
    (transferWitness : K30SpectralTransferWitness O) :
    FinalExternalCertificate C F D H G O :=
  {
    stateMap := stateMap
    observableState := observableState
    mappedStatesPhysical := mappedStatesPhysical
    observableStatesPhysical := observableStatesPhysical
    constructionBlock := k23_inputs_build_construction_block C23 hC23
    constructionFromA1 := constructionFromA1
    infraredBlock := k25_uniform_clustering_builds_infrared_block B25 hc25 hs25
    limitBlock := k27_bridge_builds_limit_block B27
    excitation := excitation
    excitationInDomain := excitationInDomain
    excitationPhysical := excitationPhysical
    excitationOrthogonalVacuum := excitationOrthogonalVacuum
    transferWitness := transferWitness
  }

theorem FINAL_ROOT_of_exact_fields
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}
    (E : FinalExternalCertificate C F D H G O) :
    FINAL_ROOT D H G :=
  finalExternal_to_FINAL_ROOT E

#print axioms MCore.YangMills.A1.Final.finalExternal_of_exact_fields
#print axioms MCore.YangMills.A1.Final.FINAL_ROOT_of_exact_fields

end Final
end MCore.YangMills.A1
