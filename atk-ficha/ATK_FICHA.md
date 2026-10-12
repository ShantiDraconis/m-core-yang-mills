# ATK — FICHA de matemática nova (formalizada em 12/10/2026)

**Estado:** `STRUCTURAL_DESIGN` · `OPEN_MATH = true` · `TERMINAL_CERTIFIED = 0/7` · nenhuma prova nova.

Esta pasta formaliza a proposta de método feita em 12/10 (ficha + núcleo ISK + os 3 corpos de NS + os 7 corpos,
um por problema), com refinamentos. A ficha **não prova nada**: é um filtro de **condições necessárias**.
Uma proposta pode sair daqui como `REJEITADA`, `INCOMPLETA` ou, no máximo, `PASSA_GATE` — que quer dizer
"não foi barrada pelo que dá para verificar automaticamente; agora falta a prova". Não existe veredito "PROVADA".

Arquivos: `ficha_gate.py` (portão, roda no CI), `fichas/*.json` (propostas avaliadas), `fichas/TEMPLATE.json`.
Medições: `atk-kernel/ns_data/new_functional.py` (m-core-openai-ns-audit) e `atk-kernel/numerics/mobius_operator_norm.py`
(M-Core, m-core-riemann).

---

## 1. Núcleo ISK (Invariant Structural Kernel), refinado

Uma proposta é 𝒦 = (X, G, T, 𝓘, 𝓒, 𝓟): objetos X, grupo de simetrias G, evolução/transformação T, invariantes
e cancelamentos 𝓘, mecanismo de controle/compacidade 𝓒, ponte terminal 𝓟.

    Admissível(𝒦)  = Escala ∧ NãoDegenerado ∧ NãoTautológico ∧ Barreira ∧ Dados      ← verificável, necessário
    Fechamento(𝒦)  = Admissível(𝒦) ∧ ControleDinâmico(𝒦) ∧ Ponte(𝒦)                    ← prova; hoje ABERTO

**Correção ao esqueleto Lean proposto.** Uma `structure` com campos `scalingLaw : Prop` e
`scaling_proof : scalingLaw` é habitada com `True` — o kernel já provou isso para todos os portões desse formato
(`ATK.Audit.lane_iff`, `gate_iff`, `certificate_iff`, `producer_iff`). Forma corrigida: o alvo terminal é FIXO no
enunciado oficial, e as leis são as do modelo concreto:

```lean
-- esqueleto (não compilado; só entra no kernel quando uma ficha chegar a PASSA_GATE)
structure ISK_NS where
  M : ATK.Correcao_20261012.ScalingModel          -- leis de escala concretas, não `Prop` livre
  F : M.State → ℝ                                  -- funcional candidato
  escala_a : ∀ a, 0 < a → ∀ u, F (M.amp a u) = a ^ 3 * F u
  escala_l : ∀ l, 0 < l → ∀ u, F (M.dil l u) = l ^ 3 * F u
  cota     : ∃ θ C, θ < 1 ∧ ∀ u, M.S u ≤ θ * M.z u + C * F u
  ponte    : (controle dinâmico de F) → ATK.Exact.NavierStokes   -- alvo fixo: (A)–(D) do Clay
```

## 2. Leis — o núcleo rígido (Navier–Stokes em ℝ³)

Grupo de simetrias: amplitude u ↦ a·u, dilatação u ↦ λ·u(λ·), translações, rotações. Vetores de escala (a, λ):

| Quantidade | Definição | (a, λ) | Natureza |
|---|---|---|---|
| E | ‖u‖₂² | (2, −1) | supercrítica (a única controlada para dado grande) |
| y | ‖ω‖₂² | (2, 1) | |
| z | ‖∇ω‖₂² | (2, 3) | dissipação |
| S | ∫ω·(∇u)ω | (3, 3) | estiramento |
| ‖u‖_{L³} | | (1, 0) | crítica |
| ‖u‖²_{Ḣˢ} | | (2, 2s − 1) | crítica em s = ½ |

**Lei do portão.** Uma cota S ≤ θνz + Σ Cᵢ Fᵢ só sobrevive às duas escalas se (3, 3) estiver no fecho convexo de
{(2, 3)} ∪ {σ(Fᵢ)}. Com um único F: **λ_F = 3 e a_F ≥ 3**. No kernel: `only_cubic_survives`, `exponent_rigidity`.

