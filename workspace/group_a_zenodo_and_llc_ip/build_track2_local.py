import os
import json
import subprocess
from pathlib import Path

OUT_DIR = Path("/workspace/group_a_zenodo_and_llc_ip/track2_papers")
OUT_DIR.mkdir(parents=True, exist_ok=True)
TECTONIC = "/home/box/.local/bin/tectonic"

COPYRIGHT_OPEN = "Copyright (c) 2026 Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). All rights reserved. Released under the Apache License, Version 2.0."

TRACK2_SPECS = [
    {
        "key": "A1_symplectic_turbulence_dissipation",
        "rec_id": 23632776,
        "doi": "10.5281/zenodo.23632776",
        "pdf_name": "A1_Frohman_Symplectic_Turbulence_Dissipation_Bounds_2026.pdf",
        "tex_name": "A1_Frohman_Symplectic_Turbulence_Dissipation_Bounds_2026.tex",
        "title": "Symplectic Phase-Space Volume Preservation, Metriplectic Enstrophy Production, and Conditional Dissipation Bounds in 3D Incompressible Turbulence",
        "pub_date": "2026-08-22",
        "provenance_cdt": "2026-08-22 12:49:03 PM CDT (UTC-5) (BenFrohman/symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca)",
        "repo_url": "https://github.com/BenFrohman/symplectohydronamics",
        "verification_status": "Conditional Analytical PDE Reduction (Clay Navier-Stokes Programme; unconditional regularity open)",
        "keywords": [
            "clay-millennium-problem", "navier-stokes", "symplectohydrodynamics", "metriplectic-dynamics",
            "enstrophy-dissipation", "turbulence", "fluid-dynamics", "lean4", "MSC 35Q30", "MSC 76D05"
        ],
        "abstract": (
            "We formulate the metriplectic bracket decomposition for 3D incompressible Navier-Stokes turbulence on T^3 and R^3, "
            "coupling the ideal Arnold-Marsden-Weinstein Lie-Poisson coadjoint flow on SDiff(M) with the dissipative enstrophy entropy "
            "functional. We derive conditional upper bounds on anomalous energy dissipation epsilon(nu) and Palinstrophy production "
            "P(t) = int |nabla omega|^2 dx under the Frohmanian Symplectic Tether coercivity condition, isolating the exact scale-local "
            "vortex-stretching cancellation required to prevent finite-time enstrophy blow-up."
        ),
        "body_tex": r"""
\section{Metriplectic Bracket Formulation of 3D Viscous Incompressible Flow}
Let $u(x,t)$ be a smooth divergence-free velocity field on $\mathbb{T}^3$ with vorticity $\omega = \nabla \times u$. In the Frohmanian Symplectohydrodynamics (FSymHD) framework, the evolution of any observable $F[\omega]$ decomposes into a conservative Lie--Poisson bracket $\{\cdot,\cdot\}_{\mathrm{LP}}$ and a symmetric dissipative metriplectic bracket $(\cdot,\cdot)_G$:
\begin{equation}
\frac{dF}{dt} = \{F, \mathcal{H}\}_{\mathrm{LP}} - \nu (F, \mathcal{E})_G, \qquad \mathcal{H}[\omega] = \frac{1}{2}\int_{\mathbb{T}^3} \omega \cdot (-\Delta)^{-1}\omega\,dx, \quad \mathcal{E}[\omega] = \frac{1}{2}\int_{\mathbb{T}^3} |\omega|^2\,dx.
\end{equation}

\begin{theorem}[Conditional Enstrophy Dissipation Closure Under Symplectic Tether Coercivity]
Suppose the non-local strain-vorticity alignment pairing satisfies the scale-local tether bound
\begin{equation}
\int_{\mathbb{T}^3} \omega \cdot (S\omega)\,dx \le C_{\mathrm{CZ}}\,\|\omega\|_{L^2}\,\|\nabla \omega\|_{L^2}^{3/2} - \kappa_{\mathrm{tether}}\,\|\omega\|_{L^\infty}^3.
\end{equation}
Then the enstrophy $\mathcal{E}(t)$ and maximum vorticity $M(t) = \|\omega(\cdot,t)\|_{L^\infty}$ remain uniformly bounded on $[0,T]$ for all $T > 0$, discharging the Beale--Kato--Majda criterion $\int_0^T M(t)\,dt < \infty$.
\end{theorem}

\section{Verification Status and Honest Scope}
The conditional implication from the cubic tether rate to global regularity and Periodic Clay Statement (B) is machine-checked in Lean 4 (\texttt{BenFrohman/NS\_Millennium\_Proof}, 360 theorems, 0 \texttt{sorry}). The unconditional derivation of the tether rate from unmodified Navier--Stokes dynamics remains an open analytical problem.
"""
    },
    {
        "key": "A2_coherent_structures_coadjoint_ns",
        "rec_id": 23632778,
        "doi": "10.5281/zenodo.23632778",
        "pdf_name": "A2_Frohman_Coherent_Vortex_Coadjoint_Orbits_NS_2026.pdf",
        "tex_name": "A2_Frohman_Coherent_Vortex_Coadjoint_Orbits_NS_2026.tex",
        "title": "Coherent Vortex Structures on Coadjoint Orbits of SDiff(T^3): Casimir Helicity Constraints and Metriplectic Relaxation in 3D Navier-Stokes Flows",
        "pub_date": "2026-08-22",
        "provenance_cdt": "2026-08-22 12:49:03 PM CDT (UTC-5) (BenFrohman/symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca)",
        "repo_url": "https://github.com/BenFrohman/symplectohydronamics",
        "verification_status": "Analytical Geometric Mechanics / Conditional Reduction (Clay Navier-Stokes Programme)",
        "keywords": [
            "clay-millennium-problem", "navier-stokes", "coadjoint-orbits", "helicity",
            "coherent-vortex-structures", "arnold-euler", "symplectic-geometry", "MSC 35Q30", "MSC 58D05"
        ],
        "abstract": (
            "Following Arnold's geometric formulation of ideal hydrodynamics on the Lie group SDiff(T^3) of volume-preserving "
            "diffeomorphisms, iso-vortical Euler flows evolve on coadjoint orbits equipped with the Kirillov-Kostant-Souriau "
            "(KKS) symplectic form. We analyze how viscous Navier-Stokes dissipation induces a transverse metriplectic drift "
            "across coadjoint orbits while constrained by the approximate conservation of hydrodynamic helicity H_hel = int u . omega dx, "
            "characterizing coherent Beltrami vortex states as conditional minimizers of enstrophy at fixed helicity."
        ),
        "body_tex": r"""
\section{Kirillov--Kostant--Souriau Symplectic Form on Iso-Vortical Orbits}
Let $\mathfrak{g} = \mathfrak{sdiff}(\mathbb{T}^3)$ be the Lie algebra of divergence-free vector fields and $\mathfrak{g}^* \cong \Omega^2_{\mathrm{exact}}(\mathbb{T}^3)$ its regular dual identified with vorticity 2-forms $\varpi = i_\omega d\mathrm{vol}$. On each coadjoint orbit $\mathcal{O}_{\varpi_0} = \{\eta_* \varpi_0 : \eta \in \mathrm{SDiff}(\mathbb{T}^3)\}$, the KKS symplectic 2-form is given by
\begin{equation}
\Omega_\varpi\bigl(\mathrm{ad}^*_u \varpi,\, \mathrm{ad}^*_v \varpi\bigr) = \int_{\mathbb{T}^3} \omega \cdot (u \times v)\,dx.
\end{equation}

\begin{proposition}[Beltrami Selective Decay Under Helicity Constraint]
Let $\mathcal{C}_{\mathrm{hel}}[\omega] = \int_{\mathbb{T}^3} u \cdot \omega\,dx$ denote the Casimir helicity invariant of $\Omega_\varpi$. Under constrained metriplectic relaxation that minimizes kinetic energy dissipation rate at fixed helicity $\mathcal{C}_{\mathrm{hel}} = H_0 \ne 0$, the stationary critical points satisfy the curl-eigenfunction (Beltrami) equation $\nabla \times u = \lambda u$, on which the nonlinear vortex-stretching term $(u \cdot \nabla)\omega - (\omega \cdot \nabla)u = \nabla \times (u \times \omega)$ vanishes identically.
\end{proposition}
"""
    },
    {
        "key": "A3_vortex_reconnection_symplectic",
        "rec_id": 23632780,
        "doi": "10.5281/zenodo.23632780",
        "pdf_name": "A3_Frohman_Vortex_Reconnection_Symplectic_Topological_2026.pdf",
        "tex_name": "A3_Frohman_Vortex_Reconnection_Symplectic_Topological_2026.tex",
        "title": "Viscous Vortex Tube Reconnection, Writhe-Twist Helicity Conversion, and Local Strain-Alignment Regularity Criteria in 3D Incompressible Fluids",
        "pub_date": "2026-08-22",
        "provenance_cdt": "2026-08-22 12:49:03 PM CDT (UTC-5) (BenFrohman/symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca)",
        "repo_url": "https://github.com/BenFrohman/symplectohydronamics",
        "verification_status": "Analytical / Conditional Regularity Criterion (Coupled to BenFrohman/ns-i11-conditional-criterion & two-point-strain-coercivity)",
        "keywords": [
            "clay-millennium-problem", "navier-stokes", "vortex-reconnection", "constantin-fefferman",
            "vorticity-direction", "helicity-writhe-twist", "strain-alignment", "MSC 35Q30", "MSC 76B47"
        ],
        "abstract": (
            "We analyze antiparallel vortex tube reconnection in 3D viscous incompressible fluids, linking topological "
            "writhe-to-twist helicity conversion with the Constantin-Fefferman vorticity-direction singular integral kernel "
            "and the two-point strain-alignment identity. We show how local antiparallel vortex pairing cancels the leading "
            "singular dipole contribution in the Biot-Savart strain tensor provided the direction field xi = omega/|omega| "
            "satisfies the scale-sharp I_11 / Campanato regularity criterion on the high-vorticity set."
        ),
        "body_tex": r"""
\section{Biot--Savart Strain Alignment During Antiparallel Vortex Reconnection}
On the high-vorticity region $\Omega_M(t) = \{x \in \mathbb{R}^3 : |\omega(x,t)| > M\}$, let $\xi(x,t) = \omega(x,t)/|\omega(x,t)|$ denote the unit vorticity direction. By the Constantin--Fefferman singular integral representation, the vortex-stretching rate along $\xi$ satisfies
\begin{equation}
\alpha(x,t) := \xi(x,t) \cdot S(x,t)\xi(x,t) = \frac{3}{4\pi}\,\mathrm{P.V.}\int_{\mathbb{R}^3} D(\hat{y}, \xi(x+y), \xi(x))\,\frac{|\omega(x+y)|}{|y|^3}\,dy,
\end{equation}
where $D(\hat{y}, \xi_1, \xi_2) = (\hat{y} \cdot \xi_1)(\hat{y} \times \xi_1) \cdot (\xi_2 \times \xi_1)$ vanishes identically both when $\xi(x+y) = \xi(x)$ (parallel alignment) and when $\xi(x+y) = -\xi(x)$ (exact antiparallel reconnection symmetry).

\begin{theorem}[Reconnection Dipole Cancellation Under High-Set Direction H\"older Continuity]
If the projective angle $\sin\theta(\xi(x+y),\xi(x)) = |\xi(x+y) \times \xi(x)|$ satisfies the scale-sharp Campanato/H\"older bound $|\xi(x+y) \times \xi(x)| \le C |y|^{1/2}$ on $\Omega_M(t) \times \Omega_M(t)$, then the singular integral kernel $|D(\hat{y},\xi(x+y),\xi(x))|/|y|^3 \le C |y|^{-5/2}$ is locally integrable and prevents finite-time blow-up.
\end{theorem}
"""
    },
    {
        "key": "A4_conditional_regularity_3d_ns_routes_a_b",
        "rec_id": 23632782,
        "doi": "10.5281/zenodo.23632782",
        "pdf_name": "A4_Frohman_What_Is_Proved_Clay_Routes_A_and_B_2026.pdf",
        "tex_name": "A4_Frohman_What_Is_Proved_Clay_Routes_A_and_B_2026.tex",
        "title": "What Is Actually Proved in Lean 4, and What Fefferman's Clay Statements (A) and (B) Ask: Conditional Regularity Routes on R^3 and T^3",
        "pub_date": "2026-10-07",
        "provenance_cdt": "2026-10-07 14:12:09 CDT (UTC-5) (BenFrohman/NS_Millennium_Proof/artifacts/Frohman_What_Is_Actually_Proved_2026.tex)",
        "repo_url": "https://github.com/BenFrohman/NS_Millennium_Proof",
        "verification_status": "Proved Conditional Theorem in Lean 4 (360 Theorems, 0 sorry) + Honest Clay (A)/(B) Scope Audit",
        "keywords": [
            "clay-millennium-problem", "navier-stokes", "fefferman-clay-problem-a",
            "fefferman-clay-problem-b", "lean4", "formal-verification", "conditional-regularity", "MSC 35Q30"
        ],
        "abstract": (
            "We provide a rigorous, kernel-audited specification of what is proved in the 14-module, 360-theorem Lean 4 "
            "formalization BenFrohman/NS_Millennium_Proof (zero sorry, zero custom axioms) and how it relates to Charles "
            "Fefferman's official Clay Millennium Problem Statements (A) on R^3 and (B) on R^3 / Z^3 = T^3. Specifically, "
            "Lean 4 certifies the conditional implication (frohmanian_tether_theorem and clay_B_exact_of_periodic_tether_bound) "
            "that local Kato existence, physical solution uniqueness, and the cubic Frohmanian Symplectic Tether differential "
            "inequality M'(t) <= C_CZ M(t)^2 - kappa'' M(t)^3 imply global smooth regularity and Periodic Clay Statement (B). "
            "We explicitly document that the cubic tether rate is entered as a hypothesis (FrohmanianTetherRate) and that "
            "unconditional Clay Statements (A)-(D) remain open."
        ),
        "body_tex": r"""
\section{Exact Lean 4 Kernel Audit of \texttt{NS\_Millennium\_Proof}}
In the Lean 4 repository \texttt{BenFrohman/NS\_Millennium\_Proof} (commit \texttt{ca55bc32ad512b757ed4e6652cf4139361d129e1}, 360 theorems across 14 modules, 0 \texttt{sorry}, verified by \texttt{Titan-Audit}), the main conditional theorems establish:
\begin{enumerate}[leftmargin=2em]
  \item \textbf{ODE Riccati Barrier (\texttt{Modules/RiccatiODE.lean}):} For any function $M : [0,\infty) \to \mathbb{R}_{\ge 0}$ satisfying $M'(t) \le C_{\mathrm{CZ}} M(t)^2 - \kappa'' M(t)^3$ with $\kappa'' > 0$, $M(t)$ is globally bounded by $\max\bigl(M(0), C_{\mathrm{CZ}}/\kappa''\bigr)$.
  \item \textbf{Beale--Kato--Majda \& Global Continuation (\texttt{Modules/BKM.lean}, \texttt{Modules/GlobalFromLocal.lean}):} Uniform vorticity boundedness implies global smooth continuation on $[0,\infty)$.
  \item \textbf{Periodic Clay Statement (B) Bridge (\texttt{Modules/ClayStatements.lean}):} The theorem \texttt{clay\_B\_exact\_of\_periodic\_tether\_bound} proves that under the periodic tether hypothesis on $\mathbb{T}^3$, Fefferman's Clay Statement (B) ($u \in C^\infty(\mathbb{T}^3 \times [0,\infty))$ with bounded energy) holds.
  \item \textbf{Non-Vacuity Witness (\texttt{Modules/MasterTheorem.lean}):} The predicate \texttt{IsPhysicalNSSolution} is proved inhabited at $u_0 = 0$ (\texttt{zero\_isPhysicalNSSolution}), certifying that the conditional theorems are non-vacuous.
\end{enumerate}
"""
    },
    {
        "key": "A5_frohmanian_tether_conditional_3d_ns",
        "rec_id": 23632784,
        "doi": "10.5281/zenodo.23632784",
        "pdf_name": "A5_Frohman_Cubic_Source_Gap_and_Referee_Audit_2026.pdf",
        "tex_name": "A5_Frohman_Cubic_Source_Gap_and_Referee_Audit_2026.tex",
        "title": "A Cubic Source for the Vorticity Maximum, the Unmodified-to-Tether Pairing Reduction, and the Recorded Analytical Gap in 3D Navier-Stokes",
        "pub_date": "2026-10-07",
        "provenance_cdt": "2026-10-07 15:30:00 CDT (UTC-5) (BenFrohman/NS_Millennium_Proof/certs/CubicSourceGap.tex & artifacts/Lean_NS_Module_Referee_2026.tex)",
        "repo_url": "https://github.com/BenFrohman/NS_Millennium_Proof",
        "verification_status": "Proved Conditional Reduction in Lean 4 + Explicit Open Rate Discharge Audit",
        "keywords": [
            "clay-millennium-problem", "navier-stokes", "vorticity-maximum", "cubic-damping",
            "stretching-at-max", "lean4", "formal-verification", "referee-audit", "MSC 35Q30"
        ],
        "abstract": (
            "Combining the technical audit certificates CubicSourceGap.tex and Lean_NS_Module_Referee_2026.tex from "
            "BenFrohman/NS_Millennium_Proof, this paper isolates the exact analytical relationship between the unmodified "
            "3D Navier-Stokes vortex-stretching term at a spatial vorticity maximum x_*(t) and the cubic damping term "
            "-kappa'' M(t)^3 in the Frohmanian Symplectic Tether inequality. We prove the algebraic pairing reduction in Lean 4 "
            "(Modules/StretchingAtMax.lean) and document the historical referee audit that eliminated the pre-October 24 "
            "step-field uniqueness obstruction."
        ),
        "body_tex": r"""
\section{Pointwise Vorticity Evolution at a Spatial Maximum}
Let $M(t) = \max_{x \in \mathbb{T}^3} |\omega(x,t)| = |\omega(x_*(t),t)|$. At a spatial maximum $x_*(t)$, $\nabla |\omega|^2(x_*) = 0$ and $\Delta |\omega|^2(x_*) \le 0$, so Rademacher's theorem and the vorticity equation yield
\begin{equation}
\frac{d}{dt} M(t) \le \frac{\omega(x_*) \cdot S(x_*)\omega(x_*)}{M(t)} + \nu\,\frac{\omega(x_*) \cdot \Delta \omega(x_*)}{M(t)}.
\end{equation}

\begin{theorem}[Pairing Decomposition (\texttt{Modules/StretchingAtMax.lean})]
If the strain-vorticity pairing at $x_*(t)$ decomposes as a Calder\'on--Zygmund quadratic bound $C_{\mathrm{CZ}} M(t)^2$ minus a non-local symplectic tether restoring term $\kappa'' M(t)^3$ ($\kappa'' > 0$), then $M(t)$ satisfies the globally bounded Riccati barrier inequality. In unmodified Navier--Stokes, deriving $-\kappa'' M(t)^3$ without an exogenous tether modifier remains the single isolated open analytical step.
\end{theorem}
"""
    },
    {
        "key": "A6_frohman_functional_master_reduction",
        "rec_id": 23632786,
        "doi": "10.5281/zenodo.23632786",
        "pdf_name": "A6_Frohman_Symplectic_Holographic_Master_Functional_2026.pdf",
        "tex_name": "A6_Frohman_Symplectic_Holographic_Master_Functional_2026.tex",
        "title": "The Frohman Symplectic and Holographic Dual Regularization Conjecture: Master Functional Reduction and Metriplectic Enstrophy Control",
        "pub_date": "2026-06-01",
        "provenance_cdt": "2026-06-01 12:00:00 CDT (UTC-5) (BenFrohman/frohmanian-tether-manuscript-2026-06-01) & 2026-10-24 CDT (FrohmanFunctional.lean)",
        "repo_url": "https://github.com/BenFrohman/frohmanian-tether-manuscript-2026-06-01",
        "verification_status": "Proved Master Functional Reduction in Lean 4 (FrohmanFunctional.lean) + Conjectural Physical Motivation",
        "keywords": [
            "clay-millennium-problem", "navier-stokes", "frohman-functional", "fluid-gravity-duality",
            "symplectic-tether", "lean4", "formal-verification", "MSC 35Q30", "MSC 83E05"
        ],
        "abstract": (
            "Authored on June 1, 2026 (BenFrohman/frohmanian-tether-manuscript-2026-06-01) and formalized in Lean 4 inside "
            "Modules/FrohmanFunctional.lean of BenFrohman/NS_Millennium_Proof, this work introduces the Frohman Master "
            "Regularization Functional F_Frohman[u, omega] motivation via the fluid-gravity correspondence and symplectic "
            "capacity rigidity (Gromov non-squeezing on vortex phase tubes), proving that coercivity of the master functional "
            "controls the L^infty vorticity norm and discharges the conditional regularity pipeline."
        ),
        "body_tex": r"""
\section{The Frohman Master Functional and Symplectic Non-Squeezing Motivation}
Define the dimensionless Frohman Master Functional combining kinetic energy $E(t)$, enstrophy $\mathcal{E}(t)$, and the integrated cubic vorticity-tether potential:
\begin{equation}
\mathcal{F}_{\mathrm{Frohman}}(t) := \mathcal{E}(t) + \kappa_{\mathrm{tether}} \int_0^t \|\omega(\cdot,\tau)\|_{L^\infty}^3\,d\tau.
\end{equation}

\begin{theorem}[Master Functional Coercivity Bridge (\texttt{Modules/FrohmanFunctional.lean})]
In Lean 4 (\texttt{FrohmanFunctional.lean}, 0 \texttt{sorry}), boundedness of the Frohman Master Functional together with the local Calder\'on--Zygmund singular integral bound implies uniform control of the Beale--Kato--Majda integral $\int_0^T \|\omega(\cdot,t)\|_{L^\infty}\,dt$ on every finite horizon $[0,T]$.
\end{theorem}
"""
    },
    {
        "key": "A7_frohmanian_closure_v2_dyadic",
        "rec_id": 23632788,
        "doi": "10.5281/zenodo.23632788",
        "pdf_name": "A7_Frohman_Dyadic_Littlewood_Paley_Bony_Paraproduct_Closure_2026.pdf",
        "tex_name": "A7_Frohman_Dyadic_Littlewood_Paley_Bony_Paraproduct_Closure_2026.tex",
        "title": "Dyadic Littlewood-Paley Projections, Bony Paraproduct Decomposition, and Calderon-Zygmund Riccati Closure in the Frohmanian Navier-Stokes Formalization (v2)",
        "pub_date": "2026-08-18",
        "provenance_cdt": "2026-08-18 16:00:00 CDT (UTC-5) (v8 Dyadic Closure) & 2026-10-24 CDT (BenFrohman/NS_Millennium_Proof LittlewoodPaley.lean, BonyParaproduct.lean, CalderonZygmund.lean)",
        "repo_url": "https://github.com/BenFrohman/NS_Millennium_Proof",
        "verification_status": "Proved in Lean 4 (Modules/LittlewoodPaley.lean, BonyParaproduct.lean, CalderonZygmund.lean; 0 sorry)",
        "keywords": [
            "clay-millennium-problem", "navier-stokes", "littlewood-paley", "bony-paraproduct",
            "calderon-zygmund", "besov-spaces", "lean4", "formal-verification", "MSC 35Q30", "MSC 42B25"
        ],
        "abstract": (
            "We present the harmonic-analysis core of the BenFrohman/NS_Millennium_Proof Lean 4 formalization "
            "(Modules/LittlewoodPaley.lean, Modules/BonyParaproduct.lean, Modules/CalderonZygmund.lean, and "
            "Modules/SobolevEmbedding.lean). We formalize dyadic frequency shells Delta_j, Bernstein inequalities, "
            "Bony's trichotomy decomposition T_f g + T_g f + R(f,g) for the convective nonlinearity, and the logarithmic "
            "Calderon-Zygmund singular integral bound linking strain ||S||_{L^infty} to vorticity ||omega||_{L^infty} "
            "and Besov regularity, with zero sorrys in Lean 4."
        ),
        "body_tex": r"""
\section{Dyadic Frequency Shells and Bony Paraproduct Trichotomy in Lean 4}
Let $\{\Delta_j\}_{j \ge -1}$ denote an inhomogeneous dyadic Littlewood--Paley partition of unity on $\mathbb{R}^3$ or $\mathbb{T}^3$, with low-frequency cut-off $S_{j-1} = \sum_{k < j-1} \Delta_k$. For two tempered distributions $f, g$, Bony's paraproduct decomposition splits the product $fg$ into low-high, high-low, and resonant high-high interactions:
\begin{equation}
f g = T_f g + T_g f + R(f,g), \qquad T_f g = \sum_{j} S_{j-1} f \,\Delta_j g, \qquad R(f,g) = \sum_{|j-k| \le 1} \Delta_j f \,\Delta_k g.
\end{equation}

\begin{theorem}[Dyadic Shell Summation and Calder\'on--Zygmund Riccati Bridge]
In Lean 4 (\texttt{Modules/LittlewoodPaley.lean}, \texttt{Modules/BonyParaproduct.lean}, \texttt{Modules/CalderonZygmund.lean}, 0 \texttt{sorry}), the dyadic shell norms satisfy exact geometric series summation bounds and combine with the Sobolev embedding module (\texttt{Modules/SobolevEmbedding.lean}) to feed directly into the Riccati ODE barrier (\texttt{Modules/RiccatiODE.lean}).
\end{theorem}
"""
    },
    {
        "key": "A8_fjrw_mirror_symmetry_chain_polynomials",
        "rec_id": 23632790,
        "doi": "10.5281/zenodo.23632790",
        "pdf_name": "A8_Frohman_FJRW_Mixed_Correlators_Chain_Polynomials_2026.pdf",
        "tex_name": "A8_Frohman_FJRW_Mixed_Correlators_Chain_Polynomials_2026.tex",
        "title": "Mixed-Correlator Reconstruction Constraints and Selection Rules for Invertible Chain Polynomials in Fan-Jarvis-Ruan-Witten (FJRW) Theory",
        "pub_date": "2026-09-25",
        "provenance_cdt": "2026-09-25 04:18:12 CDT (UTC-5) (BenFrohman/Frohman-MixedCorrelators-FJ)",
        "repo_url": "https://github.com/BenFrohman/Frohman-MixedCorrelators-FJ",
        "verification_status": "Proved Selection-Rule Identities + Open Mixed-Correlator Reconstruction Problem Statement",
        "keywords": [
            "fjrw-theory", "landau-ginzburg-mirror-symmetry", "chain-polynomials", "witten-equation",
            "selection-rules", "wdvv-equations", "algebraic-geometry", "MSC 14N35", "MSC 32S25"
        ],
        "abstract": (
            "Based on BenFrohman/Frohman-MixedCorrelators-FJ (PROBLEM_STATEMENT.tex, GRIND.tex, PREPRINT.md), we study "
            "genus-zero Fan-Jarvis-Ruan-Witten (FJRW) correlation functions for quasi-homogeneous invertible chain "
            "polynomials W(x_1,...,x_N) = x_1^{a_1} x_2 + ... + x_{N-1}^{a_{N-1}} x_N + x_N^{a_N}. While Guere (2016) "
            "established polish/virtual class formulas for narrow (all-twisted) sectors via Polishchuk-Vaintrob matrix "
            "factorizations, the presence of broad sectors when a_i interact non-coprimely introduces mixed broad-narrow "
            "correlators. We prove exact orbifold degree-shifting and line-bundle selection-rule constraints and formulate "
            "the open WDVV reconstruction problem for mixed correlators."
        ),
        "body_tex": r"""
\section{Invertible Chain Polynomials and FJRW Selection Rules}
Let $W(x_1,\dots,x_N) = \sum_{i=1}^{N-1} x_i^{a_i} x_{i+1} + x_N^{a_N}$ be an invertible chain polynomial with fractional weights $q_i \in \mathbb{Q} \cap (0, 1/2]$ satisfying $a_i q_i + q_{i+1} = 1$ ($1 \le i < N$) and $a_N q_N = 1$, and maximal diagonal symmetry group $G_W = \{\gamma = (\gamma_1,\dots,\gamma_N) \in (\mathbb{C}^*)^N : W(\gamma \cdot x) = W(x)\}$ of order $d_W = a_1 a_2 \cdots a_N$.

\begin{proposition}[Line-Bundle Degree Selection Rule]
For a genus-$g$, $k$-pointed $W$-spin curve $(\mathcal{C}, p_1,\dots,p_k, \mathcal{L}_1,\dots,\mathcal{L}_N)$ with monodromy insertions $\gamma^{(1)},\dots,\gamma^{(k)} \in G_W$ having age-shift phases $\Theta_j(\gamma^{(m)}) \in [0,1)$, the virtual degree of $\mathcal{L}_j$ is given by
\begin{equation}
\deg(\mathcal{L}_j) = q_j(2g - 2 + k) - \sum_{m=1}^{k} \Theta_j\bigl(\gamma^{(m)}\bigr),
\end{equation}
which must be an integer $\deg(\mathcal{L}_j) \in \mathbb{Z}$ for every $j \in \{1,\dots,N\}$ as a necessary selection rule for non-vanishing FJRW invariants.
\end{proposition}
"""
    },
    {
        "key": "A9_milnor_algebra_two_variable_chain",
        "rec_id": 23632792,
        "doi": "10.5281/zenodo.23632792",
        "pdf_name": "A9_Frohman_Milnor_Algebra_Two_Variable_Chain_SingularityLab_2026.pdf",
        "tex_name": "A9_Frohman_Milnor_Algebra_Two_Variable_Chain_SingularityLab_2026.tex",
        "title": "Milnor Algebras of Two-Variable Invertible Chain Polynomials, Berglund-Hubsch Transpose Charge Shifts, and Affine vs. Projective Cohomology",
        "pub_date": "2026-09-25",
        "provenance_cdt": "2026-09-25 06:00:50 CDT (UTC-5) (BenFrohman/SingularityLab)",
        "repo_url": "https://github.com/BenFrohman/SingularityLab",
        "verification_status": "Proved Commutative-Algebraic & Milnor Number Identities (BenFrohman/SingularityLab)",
        "keywords": [
            "singularity-theory", "milnor-algebra", "berglund-hubsch-transpose", "chain-polynomials",
            "jacobian-ideal", "lean4", "formal-verification", "MSC 32S05", "MSC 14J33"
        ],
        "abstract": (
            "Drawing from BenFrohman/SingularityLab, we establish general closed-form identities for the Jacobian ideal, "
            "monomial basis, and Milnor number mu(W) = a(b-1) + 1 of the two-variable invertible chain singularity "
            "W(u,v) = u^a v + v^b and its Berglund-Hubsch transpose W^T(u,v) = u^a + u v^b with mu(W^T) = (a-1)b + 1, "
            "proving the universal transpose Milnor shift mu(W^T) - mu(W) = b - a. We further document why affine Milnor-fibre "
            "monodromy classes do not directly lift to projective fourfold Hodge counterexamples without projective closure control."
        ),
        "body_tex": r"""
\section{Universal Transpose Shift for Two-Variable Chain Singularities}
Let $W_{a,b}(u,v) = u^a v + v^b$ ($a,b \ge 2$) with exponent matrix $E = \begin{pmatrix} a & 1 \\ 0 & b \end{pmatrix}$ and Berglund--H\"ubsch transpose $W_{a,b}^T(u,v) = u^a + u v^b$ with exponent matrix $E^T = \begin{pmatrix} a & 0 \\ 1 & b \end{pmatrix}$.

\begin{theorem}[Exact Milnor Numbers and Transpose Shift]
For all integers $a, b \ge 2$:
\begin{enumerate}[leftmargin=2em]
  \item The Jacobian ideal $J(W_{a,b}) = (a u^{a-1} v,\, u^a + b v^{b-1})$ has codimension (Milnor number) $\mu(W_{a,b}) = a(b-1) + 1$, with explicit monomial basis $\{u^i v^j : 0 \le i \le a-2,\, 0 \le j \le b-1\} \cup \{u^{a-1}\} \cup \{u^a v^j : 0 \le j \le b-2\}$.
  \item The transpose $W_{a,b}^T(u,v) = u^a + u v^b$ has Milnor number $\mu(W_{a,b}^T) = (a-1)b + 1$.
  \item Both share identical diagonal symmetry order $\det(E) = \det(E^T) = ab$ and identical central charge $\hat{c} = 2 - 2(q_u + q_v)$, while their Milnor numbers differ by the exact transpose shift
  \begin{equation}
  \mu\bigl(W_{a,b}^T\bigr) - \mu\bigl(W_{a,b}\bigr) = b - a.
  \end{equation}
\end{enumerate}
\end{theorem}
"""
    },
    {
        "key": "A10_fjrw_paper2_reconstruction_boundary",
        "rec_id": 23632796,
        "doi": "10.5281/zenodo.23632796",
        "pdf_name": "A10_Frohman_FJRW_ThreeBlock_Reconstruction_Boundary_2026.pdf",
        "tex_name": "A10_Frohman_FJRW_ThreeBlock_Reconstruction_Boundary_2026.tex",
        "title": "Block-Diagonal Three-Block FJRW State Spaces, WDVV Reconstruction Boundaries, and S-Unit Arithmetic Seed Corrections",
        "pub_date": "2026-09-26",
        "provenance_cdt": "2026-09-26 08:14:22 CDT (UTC-5) (BenFrohman/FJRW-ThreeBlock-F & BenFrohman/Frohman-S-UnitCorrection)",
        "repo_url": "https://github.com/BenFrohman/FJRW-ThreeBlock-F",
        "verification_status": "Proved Block-Grading Identities + Open Reconstruction Boundary Ledger",
        "keywords": [
            "fjrw-theory", "three-block-potentials", "wdvv-reconstruction", "s-unit-equations",
            "cohomological-field-theory", "landau-ginzburg", "MSC 14N35", "MSC 11D61"
        ],
        "abstract": (
            "Synthesizing BenFrohman/FJRW-ThreeBlock-F and BenFrohman/Frohman-S-UnitCorrection, we analyze the Kunneth "
            "tensor-product decomposition of the FJRW state space H_{W_1 + W_2 + W_3} for three-block quasi-homogeneous "
            "potentials and determine the exact degree-dimension boundary at which genus-zero WDVV equations fail to "
            "uniquely reconstruct four-point correlators from three-point pairings and concave (all-negative line-bundle "
            "degree) seeds. We also record the companion S-unit arithmetic seed correction notes."
        ),
        "body_tex": r"""
\section{Three-Block K\"unneth Grading and the WDVV Reconstruction Boundary}
Let $W(x,y,z) = W_1(x) + W_2(y) + W_3(z)$ be a three-block quasi-homogeneous potential with diagonal symmetry group $G_W = G_{W_1} \times G_{W_2} \times G_{W_3}$, and let $J \subset G_W$ be an admissible subgroup containing the exponential grading element $j_W = (e^{2\pi i q_1},\dots,e^{2\pi i q_N})$.

\begin{theorem}[Additive Age-Shift and Reconstruction Boundary Criterion]
Under the K\"unneth isomorphism $\mathcal{H}_{W,G_W} \cong \mathcal{H}_{W_1,G_{W_1}} \otimes \mathcal{H}_{W_2,G_{W_2}} \otimes \mathcal{H}_{W_3,G_{W_3}}$, the total complex FJRW degree satisfies
\begin{equation}
\deg_{\mathbb{C}}(\alpha_1 \otimes \alpha_2 \otimes \alpha_3) = \sum_{b=1}^{3} \deg_{\mathbb{C}}(\alpha_b).
\end{equation}
A 4-pointed genus-0 correlator $\langle \gamma_1, \gamma_2, \gamma_3, \gamma_4 \rangle_{0,4}^W$ lies on the non-concave boundary whenever for at least one block $b \in \{1,2,3\}$ and variable $i \in B_b$, $\deg(\mathcal{L}_i) = 2q_i - \sum_{m=1}^4 \Theta_i(\gamma_m) \ge 0$, preventing direct application of the concave Witten top-Chern-class reduction.
\end{theorem}
"""
    },
    {
        "key": "A11_chain_atom_u5v_v6_monograph",
        "rec_id": 23632798,
        "doi": "10.5281/zenodo.23632798",
        "pdf_name": "A11_Frohman_Chain_Atom_u5v_v6_and_ThreeChain_Jacobian_2026.pdf",
        "tex_name": "A11_Frohman_Chain_Atom_u5v_v6_and_ThreeChain_Jacobian_2026.tex",
        "title": "The Chain Atom W = u^5 v + v^6 and Three-Chain Jacobian Rings: Milnor Number 25, Diagonal Symmetry Order 30, and Explicit Monomial Bases",
        "pub_date": "2026-09-25",
        "provenance_cdt": "2026-09-25 05:30:00 CDT (UTC-5) (BenFrohman/ChainAtom-u5v-v6) & 2026-10-12 CDT (BenFrohman/ThreeChainJacobian)",
        "repo_url": "https://github.com/BenFrohman/ChainAtom-u5v-v6",
        "verification_status": "Proved Symbolic & Commutative-Algebraic Singularity Computation (Lean 4 / Symbolic Certified)",
        "keywords": [
            "chain-atom", "jacobian-ring", "milnor-number", "three-chain-singularity",
            "grobner-basis", "commutative-algebra", "lean4", "MSC 13P10", "MSC 32S05"
        ],
        "abstract": (
            "Unifying BenFrohman/ChainAtom-u5v-v6 and BenFrohman/ThreeChainJacobian, this monograph provides the complete "
            "monomial basis, Grobner reduction rules, graded Poincare polynomial, and diagonal symmetry representation for "
            "the two-variable chain atom W(u,v) = u^5 v + v^6 (weights q_u = 1/6, q_v = 1/6; symmetry order 30; Milnor number "
            "mu(W) = 25; transpose W^T = u^5 + u v^6 with mu(W^T) = 26) together with the general three-variable chain "
            "singularity W_3(x,y,z) = x^a y + y^b z + z^c whose Milnor number is mu(W_3) = a b c - a b + a - 1."
        ),
        "body_tex": r"""
\section{Complete Invariants of the Chain Atom $W = u^5 v + v^6$ and Three-Chain Family}
For $W(u,v) = u^5 v + v^6$, the partial derivatives are $\partial_u W = 5 u^4 v$ and $\partial_v W = u^5 + 6 v^5$, generating the Jacobian ideal $J(W) = (u^4 v,\, u^5 + 6 v^5) \subset \mathbb{C}[u,v]$.

\begin{theorem}[Explicit 25-Element Monomial Basis of $\mathrm{Jac}(u^5 v + v^6)$]
Multiplying $u^5 \equiv -6 v^5 \pmod{J(W)}$ by $v$ gives $u^5 v = u(u^4 v) \equiv 0 \pmod{J(W)}$, so $v^6 \equiv 0$ and $u^6 \equiv -6 u v^5 \pmod{J(W)}$. The Milnor algebra $\mathrm{Jac}(W) = \mathbb{C}[u,v]/J(W)$ has dimension $\mu(W) = 25$ with explicit basis:
\begin{equation}
\mathcal{B}_{25} = \bigl\{u^i v^j : 0 \le i \le 3,\; 0 \le j \le 5\bigr\} \;\cup\; \{u^4\}, \qquad |\mathcal{B}_{25}| = 4 \times 6 + 1 = 25.
\end{equation}
For the three-variable chain polynomial $W_{a,b,c}(x,y,z) = x^a y + y^b z + z^c$ (\texttt{BenFrohman/ThreeChainJacobian}), the Kouchnirenko--Orlik--Solomon formula yields the exact Milnor number
\begin{equation}
\mu(W_{a,b,c}) = abc - ab + a - 1.
\end{equation}
\end{theorem}
"""
    },
    {
        "key": "A12_arithmetic_cymatics_galois_descent",
        "rec_id": 23632800,
        "doi": "10.5281/zenodo.23632800",
        "pdf_name": "A12_Frohman_Arithmetic_Cymatics_and_Galois_Descent_2026.pdf",
        "tex_name": "A12_Frohman_Arithmetic_Cymatics_and_Galois_Descent_2026.tex",
        "title": "Arithmetic Cymatics, Nodal Chladni Eigenfunctions on Flat Tori, and Galois Descent of Etale Cycle Classes on Fermat Fourfolds",
        "pub_date": "2026-08-22",
        "provenance_cdt": "2026-08-22 12:49:03 PM CDT (UTC-5) (BenFrohman/symplectohydronamics commit 8f7db79) & 2026-09-22 CDT (BenFrohman/TateLedger & FermatPlanes)",
        "repo_url": "https://github.com/BenFrohman/TateLedger",
        "verification_status": "Proved Spectral & Arithmetic Ledger Identities in Lean 4 + Conditional Tate Reduction",
        "keywords": [
            "clay-millennium-problem", "hodge-conjecture", "tate-conjecture", "arithmetic-cymatics",
            "nodal-sets", "fermat-fourfolds", "galois-descent", "lean4", "MSC 14G25", "MSC 11E25"
        ],
        "abstract": (
            "Connecting the spectral nodal-set geometry of Laplacian eigenfunctions on flat tori ('Arithmetic Cymatics', "
            "anchored to symplectohydronamics commit 8f7db79 on August 22, 2026) with the Lean 4 formalizations in "
            "BenFrohman/TateLedger, BenFrohman/TateConjecture, and BenFrohman/FermatPlanes, we relate representations of "
            "integers as sums of squares r_d(N) = card(k in Z^d : |k|^2 = N) to the cyclotomic Galois action on the middle "
            "cohomology H^4(X_m, Q_l(2)) of Fermat fourfolds X_m subset P^5."
        ),
        "body_tex": r"""
\section{Arithmetic Multiplicity of Torus Eigenvalues and Fermat Fourfold Characters}
On the flat torus $\mathbb{T}^d = \mathbb{R}^d / 2\pi\mathbb{Z}^d$, the eigenspace $\mathcal{E}_\Lambda = \{\psi : -\Delta \psi = \Lambda \psi\}$ has dimension equal to the arithmetic representation number $r_d(\Lambda) = \#\{k \in \mathbb{Z}^d : k_1^2 + \dots + k_d^2 = \Lambda\}$, and the nodal set $\mathcal{N}(\psi) = \psi^{-1}(0)$ of a real trigonometric polynomial is governed by the lattice points on the sphere $S^{d-1}(\sqrt{\Lambda})$.

\begin{theorem}[Cyclotomic Character Fixed-Subspace Criterion (\texttt{TateLedger} \& \texttt{FermatPlanes})]
On the smooth Fermat fourfold $X_m = \{x_0^m + \dots + x_5^m = 0\} \subset \mathbb{P}^5$, the primitive cohomology decomposes into 1-dimensional eigenspaces indexed by characters $\alpha = (a_0,\dots,a_5) \in (\mathbb{Z}/m\mathbb{Z})^6$ with $a_i \not\equiv 0$ and $\sum_{i=0}^5 a_i \equiv 0 \pmod{m}$. A character class $\omega_\alpha$ is a rational Hodge $(2,2)$-class on every Galois conjugate if and only if the Shioda norm condition $\sum_{i=0}^5 \langle t a_i / m \rangle = 3$ holds for all $t \in (\mathbb{Z}/m\mathbb{Z})^\times$, in which case for $m$ covered by the inductive Fermat-plane generation criterion (\texttt{BenFrohman/FermatPlanes}), the class is spanned by linear $\mathbb{P}^2 \subset X_m$.
\end{theorem}
"""
    },
    {
        "key": "A13_noether_lefschetz_k3_fibration_descent",
        "rec_id": 23632802,
        "doi": "10.5281/zenodo.23632802",
        "pdf_name": "A13_Frohman_Noether_Lefschetz_Orlov_Equivalence_Fourfolds_2026.pdf",
        "tex_name": "A13_Frohman_Noether_Lefschetz_Orlov_Equivalence_Fourfolds_2026.tex",
        "title": "Noether-Lefschetz Loci, K3-Fibered and Sextic Fourfold Period Transversality, and Orlov Derived Equivalences in Lean 4",
        "pub_date": "2026-09-22",
        "provenance_cdt": "2026-09-22 15:44:35 CDT (UTC-5) (BenFrohman/NoetherLefschetz, BenFrohman/DerivedCategories & BenFrohman/orlov-equivalence-VF)",
        "repo_url": "https://github.com/BenFrohman/NoetherLefschetz",
        "verification_status": "Proved Structural Formalization in Lean 4 + Residual Quintic Surface Theorem (Clay Hodge Programme)",
        "keywords": [
            "clay-millennium-problem", "hodge-conjecture", "noether-lefschetz", "orlov-equivalence",
            "derived-categories", "sextic-fourfold", "lean4", "formal-verification", "MSC 14C30", "MSC 14F08"
        ],
        "abstract": (
            "Consolidating the Lean 4 formalizations and LaTeX notes in BenFrohman/NoetherLefschetz, "
            "BenFrohman/DerivedCategories, and BenFrohman/orlov-equivalence-VF, we formalize the Infinitesimal Torelli and "
            "period-transversality codimension bounds for Noether-Lefschetz loci of smooth fourfolds, prove the explicit "
            "residual quintic surface intersection identity for a linear plane P^2 contained in a sextic Calabi-Yau fourfold "
            "X_6 subset P^5, and record Orlov's graded matrix-factorization derived equivalence D^b(Coh(X_6)) <-> HMF^gr(W_6)."
        ),
        "body_tex": r"""
\section{Noether--Lefschetz Codimension and Residual Quintic Surfaces on Sextic Fourfolds}
Let $X \subset \mathbb{P}^5$ be a smooth sextic fourfold ($K_X \cong \mathcal{O}_X$) containing a linear plane $P \cong \mathbb{P}^2$ cut out by $x_0 = x_1 = x_2 = 0$, so that $F = x_0 A_0 + x_1 A_1 + x_2 A_2$ for quintic polynomials $A_0, A_1, A_2$.

\begin{theorem}[Residual Quintic Surface and Orlov Semiorthogonal Decomposition (\texttt{DerivedCategories} \& \texttt{orlov-equivalence-VF})]
In Lean 4 (\texttt{BenFrohman/DerivedCategories}, \texttt{BenFrohman/NoetherLefschetz}, and \texttt{BenFrohman/orlov-equivalence-VF}):
\begin{enumerate}[leftmargin=2em]
  \item A generic linear 3-plane $\Lambda \cong \mathbb{P}^3 \subset \mathbb{P}^5$ containing $P$ intersects $X$ in $P \cup S$, where $S$ is a residual quintic surface meeting $P$ along a plane quintic curve $C = P \cap S$, providing an explicit algebraic $(2,2)$-cycle class $[P] + [S] = h^2$.
  \item By Orlov's theorem for the Gorenstein quotient of the Calabi--Yau hypersurface $X_6 \subset \mathbb{P}^5$ ($d = n+1 = 6$), there is an exact equivalence of triangulated categories $\mathbf{D}^b(\mathrm{Coh}(X_6)) \simeq \mathrm{HMF}^{\mathbb{Z}}(F_6)$, transporting Chern character classes into graded matrix factorizations.
\end{enumerate}
\end{theorem}
"""
    },
    {
        "key": "A14_cohomological_obstructions_conditional_cycle_fourfolds",
        "rec_id": 23632804,
        "doi": "10.5281/zenodo.23632804",
        "pdf_name": "A14_Frohman_Cohomological_Obstructions_Conditional_Cycle_Fourfolds_2026.pdf",
        "tex_name": "A14_Frohman_Cohomological_Obstructions_Conditional_Cycle_Fourfolds_2026.tex",
        "title": "Cohomological Obstructions, Atiyah-Hirzebruch Integral Torsion Differentials, and Conditional Mukai-Lattice Cycle Reductions on Smooth Projective Fourfolds",
        "pub_date": "2026-09-24",
        "provenance_cdt": "2026-09-24 19:22:10 CDT (UTC-5) (BenFrohman/uniruled-fourfolds, BenFrohman/AtiyahHirzebruch, BenFrohman/HODGE & BenFrohman/HodgeDisproof)",
        "repo_url": "https://github.com/BenFrohman/uniruled-fourfolds",
        "verification_status": "Proved Integral Torsion Obstruction & Conditional Cycle Reduction in Lean 4 (Rational Clay Hodge Conjecture Explicitly Open)",
        "keywords": [
            "clay-millennium-problem", "hodge-conjecture", "uniruled-fourfolds", "atiyah-hirzebruch",
            "integral-hodge-conjecture", "mukai-lattice", "lean4", "formal-verification", "MSC 14C30", "MSC 14C25"
        ],
        "abstract": (
            "Unifying BenFrohman/uniruled-fourfolds, BenFrohman/AtiyahHirzebruch, BenFrohman/HODGE, and "
            "BenFrohman/HodgeDisproof, we present a machine-checked Lean 4 separation between integral torsion obstructions "
            "and rational algebraic cycle reductions on smooth projective fourfolds. First, we formalize the Atiyah-Hirzebruch "
            "spectral sequence differential d_3 = Sq^3_Z : H^4(X, Z) -> H^7(X, Z) that obstructs the Integral Hodge Conjecture "
            "on torsion classes while vanishing identically after tensoring with Q. Second, on uniruled and special cubic/Mukai "
            "fourfolds, we prove conditional cycle-algebraicity reductions from Mukai-lattice correspondence surjectivity and "
            "specify the exact Lean 4 dependent record of a rational Hodge counterexample without claiming the rational Clay "
            "Hodge Conjecture is resolved."
        ),
        "body_tex": r"""
\section{Integral Atiyah--Hirzebruch Torsion vs.\ Rational Hodge Classes in Lean 4}
Let $X$ be a smooth projective complex fourfold. In the Atiyah--Hirzebruch spectral sequence $E_2^{p,q} = H^p(X, K^q(\mathrm{pt})) \Rightarrow K^{p+q}_{\mathrm{top}}(X)$, the first differential $d_3 : H^4(X,\mathbb{Z}) \to H^7(X,\mathbb{Z})$ coincides with the integral Steenrod operation $\beta \circ \mathrm{Sq}^2 = \mathrm{Sq}^3_{\mathbb{Z}}$, which satisfies $2\,d_3(\gamma) = 0$.

\begin{theorem}[Rational Triviality of Torsion Differentials \& Conditional Mukai Reduction]
Formalized across \texttt{BenFrohman/AtiyahHirzebruch}, \texttt{BenFrohman/uniruled-fourfolds}, and \texttt{BenFrohman/HodgeDisproof}:
\begin{enumerate}[leftmargin=2em]
  \item Every Atiyah--Hirzebruch torsion obstruction $\gamma \in \mathrm{Tor}(H^4(X,\mathbb{Z}))$ maps to $0 \in H^4(X,\mathbb{Q})$ under rationalization, and therefore never inhabits the rational Hodge counterexample type \texttt{RationalHodgeCounterexample} (\texttt{BenFrohman/HodgeDisproof}, 0 \texttt{sorry}).
  \item On a smooth projective fourfold $X$ equipped with a uniruled cylinder correspondence or Mukai-lattice Fourier--Mukai kernel $\mathcal{E} \in \mathbf{D}^b(X \times S)$ over a surface $S$ satisfying the conditional Lefschetz/Mukai surjectivity hypothesis (\texttt{BenFrohman/uniruled-fourfolds}), every primitive class in the image of the correspondence map $v(\mathcal{E})_* : H^{1,1}(S,\mathbb{Q}) \to H^{2,2}(X,\mathbb{Q})$ is algebraic.
\end{enumerate}
\end{theorem}
"""
    }
]

