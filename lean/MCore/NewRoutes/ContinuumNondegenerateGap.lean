namespace MCore.NewRoutes
structure ContinuumNondegenerateGap where
  Regulator : Type
  gap : Regulator → Nat
  positive : ∀ a, 0 < gap a
  uniformLowerBound : Nat
  nondegenerate : ∀ a, uniformLowerBound ≤ gap a
  continuumGap : Nat
  continuumPositive : 0 < continuumGap
end MCore.NewRoutes
