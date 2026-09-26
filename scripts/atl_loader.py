#!/usr/bin/env python3
import json, pathlib, sys
from collections import defaultdict, deque

DERIVED={"proof_state","build_state","kernel_state","axiom_state","semantic_state",
"certificate_state","dependencies","consumers","replacement_route","cut_value"}
ATTACKABLE="OPEN_MATH_ATTACKABLE"

def load(path):
    g=json.loads(pathlib.Path(path).read_text())
    ids=set()
    for n in g["nodes"]:
        if set(n)-{"primitive","log"}: raise ValueError("node may persist only primitive+log")
        p=n["primitive"]; nid=p["id"]
        if nid in ids: raise ValueError(f"duplicate node {nid}")
        ids.add(nid)
        if DERIVED & set(p): raise ValueError(f"derived fields persisted in {nid}")
        if DERIVED & set(n["log"]): raise ValueError(f"derived fields persisted in log {nid}")
    rel=g.get("relations",[])
    for e in rel:
        if e["from"] not in ids or e["to"] not in ids: raise ValueError(f"dangling relation {e}")
    return g

def derive(g,cost_history=None):
    deps=defaultdict(list); consumers=defaultdict(list)
    for e in g.get("relations",[]):
        deps[e["to"]].append(e["from"]); consumers[e["from"]].append(e["to"])
    nodes={n["primitive"]["id"]:n for n in g["nodes"]}
    hist=(cost_history or {}).get("events",[])
    bykind=defaultdict(list)
    for x in hist:
        if "node_kind" in x and "cycles" in x and "failed" in x:
            bykind[x["node_kind"]].append(x)
    out={}
    for nid,n in nodes.items():
        p=n["primitive"]; samples=bykind[p["kind"]]
        if len(samples)>=20:
            cycles=sum(x["cycles"] for x in samples)/len(samples)
            pf=sum(1 for x in samples if x["failed"])/len(samples)
            cost=max(cycles*max(pf,0.05),0.05); calibrated=True
        else:
            cost=float(p.get("heuristic_cost",1.0)); calibrated=False
        unlock=max(len(consumers[nid]),1)
        out[nid]={
          "dependencies":sorted(deps[nid]),"consumers":sorted(consumers[nid]),
          "attackable":p["attackability"]==ATTACKABLE,
          "cost":cost,"cost_calibrated":calibrated,
          "downstream_unlock":unlock,"cut_value":cost/unlock
        }
    return out

def active_cut(g,d):
    xs=[(v["cut_value"],nid) for nid,v in d.items() if v["attackable"]]
    return [nid for _,nid in sorted(xs)]

if __name__=="__main__":
    gp=sys.argv[1] if len(sys.argv)>1 else "audit/ATL_GRAPH.json"
    cp=sys.argv[2] if len(sys.argv)>2 else "audit/ATL_COST_HISTORY.json"
    g=load(gp); c=json.loads(pathlib.Path(cp).read_text())
    d=derive(g,c)
    print(json.dumps({"derived":d,"active_cut":active_cut(g,d)},indent=2,sort_keys=True))
