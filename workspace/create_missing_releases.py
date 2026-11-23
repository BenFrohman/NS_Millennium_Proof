import os
import json
import subprocess
from datetime import datetime, timezone, timedelta
from concurrent.futures import ThreadPoolExecutor, as_completed

ENV = os.environ.copy()
CDT = timezone(timedelta(hours=-5))

def iso_to_cdt(iso_str):
    if not iso_str:
        return "Unknown"
    dt = datetime.fromisoformat(iso_str.replace("Z", "+00:00")).astimezone(CDT)
    return dt.strftime("%Y-%m-%d %I:%M:%S %p CDT (UTC-5)")

# Map repositories to their Zenodo DOI (if published) and honest mathematical/technical classification
REPO_RELEASE_META = {
    "NS_Millennium_Proof": {
        "doi": "10.5281/zenodo.23627610",
        "tag": "v1.0.0",
        "status": "Conditional Regularity Theorem (Proved in Lean 4) + Open Unconditional Rate Discharge",
        "summary": "Conditional 3D Incompressible Navier–Stokes Global Regularity & Periodic Clay Statement (B) Reduction via Frohmanian Symplectic Tether (`clay_B_exact_of_periodic_tether_bound` machine-checked in Lean 4; unconditional cubic tether rate `FrohmanianTetherRate` remains open)."
    },
    "Clay-": {
        "doi": "10.5281/zenodo.22240549",
        "tag": "v1.0.0",
        "status": "Proved Conditional Reduction (`ClayStatements.lean`)",
        "summary": "Lean 4 formalization of Fefferman's Periodic Clay Statement (B) on T^3 and the conditional regularity bridge from the Frohmanian Symplectic Tether bound (`clay_B_exact_of_periodic_tether_bound`)."
    },
    "Clay-CD-not-certified": {
        "doi": "10.5281/zenodo.22240549",
        "tag": "v1.0.0",
        "status": "Audit Ledger — Clay Statements (C) & (D) Explicitly Marked Uncertified/Open",
        "summary": "Formal verification audit boundary documenting why Fefferman's Clay Statements (C) and (D) and unconditional rate discharge are not claimed as certified unconditionally."
    },
    "ns-i11-conditional-criterion": {
        "doi": "10.5281/zenodo.23629480",
        "tag": "v1.0.0",
        "status": "Proved Conditional Regularity Criterion (Lean 4)",
        "summary": "Lean 4 formalization of the conditional I_11 vorticity-direction / strain-alignment regularity criterion for 3D incompressible Navier–Stokes."
    },
    "global-from-local-restart": {
        "doi": "10.5281/zenodo.23629482",
        "tag": "v1.0.0",
        "status": "Proved Continuation / Restart Lemma (Lean 4)",
        "summary": "Lean 4 formalization of the Global-from-Local Restart Continuation Theorem for evolutionary PDEs and 3D Navier–Stokes under uniform norm control."
    },
    "HODGE": {
        "doi": "10.5281/zenodo.23627612",
        "tag": "v1.0.0",
        "status": "Lean 4 Formalization of Fourfold Hodge / Motivic Tether Infrastructure",
        "summary": "Lean 4 formalization of fourfold Hodge theory, motivic tether reductions, and algebraic cycle pairings supporting the fourfold Hodge & Tate ledger."
    },
    "HODGE-DISPROOF": {
        "doi": "10.5281/zenodo.23627612",
        "tag": "v1.0.0",
        "status": "Lean 4 Formalization of Integral Torsion Obstructions & Rational Counterexample Candidates",
        "summary": "Lean 4 formalization of Atiyah–Hirzebruch torsion obstructions to the integral Hodge conjecture and rational fourfold candidate analysis."
    },
    "DerivedCategories": {
        "doi": "10.5281/zenodo.23629478",
        "tag": "v1.0.0",
        "status": "Proved Structural Formalization (Lean 4)",
        "summary": "Lean 4 formalization of bounded derived categories of coherent sheaves, semiorthogonal decompositions, and Kuznetsov components."
    },
    "StandardConjectures": {
        "doi": "10.5281/zenodo.23629486",
        "tag": "v1.0.0",
        "status": "Proved Conditional Equivalence & Structural Formalization (Lean 4)",
        "summary": "Lean 4 formalization of Grothendieck's Standard Conjectures (Lefschetz, Künneth, Hodge Index) and their implications for algebraic cycles."
    },
    "NoetherLefschetz": {
        "doi": "10.5281/zenodo.23629488",
        "tag": "v1.0.0",
        "status": "Proved Structural Formalization (Lean 4)",
        "summary": "Lean 4 formalization of Noether–Lefschetz loci, period domain transversality, and special fourfold divisors."
    },
    "AtiyahHirzebruch": {
        "doi": "10.5281/zenodo.23629490",
        "tag": "v1.0.0",
        "status": "Proved Integral Hodge Torsion Obstruction (Lean 4)",
        "summary": "Lean 4 formalization of the Atiyah–Hirzebruch spectral sequence differential d_3 / Steenrod operation obstruction to the integral Hodge conjecture."
    },
    "TateConjecture": {
        "doi": "10.5281/zenodo.23629492",
        "tag": "v1.0.0",
        "status": "Proved Conditional Reduction & Structural Ledger (Lean 4)",
        "summary": "Lean 4 formalization of Galois-invariant étale cohomology classes, cycle class maps, and the Tate conjecture ledger on fourfolds."
    },
    "TateLedger": {
        "doi": "10.5281/zenodo.23629492",
        "tag": "v1.0.0",
        "status": "Proved Arithmetic Fourfold Ledger (Lean 4)",
        "summary": "Lean 4 formalization of the arithmetic Tate ledger and Galois eigenvalue verification on Fermat and special fourfolds."
    },
    "FermatPlanes": {
        "doi": "10.5281/zenodo.23629494",
        "tag": "v1.0.0",
        "status": "Proved Algebraic Cycle Generation Ledger (Lean 4)",
        "summary": "Lean 4 formalization of linear planes and intersection pairings on Fermat fourfolds."
    },
    "FermatQuinticHost": {
        "doi": "10.5281/zenodo.23629496",
        "tag": "v1.0.0",
        "status": "Proved Structural Formalization (Lean 4)",
        "summary": "Lean 4 formalization of the Fermat quintic host geometry, Hodge diamond invariants, and Griffiths residue pairings."
    },
    "FermatQuinticJacobian": {
        "doi": "10.5281/zenodo.23629496",
        "tag": "v1.0.0",
        "status": "Proved Commutative Algebraic Identity (Lean 4)",
        "summary": "Lean 4 formalization of the Jacobian ring, Milnor number, and monomial basis for the Fermat quintic."
    },
    "fourfold-structural-template": {
        "doi": "10.5281/zenodo.23629476",
        "tag": "v1.0.0",
        "status": "Proved Structural Template (Lean 4)",
        "summary": "Reusable Lean 4 structural template for smooth projective fourfold cohomology, intersection pairings, and cycle class verification."
    },
    "SingularityLab": {
        "doi": "10.5281/zenodo.23629498",
        "tag": "v1.0.0",
        "status": "Proved Quasi-Homogeneous Singularity Identities (Lean 4)",
        "summary": "Lean 4 formalization of quasi-homogeneous isolated singularities, Milnor algebras, and FJRW state-space grading."
    },
    "ThreeChainJacobian": {
        "doi": "10.5281/zenodo.23629499",
        "tag": "v1.0.0",
        "status": "Proved Three-Variable Chain Jacobian Basis (Lean 4)",
        "summary": "Lean 4 formalization of the Jacobian ring and monomial basis for three-variable invertible chain polynomials."
    },
    "OmegaZero34": {
        "doi": "10.5281/zenodo.23627616",
        "tag": "v1.0.0",
        "status": "Proved Selection Rule & Degree Identity (Lean 4)",
        "summary": "Lean 4 formalization of the OmegaZero34 FJRW moduli degree and selection rule identities."
    },
    "collatz-teaming-lemma": {
        "doi": "10.5281/zenodo.23627620",
        "tag": "v1.0.0",
        "status": "Proved 2-Adic Valuation & Teaming Lemma (Lean 4)",
        "summary": "Lean 4 formalization of the Collatz Teaming Lemma and exact 2-adic valuation pairing identities for Syracuse trajectories."
    },
    "collatz-terras-density": {
        "doi": "10.5281/zenodo.23629465",
        "tag": "v1.0.0",
        "status": "Proved Terras Cylinder Density & Stopping-Time Bounds (Lean 4)",
        "summary": "Lean 4 formalization of Terras parity vectors, cylinder sets, and stopping-time density bounds for the Collatz map."
    },
    "3n-plus-c-cycle-census": {
        "doi": "10.5281/zenodo.23629468",
        "tag": "v1.0.0",
        "status": "Proved Exact Cycle Census & Rational Denominator Bounds (Lean 4)",
        "summary": "Lean 4 formalization and verified computational census of periodic cycles for generalized 3n + c maps."
    },
    "p2q-jumps-lean": {
        "doi": "10.5281/zenodo.23629470",
        "tag": "v1.0.0",
        "status": "Proved Prime-Power Jump Bounds (Lean 4)",
        "summary": "Lean 4 formalization of p^2 q multiplicative jump identities and arithmetic valuation bounds."
    },
    "bohm-identities": {
        "doi": "10.5281/zenodo.23629484",
        "tag": "v1.0.0",
        "status": "Proved Quantum Potential & Madelung Hydrodynamic Identities (Lean 4)",
        "summary": "Lean 4 formalization of exact algebraic and differential identities for the Bohmian quantum potential and Madelung fluid equations."
    },
    "hlex-latent-exchange-fabric": {
        "doi": "10.5281/zenodo.23629472",
        "tag": "v1.0.0",
        "status": "Proprietary Prior-Art Specification & Reference Architecture (Restricted Zenodo DOI)",
        "summary": "HLEX: Holographic Latent Exchange & Zero-Copy Cross-Model Tensor Fabric (Proprietary / All Rights Reserved; Zenodo DOI: 10.5281/zenodo.23629472)."
    },
    "symplectohydronamics": {
        "doi": "10.5281/zenodo.22240549",
        "tag": "v1.0.0",
        "status": "Master Symplectohydrodynamics, SealGuard & Modular Robotics Provenance Repository",
        "summary": "Primary research portfolio and provenance ledger recording the Frohmanian Symplectic Tether, SealGuard (2026-08-22 12:49:03 PM CDT), and Modular Rotating Ball-Joint Robotic Excitation Arms (2026-08-22 12:49:03 PM CDT)."
    }
}

