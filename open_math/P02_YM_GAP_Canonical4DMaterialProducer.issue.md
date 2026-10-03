# P02-YM — canonical 4D material producer

LANE: P02-YM  
HEAD: d79f2f41edd91cfc9f16b7748d9d8eea742eccd9  
FREEZE: frozen/ym-kernel-closure-green-681acda8  
GAP ID: genuine canonical 4D material realization  
STATUS ATUAL: G0-G7 GREEN, G6b GREEN, STRUCTURAL_CLOSURE GREEN, TRANSPORT_CLOSURE GREEN, KERNEL GREEN, MATERIAL_PRODUCER OPEN_MATH 1.

## Tipos materiais já expostos

O repo já expõe, no mesmo conjunto de parâmetros `C F D H G O`:

```lean
B60FieldOpenMath C F D H G O :=
  Nonempty (B60FieldBundle C F D H G O)
```

e:

```lean
B60CanonicalPhysicalOpenBridge C F D H G O :=
  Nonempty (B60CanonicalPhysicalBinding C F D H G O)
```

Não criar um wrapper novo e chamar de equivalente. O produtor 4D genuíno deve construir os dois lados coerentemente no mesmo modelo físico não degenerado.

## Conteúdo de B60FieldBundle

- stateMap
- observableState
- mappedStatesPhysical
- observableStatesPhysical
- K23 constructive 4D data + inputs
- constructionFromA1
- K25 clustering system + uniform clustering + bridge
- cyclicity / semigroup transfer
- K27 regulated gap + uniform positive gap + limit control + limit witness + bridge
- excitation
- excitation in domain / physical / orthogonal to vacuum
- K30 spectral transfer witness

## Binding físico

`B60CanonicalPhysicalBinding` exige:

```lean
adapter : B60ConcretePhysicalAdapter C F D H G O
excitation_ne_vacuum : adapter.excitation ≠ D.vacuum
```

O toy model Unit já foi formalmente rejeitado.

## Critério de aceite

- 0 `sorry`
- 0 `admit`
- 0 `axiom` novo
- `lake build MCore` SUCCESS
- source hygiene SUCCESS
- B60 field audit SUCCESS
- canonical physical binding audit SUCCESS
- modelo 4D genuíno e não degenerado
- sem trocar construção física por um campo booleano/proposicional equivalente

## O que não conta

- toy/unit model
- binding que assume mass gap
- `FinalExternalCertificate` fabricado diretamente
- K30 witness sem ligação ao mesmo Hilbert/Hamiltonian físico
- uniformidade posta como hipótese equivalente ao próprio gap

## Pedido

Construir uma realização 4D concreta compartilhada que forneça `B60FieldBundle` e `B60CanonicalPhysicalBinding` no mesmo `C,F,D,H,G,O`, preservando a não degenerescência e alimentando o FINAL_ROOT apenas pelas rotas já GREEN.
