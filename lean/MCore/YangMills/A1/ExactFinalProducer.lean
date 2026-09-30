import MCore.YangMills.A1.FinalExternal
import MCore.K23
import MCore.K25
import MCore.K27

namespace MCore.YangMills.A1
namespace Final

/-- Exact field-by-field constructor for B6.0 from the certified K23/K25/K27/K30
    producer chain plus the genuinely physical A1-to-Hilbert data. -/
def finalExternal_of_certified_blocks
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}
    {S25 : K25ClusteringSystem}
    {U25 : K25UniformExponentialClustering S25}
    {S27 : K27RegulatedGapSystem}
    {U27 : K27UniformPositiveGap S27}
    {L27 : K27LimitControl S27}
    {W27 : K27LimitWitness S27 U27 L27}
    (K23 : K23ConstructiveYM4Data F)
    (hK23 : K23ConstructionInputsHold K23)
    (K25 : K25ClusteringToInfraredBridge F S25 U25)
    (hCyc : K25.observableCyclicityStillRequired)
    (hSemigroup : K25.semigroupTransferStillRequired)
    (K27 : K27ToFrontierBridge F S27 U27 L27 W27)
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
    (excitation : D.State)
    (excitationInDomain : H.domain excitation)
    (excitationPhysical : D.physical excitation)
    (excitationOrthogonalVacuum : D.orthogonalToVacuum excitation)
    (transferWitness : K30SpectralTransferWitness O) :
    FinalExternalCertificate C F D H G O := by
  let construction : K22ConstructionBlock F :=
    k23_inputs_build_construction_block K23 hK23
  let infrared : K22InfraredBlock F :=
    k25_uniform_clustering_builds_infrared_block K25 hCyc hSemigroup
  let limits : K22LimitBlock F :=
    k27_bridge_builds_limit_block K27
  exact {
    stateMap := stateMap
    observableState := observableState
    mappedStatesPhysical := mappedStatesPhysical
    observableStatesPhysical := observableStatesPhysical
    constructionBlock := construction
    constructionFromA1 := by
      intro _ _
      exact ⟨construction.constructiveYM4,
        construction.reflectionPositiveReconstruction,
        construction.physicalHilbertRealization⟩
    infraredBlock := infrared
    limitBlock := limits
    excitation := excitation
    excitationInDomain := excitationInDomain
    excitationPhysical := excitationPhysical
    excitationOrthogonalVacuum := excitationOrthogonalVacuum
    transferWitness := transferWitness
  }

/-- Same constructor immediately closes the already-defined final root. -/
theorem FINAL_ROOT_of_certified_blocks
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}
    {S25 : K25ClusteringSystem}
    {U25 : K25UniformExponentialClustering S25}
    {S27 : K27RegulatedGapSystem}
    {U27 : K27UniformPositiveGap S27}
    {L27 : K27LimitControl S27}
    {W27 : K27LimitWitness S27 U27 L27}
    (K23 : K23ConstructiveYM4Data F)
    (hK23 : K23ConstructionInputsHold K23)
    (K25 : K25ClusteringToInfraredBridge F S25 U25)
    (hCyc : K25.observableCyclicityStillRequired)
    (hSemigroup : K25.semigroupTransferStillRequired)
    (K27 : K27ToFrontierBridge F S27 U27 L27 W27)
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
    (excitation : D.State)
    (excitationInDomain : H.domain excitation)
    (excitationPhysical : D.physical excitation)
    (excitationOrthogonalVacuum : D.orthogonalToVacuum excitation)
    (transferWitness : K30SpectralTransferWitness O) :
    FINAL_ROOT D H G :=
  finalExternal_to_FINAL_ROOT
    (finalExternal_of_certified_blocks K23 hK23 K25 hCyc hSemigroup K27
      stateMap observableState mappedStatesPhysical observableStatesPhysical
      excitation excitationInDomain excitationPhysical
      excitationOrthogonalVacuum transferWitness)

#print axioms MCore.YangMills.A1.Final.finalExternal_of_certified_blocks
#print axioms MCore.YangMills.A1.Final.FINAL_ROOT_of_certified_blocks

end Final
end MCore.YangMills.A1