**Por que o núcleo rígido é constante.** Os vetores de escala vêm do grupo de simetrias da equação, não da proposta:
nenhum candidato os altera. A região admissível {λ_F = 3, a_F ≥ 3} é fixa. Por isso todo laço de reformulação volta
ao mesmo lugar: as propostas mudam, a geometria do portão não.

**O laço como "prova do fechamento"?** Que as derivações voltem ao núcleo é um fato, e o kernel já o registra como
equivalências (`descent_iff_beal`, `rh_iff_limit_zero_of_criterion`, `lane_iff`, `producer_iff`): cada parâmetro
derivado é equivalente à própria conjectura. Equivalência não transfere verdade: P ⇔ C não decide C. As leis do
núcleo são universais como **restrições** (condições necessárias que toda prova tem de satisfazer); não são leis que
impliquem as conjecturas.

## 3. Bases e operadores

- **Bases:** E, y, z, S, ‖u‖_{L³}, ‖u‖_{Ḣˢ}, ξ = ω/|ω|.
- **σ** (vetor de escala): F ↦ (a_F, λ_F), medido no campo semente (não suposto).
- **Γ** (portão de escala): cota ↦ admissível/rejeitada (fecho convexo).
- **𝔑** (degeneração): F ≡ 0? (ex.: lagrangianos nulos).
- **𝔗** (tautologia): F = c·S? (target laundering).
- **𝔐** (medição): `new_functional.py` — expoentes em a = 10 e λ = 1.5, 2; razões sob a e λ.
- **A_ξ(x, r)** = sup_{|h|≤r} |ξ(x)×ξ(x+h)| (direção da vorticidade; adimensional).

## 4. Classes numéricas

`DEGENERADO` (F ≡ 0) · `TAUTOLOGICO` (F ∝ S) · `REJEITADO_ESCALA` · `PASSA_ESCALA` (condição necessária ok) ·
`CONHECIDO` (cota já na literatura). Vereditos da ficha: `REJEITADA` < `INCOMPLETA` < `PASSA_GATE`.

## 5. Lemática (com o estado de cada lema)

| Lema | Enunciado | Estado |
|---|---|---|
| L1 | leis de escala (2,2,3) e (1,3,3) | medidas no campo semente, expoentes exatos até 10⁻⁶; hipóteses do `ScalingModel` |
| L2 | rigidez: S ≤ θνz + C·yᵖ ∀u ⇒ p = 3 | kernel (`only_cubic_survives`) |
| L3 | ∫det(∇u) = 0 para todo campo periódico ou de suporte compacto (lagrangiano nulo) | clássico; medido (0 exato; 10⁻¹⁹ num campo aleatório) |
| L4 | ∫ω·Sym(∇u)·ω = S e −∫(u·∇)u·Δu = −S | identidades; medidas |
| L5 | \|S\| ≤ C·y^{3/4}z^{3/4} ≤ (ν/2)z + Cν⁻³y³ | clássico (Gagliardo–Nirenberg); só tempo curto |
| L6 | \|S\| ≤ C‖u‖_{L³}·z | clássico; dados pequenos; L^∞_t L³_x ⇒ regular (Escauriaza–Seregin–Šverák 2003) |
| L7 | dividir por log crescente de z/y tira o termo da reta λ = 3 | medido (expoentes 2.51 e 2.75) |
| L8 | barreira: a NS média de Tao (2016) explode — argumento que só usa energia + estimativas que valem para ela é inválido | literatura |
| L9 | direção de ω Lipschitz onde \|ω\| é grande ⇒ regular (Constantin–Fefferman 1993) | literatura, condicional |

## 6. A ficha (passos)

1. **Problema alvo** — um só (enunciado em `ATK/Exact.lean` ou itens da lista de 72).
2. **Onde quebra hoje** — o que já foi medido ou refutado.
3. **Corpo novo** — F explícito; escala medida (a, λ); domínio.
   3b. **Não degenerado e não tautológico** — F ≢ 0 e F não é c·S.
4. **Classe e operador** — nome, Op(F): campo → ℝ.
5. **Desigualdade candidata** — e por que sobrevive à escala (portão Γ).
   5b. **Controle dinâmico** — por que F fica controlado ao longo de TODA solução, para dado grande. *É aqui que está o problema aberto*; sem isto a ficha fica `INCOMPLETA`.