def create_release_for_repo(item):
    repo, meta = item
    tag = meta["tag"]
    # Check if release already exists
    chk = subprocess.run(["gh", "release", "view", tag, "--repo", f"BenFrohman/{repo}"], env=ENV, capture_output=True, text=True)
    if chk.returncode == 0:
        return repo, "already_exists", tag

    # Get repo creation date and latest commit on default branch
    r_info = subprocess.run(["gh", "api", f"repos/BenFrohman/{repo}"], env=ENV, capture_output=True, text=True)
    if r_info.returncode != 0:
        return repo, "repo_error", r_info.stderr.strip()
    rdata = json.loads(r_info.stdout)
    default_branch = rdata.get("default_branch", "main")
    created_cdt = iso_to_cdt(rdata.get("created_at"))

    c_info = subprocess.run(["gh", "api", f"repos/BenFrohman/{repo}/commits/{default_branch}"], env=ENV, capture_output=True, text=True)
    commit_sha = "HEAD"
    commit_date_cdt = created_cdt
    if c_info.returncode == 0:
        cdata = json.loads(c_info.stdout)
        commit_sha = cdata.get("sha", "HEAD")
        commit_date_cdt = iso_to_cdt(cdata.get("commit", {}).get("committer", {}).get("date"))

    doi = meta["doi"]
    notes = (
        f"### {repo} — Official Priority & Provenance Release (`{tag}`)\n\n"
        f"- **Author:** Benjamin Stanley Frohman (`ORCID: 0009-0006-7068-3718`)\n"
        f"- **Permanent DataCite Zenodo DOI:** [`{doi}`](https://doi.org/{doi})\n"
        f"- **Verification / Claim Status:** {meta['status']}\n"
        f"- **Repository Created (`America/Chicago`, CDT / UTC-5):** `{created_cdt}`\n"
        f"- **Release Commit SHA (`{default_branch}`):** `{commit_sha}` (`{commit_date_cdt}`)\n\n"
        f"#### Summary\n{meta['summary']}\n"
    )
    res = subprocess.run([
        "gh", "release", "create", tag,
        "--repo", f"BenFrohman/{repo}",
        "--target", default_branch,
        "--title", f"{tag} — Priority & Provenance Release (DOI: {doi})",
        "--notes", notes
    ], env=ENV, capture_output=True, text=True)
    if res.returncode != 0:
        return repo, "error", res.stderr.strip()
    return repo, "created", res.stdout.strip()

print("Creating missing priority GitHub Releases across 27 repositories...")
with ThreadPoolExecutor(max_workers=6) as ex:
    futs = [ex.submit(create_release_for_repo, it) for it in REPO_RELEASE_META.items()]
    for f in as_completed(futs):
        repo, status, info = f.result()
        print(f"{repo}: {status} -> {info}")
