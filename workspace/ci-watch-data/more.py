import subprocess,re,json
targets=[("RCW-Version15-Certificates",44892924511,r"no such file|lake|manifest|error",12),
("NS_Tether_Alternatives",44893346473,r"axiom|native_decide|sorry|admit|:\d+:",15),
("HODGE-DISPROOF",44209234950,r"axiom|native_decide|sorry|admit|:\d+:",15),
("TFFrohmanianTether",44893346762,r"header|Copyright|missing|\.lean",15),
("frohmanian-symplectic-tether-regularity",44061122441,r"VERDICT|FAIL|lock|cover|sentence|P[0-9]",12),
("frohmanian-symplectic-tether",44060183284,r"VERDICT|FAIL|lock|cover|sentence|routeA",12),
("frohmanian-symplectic-tether-may-form",44057750265,r"VERDICT|FAIL|lock|cover|sentence|routeA",12),
("frohmanian-tether-manuscript-2026-06-01",44055113647,r"VERDICT|FAIL|lock|cover|sentence|thm:",12)]
skip=re.compile(r"DeprecationWarning|punycode|url.parse|git config|##\[group|##\[endgroup|Downloading|^\s*$")
for repo,rid,pat,n in targets:
    p=subprocess.run(["gh","run","view",str(rid),"-R","BenFrohman/"+repo,"--log-failed"],capture_output=True,text=True,timeout=90)
    lines=[re.sub(r"^\d{4}-\d{2}-\d{2}T\S+Z ?","",l.split("\t")[-1]) for l in p.stdout.splitlines()]
    hits=[l for l in lines if re.search(pat,l,re.I) and not skip.search(l) and "echo" not in l and "[36;1m" not in l]
    print("=====",repo); 
    for l in hits[-n:]: print("  ",l[:260])
p=subprocess.run(["gh","api","repos/BenFrohman/Test-Practice-Repo/actions/runs/45092634031","--jq","{name,path,event,conclusion,display_title}"],capture_output=True,text=True)
print("===== Test-Practice", p.stdout, p.stderr[:300])
p=subprocess.run(["gh","api","repos/BenFrohman/periodic-ns-classical-continuation/actions/runs/43975052852","--jq","{conclusion,status}"],capture_output=True,text=True)
print("===== periodic 43975052852", p.stdout)
