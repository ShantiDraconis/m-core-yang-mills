import MCore.YangMills.A1.FinalExternal

namespace MCore.YangMills.A1
namespace Final

def b60OfFields
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
        (psi : (C.fiber a V).State),
        C.admissible a V → D.physical (stateMap a V psi))
    (observableStatesPhysical :
      ∀ (a : C.Signature.Regulator) (V : C.Signature.Volume)
        (A : C.Signature.Observable),
        C.admissible a V → D.physical (observableState a V A))
    (constructionBlock : K22ConstructionBlock F)
    (constructionFromA1 :
      MeasureInvariance C →
      ObservableInvariance C →
      F.constructiveYM4 ∧
        F.reflectionPositiveReconstruction ∧
        F.physicalHilbertRealization)
    (infraredBlock : K22InfraredBlock F)
    (limitBlock : K22LimitBlock F)
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
    constructionBlock := constructionBlock
    constructionFromA1 := constructionFromA1
    infraredBlock := infraredBlock
    limitBlock := limitBlock
    excitation := excitation
    excitationInDomain := excitationInDomain
    excitationPhysical := excitationPhysical
    excitationOrthogonalVacuum := excitationOrthogonalVacuum
    transferWitness := transferWitness
  }

theorem FINAL_ROOT_of_b60_fields
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}
    (E : FinalExternalCertificate C F D H G O) :
    FINAL_ROOT D H G :=
  finalExternal_to_FINAL_ROOT E

end Final
end MCore.YangMills.A1
