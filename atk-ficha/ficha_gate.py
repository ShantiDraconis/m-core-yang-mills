#!/usr/bin/env python3
"""
ATK — portão da FICHA de matemática nova (condições NECESSÁRIAS; nunca prova nada).

uso: python3 ficha_gate.py fichas/*.json [--dn caminho/dn_N1500_prec45.csv]

Vereditos (do pior para o melhor):
  REJEITADA   falha uma condição necessária verificável (escala, degeneração, tautologia, dados, barreira)
  INCOMPLETA  falta declarar algo obrigatório (controle dinâmico, como evita a barreira, ...)
  PASSA_GATE  passou em tudo o que é verificável automaticamente — continua sendo só uma PROPOSTA;
              falta a prova (e o Lean só entra depois disso)
Não existe veredito "PROVADA". Se a ficha trouxer "veredito_esperado", divergência faz o CI falhar.
"""
import csv, json, math, os, sys
from fractions import Fraction as Fr
from itertools import combinations

ORDEM = {"REJEITADA": 0, "INCOMPLETA": 1, "PASSA_GATE": 2}

# ---------------- núcleo rígido de Navier–Stokes (ℝ³): vetores de escala (amplitude a, dilatação λ) ----------------
ESCALA_NS = {"S": (3, 3), "z": (2, 3), "y": (2, 1), "E": (2, -1), "u_L3": (1, 0)}

def _cross(o, p, q):
    return (p[0] - o[0]) * (q[1] - o[1]) - (p[1] - o[1]) * (q[0] - o[0])

def no_fecho(P, pts):
    pts = list(dict.fromkeys(pts))
    if P in pts:
        return True
    for p, q in combinations(pts, 2):
        if _cross(p, q, P) == 0 and min(p[0], q[0]) <= P[0] <= max(p[0], q[0]) \
                and min(p[1], q[1]) <= P[1] <= max(p[1], q[1]):
            return True
    for p, q, r in combinations(pts, 3):
        if _cross(p, q, r) == 0:
            continue
        d = (_cross(p, q, P), _cross(q, r, P), _cross(r, p, P))
        if all(v >= 0 for v in d) or all(v <= 0 for v in d):
            return True
    return False

def vazio(v):
    return v is None or (isinstance(v, str) and not v.strip()) or (isinstance(v, (list, dict)) and not v)

# ---------------- objetos que toda proposta TEM QUE FALHAR (contraexemplos conhecidos e verificáveis) ----------------
FERMAT_CATALAN = [(1, 7, 2, 3, 3, 2), (2, 5, 7, 2, 3, 4), (7, 3, 13, 2, 2, 9), (2, 7, 17, 3, 71, 2),
                  (3, 5, 11, 4, 122, 2), (17, 7, 76271, 3, 21063928, 2), (1414, 3, 2213459, 2, 65, 7),
                  (9262, 3, 15312283, 2, 113, 7), (43, 8, 96222, 3, 30042907, 2),
                  (33, 8, 1549034, 2, 15613, 3)]

def fermat_catalan_ok():
    return all(A**x + B**y == C**z and math.gcd(math.gcd(A, B), C) == 1 and min(x, y, z) == 2
               for A, x, B, y, C, z in FERMAT_CATALAN)

