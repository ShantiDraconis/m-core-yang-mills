import MCore.K1

namespace MCore.YangMillsMaterialProbe

/-
EXPECTED-FAILURE SENTINEL.

The current repository does not yet expose a canonical concrete proposition for
"genuine 4D physical realization + positive uniform spectral gap" built from
standard gauge-theory objects. Therefore we deliberately do NOT invent a fake
structure such as:

  structure YMWitness where
    bound : PhysicalLowerBound c

A future material probe must replace this sentinel only when the standard
endpoint types are present in the repository and must construct the lower bound
directly from those objects.
-/

def expectedFailureReason : String :=
  "TYPE_ENDPOINT_RESIDUE: canonical 4D physical Yang--Mills material endpoint not yet bound to standard objects"

end MCore.YangMillsMaterialProbe
