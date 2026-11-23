#!/usr/bin/env python3
"""Poll header PRs and merge when all checks pass. Never --admin."""
import json, pathlib, subprocess, time, datetime, sys

SCAN = pathlib.Path("/workspace/lean-header-20261116/scan")
PRS = {
    "Clay-": "12",
    "Clay-CD-not-certified": "5",
    "DHL-3-2-implies-liminf-prime-gap-le-6": "4",
    "DerivedCategories": "3",
    "FermatPlanes": "2",
    "FermatQuinticHost": "3",
    "FermatQuinticJacobian": "4",
    "HodgeDisproof": "2",
    "NoetherLefschetz": "6",
    "OmegaZero34": "5",
    "StandardConjectures": "5",
    "TateConjecture": "4",
    "bohm-identities": "3",
    "collatz-covering-claim": "2",
    "frohmanian-metriplectic-ns": "3",
    "frohmanian-tether-manuscript-2026-06-01": "4",
    "global-from-local-restart": "3",
    "mk1-kernel-limits": "2",
    "mk1-quantum-kernel": "1",
    "orlov-equivalence-VF": "2",
    "symplectohydronamics": "1",
    "uniruled-fourfolds": "1",
}

OK_CONCLUSIONS = {None, "", "SUCCESS", "SKIPPED", "NEUTRAL", "ACTION_REQUIRED"}  # ACTION_REQUIRED is not ok actually
# ACTION_REQUIRED should not be treated as success
OK_CONCLUSIONS = {None, "", "SUCCESS", "SKIPPED", "NEUTRAL"}

def gh_json(args):
    r = subprocess.run(["gh"] + args, capture_output=True, text=True)
    if r.returncode != 0:
        return None, r.stderr.strip()
    return json.loads(r.stdout) if r.stdout.strip() else None, r.stderr.strip()

def classify(pr):
    if not pr:
        return "error", "no pr json"
    if pr.get("state") == "MERGED":
        return "merged", pr.get("mergeCommit", {}).get("oid")
    if pr.get("state") != "OPEN":
        return "closed", pr.get("state")
    checks = pr.get("statusCheckRollup") or []
    pending = []
    failed = []
    passed = []
    for ch in checks:
        name = ch.get("name") or ch.get("context") or "?"
        status = (ch.get("status") or ch.get("state") or "").upper()
        conclusion = (ch.get("conclusion") or "").upper()
        # GitHub check run uses status IN_PROGRESS/QUEUED/COMPLETED and conclusion
        if status in {"IN_PROGRESS", "QUEUED", "PENDING", "EXPECTED", "WAITING"} or (status == "" and not conclusion):
            pending.append(name)
        elif conclusion not in {"SUCCESS", "SKIPPED", "NEUTRAL"} or status in {"FAILURE", "ERROR"}:
            # some rollups use state FAILURE
            if status in {"SUCCESS", "SKIPPED", "NEUTRAL"} and not conclusion:
                passed.append(name)
            else:
                failed.append((name, status, conclusion))
        else:
            passed.append(name)
    review = pr.get("reviewDecision")
    merge_state = pr.get("mergeStateStatus")
    if failed:
        return "failed", {"failed": failed, "pending": pending, "review": review, "merge": merge_state}
    if pending:
        return "pending", {"pending": pending, "review": review, "merge": merge_state, "passed": len(passed)}
    if review == "REVIEW_REQUIRED" or merge_state == "BLOCKED":
        return "blocked", {"review": review, "merge": merge_state, "passed": len(passed)}
    if pr.get("mergeable") == "CONFLICTING" or merge_state == "DIRTY":
        return "conflict", {"review": review, "merge": merge_state}
    if merge_state in {"CLEAN", "UNSTABLE", "HAS_HOOKS", "UNKNOWN", None} or pr.get("mergeable") == "MERGEABLE":
        # UNSTABLE can mean some non-required failed; we already require all checks green
        return "ready", {"review": review, "merge": merge_state, "passed": len(passed)}
    return "wait", {"review": review, "merge": merge_state, "passed": len(passed)}

def snapshot():
    rows = []
    for repo, num in PRS.items():
        pr, err = gh_json([
            "pr", "view", num, "--repo", f"BenFrohman/{repo}",
            "--json", "number,url,state,mergeable,mergeStateStatus,statusCheckRollup,reviewDecision,mergeCommit,headRefOid,title"
        ])
        if pr is None:
            rows.append({"repo": repo, "pr": num, "class": "error", "detail": err})
            continue
        cls, detail = classify(pr)
        rec = {
            "repo": repo,
            "pr": num,
            "url": pr.get("url"),
            "state": pr.get("state"),
            "class": cls,
            "detail": detail,
            "head": pr.get("headRefOid"),
            "mergeCommit": (pr.get("mergeCommit") or {}).get("oid"),
        }
        rows.append(rec)
    return rows

def maybe_merge(rec):
    if rec["class"] != "ready":
        return rec
    repo, num = rec["repo"], rec["pr"]
    r = subprocess.run(
        ["gh", "pr", "merge", num, "--repo", f"BenFrohman/{repo}", "--merge"],
        capture_output=True, text=True,
    )
    rec["merge_attempt"] = {
        "rc": r.returncode,
        "stdout": r.stdout.strip(),
        "stderr": r.stderr.strip(),
    }
    if r.returncode == 0:
        rec["class"] = "merged_now"
        # refresh merge commit
        pr, _ = gh_json(["pr", "view", num, "--repo", f"BenFrohman/{repo}", "--json", "state,mergeCommit,mergedAt"])
        if pr:
            rec["state"] = pr.get("state")
            rec["mergeCommit"] = (pr.get("mergeCommit") or {}).get("oid")
            rec["mergedAt"] = pr.get("mergedAt")
    else:
        rec["class"] = "merge_failed"
    return rec

def main():
    rounds = int(sys.argv[1]) if len(sys.argv) > 1 else 1
    sleep_s = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    all_rows = []
    for i in range(rounds):
        now = datetime.datetime.now().isoformat(timespec="seconds")
        rows = snapshot()
        for rec in rows:
            rec = maybe_merge(rec)
            print(f"[{now}] {rec['repo']}: {rec['class']} {rec.get('detail') if rec['class'] not in {'merged','merged_now'} else rec.get('mergeCommit')}", flush=True)
        (SCAN / "pr-poll.json").write_text(json.dumps({"at": now, "rows": rows}, indent=2, default=str))
        all_rows = rows
        classes = {r["class"] for r in rows}
        unfinished = [r for r in rows if r["class"] in {"pending", "wait", "ready"}]
        if not unfinished:
            print("no pending/ready left", flush=True)
            break
        if i < rounds - 1 and sleep_s:
            time.sleep(sleep_s)
    # summary
    from collections import Counter
    print("SUMMARY", Counter(r["class"] for r in all_rows))

if __name__ == "__main__":
    main()
