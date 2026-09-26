import MCore.K8

/-!
Typed structural payload for the K9 classical layer.

This module intentionally carries only the classical obligation label.  It does
not assert existence of a four-dimensional quantum Yang--Mills theory, a
physical Hilbert-space reconstruction, a continuum limit, or a positive mass
gap.
-/

namespace MCore.K9

/-- Minimal data carried by the classical interface.  The proof only fixes the
audit label already certified at K8; it introduces no scientific existence
claim. -/
structure ClassicalGaugeData where
  obligation : MCore.YMObligation
  obligation_is_classical :
    obligation = MCore.YMObligation.classicalGaugeTheory

/-- Canonical label-only inhabitant used for structural wiring tests. -/
def classicalLabelData : ClassicalGaugeData where
  obligation := MCore.YMObligation.classicalGaugeTheory
  obligation_is_classical := rfl

end MCore.K9