# ---------------- portões por problema ----------------
def gate_ns(p, msgs):
    if p.get("tipo") == "criterio_geometrico":
        if p.get("invariancia_de_escala") != "ok":
            msgs.append("critério geométrico sem invariância de escala verificada")
            return "REJEITADA"
        msgs.append("critério geométrico invariante por escala (condição necessária ok)")
        if p.get("conhecida_na_literatura"):
            msgs.append("resultado condicional já conhecido: " + p["conhecida_na_literatura"])
        if vazio(p.get("controle_dinamico")):
            msgs.append("falta provar que a dinâmica preserva o critério para todo dado inicial — aberto")
            return "INCOMPLETA"
        return "PASSA_GATE"
    cls = p.get("classe_medida", "")
    if cls in ("DEGENERADO", "TAUTOLOGICO"):
        msgs.append(f"classe medida {cls}: F ≡ 0 ou F ∝ S não carrega informação nova")
        return "REJEITADA"
    termos = [tuple(t["vetor"]) for t in p.get("termos_rhs", [])]
    pts = [ESCALA_NS["z"]] + [(Fr(a), Fr(l)) for a, l in termos]
    if not no_fecho((Fr(3), Fr(3)), pts):
        msgs.append(f"escala: (3,3) de S fora do fecho convexo de {[(str(a), str(l)) for a, l in pts]} — "
                    "a cota quebra por amplitude/dilatação")
        return "REJEITADA"
    msgs.append("escala: ok (condição necessária)")
    if p.get("conhecida_na_literatura"):
        msgs.append("cota já conhecida: " + p["conhecida_na_literatura"])
    v = "PASSA_GATE"
    if vazio(p.get("controle_dinamico")):
        msgs.append("falta o controle dinâmico de F ao longo da solução — é exatamente o problema aberto")
        v = "INCOMPLETA"
    if vazio(p.get("como_evita_barreira_tao")):
        msgs.append("falta dizer que estrutura de NS o argumento usa e que a NS média de Tao (2016, explode) não tem")
        v = "INCOMPLETA"
    return v

def gate_rh(p, msgs, dn):
    v = "PASSA_GATE"
    taxa = p.get("taxa")
    if taxa:
        s, K = float(taxa["s"]), taxa.get("K")
        if s > 1:
            msgs.append(f"D_N ≤ K/(log N)^{s} com s > 1 contradiz Burnol (2001): liminf D_N·log N > 0")
            return "REJEITADA"
        if K is not None and dn:
            viol = [(N, d) for N, d in dn if N >= 2 and d > float(K) * math.log(N) ** (-s)]
            if viol:
                N, d = viol[0]
                msgs.append(f"dados: D_{N} = {d:.6g} > {K}·(log {N})^(-{s}) — {len(viol)} violações em N ≤ {dn[-1][0]}")
                return "REJEITADA"
            msgs.append(f"dados: compatível com D_N para 2 ≤ N ≤ {dn[-1][0]}")
        if s == 1:
            msgs.append("taxa 1/log N: é exatamente o item 10/48 (mais forte que RH) — continua aberto")
    if vazio(p.get("como_falha_davenport_heilbronn")):
        msgs.append("falta dizer onde o argumento usa o produto de Euler: a função de Davenport–Heilbronn tem "
                    "equação funcional e zeros fora da reta crítica")
        v = "INCOMPLETA"
    return v

def gate_beal(p, msgs):
    ok = fermat_catalan_ok()
    msgs.append(f"{len(FERMAT_CATALAN)} soluções primitivas de Fermat–Catalan conferidas (todas com um expoente 2): {ok}")
    if vazio(p.get("usa_expoentes_maiores_que_2_em")):
        msgs.append("o argumento não diz onde usa x, y, z > 2: ele se aplicaria às soluções acima, que existem")
        return "REJEITADA"
    return "PASSA_GATE"

def gate_hodge(p, msgs):
    v = "PASSA_GATE"
    if vazio(p.get("usa_projetividade_em")):
        msgs.append("não usa projetividade: a versão para variedades de Kähler é falsa (Voisin 2002)")
        v = "REJEITADA"
    if vazio(p.get("usa_coeficientes_racionais_em")):
        msgs.append("não usa coeficientes racionais: a versão inteira é falsa (Atiyah–Hirzebruch 1962)")
        v = "REJEITADA"
    if int(p.get("codimensao", 2)) < 2:
        msgs.append("codimensão 1 já é teorema (Lefschetz (1,1)); o aberto é p ≥ 2")
    return v

