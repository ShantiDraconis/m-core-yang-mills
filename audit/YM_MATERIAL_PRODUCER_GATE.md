# Yang--Mills MATERIAL_PRODUCER_GATE v1

## Current frontier

The repository already records the honest mathematical state in `GATE_LEDGER.json`:

```
state_math = OPEN_MATH
next = construct B6 genuine 4D physical realization with continuum/IR control
       and spectral-transfer witness yielding a positive uniform gap
```

The terminal-producer index states the same boundary:

> genuine 4D physical mass/reconstruction input yielding a positive spectral gap;
> trivial/phantom physical interfaces do not count.

## Important typing fence

Do **not** introduce a fake endpoint merely to make the probe compile.

In particular, the gate rejects patterns such as:

```lean
structure YMWitness where
  bound : PhysicalLowerBound c
```

followed by projection of `bound`.

The current repository snapshot still has a TYPE_ENDPOINT_RESIDUE: the K1 layer
records `massGap/openBridge`, but the canonical standard-object proposition for
the genuine 4D physical realization is not yet exposed at this layer.

Therefore the correct material status is:

```
AUDIT_STATUS    = GREEN
MATERIAL_STATUS = OPEN_MATH
MATERIAL_GREEN  = false
```

## Stable hole

Construct a genuine 4D Yang--Mills physical realization, with continuum/IR
control and an independently derived strictly positive uniform spectral gap,
from standard gauge-theory objects. The lower bound may not be supplied as a
field, oracle, axiom, or endpoint-equivalent hypothesis.

## Forward-only rule

Existing K12--K30, spectral, B60, adapter, and firewall certificates remain
reusable as GREEN_INTERFACE / GREEN_TRANSPORT / GREEN_FIREWALL according to
their exact statements. None may be promoted to MATERIAL_GREEN unless they
construct the missing physical object and positive gap directly.
