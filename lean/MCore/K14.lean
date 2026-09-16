import MCore.K13

namespace MCore

/-- K14.0: abstract physical Hilbert-layer interface.
    This is interface data, not existence of the YM4 physical Hilbert space. -/
structure K14PhysicalHilbertData where
  State : Type
  vacuum : State
  physical : State → Prop
  norm : State → ℝ
  orthogonalToVacuum : State → Prop
  vacuum_normalized : norm vacuum = 1

/-- K14.1: an unbounded Hamiltonian is represented by an explicit domain
    and an action on domain elements. Analytic self-adjointness is a property
    to be supplied by a realization, not inferred from K13. -/
structure K14HamiltonianOperator (D : K14PhysicalHilbertData) where
  domain : D.State → Prop
  act : (ψ : D.State) → domain ψ → D.State
  denselyDefined : Prop
  symmetric : Prop
  selfAdjoint : Prop

/-- K14.2: vacuum information is explicit realization data. -/
structure K14VacuumAxiom (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D) where
  vacuum_mem_domain : H.domain D.vacuum
  vacuum_zero : H.act D.vacuum vacuum_mem_domain = D.vacuum
  vacuum_isolated_in_physical_kernel : Prop

/-- K14.3: mass gap is a predicate only. It does not assert existence of Δ. -/
def K14MassGap (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D) (Δ : ℝ) : Prop :=
  0 < Δ ∧
    ∀ (ψ : D.State) (hψ : H.domain ψ),
      D.physical ψ → D.orthogonalToVacuum ψ →
        Δ * D.norm ψ ≤ D.norm (H.act ψ hψ)

/-- K14.4: abstract semigroup-decay predicate. The bridge between this
    predicate and K14MassGap requires genuine spectral/functional calculus
    hypotheses and is deliberately not postulated here. -/
def K14SemigroupDecay (m : ℝ) : Prop := 0 < m

/-- K14.5: the scientific frontier. This records the uniformity requirements
    without manufacturing a YM4 witness. -/
structure K14UniformExpClusteringData where
  Cutoff : Type
  Volume : Type
  LocalObservable : Type
  separation : LocalObservable → ℝ
  connectedMagnitude : Cutoff → Volume → LocalObservable → ℝ
  observableConstant : LocalObservable → ℝ

/-- Uniform exponential clustering is a proposition parameterized by explicit
    correlator data. No instance for four-dimensional Yang--Mills is supplied. -/
def K14UniformExpClustering (C : K14UniformExpClusteringData) : Prop :=
  ∃ m : ℝ, 0 < m ∧
    ∀ (a : C.Cutoff) (Λ : C.Volume) (O : C.LocalObservable),
      C.connectedMagnitude a Λ O ≤
        C.observableConstant O * Real.exp (-m * C.separation O)

/-- K14.5b: reconstruction/cyclicity remains an explicit bridge rather than
    being hidden inside the phrase 'transfer matrix'. -/
def K14ReconstructionCyclicityBridge
    (C : K14UniformExpClusteringData)
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D) : Prop :=
  K14UniformExpClustering C → ∃ m : ℝ, K14SemigroupDecay m

/-- K14.6 is conditional: it packages exactly the missing bridge needed to
    obtain a mass gap. It cannot be instantiated from K13 alone. -/
def K14ClusteringToMassGapBridge
    (C : K14UniformExpClusteringData)
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D) : Prop :=
  K14UniformExpClustering C → ∃ Δ : ℝ, K14MassGap D H Δ

/-- A supplied bridge and a supplied clustering proof yield the conditional
    conclusion. This theorem contains no YM4 clustering proof. -/
theorem k14_conditional_mass_gap
    {C : K14UniformExpClusteringData}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    (bridge : K14ClusteringToMassGapBridge C D H)
    (clustering : K14UniformExpClustering C) :
    ∃ Δ : ℝ, K14MassGap D H Δ :=
  bridge clustering

/-- The repository's original certified target remains OPEN_BRIDGE. -/
theorem k14_target_still_open :
    k6_dependency.target.status = .openBridge :=
  k13_target_still_open

/-- K14 cannot manufacture a proof certificate for the open target. -/
theorem k14_no_promotion :
    ¬ Nonempty (ProofCertificate k6_dependency.target) :=
  k13_no_promotion

end MCore