def gate_ym(p, msgs):
    if vazio(p.get("usa_estrutura_nao_abeliana_em")):
        msgs.append("não usa estrutura não abeliana: a teoria U(1) livre em 4D (fóton) não tem gap")
        return "REJEITADA"
    if int(p.get("dimensao", 4)) != 4:
        msgs.append("o problema é em dimensão 4")
        return "INCOMPLETA"
    return "PASSA_GATE"

def gate_bsd(p, msgs):
    f = p.get("falhas_na_base_cremona")
    if f is None:
        msgs.append("falta rodar a fórmula proposta na varredura de Cremona (64 687 curvas, bsd_scan)")
        return "INCOMPLETA"
    if int(f) > 0:
        msgs.append(f"falha em {f} curvas da base de Cremona")
        return "REJEITADA"
    msgs.append("compatível com as 64 687 curvas de condutor < 10 000")
    if vazio(p.get("argumento_geral")):
        msgs.append("dados finitos não provam a lei geral: falta o argumento")
        return "INCOMPLETA"
    return "PASSA_GATE"

def gate_pnp(p, msgs):
    b = p.get("barreiras", {})
    faltam = [k for k in ("relativizacao", "provas_naturais", "algebrizacao") if vazio(b.get(k))]
    if faltam:
        msgs.append("falta dizer como evita: " + ", ".join(faltam) +
                    " (Baker–Gill–Solovay 1975; Razborov–Rudich 1997; Aaronson–Wigderson 2009)")
        return "INCOMPLETA"
    return "PASSA_GATE"

GATES = {"NS": gate_ns, "RH": gate_rh, "BEAL": gate_beal, "HODGE": gate_hodge, "YM": gate_ym,
         "BSD": gate_bsd, "PNP": gate_pnp}
OBRIG = ["id", "problema", "alvo", "onde_quebra_hoje", "proposta"]

def main():
    args = sys.argv[1:]
    dn = None
    if "--dn" in args:
        i = args.index("--dn"); path = args[i + 1]; del args[i:i + 2]
        if os.path.exists(path):
            dn = [(int(r["N"]), float(r["D_N"])) for r in csv.DictReader(open(path))]
    linhas, falhas = [], 0
    for fn in args:
        f = json.load(open(fn, encoding="utf-8"))
        if fn.endswith("TEMPLATE.json"):
            continue
        msgs = []
        falta = [k for k in OBRIG if vazio(f.get(k))]
        if falta:
            v = "INCOMPLETA"; msgs.append("campos obrigatórios ausentes: " + ", ".join(falta))
        else:
            prob = f["problema"].upper()
            g = GATES.get(prob)
            v = (g(f["proposta"], msgs, dn) if prob == "RH" else g(f["proposta"], msgs)) if g else "INCOMPLETA"
            rev = f.get("revisao", {})
            if not vazio(rev.get("contradiz")):
                msgs.append("contradiz resultado conhecido: " + rev["contradiz"])
                v = "REJEITADA"
            if not vazio(rev.get("nao_segue")):
                msgs.append("passo que não segue: " + rev["nao_segue"])
                v = min(v, "INCOMPLETA", key=ORDEM.get)
            if not vazio(rev.get("nota")):
                msgs.append("nota: " + rev["nota"])
        esp = f.get("veredito_esperado")
        div = esp is not None and esp != v
        falhas += div
        linhas.append(f"{'DIVERGE ' if div else ''}{f.get('id', fn)} [{f.get('problema')}] → {v}"
                      + (f" (esperado {esp})" if div else "") + "\n    " + "\n    ".join(msgs))
    out = "\n".join(linhas)
    print(out)
    if os.environ.get("GITHUB_ACTIONS"):
        esc = lambda s: s.replace("%", "%25").replace("\n", "%0A")
        print(f"::notice title=FICHA ATK — {len(linhas)} propostas avaliadas (nenhuma prova)::" + esc(out))
        with open(os.environ["GITHUB_STEP_SUMMARY"], "a") as s:
            s.write("## FICHA ATK — portão de matemática nova\n\n```\n" + out + "\n```\n")
    sys.exit(1 if falhas else 0)

if __name__ == "__main__":
    main()
