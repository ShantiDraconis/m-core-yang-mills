import MCore.YangMills.A1.B60FieldBundle
import MCore.YangMills.A1.B60CanonicalPhysicalBinding

namespace MCore.YangMills.A1.OpenMath

/--
P02-YM exposes two existing material obligations on one shared concrete model.
This file deliberately does not invent a wrapper and does not claim equivalence.
-/
#check MCore.YangMills.A1.Final.B60FieldOpenMath
#check MCore.YangMills.A1.B60CanonicalPhysicalOpenBridge
#check MCore.YangMills.A1.Final.B60FieldBundle
#check MCore.YangMills.A1.B60CanonicalPhysicalBinding
#check MCore.YangMills.A1.Final.B60FieldBundle.closes_FINAL_ROOT
#check MCore.YangMills.A1.canonical_binding_closes_conditional_chain

end MCore.YangMills.A1.OpenMath
