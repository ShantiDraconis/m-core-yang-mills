import MCore.YangMills.A1.B60ConcretePhysicalAdapter

namespace MCore.YangMills.A1

structure FinalExternal
    (C : RegulatedYM4Construction)
    (F : K20ScientificFrontier)
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D)
    (O : K30SpectralTransferObligations F D H G) where
  adapter : B60ConcretePhysicalAdapter C F D H G O

def FINAL_EXTERNAL
    (C : RegulatedYM4Construction)
    (F : K20ScientificFrontier)
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D)
    (O : K30SpectralTransferObligations F D H G) :=
  FinalExternal C F D H G O

theorem FINAL_ROOT
    {C F D H G O}
    (E : FinalExternal C F D H G O) :
    ∃ gap : D.Scale, K14MassGap D H G gap :=
  b60_adapter_closes_conditional_chain E.adapter

#print axioms MCore.YangMills.A1.FINAL_ROOT
end MCore.YangMills.A1
