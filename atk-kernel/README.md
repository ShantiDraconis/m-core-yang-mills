# atk-kernel — verificação formal de resultados auxiliares

**Escopo da certificação:** `CERTIFIED` identifica uma declaração específica aceita pelo kernel com as dependências auditadas; não certifica automaticamente a conjectura original. Teoremas condicionais continuam dependentes de suas hipóteses, e modelos abstratos exigem uma ligação demonstrada aos objetos matemáticos originais. A promoção para prova terminal requer um teorema incondicional do enunciado fiel, com auditoria das dependências.

Pasta independente do restante do repositório (lakefile e Mathlib próprios).

Verificação no kernel do Lean 4 (Mathlib `v4.34.1`) dos lemas auxiliares do programa ATK,
com auditoria automática de axiomas no GitHub Actions.

## O que roda a cada push

**Job `kernel`**
1. Instala o Lean e baixa a Mathlib já compilada.
2. Roda `lake build`.
3. Compila cada arquivo `ATK/*.lean` separadamente e executa os `#print axioms` do final de cada um.
4. `scripts/check_axioms.py` marca cada teorema como **CERTIFIED** só se:
   * o arquivo compilou sem erro, e
   * os axiomas usados estão entre `propext`, `Classical.choice` e `Quot.sound`, e
   * a fonte não contém `sorry`, `admit` ou `axiom`.

   Um teorema com erro entra no ambiente com `sorryAx` e é reprovado automaticamente.
5. A tabela aparece no resumo da execução, e os logs ficam no artefato `atk-kernel-report`.

## Teoremas (2)

| Arquivo | Conteúdo | Observação |
|---|---|---|
| `YangMills` | Cauchy–Schwarz ponderado; inclinação da massa efetiva ≤ 0 | não constrói a teoria 4D nem o gap |

Nenhum destes lemas prova uma conjectura do milênio: `OPEN_MATH = true`.
