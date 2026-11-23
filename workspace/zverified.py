import os,requests,json
T=os.environ['ZENODO_ACCESS_TOKEN'];A='https://zenodo.org/api/deposit/depositions';P={'access_token':T}
desc="""<p>We audit the claims of the technical compilation <em>The Frohmanian Symplectic Tether: Architecture, Reduced Jacobi Identity, and the Frohmanian Curve</em> (Zenodo record 23942466) against a Lean 4/Mathlib formalization. Every claim is classified as proved, conditional (proved under explicitly stated hypotheses), refuted (its negation is machine-checked), or not formalized.</p>
<p>The library builds without sorry, and the 37 key theorems depend only on the standard axioms propext, Classical.choice, and Quot.sound. Proved results include locality and nonpositive self-pairing (C1/C3) and exact degeneracy on kinetic energy (C2).</p>
<p>The compilation's claims of Jacobi vanishing on the reduced orbit and of energy-budget damping are refuted. Its Clay-standard global regularity claim is not established: it holds only conditionally on open hypotheses. The Frohmanian Curve and the Section 5 representations are not formalized. This paper makes no Millennium Prize claim.</p>
<p>Code: https://github.com/BenFrohman/frohmanian-tether-verified (commit 26f16da).</p>"""
md={'upload_type':'publication','publication_type':'preprint','title':'The Frohmanian Tether: A Machine-Checked Audit of Its Architecture and Obstructions',
'creators':[{'name':'Frohman, Benjamin Stanley','orcid':'0009-0006-7068-3718','affiliation':'Independent Researcher'}],
'description':desc,'keywords':['Lean 4','Mathlib','formal verification','Navier-Stokes','metriplectic','Poisson bracket','Jacobi identity','Frohmanian Tether'],
'license':'apache-2.0','access_right':'open',
'related_identifiers':[{'identifier':'https://github.com/BenFrohman/frohmanian-tether-verified','relation':'isSupplementedBy','resource_type':'software'},
{'identifier':'10.5281/zenodo.23956935','relation':'references'}]}
r=requests.post(A,params=P,json={'metadata':md});print(r.status_code);d=r.json()
if r.status_code>=300: print(r.text);raise SystemExit
i=d['id'];b=d['links']['bucket']
with open('frohmanian-tether-verified/paper/frohmanian-tether-verified.pdf','rb') as f:
  print(requests.put(b+'/frohmanian-tether-verified.pdf',params=P,data=f).status_code)
d=requests.get(f'{A}/{i}',params=P).json();m=d['metadata']
print(i,d['state'],d['submitted'],m.get('prereserve_doi'),m.get('license'),m['title'],m['related_identifiers'],[(x['filename'],x['filesize']) for x in d['files']])
