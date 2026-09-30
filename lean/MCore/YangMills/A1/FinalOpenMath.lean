import MCore.YangMills.A1.ExactFinalProducer

namespace MCore.YangMills.A1.Final

structure PhysicalResidual
    (C : RegulatedYM4Construction)
    (F : K20ScientificFrontier)
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D)
    (O : K30SpectralTransferObligations F D H G) where
  stateMap :
    ∀ a V, (C.fiber a V).State → D.State
  observableState :
    ∀ a V, C.Signature.Observable → D.State
  mappedStatesPhysical :
    ∀ a V psi, C.admissible a V → D.physical (stateMap a V psi)
  observableStatesPhysical :
    ∀ a V A, C.admissible a V → D.physical (observableState a V A)
  constructionFromA1 :
    MeasureInvariance C → ObservableInvariance C →
      F.constructiveYM4 ∧
      F.reflectionPositiveReconstruction ∧
      F.physicalHilbertRealization
  excitation : D.State
  excitationInDomain : H.domain excitation
  excitationPhysical : D.physical excitation
  excitationOrthogonalVacuum : D.orthogonalToVacuum excitation
  transferWitness : K30SpectralTransferWitness O

end MCore.YangMills.A1.Final
