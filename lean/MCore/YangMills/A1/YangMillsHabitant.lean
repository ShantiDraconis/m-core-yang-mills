import MCore.YangMills.A1.YMGapShapeF2F4F7

/-!
Canonical Yang--Mills F2 inhabitant.

This file freezes the single terminal inhabitant shape:
physical Hilbert data + Hamiltonian + vacuum data + explicit positive gap
certificate for the same physical realization.

It does not manufacture the missing Yang--Mills mathematics. The structure is
a target type. A concrete term of this type is the material object that closes
the F2 mass-gap endpoint.
-/

namespace MCore.YangMills.A1

/-- Explicit continuum/QFT realization obligations for the same YM4 model and
the same Hamiltonian used by the mass-gap proof.

Unlike the older frontier records, these fields are *proofs of fixed
propositions attached to S/D/H*.  A constructor therefore cannot close F4 by
choosing unrelated propositions such as True. -/
structure YM4ContinuumPhysicalAxioms
    (S : YMClosedStart)
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D) where
  constructiveYM4 : S.frontier.constructiveYM4
  regulatedGaugeInvariantMeasure : S.regulated.gaugeInvariantMeasure
  regulatedGaugeInvariantObservables : S.regulated.gaugeInvariantObservables
  regulatedReflectionPositive : S.regulated.reflectionPositive
  regulatedPositiveTransfer : S.regulated.positiveTransferOperator
  reflectionPositiveReconstruction :
    S.frontier.reflectionPositiveReconstruction
  physicalHilbertRealization : S.frontier.physicalHilbertRealization
  continuumLimitControl : S.frontier.continuumLimitControl
  thermodynamicLimitControl : S.frontier.thermodynamicLimitControl
  observableCyclicity : S.frontier.observableCyclicity
  semigroupSpectralTransfer : S.frontier.semigroupSpectralTransfer
  hamiltonianDenselyDefined : H.denselyDefined
  hamiltonianSymmetric : H.symmetric
  hamiltonianSelfAdjoint : H.selfAdjoint

/-- The unique terminal F2 inhabitant in the repository's existing K14 model.

The massGap field includes both strict positivity of delta and the gap bound
for all physical states orthogonal to the vacuum, through K14MassGap.
The vacuumAxiom field pins the same Hamiltonian to the distinguished vacuum.
The physicalRealization field ties the inhabitant to the same concrete B6.0
YM realization so an unrelated abstract gapped Hamiltonian cannot close YM. -/
structure YangMillsHabitant where
  start : YMClosedStart
  physicalData : K14PhysicalHilbertData
  hamiltonian : K14HamiltonianOperator physicalData
  gapScale : K14GapScale physicalData
  obligations :
    K30SpectralTransferObligations
      start.frontier physicalData hamiltonian gapScale
  physicalRealization :
    B60ConcretePhysicalAdapter
      start.regulated start.frontier physicalData
      hamiltonian gapScale obligations
  vacuumAxiom : K14VacuumAxiom physicalData hamiltonian
  continuumQFT : YM4ContinuumPhysicalAxioms start physicalData hamiltonian
  delta : physicalData.Scale
  massGap : K14MassGap physicalData hamiltonian gapScale delta


/-- F4 realization target for the exact same physical Yang--Mills Hamiltonian
used by the terminal F2 gap.  This freezes the attack order without weakening
the final PACK requirement. -/
structure YMPhysicalRealizationF4 where
  start : YMClosedStart
  physicalData : K14PhysicalHilbertData
  hamiltonian : K14HamiltonianOperator physicalData
  gapScale : K14GapScale physicalData
  obligations :
    K30SpectralTransferObligations
      start.frontier physicalData hamiltonian gapScale
  physicalRealization :
    B60ConcretePhysicalAdapter
      start.regulated start.frontier physicalData
      hamiltonian gapScale obligations
  vacuumAxiom : K14VacuumAxiom physicalData hamiltonian
  continuumQFT : YM4ContinuumPhysicalAxioms start physicalData hamiltonian

/-- F2 is allowed only on the Hamiltonian fixed by F4. -/
def YMPhysicalRealizationF4.F2Gap
    (R : YMPhysicalRealizationF4) : Prop :=
  ∃ delta : R.physicalData.Scale,
    K14MassGap R.physicalData R.hamiltonian R.gapScale delta

/-- Pack one F4 realization and an F2 witness on that exact same Hamiltonian
into the unique terminal inhabitant. -/
def YMPhysicalRealizationF4.packHabitant
    (R : YMPhysicalRealizationF4)
    (delta : R.physicalData.Scale)
    (hgap : K14MassGap R.physicalData R.hamiltonian R.gapScale delta) :
    YangMillsHabitant where
  start := R.start
  physicalData := R.physicalData
  hamiltonian := R.hamiltonian
  gapScale := R.gapScale
  obligations := R.obligations
  physicalRealization := R.physicalRealization
  vacuumAxiom := R.vacuumAxiom
  continuumQFT := R.continuumQFT
  delta := delta
  massGap := hgap

/-- Exact attack theorem: constructing the terminal inhabitant is equivalent
to constructing F4 and then proving F2 for the same H. -/
theorem yangMillsHabitant_iff_F4_and_F2 :
    Nonempty YangMillsHabitant ↔
      ∃ R : YMPhysicalRealizationF4, R.F2Gap := by
  constructor
  · rintro ⟨Y⟩
    let R : YMPhysicalRealizationF4 := {
      start := Y.start
      physicalData := Y.physicalData
      hamiltonian := Y.hamiltonian
      gapScale := Y.gapScale
      obligations := Y.obligations
      physicalRealization := Y.physicalRealization
      vacuumAxiom := Y.vacuumAxiom
      continuumQFT := Y.continuumQFT
    }
    exact ⟨R, Y.delta, Y.massGap⟩