import MCore.YMFinalEndpoint

namespace MCore.YM

/-- Authoritative typed endpoint interface.
    MATERIAL_GREEN additionally requires binding S to concrete standard
    four-dimensional Yang--Mills objects and constructing this proposition. -/
def MinimalYMInhabitant (S : EndpointSemantics) : Prop :=
  FinalEndpoint S

end MCore.YM
