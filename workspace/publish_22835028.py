import os
import json
import shutil
import subprocess
import urllib.request
import urllib.error
from pathlib import Path

from update_zenodo_provenance import PROVENANCE_LEDGER_HTML, CANONICAL_NS_DOIS, ORIGIN_URLS

TOKEN = os.environ["ZENODO_ACCESS_TOKEN"]
REC_ID = 22835028
PKG_DIR = Path("/workspace/zenodo_22835028_package")
PKG_DIR.mkdir(parents=True, exist_ok=True)
TECTONIC = "/home/box/.local/bin/tectonic"

COVER_TEX = r"""% Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
% Released under the Apache License, Version 2.0 (SPDX: Apache-2.0).
% Author: Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718)
\documentclass[11pt,a4paper]{article}
\usepackage[margin=1in]{geometry}
\usepackage{amsmath,amssymb,amsthm,mathtools}
\usepackage{microtype}
\usepackage[T1]{fontenc}
\usepackage{lmodern}
\usepackage{enumitem}
\usepackage[hidelinks]{hyperref}

\newtheorem{theorem}{Theorem}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem{lemma}[theorem]{Lemma}
\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}
\theoremstyle{remark}
\newtheorem{remark}[theorem]{Remark}

\newcommand{\R}{\mathbb{R}}
\newcommand{\T}{\mathbb{T}}
\newcommand{\Z}{\mathbb{Z}}
\newcommand{\abs}[1]{\lvert#1\rvert}
\newcommand{\norm}[1]{\lVert#1\rVert}
\newcommand{\grad}{\nabla}

\title{\textbf{September 2026 Working Notes on 3D Navier--Stokes Conditional Regularity Criteria, the Hodge--Navier--Stokes Architecture Referee Audit, and Triadic Multiscale Homogenization}}
\author{Benjamin Stanley Frohman\\
\small Independent Researcher, Texas, United States\\
\small ORCID: \href{https://orcid.org/0009-0006-7068-3718}{\texttt{0009-0006-7068-3718}} $\cdot$ GitHub: \href{https://github.com/BenFrohman}{\texttt{@BenFrohman}} $\cdot$ DOI: \href{https://doi.org/10.5281/zenodo.22835028}{\texttt{10.5281/zenodo.22835028}}}
\date{September 16--18, 2026}

\begin{document}
\maketitle

\begin{center}
\footnotesize
Copyright \copyright\ 2026 Benjamin Stanley Frohman. All rights reserved. Released under the Apache License, Version 2.0 (\texttt{Apache-2.0}).\\
\textbf{Scope \& Verification Notice:} Working preprint and formal referee audit from the September 2026 pass. This record establishes conditional regularity criteria, multiscale triadic projection identities, and formal Lean~4 specification boundaries; it does \emph{not} claim an unconditional solution of Fefferman's Clay Millennium Statements (A) or (B) or of the rational Hodge Conjecture.
\end{center}

\begin{abstract}
This archival working note consolidates three interconnected artifacts from the September 2026 phase of the Frohmanian Symplectohydrodynamics (FSymHD) and Lean~4 formal verification programme:
(1)~the exact logical boundary between proved conditional vorticity-direction regularity criteria on $\T^3$ ($C^{0,1/2}$ high-set direction coherence $\mathrm{G} \Longrightarrow \mathrm{R}$ and two-point strain increments $\delta\xi\cdot(S(x)\xi(x)-S(y)\xi(y))$) and the universal quantifier required by Fefferman's Clay statements (A) and (B);
(2)~a rigorous referee audit of uninterpreted Lean~4 interface stubs and multiplier-sheaf orientation in Hodge--Navier--Stokes coupling attempts, codifying the zero-\texttt{sorry}, zero-custom-axiom verification standard enforced across the author's Lean~4 repositories; and
(3)~the multiscale triadic cube partition, projection, and martingale difference increment identities (\texttt{TriadicHomogenization.lean}) together with the functional-equation orbit-invariance reduction (\texttt{B4}) illustrating the Frohmanian Symplectic Tether methodology.
\end{abstract}

\section{Logical Boundary Between Conditional Criteria and Clay Statements (A)--(B)}

Fefferman's official formulation offers four statements; only (A) on $\R^3$ and (B) on $\T^3=\R^3/\Z^3$ are existence-and-smoothness claims for the unforced incompressible Navier--Stokes equations. In both cases the quantifier is universal in the smooth divergence-free initial datum $u_0$ and empty in extra hypotheses on the ensuing solution.

\begin{definition}[High-Set Direction Coherence $\mathrm{G}$]
\label{def:G}
There exist $\Omega=\Omega(u_0,\nu)>0$ and $C=C(u_0,\nu)<\infty$, independent of the maximal existence time $T_*$, such that the vorticity direction $\xi=\omega/\abs{\omega}$ satisfies
\[
\abs{\xi(x,t)-\xi(y,t)}\le C\abs{x-y}^{1/2}
\qquad \text{whenever } \abs{\omega(x,t)},\abs{\omega(y,t)}\ge\Omega,\ t\in[0,T_*).
\]
\end{definition}

\begin{theorem}[Conditional Regularity Implication $\mathrm{G}\Longrightarrow\mathrm{R}$]
\label{thm:GtoR}
If a classical solution of the unmodified Navier--Stokes equations on $\T^3$ satisfies Definition~\ref{def:G}, then $T_*=\infty$ and the solution is globally smooth.
\end{theorem}

Theorem~\ref{thm:GtoR} is a conditional regularity criterion of Constantin--Fefferman / Beir\~ao da Veiga--Berselli type, companion to the September~18, 2026 identified strain-kernel note (\texttt{10.5281/zenodo.22835069}, where $A(\theta,\omega)=(\theta\times\omega)\otimes\theta+\theta\otimes(\theta\times\omega)$ and $\kappa=C_{\mathrm{CZ}}(3)=3/2\ne 1$). Because $\operatorname{tr}S=0$, the strain tensor $S=\tfrac12(\grad u+(\grad u)^\top)$ has eigenvalues of both signs, and closing the two-point remainder
\[
\delta\xi\cdot\bigl(S(x)\xi(x)-S(y)\xi(y)\bigr)
\le -\gamma\abs{\delta\xi}^2 + \varepsilon\bigl(\abs{\grad\xi(x)}^2+\abs{\grad\xi(y)}^2\bigr) + K_\varepsilon\abs{\delta\xi}^2
\]
from $\norm{u_0}_{L^2}$ and $\nu$ alone remains the open analytical step separating $\mathrm{G}\Longrightarrow\mathrm{R}$ from $\forall u_0,\,\mathrm{R}(u_0)$.

\section{Referee Audit of Uninterpreted Lean~4 Stubs and Multiplier Orientation}

To prevent vacuous formalization claims in automated or AI-assisted theorem proving, we record four mandatory verification rules enforced across the FSymHD Lean~4 corpus (\texttt{BenFrohman/NS\_Millennium\_Proof}, \texttt{BenFrohman/fefferman-clay-navier-stokes}, \texttt{BenFrohman/frohmanian-symplectic-tether-regularity}):
\begin{enumerate}[label=\textup{(\roman*)}]
\item \textbf{No Uninterpreted Carrier Types:} Declaring \texttt{VelocityField : Type} or \texttt{enstrophyDensity : VelocityField $\to$ Point $\to$ $\R$} as opaque axioms without the Navier--Stokes PDE, divergence-free constraint, or Sobolev/Bochner topology does not formalize Fefferman's problem.
\item \textbf{No Trivial Structure Fields:} Packaging an ideal with \texttt{is\_coherent : True} imposes zero mathematical constraint;boundedness of an unrelated real function cannot force an arbitrary ideal of a commutative ring $S$ to equal $\top$.
\item \textbf{Multiplier Weight Orientation:} Setting $\varphi=\log(1+\abs{\omega}^2)$ causes the Nadel/Demailly multiplier weight $e^{-2\varphi}=(1+\abs{\omega}^2)^{-2}$ to vanish as $\abs{\omega}\to\infty$, which enlarges rather than restricts the multiplier ideal unless paired with the correct subharmonic singular weight polarity.
\item \textbf{Kernel Axiom Audit:} Every published Lean~4 certificate must pass \texttt{\#print axioms} depending solely on standard foundational axioms (\texttt{propext}, \texttt{Classical.choice}, \texttt{Quot.sound}) with zero \texttt{sorryAx} and zero custom axioms.
\end{enumerate}

\section{Triadic Multiscale Cube Projections and Functional-Equation Orbit Reduction}

In companion formalizations included in this deposit:
\begin{itemize}[leftmargin=1.5em]
\item \textbf{Triadic Multiscale Homogenization (\texttt{TriadicHomogenization.lean}, \texttt{10.5281/zenodo.23629467}):} For a triadic cube $Q\subset\R^d$ of scale $s\in\Z$, the depth-$j$ descendant partition $\mathcal{D}_j(Q)$ satisfies pairwise disjointness, exact measure conservation $\sum_{R\in\mathcal{D}_j(Q)}\abs{R}=\abs{Q}$, and telescoping martingale difference projections $\Delta_n f = P_{n+1}f - P_n f$ with vanishing integral on every parent subcube.
\item \textbf{Functional-Equation Orbit Reduction (\texttt{10.5281/zenodo.23629465}):} For continuous $f:D\to\R$ satisfying $f(x^2)=f(x)^2$, forward/backward iteration along orbits $x\mapsto x^{2^{\pm n}}$ provides a discrete model of coadjoint-orbit invariance, canonical fixed-point uniqueness on $[0,1]$ when $f(0)\ne 0$, and fundamental-domain majorant construction on $(0,\infty)$.
\end{itemize}

\section*{Chronological Provenance \& AI Scaffolding Disclosure}
\small
This working note connects the April--May 2026 foundational manuscripts (\texttt{Mathematical\_Food\_Forethought.pdf}, Apr~29, 2026, SHA-256 \texttt{20dd3b53...}; \texttt{Triple\_conjecture\_a\_rigorous\_refinement.pdf}, May~9, 2026, SHA-256 \texttt{a7e3cd19...}), the June~1, 2026 origin repository \texttt{BenFrohman/frohmanian-tether-manuscript-2026-06-01} (commit \texttt{6c6cac908304d1ed3c90bddc907c4d2c3f4a8d79}, \texttt{10.5281/zenodo.23629499}), and the August~19, 2026 snapshot (\texttt{10.5281/zenodo.21856430}) to the September 2026 working notes (\texttt{10.5281/zenodo.22240168}, \texttt{10.5281/zenodo.22240549}, \texttt{10.5281/zenodo.22835028}, \texttt{10.5281/zenodo.22835069}, \texttt{10.5281/zenodo.23627618}) and the October 2026 zero-\texttt{sorry} Lean~4 formalizations (\texttt{10.5281/zenodo.23717082}, \texttt{10.5281/zenodo.23717083}, \texttt{10.5281/zenodo.23717084}). All mathematical definitions, physical models, and proof architectures are the sole original work of Benjamin Stanley Frohman; AI tooling (Grok / Grok Bot, xAI) assisted with Lean~4 tactic elaboration, \LaTeX\ typesetting, and repository/provenance audit scaffolding.

\end{document}
"""