6. **Teste numérico obrigatório** — `new_functional.py` (128³): expoentes, degeneração, tautologia, razões em a e λ.
7. **Lean** — só depois de `PASSA_GATE`. Uma cota verdadeira S ≤ θνz + C·F (do tipo L5/L6) aumenta a contagem do kernel, mas **não** tira o ATK do FINAL FAIL; só o controle dinâmico (5b) tiraria.
8. **Verificação** — `ficha_gate.py` no CI, `scaling_check.py`, `lake build` + kernel; `Exact.lean` intocado.

## 7. Portões das outras conjecturas — objetos onde a proposta TEM QUE FALHAR

| Problema | Portão automático | Contraexemplos que o argumento precisa distinguir |
|---|---|---|
| RH | taxa D_N ≤ K(log N)^{−s} com s > 1 é rejeitada (Burnol 2001: liminf D_N·log N > 0); conferência com D_N, N ≤ 1500 | função de Davenport–Heilbronn: equação funcional, sem produto de Euler, zeros fora da reta |
| YM | precisa usar estrutura não abeliana; dimensão 4 | U(1) livre em 4D (fóton, sem gap); em 4D ∫\|F\|² é adimensional (λ⁰) |
| BSD | rodar a fórmula na varredura de Cremona (64 687 curvas, condutor < 10 000) | dados finitos não provam a lei; posto analítico ≥ 2 |
| Hodge | precisa usar projetividade e coeficientes racionais | versão de Kähler falsa (Voisin 2002); versão inteira falsa (Atiyah–Hirzebruch 1962) |
| Beal | precisa dizer onde usa x, y, z > 2 | 10 soluções primitivas de Fermat–Catalan com um expoente 2 (conferidas pelo script); toda curva elíptica sobre ℚ é modular |
| P ≠ NP | dizer como evita relativização, provas naturais, algebrização | cotas para sistemas de prova fracos (resolução) não implicam P ≠ NP |

## 8. Propostas de 12/10 avaliadas (`fichas/`)

| Ficha | Veredito | Motivo principal |
|---|---|---|
| NS-C1 ∫det(∇u) | REJEITADA | ≡ 0 (lagrangiano nulo); o termo GN/log quebra a escala |
| NS-C2 ∫ω·Sym(∇u)·ω | REJEITADA | é o próprio S (tautologia) |
| NS-C3 ∫\|∇u\|³ | INCOMPLETA | passa a escala, mas equivale à cota clássica (L5); falta controle dinâmico |
| NS-Corpo1 GN/√log(e+z/y) | REJEITADA | expoente de dilatação medido 2.75 < 3; razão cresce como √log λ |
| NS-crítico ‖u‖_{L³}·z | INCOMPLETA | cota conhecida (L6); controlar ‖u‖_{L³} para dado grande é o aberto |
| NS-ISK A_ξ | INCOMPLETA | invariante por escala; é o critério de Constantin–Fefferman; falta provar que a dinâmica o preserva |
| RH-Corpo2 Möbius H_N | REJEITADA | ‖H_N‖ cresce (1.61 → 2.26, N = 10 → 1500); o operador completo é ilimitado (1/ζ(1+it) não é limitada) |
| RH taxa (log N)⁻² | REJEITADA | contradiz Burnol |
| YM-Corpo3 RG cúbico | REJEITADA | contagem de escala 4D errada; não usa estrutura não abeliana |
| BSD-Corpo4 pairing | INCOMPLETA | operador não definido; a varredura não "falha" em curva nenhuma |
| HODGE-Corpo5 distância | REJEITADA | não usa projetividade; reformulação equivalente |
| BEAL-Corpo6 Frey–Beal | REJEITADA | toda curva elíptica sobre ℚ é modular |
| BEAL descida sem expoente | REJEITADA | valeria para as soluções de Fermat–Catalan |
| PNP-Corpo7 largura | INCOMPLETA | largura Ω(n) limita só resolução; barreiras não tratadas |

Nenhuma das 15 fichas chegou a `PASSA_GATE`. As que passaram na escala (C3, crítico, ISK) são resultados já conhecidos;
o que falta nelas é o mesmo em todas: controle dinâmico para dado grande.

## 9. O que não pode ser afirmado

- "kernel 85 → 108": a contagem só sobe com teoremas provados; nenhuma das propostas traz um.
- Um operador M unificado para os seis problemas não está definido; não há o que medir nem provar.
- Passar na escala não é fechar: L5 e L6 passam e são teoremas antigos.
- FINAL FAIL do ATK se mantém: 8 enunciados abertos (RH; taxa uniforme; YM; BSD posto; BSD fórmula; Hodge; Beal; P ≠ NP).
