#!/usr/bin/env python3
import json, pathlib, sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
GRAPH=ROOT/"audit/ATL_GRAPH.json"; COST=ROOT/"audit/ATL_COST_HISTORY.json"
CLASSES={"TYPE","BUILD","AXIOM","SEMANTIC","OPEN_MATH"}
def load():
 g=json.loads(GRAPH.read_text()); c=json.loads(COST.read_text())
 assert g["schema"]=="atl.graph.v3"
 forbidden=set(g["node_schema"]["derived"])
 for n in g["nodes"]:
  leak=forbidden & set(n)
  if leak: raise ValueError(f"derived-state leak {n['primitive']['id']}: {sorted(leak)}")
  assert set(n)=={"primitive","log"}
 return g,c
def derived(g,c):
 nodes={n["primitive"]["id"]:n for n in g["nodes"]}
 # Edges are provenance/reuse metadata until explicit graph edges are added.
 deps={k:[] for k in nodes}; consumers={k:[] for k in nodes}
 samples=c.get("events",[])
 out={}
 for k,n in nodes.items():
  p=n["primitive"]; ev=n["log"].get("evidence",[])
  cls=p["attackability"]
  cost_ev=[x for x in samples if x.get("node_id")==k]
  cost=(sum(x.get("cycles",1)*x.get("failure_probability",1.0) for x in cost_ev)/len(cost_ev)) if cost_ev else 1.0
  unlock=max(1,len(consumers[k]))
  out[k]={"dependencies":deps[k],"consumers":consumers[k],
          "replacement_route":[],"classification":cls,
          "certificate_state":"REUSED" if cls=="CLOSED_REUSE" and ev else "UNISSUED",
          "cost_estimate":cost,"cost_calibrated":len(cost_ev)>=20,
          "downstream_unlock":unlock,"cut_value":cost/unlock}
 return out
def active_cut(d):
 xs=[(v["cut_value"],k) for k,v in d.items() if v["classification"]=="OPEN_MATH_ATTACKABLE"]
 return [k for _,k in sorted(xs)]
def gate(errors):
 es=[e for e in errors if e.get("class") in CLASSES]
 # canonical = minimal declared DAG depth; ties retained.
 m=min((e.get("depth",0) for e in es),default=None)
 return {"independent_errors":es,"canonical":[e for e in es if e.get("depth",0)==m] if m is not None else []}
if __name__=="__main__":
 g,c=load(); d=derived(g,c)
 print(json.dumps({"derived":d,"active_cut":active_cut(d)},indent=2,sort_keys=True))