def prepare_files():
    cover_tex_path = PKG_DIR / "00_Frohman_September_2026_NS_Hodge_Triadic_Working_Notes.tex"
    cover_tex_path.write_text(COVER_TEX, encoding="utf-8")
    subprocess.run([TECTONIC, str(cover_tex_path)], cwd=str(PKG_DIR), check=True)

    # Copy and compile the two genuine September 2026 working notes from /workspace/ns_ci_zenodo/artifacts/
    for tex_name in ("Frohman_What_Is_Actually_Proved_2026.tex", "Lean_NS_Module_Referee_2026.tex"):
        src = Path("/workspace/ns_ci_zenodo/artifacts") / tex_name
        dst = PKG_DIR / tex_name
        shutil.copy2(src, dst)
        subprocess.run([TECTONIC, str(dst)], cwd=str(PKG_DIR), check=True)

    # Copy the Functional Equation note PDF/tex and TriadicHomogenization.lean from /workspace/drive_downloads/
    for fname in (
        "Frohmanian_Tether_Application_to_Functional_Equation_Note.pdf",
        "Frohmanian_Tether_Application_to_Functional_Equation_Note.tex",
        "TriadicHomogenization.lean",
    ):
        shutil.copy2(Path("/workspace/drive_downloads") / fname, PKG_DIR / fname)

    # Copy README.md and LICENSE
    shutil.copy2(Path("/workspace/ns_ci_zenodo/artifacts/README.md"), PKG_DIR / "README.md")
    shutil.copy2(Path("/workspace/repos_audit/ns-i11-conditional-criterion/LICENSE"), PKG_DIR / "LICENSE")

