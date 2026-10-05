import MCore.OpenMath.ForcingKernel

namespace MCore.OpenMath.YM

open MCore.YangMills.A1

example
    (C : RegulatedYM4Construction)
    (F : K20ScientificFrontier)
    (D : K14PhysicalHilbertData)
    (H : K14HamiltonianOperator D)
    (G : K14GapScale D)
    (O : K30SpectralTransferObligations F D H G) :
    FirstRealOpenMath C F D H G O := by
  refine ⟨?_⟩
  constructor

end MCore.OpenMath.YM
