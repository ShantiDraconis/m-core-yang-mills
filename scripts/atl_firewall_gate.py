#!/usr/bin/env python3
import json, sys
CLASSES=("TYPE","BUILD","AXIOM","CIRCULARITY","SEMANTIC","INTERFACE","VACUITY","OPEN_MATH")

def five_firewalls(ev):
    return {
      "AXIOM": bool(ev.get("axiom_clean",False)),
      "CIRCULARITY": bool(ev.get("dag_acyclic",False)),
      "SEMANTIC": bool(ev.get("statement_hash_match",False) and ev.get("semantic_match",False)),
      "INTERFACE": bool(ev.get("data_bearing_interface",False)),
      "VACUITY": bool(ev.get("nonvacuity_proved",False) and ev.get("nontrivial_conclusion",False)),
    }

def gate(errors,upstream):
    es=[e for e in errors if e.get("class") in CLASSES]
    ids={e["node"] for e in es}
    canonical=[]
    for e in es:
        n=e["node"]
        if not any((m!=n and n in upstream.get(m,[])) for m in ids):
            canonical.append(e)
    return {"independent_errors":es,"canonical_upstream_errors":canonical,
            "status":"GREEN" if not es else "RED"}

if __name__=="__main__":
    payload=json.load(sys.stdin)
    if "evidence" in payload: print(json.dumps(five_firewalls(payload["evidence"]),indent=2))
    else: print(json.dumps(gate(payload.get("errors",[]),payload.get("upstream",{})),indent=2))