def upload_file_to_bucket(bucket_url: str, file_path: Path):
    fname = file_path.name
    url = f"{bucket_url}/{fname}"
    data = file_path.read_bytes()
    req = urllib.request.Request(
        url,
        data=data,
        headers={
            "Authorization": f"Bearer {TOKEN}",
            "Content-Type": "application/octet-stream",
        },
        method="PUT",
    )
    with urllib.request.urlopen(req, timeout=60) as resp:
        res = json.loads(resp.read().decode("utf-8"))
        print(f"  Uploaded {fname} ({len(data)} bytes, checksum={res.get('checksum')})", flush=True)

def main():
    # files already prepared and uploaded

    req = urllib.request.Request(
        f"https://zenodo.org/api/deposit/depositions/{REC_ID}",
        headers={"Authorization": f"Bearer {TOKEN}"}
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        dep = json.loads(resp.read().decode("utf-8"))

    bucket_url = dep["links"]["bucket"]
    ordered_files = [
        "00_Frohman_September_2026_NS_Hodge_Triadic_Working_Notes.pdf",
        "Frohman_What_Is_Actually_Proved_2026.pdf",
        "Lean_NS_Module_Referee_2026.pdf",
        "Frohmanian_Tether_Application_to_Functional_Equation_Note.pdf",
        "00_Frohman_September_2026_NS_Hodge_Triadic_Working_Notes.tex",
        "Frohman_What_Is_Actually_Proved_2026.tex",
        "Lean_NS_Module_Referee_2026.tex",
        "Frohmanian_Tether_Application_to_Functional_Equation_Note.tex",
        "TriadicHomogenization.lean",
        "README.md",
        "LICENSE",
    ]

    base_desc = """<p><strong>Working Preprint &amp; Formal Verification Referee Audit (September 16–18, 2026). Does NOT claim an unconditional solution of Fefferman's Clay Millennium Statements (A) or (B).</strong></p>
<p>This archival record preserves the September 2026 working notes and referee audits from the <strong>Frohmanian Symplectohydrodynamics (FSymHD)</strong> and <strong>Lean 4 Formal Verification</strong> programme by <strong>Benjamin Stanley Frohman</strong> (ORCID: <a href="https://orcid.org/0009-0006-7068-3718">0009-0006-7068-3718</a>):</p>
<ol>
  <li><strong>Conditional Regularity Criteria vs. Clay Statements (A) and (B) (<code>Frohman_What_Is_Actually_Proved_2026.pdf/.tex</code>):</strong> Establishes the exact logical separation between proved Constantin–Fefferman / Beirão da Veiga–Berselli conditional regularity criteria on <code>T^3</code> (uniform <code>C^{0,1/2}</code> coherence of the vorticity direction <code>&xi; = &omega;/&vert;&omega;&vert;</code> on high-amplitude sets <code>{&vert;&omega;&vert; &ge; &Omega;}</code> implies <code>T_* = &infin;</code>, i.e., <code>G &rArr; R</code>) and the universal quantifier <code>&forall; u_0 &in; C^&infin;_div(T^3), R(u_0)</code> required by Clay Statement (B). Identifies the exact two-point strain-increment inequality on <code>&delta;&xi; &middot; (S(x)&xi;(x) - S(y)&xi;(y))</code> that remains open because <code>tr(S) = 0</code> prevents <code>&xi; &mapsto; &xi; &middot; S&xi;</code> from having a definite sign. Companion to the September 18, 2026 strain-kernel working note <a href="https://doi.org/10.5281/zenodo.22835069"><code>10.5281/zenodo.22835069</code></a> (<code>&kappa; = C_CZ(3) = 3/2 &ne; 1</code>).</li>
  <li><strong>Referee Audit of Uninterpreted Lean 4 Stubs &amp; Hodge–Navier–Stokes Coupling (<code>Lean_NS_Module_Referee_2026.pdf/.tex</code>):</strong> Documents why uninterpreted Lean 4 carrier types (<code>VelocityField : Type</code>), trivial coherence fields (<code>is_coherent : True</code>), and inverted Nadel/Demailly multiplier weights (<code>&phi; = log(1 + &vert;&omega;&vert;^2)</code>) do not formalize Fefferman's problem or the Hodge Conjecture, codifying the strict zero-<code>sorry</code>, zero-custom-axiom audit standard implemented across <code>BenFrohman/NS_Millennium_Proof</code> (<a href="https://doi.org/10.5281/zenodo.23717084"><code>10.5281/zenodo.23717084</code></a>), <code>BenFrohman/fefferman-clay-navier-stokes</code> (<a href="https://doi.org/10.5281/zenodo.23717083"><code>10.5281/zenodo.23717083</code></a>), and <code>BenFrohman/frohmanian-symplectic-tether-regularity</code> (<a href="https://doi.org/10.5281/zenodo.23717082"><code>10.5281/zenodo.23717082</code></a>).</li>
  <li><strong>Triadic Multiscale Homogenization &amp; Functional-Equation Orbit Reduction (<code>TriadicHomogenization.lean</code> &amp; <code>Frohmanian_Tether_Application_to_Functional_Equation_Note.pdf/.tex</code>):</strong> Formalizes triadic cube partitions, measure conservation, and multiscale martingale difference increments (companion to <a href="https://doi.org/10.5281/zenodo.23629467"><code>10.5281/zenodo.23629467</code></a>), alongside the orbit-invariance and majorant reduction for <code>f(x^2) = f(x)^2</code> (companion to <a href="https://doi.org/10.5281/zenodo.23629465"><code>10.5281/zenodo.23629465</code></a>).</li>
</ol>"""

    full_desc = base_desc + "\n" + PROVENANCE_LEDGER_HTML

    rel_list = [
        {"identifier": "https://github.com/BenFrohman/frohmanian-tether-manuscript-2026-06-01/commit/6c6cac908304d1ed3c90bddc907c4d2c3f4a8d79", "relation": "isDerivedFrom"},
        {"identifier": "https://github.com/BenFrohman/frohmanian-tether-manuscript-2026-06-01", "relation": "references"},
        {"identifier": "https://github.com/BenFrohman/NS_Millennium_Proof", "relation": "isSupplementTo"},
        {"identifier": "https://github.com/BenFrohman/frohmanian-ns-symplectic-tether", "relation": "isSupplementTo"},
        {"identifier": "https://github.com/BenFrohman/ns-i11-conditional-criterion", "relation": "references"},
        {"identifier": "https://github.com/BenFrohman/two-point-strain-coercivity", "relation": "references"},
        {"identifier": "https://github.com/BenFrohman/frohmanian-symplectic-tether-regularity", "relation": "references"},
        {"identifier": "https://github.com/BenFrohman/fefferman-clay-navier-stokes", "relation": "references"},
    ]
    for target_doi, target_date, _ in CANONICAL_NS_DOIS:
        if target_doi == "10.5281/zenodo.22835028":
            continue
        if target_doi == "10.5281/zenodo.23629499":
            rel = "isDerivedFrom"
        elif target_doi in ("10.5281/zenodo.21856430", "10.5281/zenodo.22240168", "10.5281/zenodo.22240549", "10.5281/zenodo.22835069"):
            rel = "references"
        else:
            rel = "isReferencedBy"
        rel_list.append({"identifier": target_doi, "relation": rel})

    meta_payload = {
        "metadata": {
            "title": "September 2026 Working Notes on 3D Navier–Stokes Conditional Regularity Criteria, the Hodge–Navier–Stokes Architecture Referee Audit, and Triadic Multiscale Homogenization",
            "upload_type": "publication",
            "publication_type": "workingpaper",
            "publication_date": "2026-09-18",
            "prereserve_doi": True,
            "creators": [
                {
                    "name": "Frohman, Benjamin Stanley",
                    "affiliation": "Independent Researcher, Texas, United States",
                    "orcid": "0009-0006-7068-3718"
                }
            ],
            "description": full_desc,
            "access_right": "open",
            "license": "apache-2.0",
            "language": "eng",
            "version": "1.0.0",
            "keywords": [
                "3D Navier-Stokes",
                "Frohmanian Symplectic Tether",
                "Conditional Regularity Criterion",
                "Vorticity Direction Coherence",
                "Calderon-Zygmund Strain Kernel",
                "Beale-Kato-Majda",
                "Constantin-Fefferman",
                "Lean 4",
                "Mathlib4",
                "Triadic Homogenization",
                "Hodge Conjecture Referee Audit",
                "Prior Art Provenance"
            ],
            "related_identifiers": rel_list,
            "dates": [
                {
                    "start": "2026-04-29",
                    "end": "2026-06-01",
                    "type": "collected",
                    "description": "Foundational prior-art manuscripts: Mathematical_Food_Forethought.pdf (2026-04-29 CDT, SHA-256 20dd3b53...), Triple_conjecture_a_rigorous_refinement.pdf (2026-05-09 CDT, SHA-256 a7e3cd19...), Lean_Formalization_2026-05-28, and GitHub root commit 6c6cac908304d1ed3c90bddc907c4d2c3f4a8d79 (2026-06-01 01:20:57 AM CDT)."
                },
                {
                    "start": "2026-09-09",
                    "end": "2026-09-18",
                    "type": "created",
                    "description": "September 9–18, 2026 working notes on 3D Navier–Stokes conditional regularity criteria, Hodge–Navier–Stokes Lean 4 referee audit, and multiscale triadic homogenization (deposited 2026-09-18 12:48:45 PM CDT)."
                }
            ],
            "notes": (
                "Copyright (c) 2026 Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). All rights reserved. "
                "Released under the Apache License, Version 2.0 (SPDX: Apache-2.0). "
                "Prior-Art Lineage: Mathematical_Food_Forethought.pdf (2026-04-29 CDT, SHA-256: 20dd3b53e02a5a3a5a02fd9f753844b162ad920cfd3e4c5f6f89106d7d66dac5); "
                "Triple_conjecture_a_rigorous_refinement.pdf (2026-05-09 CDT, SHA-256: a7e3cd19697eed920549cdfa2f6177a45312b9c2cf8e2e33fe220691f550ba61); "
                "BenFrohman/frohmanian-tether-manuscript-2026-06-01 commit 6c6cac908304d1ed3c90bddc907c4d2c3f4a8d79 (2026-06-01 01:20:57 AM CDT, DOI: 10.5281/zenodo.23629499); "
                "Historical Zenodo snapshot 10.5281/zenodo.21856430 (2026-08-19 CDT); "
                "Companion September 18, 2026 strain kernel note 10.5281/zenodo.22835069; "
                "Lean 4 Formalizations: 10.5281/zenodo.23717082, 10.5281/zenodo.23717083, 10.5281/zenodo.23717084. "
                "AI Tooling Disclosure: Mathematical architecture and proofs by Benjamin Stanley Frohman; Lean 4 tactic translation, LaTeX typesetting, and audit scaffolding assisted by Grok (xAI)."
            )
        }
    }

    req_put = urllib.request.Request(
        f"https://zenodo.org/api/deposit/depositions/{REC_ID}",
        data=json.dumps(meta_payload).encode("utf-8"),
        headers={"Authorization": f"Bearer {TOKEN}", "Content-Type": "application/json"},
        method="PUT"
    )
    with urllib.request.urlopen(req_put, timeout=30) as resp:
        upd = json.loads(resp.read().decode("utf-8"))
        print("PUT 22835028 metadata OK, related_identifiers:", len(upd["metadata"].get("related_identifiers", [])), flush=True)

    req_pub = urllib.request.Request(
        f"https://zenodo.org/api/deposit/depositions/{REC_ID}/actions/publish",
        headers={"Authorization": f"Bearer {TOKEN}"},
        method="POST"
    )
    with urllib.request.urlopen(req_pub, timeout=30) as resp:
        pub = json.loads(resp.read().decode("utf-8"))
        print("PUBLISHED 22835028 -> state:", pub.get("state"), "submitted:", pub.get("submitted"), "doi:", pub.get("doi"), flush=True)

if __name__ == "__main__":
    main()
