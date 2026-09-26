#!/usr/bin/env python3
import json, pathlib, sys, re
ROOT=pathlib.Path(__file__).resolve().parents[1]
GRAPH=ROOT/"audit/ATL_GRAPH.json"; COST=ROOT/"audit/ATL_COST_HISTORY.json"
CLASSES={"TYPE","BUILD","AXIOM","SEMANTIC","OPEN_MATH"}
FORBIDDEN_TOKENS=(r"\bsorry\b",r"\badmit\b",r"\baxiom\b")
def load():
 g=json.loads(GRAPH.read_text()); c=json.loads(COST.read_text())
 if g.get("schema")!="atl.graph.v3": raise ValueError("wrong graph schema")
 forbidden=set(g["node_schema"]["derived"]); nodes={}
 for n in g["nodes"]:
  if set(n)!={"primitive","log"}: raise ValueError("node must contain only primitive+log")
  leak=forbidden & set(n)
  if leak: raise ValueError(f"derived-state leak {n['primitive']['id']}: {sorted(leak)}")
  k=n["primitive"]["id"]
  if k in nodes: raise ValueError(f"duplicate node {k}")
  nodes[k]=n
 allowed=set(g.get("edge_schema",{}).get("kinds",[]))
 for e in g.get("edges",[]):
  if e["from"] not in nodes or e["to"] not in nodes: raise ValueError(f"dangling edge {e}")
  if e["kind"] not in allowed: raise ValueError(f"unknown edge kind {e['kind']}")
 return g,c
def dag(g):
 ids=[n["primitive"]["id"] for n in g["nodes"]]
 deps={k:[] for k in ids}; consumers={k:[] for k in ids}; replacement={k:[] for k in ids}
 for e in g.get("edges",[]):
  if e["kind"]=="depends_on":
   deps[e["to"]].append(e["from"]); consumers[e["from"]].append(e["to"])
  elif e["kind"]=="reuses":
   deps[e["to"]].append(e["from"]); consumers[e["from"]].append(e["to"])
  elif e["kind"]=="replacement_step": replacement[e["to"]].append(e["from"])
 state={}
 def visit(k):
  if state.get(k)==1: raise ValueError(f"cycle at {k}")
  if state.get(k)==2:return
  state[k]=1
  for d in deps[k]: visit(d)
  state[k]=2
 for k in ids: visit(k)
 return deps,consumers,replacement
def reachable(consumers,start):
 seen=set(); stack=list(consumers[start])
 while stack:
  x=stack.pop()
  if x in seen: continue
  seen.add(x); stack.extend(consumers[x])
 return seen
def derived(g,c):
 nodes={n["primitive"]["id"]:n for n in g["nodes"]}
 deps,consumers,replacement=dag(g); samples=c.get("events",[]); out={}
 for k,n in nodes.items():
  p=n["primitive"]; ev=n["log"].get("evidence",[]); cls=p["attackability"]
  ce=[x for x in samples if x.get("node_id")==k]
  cost=(sum(x.get("cycles",1)*x.get("failure_probability",1.0) for x in ce)/len(ce)) if ce else 1.0
  unlock=1.0+sum(1.0/(1+len(deps[x])) for x in reachable(consumers,k))
  out[k]={"dependencies":sorted(set(deps[k])),"consumers":sorted(set(consumers[k])),
   "replacement_route":replacement[k],"classification":cls,
   "certificate_state":"REUSED" if cls=="CLOSED_REUSE" and ev else "UNISSUED",
   "cost_estimate":cost,"cost_calibrated":len(ce)>=20,
   "downstream_unlock":unlock,"cut_value":cost/unlock}
 return out
def active_cut(d):
 return [k for _,k in sorted((v["cut_value"],k) for k,v in d.items() if v["classification"]=="OPEN_MATH_ATTACKABLE")]
def firewall_source(g):
 errors=[]
 for n in g["nodes"]:
  p=n["primitive"]; nid=p["id"]
  for rel in p.get("source_files",[]):
   fp=ROOT/rel
   if not fp.exists():
    # Frozen/reused sources may live only on their certified ref.
    if p["attackability"]!="CLOSED_REUSE": errors.append({"class":"BUILD","node":nid,"detail":f"missing source {rel}","depth":0})
    continue
   s=fp.read_text(errors="replace")
   for tok in FORBIDDEN_TOKENS:
    if re.search(tok,s) and p["kind"]=="scientific_producer":
     errors.append({"class":"AXIOM","node":nid,"detail":f"forbidden token pattern {tok} in {rel}","depth":0})
  fs=p.get("formal_statement","")
  if fs.strip() in {"True","Prop := True"}: errors.append({"class":"SEMANTIC","node":nid,"detail":"trivial formal statement","depth":0})
  if p.get("kind")=="scientific_producer" and not p.get("semantic_statement","").strip():
   errors.append({"class":"SEMANTIC","node":nid,"detail":"missing semantic statement","depth":0})
 return errors
def gate(errors):
 es=[e for e in errors if e.get("class") in CLASSES]
 m=min((e.get("depth",0) for e in es),default=None)
 return {"independent_errors":es,"canonical":[e for e in es if e.get("depth",0)==m] if m is not None else []}
if __name__=="__main__":
 g,c=load(); d=derived(g,c); fw=firewall_source(g); gr=gate(fw)
 print(json.dumps({"derived":d,"active_cut":active_cut(d),"firewall":gr},indent=2,sort_keys=True))
 if gr["canonical"]: sys.exit(2)
