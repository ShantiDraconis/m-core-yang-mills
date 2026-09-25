import MCore.YangMills.B6RealOpenMath

/-!
Canonical no-loop endpoint for the active Yang--Mills lane.
Historical files remain untouched. This module only narrows the active dependency path.
-/

namespace MCore.YangMills

open A1

/-- The active mathematical payload. No structural substitute is accepted. -/
abbrev ATKExternalPayload := B6RealOpenMath

/-- Single active scientific gate. -/
def ATK_EXTERNAL_OPEN_MATH : Prop := B6_REAL_OPEN_MATH

/--
A genuine B6 payload reaches the already-defined K14 mass-gap predicate.
This is deliberately only a routing theorem; it does not manufacture a B6 inhabitant.
-/
theorem atk_b6_to_k14
    {C : K22ConstructionBlock}
    {F : K20ScientificFrontier}
    {D : K14PhysicalHilbertData}
    {H : K14HamiltonianOperator D}
    {G : K14GapScale}
    {O : K30SpectralTransferObligations D H G}
    (b6 : B6RealOpenMath C F D H G O) :
    K14MassGap D H G :=
  b6_real_open_math_closes_mass_gap b6

end MCore.YangMills
