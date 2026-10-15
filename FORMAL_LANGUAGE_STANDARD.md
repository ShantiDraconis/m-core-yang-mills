# ATK — Norma de linguagem e evidência formal (v1)

## Regra de certificação
Um resultado só recebe `TERMINAL_CERTIFIED` se o enunciado fiel ao problema original tiver um termo de prova incondicional aceito pelo kernel, com dependências e axiomas auditados. Uma declaração compilada com hipóteses continua condicional. GREEN/FROZEN/CLOSED operacionais não são sinônimos de solução.

## Categorias semânticas a localizar
1. teoria — explicitar definições e axiomas
2. hipótese — declarar premissas e dependências
3. conjectura — manter aberta sem prova terminal
4. proposta — distinguir definição, construção e teorema
5. poderia existir — exigir testemunha ou obrigação de existência
6. seria possível — indicar condição suficiente ou hipótese
7. se existisse — registrar implicação condicional
8. assumimos — explicitar hipótese local
9. supomos — explicitar premissa
10. é evidente — fornecer lema ou prova
11. segue imediatamente — indicar aplicação formal
12. é equivalente — demonstrar os dois sentidos
13. é necessário — provar implicação necessária
14. é suficiente — provar implicação suficiente
15. é universal — explicitar domínio e quantificador
16. é único — demonstrar existência e unicidade
17. provado — apontar enunciado exato e certificado
18. certificado — apontar execução do kernel e dependências
19. GREEN — apontar critério técnico e execução
20. FROZEN — identificar versão/commit congelado
21. CLOSED — identificar obrigação descarregada
22. OPEN — identificar obrigação pendente
23. modelo validado — delimitar modelo e propriedades
24. ponte concluída — indicar teorema de ligação
25. redução completa — não confundir com prova do alvo
26. evidência numérica — delimitar domínio, erro e precisão
27. sem axiomas — distinguir axiomas adicionais dos axiomas lógicos permitidos
28. prova final — exigir enunciado original incondicional

## Estados permitidos
- `DEFINITION`: objeto formal definido, sem alegação de existência adicional.
- `CONDITIONAL`: conclusão demonstrada sob premissas explícitas.
- `PROVEN_REDUCTION`: implicação/equivalência provada, sem afirmar a conclusão isolada.
- `COMPUTED`: cálculo executado com domínio e precisão conhecidos.
- `MODEL_PROVEN`: resultado demonstrado apenas no modelo especificado.
- `OPEN_OBLIGATION`: premissa ou alvo sem prova incondicional identificada.
- `KERNEL_PROVEN`: declaração específica aceita pelo kernel; verificar axiomas.
- `TERMINAL_CERTIFIED`: prova fiel e incondicional do problema original.

## Linguagens e arquivos
Lean/Mathlib: theorem, lemma, axiom, sorry, imports e dependências. Coq/Rocq: Theorem, Lemma, Admitted, Axiom. Isabelle: theorem, assumes, shows, sorry. Agda: postulate e buracos. Python/C++: testes e limites. Shell/CI: condições reais de sucesso. JSON/YAML: estados e rastreabilidade. Markdown/LaTeX: alegações e demonstrações. CSV/dados: proveniência e precisão.

## Procedimento
1. Inventariar por repositório, branch, caminho, linha, termo, commit e hash.
2. Marcar ocorrência como `REVIEW`, `CORRECT` ou `CHANGE_REQUIRED`; correspondência textual isolada não é erro.
3. Corrigir apenas linguagem comprovadamente incompatível com o enunciado e suas dependências.
4. Não renomear símbolos Lean ou remover hipóteses, axiomas ou sorry por substituição textual.
5. Validar diff, compilar cada projeto no seu toolchain, auditar `#print axioms` e preservar histórico.
6. Nunca promover automaticamente `OPEN_OBLIGATION` a `TERMINAL_CERTIFIED`.

Fonte do inventário histórico: `conditional/INVENTORY.md` no M-Core. Seus totais são um retrato registrado, não evidência de uma nova varredura.
