import os
import json
import subprocess
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed

ENV = os.environ.copy()

# 1. Define comprehensive GitHub repository topics (Clay Millennium Problem & Frontier Math/Physics/IP)
REPO_TOPICS = {
    # Navier-Stokes Millennium Problem (Conditional Regularity, Periodic Clay Statement B, & Obstructions)
    "NS_Millennium_Proof": [
        "clay-millennium-problem", "navier-stokes", "fefferman-clay-problem-b",
        "conditional-regularity", "symplectic-geometry", "lean4", "formal-verification",
        "beale-kato-majda", "fluid-dynamics", "millennium-prize-problems"
    ],
    "frohmanian-ns-symplectic-tether": [
        "clay-millennium-problem", "navier-stokes", "fefferman-clay-problem-b",
        "symplectic-tether", "conditional-regularity", "lean4", "formal-verification",
        "periodic-navier-stokes", "vorticity-stretching", "beale-kato-majda"
    ],
    "two-point-strain-coercivity": [
        "clay-millennium-problem", "navier-stokes", "strain-coercivity",
        "vorticity-alignment", "counterexample", "lean4", "formal-verification",
        "fluid-dynamics", "obstruction-analysis"
    ],
    "ns-i11-conditional-criterion": [
        "clay-millennium-problem", "navier-stokes", "conditional-regularity",
        "vorticity-direction", "constantin-fefferman", "lean4", "formal-verification",
        "sobolev-regularity"
    ],
    "global-from-local-restart": [
        "clay-millennium-problem", "navier-stokes", "global-regularity",
        "local-well-posedness", "restart-lemma", "lean4", "formal-verification",
        "pde-analysis"
    ],
    "Clay-": [
        "clay-millennium-problem", "navier-stokes", "fefferman-clay-problem-b",
        "lean4", "formal-verification", "conditional-regularity", "symplectic-tether"
    ],
    "Clay-CD-not-certified": [
        "clay-millennium-problem", "navier-stokes", "fefferman-clay-problem-c",
        "fefferman-clay-problem-d", "lean4", "formal-verification", "unconditional-status-open"
    ],

    # Hodge Conjecture & Algebraic/Arithmetic Fourfold Programme
    "HodgeDisproof": [
        "clay-millennium-problem", "hodge-conjecture", "algebraic-cycles",
        "integral-hodge-conjecture", "atiyah-hirzebruch", "lean4", "formal-verification",
        "algebraic-geometry", "hodge-theory", "millennium-prize-problems"
    ],
    "HODGE": [
        "clay-millennium-problem", "hodge-conjecture", "algebraic-cycles",
        "hodge-theory", "lean4", "formal-verification", "algebraic-geometry"
    ],
    "HODGE-DISPROOF": [
        "clay-millennium-problem", "hodge-conjecture", "integral-hodge-conjecture",
        "torsion-cycles", "lean4", "formal-verification", "algebraic-geometry"
    ],
    "CubicFourfold": [
        "clay-millennium-problem", "hodge-conjecture", "cubic-fourfold",
        "kuznetsov-component", "noether-lefschetz", "hassett-divisors",
        "lean4", "formal-verification", "algebraic-geometry"
    ],
    "uniruled-fourfolds": [
        "clay-millennium-problem", "hodge-conjecture", "uniruled-fourfolds",
        "integral-hodge-conjecture", "tate-conjecture", "lean4", "formal-verification",
        "algebraic-geometry", "arithmetic-geometry"
    ],
    "motivic-tether": [
        "clay-millennium-problem", "hodge-conjecture", "tate-conjecture",
        "motivic-cohomology", "algebraic-cycles", "lean4", "formal-verification",
        "arithmetic-geometry"
    ],
    "DerivedCategories": [
        "clay-millennium-problem", "hodge-conjecture", "derived-categories",
        "orlov-equivalence", "kuznetsov-component", "lean4", "formal-verification",
        "algebraic-geometry"
    ],
    "orlov-equivalence-VF": [
        "clay-millennium-problem", "hodge-conjecture", "orlov-equivalence",
        "derived-categories", "matrix-factorizations", "lean4", "formal-verification",
        "algebraic-geometry"
    ],
    "StandardConjectures": [
        "clay-millennium-problem", "hodge-conjecture", "grothendieck-standard-conjectures",
        "lefschetz-standard-conjecture", "hodge-index-theorem", "lean4",
        "formal-verification", "algebraic-geometry"
    ],
    "NoetherLefschetz": [
        "clay-millennium-problem", "hodge-conjecture", "noether-lefschetz",
        "hodge-loci", "period-domains", "lean4", "formal-verification", "algebraic-geometry"
    ],
    "AtiyahHirzebruch": [
        "clay-millennium-problem", "hodge-conjecture", "atiyah-hirzebruch",
        "integral-hodge-conjecture", "steenrod-operations", "torsion-obstruction",
        "lean4", "formal-verification", "algebraic-topology"
    ],
    "TateConjecture": [
        "clay-millennium-problem", "hodge-conjecture", "tate-conjecture",
        "galois-representations", "etale-cohomology", "lean4", "formal-verification",
        "arithmetic-geometry"
    ],
    "TateLedger": [
        "clay-millennium-problem", "hodge-conjecture", "tate-conjecture",
        "fermat-fourfolds", "etale-cohomology", "lean4", "formal-verification",
        "arithmetic-geometry"
    ],
    "FermatPlanes": [
        "clay-millennium-problem", "hodge-conjecture", "fermat-hypersurfaces",
        "linear-cycles", "algebraic-cycles", "lean4", "formal-verification", "algebraic-geometry"
    ],
    "FermatQuinticHost": [
        "clay-millennium-problem", "hodge-conjecture", "fermat-quintic",
        "calabi-yau", "hodge-theory", "lean4", "formal-verification", "algebraic-geometry"
    ],
    "FermatQuinticJacobian": [
        "clay-millennium-problem", "hodge-conjecture", "fermat-quintic",
        "jacobian-ring", "griffiths-residue", "lean4", "formal-verification", "algebraic-geometry"
    ],
    "fourfold-structural-template": [
        "clay-millennium-problem", "hodge-conjecture", "fourfolds",
        "intersection-pairing", "lean4", "formal-verification", "algebraic-geometry"
    ],

    # Chain Atom / FJRW / Jacobian Ring Formalizations
    "ChainAtom-u5v-v6": [
        "singularity-theory", "fjrw-theory", "jacobian-ring", "chain-polynomials",
        "milnor-number", "lean4", "formal-verification", "landau-ginzburg"
    ],
    "SingularityLab": [
        "singularity-theory", "fjrw-theory", "milnor-algebra", "quasi-homogeneous-singularities",
        "lean4", "formal-verification", "algebraic-geometry"
    ],
    "ThreeChainJacobian": [
        "singularity-theory", "jacobian-ring", "three-chain-singularity",
        "milnor-basis", "lean4", "formal-verification", "commutative-algebra"
    ],
    "Frohman-MixedCorrelators-FJ": [
        "fjrw-theory", "witten-equation", "selection-rules", "mixed-correlators",
        "lean4", "formal-verification", "mathematical-physics"
    ],
    "OmegaZero34": [
        "singularity-theory", "fjrw-theory", "moduli-of-curves", "cohomological-field-theory",
        "lean4", "formal-verification"
    ],

    # Collatz & Arithmetic Dynamics
    "collatz-teaming-lemma": [
        "collatz-conjecture", "syracuse-dynamics", "2-adic-analysis", "arithmetic-dynamics",
        "lean4", "formal-verification", "number-theory"
    ],
    "collatz-terras-density": [
        "collatz-conjecture", "terras-theorem", "stopping-time-density", "arithmetic-dynamics",
        "lean4", "formal-verification", "number-theory"
    ],
    "3n-plus-c-cycle-census": [
        "collatz-conjecture", "3n-plus-c", "cycle-census", "arithmetic-dynamics",
        "lean4", "formal-verification", "number-theory"
    ],
    "p2q-jumps-lean": [
        "number-theory", "diophantine-analysis", "prime-powers", "lean4", "formal-verification"
    ],
    "bohm-identities": [
        "mathematical-physics", "bohmian-mechanics", "quantum-hydrodynamics",
        "madelung-transform", "lean4", "formal-verification"
    ],

    # Proprietary Systems, Security & Symplectohydrodynamics
    "symplectohydronamics": [
        "symplectohydrodynamics", "navier-stokes", "sealguard", "robotics",
        "lean4", "formal-verification", "fluid-dynamics", "research-portfolio"
    ],
    "Research-Center": [
        "research-portfolio", "clay-millennium-problem", "lean4", "formal-verification",
        "navier-stokes", "hodge-conjecture", "fjrw-theory", "collatz-conjecture"
    ],
    "FrohmanResearch": [
        "research-portfolio", "clay-millennium-problem", "lean4", "formal-verification",
        "mathematical-physics", "algebraic-geometry"
    ]
}

def apply_topics(item):
    repo, topics = item
    cmd = ["gh", "repo", "edit", f"BenFrohman/{repo}"]
    for t in topics:
        cmd.extend(["--add-topic", t])
    res = subprocess.run(cmd, env=ENV, capture_output=True, text=True)
    return repo, res.returncode, res.stderr.strip()

print("Applying GitHub repository topics across Clay & frontier repositories...")
with ThreadPoolExecutor(max_workers=6) as ex:
    futs = [ex.submit(apply_topics, it) for it in REPO_TOPICS.items()]
    for f in as_completed(futs):
        repo, rc, err = f.result()
        if rc != 0:
            print(f"Topic error on {repo}: {err}")
        else:
            print(f"Topics updated: {repo} ({len(REPO_TOPICS[repo])} topics)")
