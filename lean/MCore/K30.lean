import MCore.K29

namespace MCore

/-- K30 separates the remaining scientific transfer into four independently
inspectable obligations.  None is derived merely from frontier closure. -/
structure K30SpectralTransferObligations
    (F : K20ScientificFrontier)
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D) where
  gap : D.Scale
  positiveGap : G.positive gap
  physicalSectorControlled : Prop
  observableStatesDense : Prop
  clusteringTransfersToSemigroup : Prop
  semigroupExcludesLowSpectrum : Prop
  exclusionFromObligations :
    K20FrontierClosed F →
    physicalSectorControlled →
    observableStatesDense →
    clusteringTransfersToSemigroup →
    semigroupExcludesLowSpectrum →
    ∀ (psi : D.State) (hpsi : H.domain psi),
      D.physical psi → D.orthogonalToVacuum psi →
        G.gapBound gap psi (H.act psi hpsi)

structure K30SpectralTransferWitness
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    (O : K30SpectralTransferObligations F D H G) where
  physicalSector : O.physicalSectorControlled
  density : O.observableStatesDense
  clusteringToSemigroup : O.clusteringTransfersToSemigroup
  spectralExclusion : O.semigroupExcludesLowSpectrum

theorem k30_obligations_build_realization
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    (O : K30SpectralTransferObligations F D H G)
    (W : K30SpectralTransferWitness O)
    (hF : K20FrontierClosed F) : K29SpectralGapRealization D H G := {
  gap := O.gap
  gapPositive := O.positiveGap
  excludesLowSpectrum := O.exclusionFromObligations hF W.physicalSector W.density
    W.clusteringToSemigroup W.spectralExclusion
}

theorem k30_witness_builds_transfer
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    (O : K30SpectralTransferObligations F D H G)
    (W : K30SpectralTransferWitness O) :
    K29FrontierToSpectralRealization F D H G := {
  transfer := k30_obligations_build_realization O W
}

theorem k30_target_still_open :
    k6_dependency.target.status = .openBridge := k29_target_still_open

theorem k30_no_promotion :
    ¬ Nonempty (ProofCertificate k6_dependency.target) := k29_no_promotion

end MCore
