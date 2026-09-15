#!/usr/bin/env python3
import argparse, json
CLASSES=['A1_amplitude','A2_self_reference','A3_zero_path','A4_scale','homogeneity','division_by_zero','missing_cases','circularity','normalization','positivity_zero','barrier','limit_compactness_uniformity','spec_quantifiers','axiom_creep','numerical_promotion','dependency_frontier']
def main():
 p=argparse.ArgumentParser(); p.add_argument('--target',required=True); p.add_argument('--output',required=True); a=p.parse_args()
 gaps=[{'id':x,'disposition':'REVIEW_REQUIRED','formal_proof':False} for x in CLASSES]
 out={'target':a.target,'automatic_promotion':False,'predicted_gaps':gaps,'rule':'predictor classifications are obligations, never proofs'}
 with open(a.output,'w') as f: json.dump(out,f,indent=2,sort_keys=True)
 print(json.dumps(out,sort_keys=True))
if __name__=='__main__': main()
