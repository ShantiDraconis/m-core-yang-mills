#!/usr/bin/env python3
import argparse, json

CLASSES = [
 "A1_amplitude","A2_self_reference","A3_zero_path","A4_scale","homogeneity_degree",
 "division_domain","limit_interchange","missing_cases","circularity","normalization_positivity",
 "compactness_uniformity","spec_quantifiers","axiom_creep","numerical_symbolic_promotion",
 "dependency_closure","cross_audit_equivalence"
]

def audit(target: str):
    gaps=[]
    for cid in CLASSES:
        disposition = "OPEN_BRIDGE" if cid in {"homogeneity_degree","division_domain","dependency_closure"} else "REVIEW_REQUIRED"
        gaps.append({"id":cid,"disposition":disposition,"certNode_status":"openBridge","formal_proof":False})
    return {"target":target,"schema":"K3-G8-v1","allowed_dispositions":["PASS_CERTIFIED","OPEN_BRIDGE","REFUTED_ROUTE","REVIEW_REQUIRED"],"predicted_gaps":gaps,"automatic_promotion":False,"action":"record openBridge/frontier or review; never synthesize proof"}

if __name__ == '__main__':
    p=argparse.ArgumentParser(); p.add_argument('--target',default='MCore.K3'); p.add_argument('--output')
    a=p.parse_args(); data=audit(a.target); text=json.dumps(data,indent=2,sort_keys=True)
    if a.output:
        open(a.output,'w',encoding='utf-8').write(text+'\n')
    else: print(text)
