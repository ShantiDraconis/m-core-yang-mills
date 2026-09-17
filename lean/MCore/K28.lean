import MCore.K27

namespace MCore

/-- K28 assembles the three independently audited scientific blocks without
turning their existence into a proof of the open Yang--Mills target. -/
structure K28FrontierBlocks (F : K20ScientificFrontier) where
  construction : K22ConstructionBlock F
  infrared : K22InfraredBlock F
  limits : K22LimitBlock F

theorem k28_blocks_recover_frontier
    {F : K20ScientificFrontier}
    (B : K28FrontierBlocks F) : K20FrontierClosed F := by
  rcases B.construction with ⟨hc, hr, hh⟩
  rcases B.infrared with ⟨hcl, hcyc, hsg⟩
  rcases B.limits with ⟨hug, hcont, htherm, hpres⟩
  exact {
    constructiveYM4 := hc
    reflectionPositiveReconstruction := hr
    physicalHilbertRealization := hh
    uniformExponentialClustering := hcl
    observableCyclicity := hcyc
    semigroupSpectralTransfer := hsg
    uniformRegulatedGap := hug
    continuumLimitControl := hcont
    thermodynamicLimitControl := htherm
    gapPreservedUnderLimits := hpres
  }

/-- The endpoint remains conditional on an explicit bridge from the closed
scientific frontier to the target proposition. -/
theorem k28_conditional_endpoint
    {F : K20ScientificFrontier}
    (B : K28FrontierBlocks F)
    (bridge : K20FrontierToMassGapBridge F) : k6_dependency.target.proposition :=
  bridge.closes (k28_blocks_recover_frontier B)

theorem k28_target_still_open :
    k6_dependency.target.status = .openBridge := k27_target_still_open

theorem k28_no_promotion :
    ¬ Nonempty (ProofCertificate k6_dependency.target) := k27_no_promotion

end MCore