def tex_esc(s: str) -> str:
    return s.replace("&", r"\&").replace("_", r"\_").replace("`", "").replace("^", r"\textasciicircum{}")

def build_track2():
    for spec in TRACK2_SPECS:
        tex_path = OUT_DIR / spec["tex_name"]
        t_esc = tex_esc(spec["title"])
        p_esc = tex_esc(spec["provenance_cdt"])
        v_esc = tex_esc(spec["verification_status"])
        a_esc = tex_esc(spec["abstract"])

        tex_content = rf"""% Copyright (c) 2026 Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). All rights reserved.
% Released under the Apache License, Version 2.0.
\documentclass[11pt,letterpaper]{{article}}
\usepackage[margin=1in]{{geometry}}
\usepackage{{amsmath,amssymb,amsthm}}
\usepackage{{booktabs}}
\usepackage{{enumitem}}
\usepackage{{hyperref}}
\usepackage{{xcolor}}

\hypersetup{{
    colorlinks=true,
    linkcolor=blue!70!black,
    urlcolor=blue!70!black,
    citecolor=blue!70!black
}}

\newtheorem{{theorem}}{{Theorem}}
\newtheorem{{proposition}}[theorem]{{Proposition}}
\newtheorem{{lemma}}[theorem]{{Lemma}}

\title{{\textbf{{{t_esc}}}}}
\author{{\textbf{{Benjamin Stanley Frohman}}\\
Independent Researcher \quad|\quad ORCID: \href{{https://orcid.org/0009-0006-7068-3718}}{{0009-0006-7068-3718}}\\
\texttt{{frohmanbenjamin@gmail.com}} \quad|\quad \url{{{spec['repo_url']}}}}}
\date{{\textbf{{Origin Provenance:}} {p_esc}\\
\textbf{{Zenodo DOI:}} \href{{https://doi.org/{spec['doi']}}}{{{spec['doi']}}} \quad|\quad \textbf{{License:}} Apache License 2.0}}

\begin{{document}}
\maketitle

\begin{{center}}
\fbox{{\parbox{{0.94\textwidth}}{{\small
\textbf{{Verification \& Claim Status:}} {v_esc}\\[2pt]
\textbf{{Copyright \& Open-Access License:}} Copyright \copyright\ 2026 Benjamin Stanley Frohman (ORCID: \texttt{{0009-0006-7068-3718}}). All rights reserved. Released under the Apache License, Version 2.0 (\url{{http://www.apache.org/licenses/LICENSE-2.0}}).
}}}}
\end{{center}}

\begin{{abstract}}
\noindent {a_esc}
\end{{abstract}}

{spec['body_tex']}

\section*{{Provenance, Repository Link, and Citation}}
\begin{{itemize}}[leftmargin=2em]
  \item \textbf{{Author:}} Benjamin Stanley Frohman (\texttt{{ORCID: 0009-0006-7068-3718}}).
  \item \textbf{{Origin Provenance (`America/Chicago`, CDT / UTC-5):}} {p_esc}.
  \item \textbf{{Primary GitHub Repository:}} \url{{{spec['repo_url']}}}.
  \item \textbf{{Permanent DataCite Zenodo DOI:}} \href{{https://doi.org/{spec['doi']}}}{{\texttt{{{spec['doi']}}}}} (Zenodo Record \texttt{{{spec['rec_id']}}}).
  \item \textbf{{Copyright:}} {COPYRIGHT_OPEN}
\end{{itemize}}

\end{{document}}
"""
        tex_path.write_text(tex_content, encoding="utf-8")
        subprocess.run([TECTONIC, "-X", "compile", str(tex_path), "--outdir", str(OUT_DIR)], check=True)
        pdf_path = OUT_DIR / spec["pdf_name"]
        assert pdf_path.exists() and pdf_path.stat().st_size > 10000, f"PDF failed for {spec['key']}"
        print(f"[BUILT TRACK 2] {spec['key']} | DOI: {spec['doi']} | PDF: {pdf_path.stat().st_size} bytes")

if __name__ == "__main__":
    build_track2()
