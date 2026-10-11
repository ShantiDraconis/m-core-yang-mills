# Certificado ATK v1 — ShantiDraconis/m-core-yang-mills

- Commit verificado: `4feb31a842c07966724ccd65ad75fa207e6f8f61` (tag `atk-kernel-cert-v1`)
- Gerado em: 2026-10-11T23:51:50+00:00
- Teoremas aceitos pelo kernel: **2/2**

## ATK kernel check
- Execução: https://github.com/ShantiDraconis/m-core-yang-mills/actions/runs/38181947601
- Lean (version 4.34.1, x86_64-unknown-linux-gnu, commit 5045d0056413266e57c625dcd7c365b10e377c52, Release)
- SHA-256 das fontes: `51a7324a0df74da488441508cbacc46d20d17868cd1665de2c73451b73da4b52`
- Job “Lean 4 + Mathlib — compilação e auditoria de axiomas”: success

| Teorema | Veredito | Axiomas |
|---|---|---|
| `ATK.YangMills.weighted_cauchy_schwarz` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |
| `ATK.YangMills.effective_mass_slope_nonpos` | ✅ CERTIFIED  | propext, Classical.choice, Quot.sound |

Lemas auxiliares e cálculos concretos. Nenhuma das sete conjecturas foi provada; OPEN_MATH=true.
