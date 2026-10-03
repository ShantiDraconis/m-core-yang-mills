import MCore.YangMills.A1.B60FieldBundle
import MCore.YangMills.A1.B60CanonicalPhysicalBinding

namespace P02.YM.Physical

open MCore.YangMills.A1
open MCore.YangMills.A1.Final

/--
Shared nondegenerate B6.0 physical realization.

Unlike the rejected Unit toy model, this package requires the canonical
physical binding to be exactly the adapter assembled from the same field
bundle.
-/
structure B60PhysicalModel
    (C : RegulatedYM4Construction)
    (F : K20ScientificFrontier)
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D)
    (O : K30SpectralTransferObligations F D H G) where
  fieldBundle : B60FieldBundle C F D H G O
  binding : B60CanonicalPhysicalBinding C F D H G O
  coherent : binding.adapter = fieldBundle.toFinalExternal

theorem B60PhysicalModel.excitation_ne_vacuum
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}
    (P : B60PhysicalModel C F D H G O) :
    P.fieldBundle.toFinalExternal.excitation ≠ D.vacuum := by
  rw [← P.coherent]
  exact P.binding.excitation_ne_vacuum

theorem B60PhysicalModel.closesFinalRoot
    {C : RegulatedYM4Construction}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale D}
    {O : K30SpectralTransferObligations F D H G}
    (P : B60PhysicalModel C F D H G O) :
    FINAL_ROOT D H G :=
  P.fieldBundle.closes_FINAL_ROOT

#print axioms P02.YM.Physical.B60PhysicalModel.excitation_ne_vacuum
#print axioms P02.YM.Physical.B60PhysicalModel.closesFinalRoot

end P02.YM.Physical
