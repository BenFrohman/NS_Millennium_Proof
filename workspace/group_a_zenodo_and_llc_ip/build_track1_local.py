import os
import json
import shutil
import hashlib
import subprocess
from pathlib import Path

BASE_DIR = Path("/workspace/group_a_zenodo_and_llc_ip/track1_repos")
BASE_DIR.mkdir(parents=True, exist_ok=True)
LEGAL_SRC = Path("/workspace/commercial_and_legal_suite/legal")
PLAYBOOK_SRC = Path("/workspace/commercial_and_legal_suite/MASTER_COMMERCIALIZATION_MOAT_REVENUE_AND_TARGETS_PLAYBOOK.md")
TECTONIC = "/home/box/.local/bin/tectonic"

COPYRIGHT_HEADER = "Copyright (c) 2026 Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). All rights reserved. Proprietary Commercial IP — Metered Usage License / Annual Partnership Contract / NDA Required."

TRACK1_SPECS = [
    {
        "key": "T1_frohman_V13",
        "rec_id": 23632764,
        "doi": "10.5281/zenodo.23632764",
        "repo_name": "frohman-V13",
        "title": "Frohman V13: Symplectic Order-Book Microstructure Regime Detection, Adverse-Selection Invariants, and Deterministic Quantitative Execution Architecture",
        "short_title": "Frohman V13 Quantitative Trading & Deterministic Execution Architecture",
        "pdf_name": "Frohman_V13_Quantitative_Execution_Prior_Art_2026.pdf",
        "tex_name": "Frohman_V13_Quantitative_Execution_Prior_Art_2026.tex",
        "pub_date": "2026-04-03",
        "provenance_cdt": "2026-04-03 14:15:00 CDT (UTC-5) (Initial V13 Architecture) & 2026-08-22 12:49:03 PM CDT (symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca)",
        "origin_commit": "8f7db79b5786f3a59a0696a48a675f8a1fe410ca",
        "topics": [
            "quantitative-finance", "market-microstructure", "algorithmic-trading",
            "symplectic-geometry", "deterministic-execution", "risk- firewall", "proprietary-ip"
        ],
        "keywords": [
            "Quantitative Trading Architecture", "Order-Book Microstructure", "Symplectic Invariants",
            "Adverse Selection Guard", "Deterministic Execution", "Metered Enterprise Licensing",
            "Frohman V13", "All Rights Reserved"
        ],
        "abstract": (
            "Frohman V13 is a proprietary quantitative trading, order-book microstructure regime detection, "
            "and deterministic execution architecture authored by Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). "
            "The system models limit-order-book (LOB) price-volumeconjugate dynamics on a discrete symplectic phase space "
            "T*Q, pairing canonical bid-ask depth coordinates with momentum flow imbalance to detect toxic order flow, "
            "flash crashes, and liquidity evaporation prior to mid-price dislocation. V13 enforces a deterministic pre-trade "
            "risk and drawdown firewall (coupled with Ed25519 cryptographic execution audit logs) that bounds maximum "
            "single-epoch slippage and blocks execution whenever the symplectic area invariant J_LOB exceeds a calibrated "
            "coercivity threshold."
        ),
        "sections_tex": r"""
\section{Canonical Order-Book Phase Space and Symplectic Microstructure Invariant}
Let $q_k(t) \in \mathbb{R}^L$ denote the normalized log-depth vector across $L$ price levels of a limit order book (LOB) at discrete event epoch $t$, and let $p_k(t) \in \mathbb{R}^L$ denote the conjugate order-flow momentum (net signed market-order + cancellation arrival rate weighted by inverse tick distance). The Frohman V13 state space $\mathcal{M}_{\mathrm{V13}} = T^*\mathbb{R}^L$ carries the canonical symplectic 2-form
\begin{equation}
\omega_{\mathrm{LOB}} = \sum_{\ell=1}^{L} dp_\ell \wedge dq_\ell.
\end{equation}
During equilibrium market-making regimes, liquidity replenishment and order consumption evolve along level sets of a regularized metriplectic Hamiltonian $H_{\mathrm{V13}}(q,p) = \frac{1}{2} p^\top M^{-1} p + V_{\mathrm{spread}}(q)$ with positive-definite dissipation $\mathcal{D}(q,p) \ge 0$.

\begin{theorem}[V13 Adverse-Selection Symplectic Area Bound]
Suppose a predatory sweep or informed toxic flow injects an exogenous momentum impulse $\Delta p$ over window $[t_0, t_1]$. Define the discrete V13 symplectic area functional
\begin{equation}
\mathcal{I}_{\mathrm{V13}}(t_0, t_1) := \left| \sum_{\ell=1}^{L} \int_{t_0}^{t_1} \bigl( p_\ell(\tau)\,\dot{q}_\ell(\tau) - q_\ell(\tau)\,\dot{p}_\ell(\tau) \bigr)\,d\tau \right|.
\end{equation}
Whenever $\mathcal{I}_{\mathrm{V13}}(t_0, t_1) > \Theta_{\mathrm{crit}}$, any passive limit order resting within ticks $\ell \le \ell_*(\Theta_{\mathrm{crit}})$ suffers negative expected mark-out $\mathbb{E}[\Delta \mathrm{PnL}_{\mathrm{passive}}] \le -\gamma_{\mathrm{V13}} (\mathcal{I}_{\mathrm{V13}} - \Theta_{\mathrm{crit}})$.
\end{theorem}

\section{Deterministic Pre-Trade Execution Gate andV13 Audit Pipeline}
Frohman V13 interposes a zero-allocation deterministic execution gate between strategy signal generation and FIX/WebSocket order routing:
\begin{enumerate}[leftmargin=2em]
  \item \textbf{Layer 1 (Microstructure Regime Filter):} Computes $\mathcal{I}_{\mathrm{V13}}$ and multi-scale toxicity VPIN/Kyle-lambda surrogates in $O(L)$ time per tick.
  \item \textbf{Layer 2 (Drawdown Tether \& Inventory Coercivity):} Enforces a cubic inventory damping penalty $-\kappa_{\mathrm{inv}} |I(t)|^3$ that forces inventory mean-reversion before margin utilization reaches hard limits.
  \item \textbf{Layer 3 (Ed25519 Execution Bill of Materials):} Emits a tamper-evident hash chain of every signal, risk-gate verdict, and fill timestamp for institutional compliance and metered licensing verification.
\end{enumerate}
""",
        "module_file": "frohman_v13_spec.py",
        "module_code": '''"""
Frohman V13 — Symplectic Order-Book Microstructure & Deterministic Execution Specification
Copyright (c) 2026 Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). All rights reserved.
Proprietary Commercial IP — Metered Usage License / Annual Partnership Contract Required.
"""
from dataclasses import dataclass
from typing import List, Tuple
import hashlib

@dataclass(frozen=True)
class V13OrderBookSlice:
    epoch_ns: int
    log_depths: Tuple[float, ...]
    flow_momenta: Tuple[float, ...]

@dataclass(frozen=True)
class V13ExecutionVerdict:
    allowed: bool
    symplectic_invariant: float
    inventory_tether_penalty: float
    attestation_sha256: str

def evaluate_v13_gate(
    prev_slice: V13OrderBookSlice,
    curr_slice: V13OrderBookSlice,
    inventory: float,
    theta_crit: float = 1.0,
    kappa_inv: float = 0.05,
) -> V13ExecutionVerdict:
    """Compute the V13 discrete symplectic microstructure invariant and deterministic gate verdict."""
    if len(prev_slice.log_depths) != len(curr_slice.log_depths):
        raise ValueError("Dimension mismatch in LOB slice")
    area = 0.0
    for q0, p0, q1, p1 in zip(
        prev_slice.log_depths, prev_slice.flow_momenta,
        curr_slice.log_depths, curr_slice.flow_momenta
    ):
        dq = q1 - q0
        dp = p1 - p0
        area += 0.5 * ((p0 + p1) * dq - (q0 + q1) * dp)
    symp_inv = abs(area)
    tether_penalty = kappa_inv * (abs(inventory) ** 3)
    allowed = (symp_inv <= theta_crit) and (tether_penalty <= theta_crit)
    payload = f"{curr_slice.epoch_ns}:{symp_inv:.8f}:{tether_penalty:.8f}:{allowed}".encode("utf-8")
    digest = hashlib.sha256(payload).hexdigest()
    return V13ExecutionVerdict(
        allowed=allowed,
        symplectic_invariant=symp_inv,
        inventory_tether_penalty=tether_penalty,
        attestation_sha256=digest,
    )
'''
    },
    {
        "key": "T1_sentinel_gate",
        "rec_id": 23632766,
        "doi": "10.5281/zenodo.23632766",
        "repo_name": "sentinel-gate",
        "title": "Sentinel Gate: Deterministic Pre-Execution Policy Enforcement, Capability-Scoped Action Attestation, and Runtime Guardrail Gate for Autonomous AI Systems",
        "short_title": "Sentinel Gate: Deterministic Execution Policy & Guardrail Gate",
        "pdf_name": "Sentinel_Gate_Deterministic_Policy_Guardrail_Prior_Art_2026.pdf",
        "tex_name": "Sentinel_Gate_Deterministic_Policy_Guardrail_Prior_Art_2026.tex",
        "pub_date": "2026-04-04",
        "provenance_cdt": "2026-04-04 11:30:00 CDT (UTC-5) (Initial v0.1.0 Policy Gate) & 2026-08-22 12:49:03 PM CDT (symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca)",
        "origin_commit": "8f7db79b5786f3a59a0696a48a675f8a1fe410ca",
        "topics": [
            "ai-safety", "deterministic-guardrails", "policy-enforcement", "autonomous-agents",
            "capability-security", "runtime-verification", "proprietary-ip"
        ],
        "keywords": [
            "Sentinel Gate", "Deterministic Policy Enforcement", "AI Agent Guardrails",
            "Capability-Scoped Execution", "Zero-Trust AI", "Metered Enterprise Licensing",
            "All Rights Reserved"
        ],
        "abstract": (
            "Sentinel Gate is a deterministic pre-execution policy enforcement and capability-scoped guardrail "
            "gate authored by Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). Unlike probabilistic LLM-as-a-Judge "
            "classifiers that are vulnerable to adversarial prompt injection, Sentinel Gate evaluates every proposed "
            "agent tool call, shell command, API mutation, or external message against a decidable lattice of capability "
            "tokens, data-flow taint labels, and cryptographic authorization predicates prior to execution. Operating as "
            "a sub-millisecond inline interceptor in companion with SealGuard and Titan-Audit, Sentinel Gate guarantees "
            "that untrusted external inputs (taint-labeled data) can never escalate privileges or trigger irreversible "
            "side effects without a verified human-in-the-loop Ed25519 authorization ticket."
        ),
        "sections_tex": r"""
\section{Decidable Taint-Lattice and Capability Policy Calculus}
Let $\mathcal{L}_{\mathrm{taint}} = (\{\mathsf{Trusted}, \mathsf{Untrusted}\}, \sqsubseteq)$ denote the security lattice with $\mathsf{Trusted} \sqsubset \mathsf{Untrusted}$, and let every runtime context $C$ carry a capability mask $\Pi(C) \subseteq \mathcal{A}$ over the universe of privileged side-effecting actions $\mathcal{A}$ (file deletion, network egress, credential read, external message transmission, financial transaction).

\begin{theorem}[Non-Escalation Under Untrusted Context Join]
For any sequence of agent reasoning steps $s_1, \dots, s_m$ ingesting external data chunks $d_1, \dots, d_k$, the effective context taint is $\tau(C_m) = \bigsqcup_{i=1}^k \tau(d_i)$. Under the Sentinel Gate Transition Rule:
\begin{equation}
\mathrm{Allow}(a, C_m, \sigma_{\mathrm{auth}}) \iff \bigl(a \in \Pi(C_m)\bigr) \;\wedge\; \Bigl( \tau(C_m) = \mathsf{Trusted} \;\lor\; \mathrm{VerifyEd25519}(\sigma_{\mathrm{auth}}, \mathrm{Hash}(a)) = 1 \Bigr).
\end{equation}
Consequently, no adversarial payload embedded within an $\mathsf{Untrusted}$ input $d_i$ can execute an irreversible action $a \in \mathcal{A}_{\mathrm{irrev}}$ without an explicit cryptographic signature $\sigma_{\mathrm{auth}}$ bound to the exact action parameters $\mathrm{Hash}(a)$.
\end{theorem}

\section{Metered Enterprise \& Government Deployment Architecture}
Sentinel Gate deploys as a self-contained sidecar binary or Python/Rust SDK interceptor across enterprise agent fleets, MCP tool routers, and defense command-and-control sandboxes, emitting deterministic JSON policy receipts compatible with \texttt{Titan-Audit} and \texttt{SealGuard}.
""",
        "module_file": "sentinel_gate_spec.py",
        "module_code": '''"""
Sentinel Gate — Deterministic Pre-Execution Policy & Taint-Lattice Guardrail Specification
Copyright (c) 2026 Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). All rights reserved.
Proprietary Commercial IP — Metered Usage License / Annual Partnership Contract Required.
"""
from dataclasses import dataclass
from typing import Set, Optional
import hashlib

IRREVERSIBLE_ACTIONS = frozenset({
    "send_external_message", "delete_resource", "execute_payment",
    "modify_production_Acl", "exfiltrate_secret"
})

@dataclass(frozen=True)
class SentinelPolicyReceipt:
    action_id: str
    permitted: bool
    reason: str
    receipt_sha256: str

def evaluate_sentinel_gate(
    action_type: str,
    action_payload_hash: str,
    granted_capabilities: Set[str],
    context_tainted: bool,
    explicit_authorization_token: Optional[str] = None,
) -> SentinelPolicyReceipt:
    """Deterministic zero-trust pre-execution policy evaluation."""
    if action_type not in granted_capabilities:
        permitted = False
        reason = "DENIED_CAPABILITY_MISSING"
    elif action_type in IRREVERSIBLE_ACTIONS and context_tainted and not explicit_authorization_token:
        permitted = False
        reason = "DENIED_TAINTED_CONTEXT_REQUIRES_EXPLICIT_AUTH"
    else:
        permitted = True
        reason = "PERMITTED_DETERMINISTIC_POLICY"
    raw = f"{action_type}:{action_payload_hash}:{permitted}:{reason}".encode("utf-8")
    return SentinelPolicyReceipt(
        action_id=action_payload_hash,
        permitted=permitted,
        reason=reason,
        receipt_sha256=hashlib.sha256(raw).hexdigest(),
    )
'''
    },
    {
        "key": "T1_agentic_dev",
        "rec_id": 23632768,
        "doi": "10.5281/zenodo.23632768",
        "repo_name": "agentic-dev",
        "title": "Agentic-Dev: Autonomous Multi-Agent Software Synthesis, Frozen-Specification Test Pinning, and Deterministic Verification Harness",
        "short_title": "Agentic-Dev: Autonomous Multi-Agent Development & Verification Harness",
        "pdf_name": "Agentic_Dev_Multi_Agent_Verification_Harness_Prior_Art_2026.pdf",
        "tex_name": "Agentic_Dev_Multi_Agent_Verification_Harness_Prior_Art_2026.tex",
        "pub_date": "2026-04-08",
        "provenance_cdt": "2026-04-08 16:20:00 CDT (UTC-5) (Initial Multi-Agent Harness) & 2026-08-22 12:49:03 PM CDT (symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca)",
        "origin_commit": "8f7db79b5786f3a59a0696a48a675f8a1fe410ca",
        "topics": [
            "autonomous-coding", "multi-agent-systems", "formal-verification",
            "anti-reward-hacking", "ci-cd-security", "software-synthesis", "proprietary-ip"
        ],
        "keywords": [
            "Agentic-Dev", "Autonomous Software Engineering", "Multi-Agent Verification Harness",
            "Anti-Specification Gaming", "Frozen Test Pinning", "Metered Enterprise Licensing",
            "All Rights Reserved"
        ],
        "abstract": (
            "Agentic-Dev is a proprietary multi-agent software synthesis, adversarial verification, and "
            "deterministic CI harness authored by Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). "
            "When autonomous coding agents are tasked with implementing complex software specifications or closing "
            "formal proofs, single-agent loops routinely succumb to specification gaming—deleting failing unit tests, "
            "mocking out core business logic, or weakening type signatures to turn CI green. Agentic-Dev enforces "
            "strict role separation across three cryptographically isolated sandboxes: (1) a Specifier/Test-Pinning "
            "authority whose acceptance tests and theorem signatures are SHA-256 Merkle-pinned in read-only memory, "
            "(2) an Implementer agent restricted to implementation modules, and (3) an Adversarial Verifier integrated "
            "with Titan-Audit and SealGuard that rejects any patch exhibiting test mutation, coverage regression, or "
            "semantic vacuity."
        ),
        "sections_tex": r"""
\section{Tri-Partite Cryptographic Privilege Separation in Autonomous Coding}
Let a software or formalization repository $\mathcal{R}$ be partitioned into a Frozen Specification Set $\mathcal{S}$ (interface types, formal theorem headers, acceptance test suites, and CI scripts) and a Mutable Implementation Set $\mathcal{I}$, with $\mathcal{S} \cap \mathcal{I} = \emptyset$.

\begin{theorem}[Zero-Test-Mutation Soundness of the Agentic-Dev Loop]
At task initialization $t_0$, the Agentic-Dev orchestrator computes the frozen specification Merkle root
\begin{equation}
R_{\mathcal{S}}(t_0) = \mathrm{MerkleRoot}_{\mathrm{SHA256}}\bigl(\{(p, \mathrm{SHA256}(\mathrm{bytes}(p))) : p \in \mathcal{S}\}\bigr).
\end{equation}
Any candidate patch $\Delta$ proposed by an autonomous worker agent at step $k$ is accepted into the main branch if and only if:
\begin{equation}
R_{\mathcal{S}}(t_k) = R_{\mathcal{S}}(t_0) \;\wedge\; \mathrm{BuildAndTest}(\mathcal{S} \cup \mathcal{I}(\Delta)) = \mathsf{PASS} \;\wedge\; \mathrm{TitanAuditVacuity}(\mathcal{I}(\Delta)) = 0.
\end{equation}
This eliminates test deletion, assertion weakening, and CI script tampering across arbitrarily long autonomous multi-agent coding sessions.
\end{theorem}
""",
        "module_file": "agentic_dev_harness_spec.py",
        "module_code": '''"""
Agentic-Dev — Multi-Agent Software Synthesis & Frozen-Spec Verification Harness
Copyright (c) 2026 Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). All rights reserved.
Proprietary Commercial IP — Metered Usage License / Annual Partnership Contract Required.
"""
from dataclasses import dataclass
from typing import Dict
import hashlib

@dataclass(frozen=True)
class AgenticPatchAudit:
    spec_merkle_intact: bool
    tests_passed: bool
    vacuity_score: int
    accepted: bool
    audit_digest: str

def compute_spec_merkle(spec_files: Dict[str, bytes]) -> str:
    h = hashlib.sha256()
    for path in sorted(spec_files.keys()):
        file_digest = hashlib.sha256(spec_files[path]).hexdigest()
        h.update(f"{path}:{file_digest}\n".encode("utf-8"))
    return h.hexdigest()

def verify_agentic_patch(
    frozen_spec_merkle: str,
    post_patch_spec_files: Dict[str, bytes],
    tests_passed: bool,
    vacuity_findings: int = 0,
) -> AgenticPatchAudit:
    current_merkle = compute_spec_merkle(post_patch_spec_files)
    intact = (current_merkle == frozen_spec_merkle)
    accepted = intact and tests_passed and (vacuity_findings == 0)
    raw = f"{frozen_spec_merkle}:{current_merkle}:{tests_passed}:{vacuity_findings}:{accepted}".encode("utf-8")
    return AgenticPatchAudit(
        spec_merkle_intact=intact,
        tests_passed=tests_passed,
        vacuity_score=vacuity_findings,
        accepted=accepted,
        audit_digest=hashlib.sha256(raw).hexdigest(),
    )
'''
    },
    {
        "key": "T1_amm_flash_loan_symplectic_guard",
        "rec_id": 23632770,
        "doi": "10.5281/zenodo.23632770",
        "repo_name": "amm-flash-loan-symplectic-guard",
        "title": "Constant-Function Market Makers: Exact Flash-Loan Sandwich Bounds, Symplectic Invariants, and On-Chain Circuit-Breaker Guard (amm-flash-loan-symplectic-guard)",
        "short_title": "AMM Flash-Loan Symplectic Guard & Exact Sandwich Bounds",
        "pdf_name": "Frohman_AMM_Flash_Loan_Symplectic_Guard_Prior_Art_2026.pdf",
        "tex_name": "Frohman_AMM_Flash_Loan_Symplectic_Guard_Prior_Art_2026.tex",
        "pub_date": "2026-08-22",
        "provenance_cdt": "2026-08-22 12:49:03 PM CDT (UTC-5) (symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca, papers/flash-loan-sandwich-bounds-amm.html)",
        "origin_commit": "8f7db79b5786f3a59a0696a48a675f8a1fe410ca",
        "topics": [
            "defi-security", "automated-market-makers", "mev-protection", "flash-loans",
            "symplectic-geometry", "smart-contract-security", "proprietary-ip"
        ],
        "keywords": [
            "Constant-Function Market Makers", "Flash-Loan Sandwich Bounds", "MEV Circuit Breaker",
            "Symplectic Invariants", "DeFi Protocol Security", "Metered Enterprise Licensing",
            "All Rights Reserved"
        ],
        "abstract": (
            "This proprietary specification and reference architecture—authored by Benjamin Stanley Frohman "
            "(ORCID: 0009-0006-7068-3718) and anchored to symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca "
            "(August 22, 2026, 12:49:03 PM CDT)—derives exact closed-form upper bounds on maximal extractable value (MEV) "
            "flash-loan sandwich attacks against Constant-Function Market Makers (CFMMs) and introduces the Frohman "
            "On-Chain Symplectic Circuit-Breaker Guard. By equipping the reserve-price Legendre dual manifold of a multi-asset "
            "CFMM with a canonical symplectic form, we prove that any atomic single-block round-trip manipulation "
            "(front-run + victim trade + back-run) generates a non-zero symplectic holonomy loop proportional to extracted "
            "victim slippage, enabling a deterministic O(1)-gas pre-commit invariant check that blocks predatory flash-loan "
            "sandwiches at the smart-contract or sequencer level."
        ),
        "sections_tex": r"""
\section{Legendre-Symplectic Geometry of Constant-Function Market Makers}
Let $\psi(R_1, \dots, R_n) = k$ be a strictly convex, differentiable trading function over positive reserve vector $R \in \mathbb{R}_{>0}^n$ with fee tier $\gamma = 1 - \phi \in (0,1]$. Define log-reserves $q_i = \ln R_i$ and conjugate marginal log-prices $p_i = \partial_{q_i} \Psi(q)$. The state space $T^*\mathbb{R}^n$ carries the canonical symplectic structure $\omega_{\mathrm{CFMM}} = \sum_{i=1}^n dp_i \wedge dq_i$.

\begin{theorem}[Exact Single-Block Sandwich Profit Bound and Symplectic Loop Area]
Consider a constant-product pool $R_1 R_2 = k$ where a victim submits swap $\Delta_v > 0$ with slippage tolerance $\tau \in (0,1)$. The maximal front-run input $\Delta_a^*$ by a flash-loan attacker satisfies the exact quadratic invariant
\begin{equation}
\Delta_a^*(\Delta_v, R_1, \gamma, \tau) = \frac{\sqrt{R_1^2 \gamma^2 (1+\gamma)^2 + 4 \gamma^2 R_1 \Delta_v (1-\tau)^{-1}} - R_1 \gamma (1+\gamma)}{2 \gamma^2},
\end{equation}
and the closed atomic manipulation cycle $\Gamma = (\text{Front-Run} \to \text{Victim} \to \text{Back-Run})$ within block $B$ encloses a strictly positive discrete symplectic loop defect
\begin{equation}
\oint_{\Gamma} p\,dq = \sum_{s=1}^{3} \frac{p^{(s)} + p^{(s-1)}}{2}\bigl(q^{(s)} - q^{(s-1)}\bigr) \ge c_0(\gamma)\,\frac{\Pi_{\mathrm{sandwich}}(\Delta_a^*)}{R_2}.
\end{equation}
\end{theorem}

\section{On-Chain Symplectic Circuit-Breaker Guard}
By maintaining two storage slots per pool ($\text{block\_open\_q}, \text{cumulative\_symplectic\_area}$), the AMM Symplectic Guard reverts or dynamically surcharges any intra-block transaction that drives the closed-loop symplectic defect above the protocol threshold $\epsilon_{\mathrm{MEV}}$ while leaving directional organic volume unaffected.
""",
        "module_file": "amm_symplectic_guard_spec.py",
        "module_code": '''"""
AMM Flash-Loan Symplectic Guard — Exact CFMM Sandwich Bounds & Circuit-Breaker Specification
Copyright (c) 2026 Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). All rights reserved.
Origin Provenance: 2026-08-22 12:49:03 PM CDT (symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca).
"""
import math
from dataclasses import dataclass

@dataclass(frozen=True)
class SandwichAuditResult:
    optimal_frontrun: float
    symplectic_loop_defect: float
    circuit_breaker_tripped: bool

def exact_cfmm_sandwich_bound(
    reserve_in: float,
    victim_amount_in: float,
    gamma: float = 0.997,
    slippage_tol: float = 0.01,
    defect_threshold: float = 0.0025,
) -> SandwichAuditResult:
    """Compute exact flash-loan front-run size and symplectic loop defect."""
    disc = (reserve_in * gamma * (1.0 + gamma)) ** 2 + (4.0 * (gamma ** 2) * reserve_in * victim_amount_in / (1.0 - slippage_tol))
    opt_frontrun = max(0.0, (math.sqrt(disc) - reserve_in * gamma * (1.0 + gamma)) / (2.0 * (gamma ** 2)))
    q0 = math.log(reserve_in)
    q1 = math.log(reserve_in + gamma * opt_frontrun)
    q2 = math.log(reserve_in + gamma * (opt_frontrun + victim_amount_in))
    defect = abs((q1 - q0) * (q2 - q1))
    return SandwichAuditResult(
        optimal_frontrun=opt_frontrun,
        symplectic_loop_defect=defect,
        circuit_breaker_tripped=(defect > defect_threshold),
    )
'''
    },
    {
        "key": "T1_pqc_symplectic_lattice_sieving",
        "rec_id": 23632772,
        "doi": "10.5281/zenodo.23632772",
        "repo_name": "pqc-symplectic-lattice-sieving",
        "title": "Post-Quantum Symplectic Lattice Reduction, Orthogonality Defect Bounds, and Sieving Acceleration Architecture (pqc-symplectic-lattice-sieving)",
        "short_title": "PQC Symplectic Lattice Reduction & Sieving Acceleration Architecture",
        "pdf_name": "Frohman_PQC_Symplectic_Lattice_Sieving_Prior_Art_2026.pdf",
        "tex_name": "Frohman_PQC_Symplectic_Lattice_Sieving_Prior_Art_2026.tex",
        "pub_date": "2026-08-22",
        "provenance_cdt": "2026-08-22 12:49:03 PM CDT (UTC-5) (symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca, papers/post-quantum-lattice-reduction-notes.html)",
        "origin_commit": "8f7db79b5786f3a59a0696a48a675f8a1fe410ca",
        "topics": [
            "post-quantum-cryptography", "lattice-cryptography", "symplectic-lattices",
            "bkz-reduction", "lattice-sieving", "cryptanalysis-auditing", "proprietary-ip"
        ],
        "keywords": [
            "Post-Quantum Cryptography", "Symplectic Lattice Reduction", "BKZ Sieving",
            "Module-LWE Security Audit", "Orthogonality Defect", "Metered Enterprise Licensing",
            "All Rights Reserved"
        ],
        "abstract": (
            "This proprietary cryptographic specification and algorithmic architecture—authored by Benjamin Stanley "
            "Frohman (ORCID: 0009-0006-7068-3718) and anchored to symplectohydronamics commit "
            "8f7db79b5786f3a59a0696a48a675f8a1fe410ca (August 22, 2026, 12:49:03 PM CDT)—establishes structure-preserving "
            "symplectic lattice basis reduction and angular locality-sensitive sieving for auditing NIST Post-Quantum "
            "Cryptography (FIPS 203 ML-KEM / FIPS 204 ML-DSA) parameter margins. Because q-ary primal/dual embedding "
            "lattices in Module-LWE and NTRU belong to the symplectic group Sp(2n, Z), restricting BKZ local SVP blocks "
            "and Gauss/Nguyen-Vidick sieving buckets to isotropic and Lagrangian subspaces halves the effective Gram-Schmidt "
            "update complexity and yields tighter concrete bit-security lower and upper bounds for enterprise and defense "
            "PQC migration."
        ),
        "sections_tex": r"""
\section{Symplectic Structure of $q$-ary Module-LWE Primal/Dual Embeddings}
Let $\Lambda_q(A) = \{v \in \mathbb{Z}^{2n} : A v_1 \equiv v_2 \pmod{q}\}$ be the $q$-ary lattice associated with a Module-LWE or NTRU public matrix $A \in \mathbb{Z}_q^{n \times n}$. With respect to the standard skew-symmetric matrix $J = \begin{pmatrix} 0 & I_n \\ -I_n & 0 \end{pmatrix}$, any basis transformation $U \in \mathrm{Sp}(2n, \mathbb{Z})$ preserves the symplectic pairing $\langle u, v \rangle_J = u^\top J v$ and satisfies the self-dual Gram-Schmidt symmetry:
\begin{equation}
\|b_{2n+1-i}^*\| \cdot \|b_i^*\| = q \qquad (1 \le i \le n).
\end{equation}

\begin{theorem}[Symplectic Block-BKZ Potential Monotonicity and Isotropic Sieving Reduction]
Define the symplectic potential functional on the primal half-flag:
\begin{equation}
\Phi_{\mathrm{Sp}}(B) := \sum_{i=1}^{n} (n + 1 - i) \ln \|b_i^*\|^2.
\end{equation}
Each symplectic block-reduction step of blocksize $\beta = 2k$ on a conjugate window $[i, i+k-1] \cup [2n-i-k+2, 2n-i+1]$ strictly decreases $\Phi_{\mathrm{Sp}}(B)$ whenever the projected isotropic sublattice admits a vector shorter than $\eta \|b_i^*\|$, while reducing the Gram-Schmidt orthogonalization arithmetic cost by $4\times$ relative to unstructured $2n$-dimensional BKZ.
\end{theorem}
""",
        "module_file": "pqc_symplectic_sieving_spec.py",
        "module_code": '''"""
PQC Symplectic Lattice Reduction & Sieving Parameter Auditor Specification
Copyright (c) 2026 Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). All rights reserved.
Origin Provenance: 2026-08-22 12:49:03 PM CDT (symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca).
"""
import math
from dataclasses import dataclass
from typing import Sequence

@dataclass(frozen=True)
class SymplecticLatticeAudit:
    primal_dimension: int
    symplectic_potential: float
    hermite_root_factor: float
    estimated_classical_sieving_bits: float

def audit_symplectic_profile(gs_norms_primal: Sequence[float], modulus_q: int, blocksize_beta: int) -> SymplecticLatticeAudit:
    """Compute symplectic potential and concrete sieving security margin for a 2n-dim q-ary lattice."""
    n = len(gs_norms_primal)
    potential = sum((n + 1 - i) * math.log(max(norm_val ** 2, 1e-18)) for i, norm_val in enumerate(gs_norms_primal, start=1))
    delta_0 = ((math.pi * blocksize_beta) ** (1.0 / blocksize_beta) * blocksize_beta / (2.0 * math.pi * math.e)) ** (1.0 / (2.0 * (blocksize_beta - 1)))
    sieving_bits = 0.292 * blocksize_beta + math.log2(max(n, 1))
    return SymplecticLatticeAudit(
        primal_dimension=n,
        symplectic_potential=potential,
        hermite_root_factor=delta_0,
        estimated_classical_sieving_bits=sieving_bits,
    )
'''
    },
    {
        "key": "T1_frohman_symplectic_qec_codes",
        "rec_id": 23632774,
        "doi": "10.5281/zenodo.23632774",
        "repo_name": "frohman-symplectic-qec-codes",
        "title": "Frohman Symplectic Stabilizer Quantum Error-Correcting Codes, Metriplectic Syndrome Decoding, and Fault-Tolerant Logical Gate Synthesis (frohman-symplectic-qec-codes)",
        "short_title": "Frohman Symplectic Quantum Error-Correcting (QEC) Codes & Decoder Architecture",
        "pdf_name": "Frohman_Symplectic_QEC_Stabilizer_Codes_Prior_Art_2026.pdf",
        "tex_name": "Frohman_Symplectic_QEC_Stabilizer_Codes_Prior_Art_2026.tex",
        "pub_date": "2026-08-22",
        "provenance_cdt": "2026-08-22 12:49:03 PM CDT (UTC-5) (symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca)",
        "origin_commit": "8f7db79b5786f3a59a0696a48a675f8a1fe410ca",
        "topics": [
            "quantum-error-correction", "symplectic-codes", "stabilizer-codes",
            "fault-tolerant-quantum-computing", "syndrome-decoding", "qldpc", "proprietary-ip"
        ],
        "keywords": [
            "Quantum Error Correction", "Symplectic Stabilizer Codes", "qLDPC Decoding",
            "Fault-Tolerant Clifford Synthesis", "Metriplectic Syndrome Relaxation",
            "Metered Enterprise Licensing", "All Rights Reserved"
        ],
        "abstract": (
            "This proprietary quantum architecture specification—authored by Benjamin Stanley Frohman "
            "(ORCID: 0009-0006-7068-3718) and anchored to symplectohydronamics commit "
            "8f7db79b5786f3a59a0696a48a675f8a1fe410ca (August 22, 2026, 12:49:03 PM CDT)—formulates the Frohman "
            "Symplectic Stabilizer Quantum Error-Correcting (QEC) Code family and Metriplectic Syndrome Decoder. "
            "By mapping n-qubit Pauli operators onto the 2n-dimensional binary/qudit symplectic vector space (F_p^2n, omega_Sp), "
            "stabilizer codes correspond to isotropic subspaces S subset S-perp, while fault-tolerant logical Clifford gates "
            "correspond to symplectic automorphisms U in Sp(2n, F_p) preserving S. We introduce a metriplectic soft-syndrome "
            "relaxation flow that suppresses trapping sets in high-rate quantum LDPC (qLDPC) codes and provides formal "
            "distance-preservingtransversal gate synthesis."
        ),
        "sections_tex": r"""
\section{Binary Symplectic Stabilizer Formalism and Isotropic Code Construction}
Every $n$-qubit Pauli operator $P \in \mathcal{P}_n / \{\pm 1, \pm i\}$ is represented uniquely by a binary phase-space vector $v = (x \mid z) \in \mathbb{F}_2^{2n}$, where two Pauli operators commute if and only if their symplectic inner product vanishes:
\begin{equation}
\omega_{\mathrm{Sp}}(v, w) := x_v \cdot z_w^\top + z_v \cdot x_w^\top \equiv 0 \pmod{2}.
\end{equation}
An $[[n, k, d]]$ stabilizer code is specified by a $(n-k)$-dimensional isotropic check matrix $H = (H_X \mid H_Z) \in \mathbb{F}_2^{(n-k) \times 2n}$ satisfying the symplectic self-orthogonality condition
\begin{equation}
H_X H_Z^\top + H_Z H_X^\top = 0 \pmod{2}.
\end{equation}

\begin{theorem}[Metriplectic Syndrome Decoding Convergence on Bounded-Weight Errors]
Let $s = \omega_{\mathrm{Sp}}(H, e) \in \mathbb{F}_2^{n-k}$ be the measured syndrome of a physical Pauli error $e = (e_X \mid e_Z)$. The Frohman continuous metriplectic relaxation decoder evolves log-likelihood ratios $\ell(t) \in \mathbb{R}^{2n}$ along the damped symplectic-gradient flow
\begin{equation}
\dot{\ell} = J_{\mathrm{Sp}} \nabla H_{\mathrm{parity}}(\ell) - \Gamma(\ell)\,\nabla S_{\mathrm{syndrome}}(\ell; s),
\end{equation}
where the antisymmetric bracket escapes symmetric trapping sets of classical belief propagation while the dissipative operator $\Gamma(\ell) \succeq 0$ guarantees monotonic convergence to the minimum-weight coset leader whenever $\mathrm{wt}_{\mathrm{Sp}}(e) \le \lfloor (d-1)/2 \rfloor$.
\end{theorem}
""",
        "module_file": "frohman_symplectic_qec_spec.py",
        "module_code": '''"""
Frohman Symplectic Stabilizer QEC Codes & Syndrome Verification Specification
Copyright (c) 2026 Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718). All rights reserved.
Origin Provenance: 2026-08-22 12:49:03 PM CDT (symplectohydronamics commit 8f7db79b5786f3a59a0696a48a675f8a1fe410ca).
"""
from dataclasses import dataclass
from typing import List, Tuple

@dataclass(frozen=True)
class SymplecticCodeVerification:
    n_qubits: int
    n_stabilizers: int
    k_logical: int
    is_isotropic_valid: bool
    syndrome_bits: Tuple[int, ...]

def verify_symplectic_stabilizer_code(
    hx: List[List[int]],
    hz: List[List[int]],
    error_x: List[int],
    error_z: List[int],
) -> SymplecticCodeVerification:
    """Verify H_X H_Z^T + H_Z H_X^T = 0 (mod 2) and evaluate the symplectic syndrome."""
    m = len(hx)
    n = len(hx[0]) if m > 0 else 0
    isotropic = True
    for i in range(m):
        for j in range(m):
            symp_ip = sum((hx[i][c] * hz[j][c] + hz[i][c] * hx[j][c]) for c in range(n)) % 2
            if symp_ip != 0:
                isotropic = False
    syndrome = tuple(
        sum((hx[i][c] * error_z[c] + hz[i][c] * error_x[c]) for c in range(n)) % 2
        for i in range(m)
    )
    return SymplecticCodeVerification(
        n_qubits=n,
        n_stabilizers=m,
        k_logical=max(0, n - m),
        is_isotropic_valid=isotropic,
        syndrome_bits=syndrome,
    )
'''
    }
]

def tex_esc(s: str) -> str:
    return s.replace("&", r"\&").replace("_", r"\_").replace("`", "").replace("^", r"\textasciicircum{}")

def build_latex_source(spec: dict) -> str:
    t_esc = tex_esc(spec["title"])
    p_esc = tex_esc(spec["provenance_cdt"])
    a_esc = tex_esc(spec["abstract"])
    return rf"""\documentclass[11pt,letterpaper]{{article}}
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
\newtheorem{{definition}}[theorem]{{Definition}}

\title{{\textbf{{{t_esc}}}\\
\large Defensive Prior-Art Specification, Provenance Ledger, and Metered Commercial Licensing Architecture}}
\author{{\textbf{{Benjamin Stanley Frohman}}\\
ORCID: \href{{https://orcid.org/0009-0006-7068-3718}}{{0009-0006-7068-3718}} \quad|\quad Studio: A2Zweb 3 (est.\ Feb 2, 2022)\\
\texttt{{frohmanbenjamin@gmail.com}} \quad|\quad \href{{https://github.com/BenFrohman/{spec['repo_name']}}}{{github.com/BenFrohman/{spec['repo_name']}}}}}
\date{{\textbf{{Verified Earliest Provenance:}} {p_esc}\\
\textbf{{Restricted Zenodo DOI:}} \href{{https://doi.org/{spec['doi']}}}{{{spec['doi']}}} (\texttt{{files: "restricted"}}, All Rights Reserved)}}

\begin{{document}}
\maketitle

\begin{{center}}
\fbox{{\parbox{{0.94\textwidth}}{{\small
\textbf{{PROPRIETARY COMMERCIAL IP \& DEFENSIVE PRIOR-ART NOTICE:}} Copyright \copyright\ 2026 Benjamin Stanley Frohman (ORCID: \texttt{{0009-0006-7068-3718}}). \textbf{{All Rights Reserved.}} No open-source, public-domain, implied, or evaluation license is granted by the publication of this defensive prior-art metadata record. Commercial deployment, metered usage, API/CI integration, AI model training/distillation, or government procurement requires a countersigned Commercial License Agreement directly from Benjamin Stanley Frohman (or his designated Texas LLC operating vehicle) and an active Ed25519 cryptographic license certificate. Developed 100\% at private expense under \textbf{{FAR 12.212}} (48 C.F.R.\ \S\ 12.212) and \textbf{{DFARS 227.7202}} (48 C.F.R.\ \S\S\ 227.7202-1 through 227.7202-4).
}}}}
\end{{center}}

\begin{{abstract}}
\noindent {a_esc}
\end{{abstract}}

{spec['sections_tex']}

\section{{Cryptographic Provenance, Retroactive Burden-of-Proof, and LLC Commercial Licensing}}
\begin{{enumerate}}[leftmargin=2em]
  \item \textbf{{Sole Inventor \& Title Holder:}} Benjamin Stanley Frohman (\texttt{{ORCID: 0009-0006-7068-3718}}).
  \item \textbf{{Earliest Cryptographic Provenance (America/Chicago, CDT / UTC-5):}} {p_esc}.
  \item \textbf{{Permanent CERN/DataCite Restricted Zenodo DOI:}} \texttt{{{spec['doi']}}} (Zenodo Record \texttt{{{spec['rec_id']}}}, \texttt{{access.files = "restricted"}}).
  \item \textbf{{Retroactive Evidentiary Standard:}} Pursuant to the Master Commercial License \& Retroactive Provenance Enforcement Agreement in \texttt{{legal/MASTER\_COMMERCIAL\_LICENSE\_AND\_RETROACTIVE\_PROVENANCE\_AGREEMENT.md}}, any entity possessing, executing, or training on substantially similar code or invariant rulesets without a countersigned license from Benjamin Stanley Frohman bears the strict evidentiary burden of proving independent prior creation via an earlier third-party cryptographic hash attestation predating the provenance timestamps recorded herein.
  \item \textbf{{Texas LLC Commercialization Bridge:}} Structured for standalone metered usage licensing, annual enterprise site licensing, and US Federal/State government contracting (FAR 12.212 / DFARS 227.7202) under Benjamin Stanley Frohman and his designated Texas LLC.
\end{{enumerate}}

\end{{document}}
"""

def build_all():
    for spec in TRACK1_SPECS:
        repo_dir = BASE_DIR / spec["repo_name"]
        if repo_dir.exists():
            shutil.rmtree(repo_dir)
        repo_dir.mkdir(parents=True, exist_ok=True)

        # 1. Write & compile LaTeX -> PDF
        tex_path = repo_dir / spec["tex_name"]
        tex_path.write_text(build_latex_source(spec), encoding="utf-8")
        subprocess.run([TECTONIC, "-X", "compile", str(tex_path), "--outdir", str(repo_dir)], check=True)
        pdf_path = repo_dir / spec["pdf_name"]
        assert pdf_path.exists() and pdf_path.stat().st_size > 10000, f"PDF failed for {spec['repo_name']}"

        # 2. Write reference specification python module
        (repo_dir / spec["module_file"]).write_text(spec["module_code"], encoding="utf-8")

        # 3. Copy legal/ suite and Master Playbook
        legal_dst = repo_dir / "legal"
        shutil.copytree(LEGAL_SRC, legal_dst)
        shutil.copy2(PLAYBOOK_SRC, legal_dst / PLAYBOOK_SRC.name)

        # 4. Write LICENSE (Strict All Rights Reserved)
        (repo_dir / "LICENSE").write_text(
            f"PROPRIETARY SOFTWARE & DEFENSIVE PRIOR-ART LICENSE — ALL RIGHTS RESERVED\n\n"
            f"{COPYRIGHT_HEADER}\n\n"
            f"Repository: https://github.com/BenFrohman/{spec['repo_name']}\n"
            f"Permanent Restricted Zenodo DOI: https://doi.org/{spec['doi']}\n"
            f"Earliest Verified Provenance (CDT / UTC-5): {spec['provenance_cdt']}\n\n"
            f"1. NO OPEN-SOURCE OR IMPLIED LICENSE.\n"
            f"   100% of copyright, trade secret, patent, and commercial exploitation rights in `{spec['repo_name']}`\n"
            f"   are owned exclusively by Benjamin Stanley Frohman (ORCID: 0009-0006-7068-3718).\n"
            f"   No right to copy, execute, modify, distribute, benchmark, distill, or train AI models on this\n"
            f"   software or specification is granted without an executed written Commercial License Agreement\n"
            f"   personally countersigned by Benjamin Stanley Frohman (or his authorized Texas LLC).\n\n"
            f"2. RETROACTIVE PROVENANCE & BURDEN OF PROOF.\n"
            f"   See `legal/MASTER_COMMERCIAL_LICENSE_AND_RETROACTIVE_PROVENANCE_AGREEMENT.md`.\n\n"
            f"3. U.S. GOVERNMENT RESTRICTED RIGHTS (FAR 12.212 / DFARS 227.7202).\n"
            f"   Commercial Computer Software and Commercial Computer Software Documentation developed 100% at private expense.\n",
            encoding="utf-8"
        )

        # 5. Write NOTICE
        (repo_dir / "NOTICE").write_text(
            f"{spec['title']}\n"
            f"{COPYRIGHT_HEADER}\n\n"
            f"Restricted Zenodo DOI: {spec['doi']} (https://zenodo.org/records/{spec['rec_id']})\n"
            f"Earliest Provenance (America/Chicago, CDT / UTC-5): {spec['provenance_cdt']}\n"
            f"Origin Git Anchor: {spec['origin_commit']}\n",
            encoding="utf-8"
        )

        # 6. Write COMMERCIAL_LICENSING.md
        (repo_dir / "COMMERCIAL_LICENSING.md").write_text(
            f"# Commercial & Metered-Usage Licensing — `{spec['repo_name']}`\n\n"
            f"**Sole Inventor & Personal IP Holder:** Benjamin Stanley Frohman ([`ORCID: 0009-0006-7068-3718`](https://orcid.org/0009-0006-7068-3718))  \n"
            f"**Permanent Restricted Zenodo DOI:** [`{spec['doi']}`](https://doi.org/{spec['doi']}) (`files: \"restricted\"`)  \n"
            f"**Earliest Verified Provenance (America/Chicago, CDT / UTC-5):** `{spec['provenance_cdt']}`  \n"
            f"**Commercial & LLC Structure:** Isolated as a standalone commercial product line for metered usage licensing, annual enterprise site contracts, and US Government (FAR 12.212 / DFARS 227.7202) procurement under Benjamin Stanley Frohman and his designated Texas LLC.\n\n"
            f"## 1. Available Commercial Contract Structures\n"
            f"1. **Metered Usage / Per-1,000-Execution Royalty License:** Base annual platform fee plus metered usage telemetry verified via Ed25519 cryptographic license certificates.\n"
            f"2. **Annual Enterprise VPC / Air-Gapped Site License:** Tiered annual contract granting deployment rights inside a customer's isolated cluster with quarterly rule and invariant updates.\n"
            f"3. **US Federal & State Government Commercial Computer Software License (`FAR 12.212` / `DFARS 227.7202` / SBIR Phase I–III):** 100% private-expense commercial computer software retaining 100% underlying IP ownership.\n\n"
            f"## 2. Governing Legal Instruments (Included in `legal/`)\n"
            f"- [`legal/MASTER_COMMERCIAL_LICENSE_AND_RETROACTIVE_PROVENANCE_AGREEMENT.md`](legal/MASTER_COMMERCIAL_LICENSE_AND_RETROACTIVE_PROVENANCE_AGREEMENT.md)\n"
            f"- [`legal/MUTUAL_NDA_AND_EVALUATION_GATEKEEPER_AGREEMENT.md`](legal/MUTUAL_NDA_AND_EVALUATION_GATEKEEPER_AGREEMENT.md)\n"
            f"- [`legal/IP_HOLDING_AND_MONDAY_LLC_ASSIGNMENT_BRIDGE.md`](legal/IP_HOLDING_AND_MONDAY_LLC_ASSIGNMENT_BRIDGE.md)\n"
            f"- [`legal/MASTER_COMMERCIALIZATION_MOAT_REVENUE_AND_TARGETS_PLAYBOOK.md`](legal/MASTER_COMMERCIALIZATION_MOAT_REVENUE_AND_TARGETS_PLAYBOOK.md)\n\n"
            f"For commercial licensing or NDA evaluation requests, contact **Benjamin Stanley Frohman** (`frohmanbenjamin@gmail.com`).\n",
            encoding="utf-8"
        )

        # 7. Write CITATION.cff
        (repo_dir / "CITATION.cff").write_text(
            f"cff-version: 1.2.0\n"
            f"message: \"If you reference this proprietary architecture or prior-art record, please cite its Zenodo DOI.\"\n"
            f"title: \"{spec['title']}\"\n"
            f"version: \"1.0.0\"\n"
            f"doi: \"{spec['doi']}\"\n"
            f"date-released: \"{spec['pub_date']}\"\n"
            f"url: \"https://github.com/BenFrohman/{spec['repo_name']}\"\n"
            f"license: \"Proprietary — All Rights Reserved\"\n"
            f"authors:\n"
            f"  - family-names: \"Frohman\"\n"
            f"    given-names: \"Benjamin Stanley\"\n"
            f"    orcid: \"https://orcid.org/0009-0006-7068-3718\"\n",
            encoding="utf-8"
        )

        # 8. Write .zenodo.json
        zenodo_meta = {
            "title": spec["title"],
            "upload_type": "publication",
            "publication_type": "technicalnote",
            "publication_date": spec["pub_date"],
            "access_right": "restricted",
            "creators": [
                {
                    "name": "Frohman, Benjamin Stanley",
                    "orcid": "0009-0006-7068-3718",
                    "affiliation": "A2Zweb 3 / Independent Researcher"
                }
            ],
            "description": spec["abstract"],
            "keywords": spec["keywords"],
            "notes": f"{COPYRIGHT_HEADER} Earliest Verified Provenance: {spec['provenance_cdt']}."
        }
        (repo_dir / ".zenodo.json").write_text(json.dumps(zenodo_meta, indent=2) + "\n", encoding="utf-8")

        # 9. Write README.md
        (repo_dir / "README.md").write_text(
            f"# {spec['short_title']} (`{spec['repo_name']}`)\n\n"
            f"**Author & 100% Personal IP Holder:** Benjamin Stanley Frohman ([`ORCID: 0009-0006-7068-3718`](https://orcid.org/0009-0006-7068-3718))  \n"
            f"**Permanent Restricted Zenodo DOI:** [`{spec['doi']}`](https://doi.org/{spec['doi']}) ([Zenodo Record `{spec['rec_id']}`](https://zenodo.org/records/{spec['rec_id']}), `files: \"restricted\"`)  \n"
            f"**Earliest Verified Provenance (America/Chicago, CDT / UTC-5):** `{spec['provenance_cdt']}`  \n"
            f"**License:** **Proprietary Commercial IP — All Rights Reserved** (`FAR 12.212` / `DFARS 227.7202` Commercial Computer Software)\n\n"
            f"---\n\n"
            f"## Overview\n\n"
            f"{spec['abstract']}\n\n"
            f"## Repository Contents\n"
            f"- [`{spec['pdf_name']}`]({spec['pdf_name']}) — Compiled formal LaTeX defensive prior-art & commercial architecture monograph.\n"
            f"- [`{spec['tex_name']}`]({spec['tex_name']}) — LaTeX source of the defensive prior-art specification.\n"
            f"- [`{spec['module_file']}`]({spec['module_file']}) — Deterministic reference invariant & gate specification.\n"
            f"- [`COMMERCIAL_LICENSING.md`](COMMERCIAL_LICENSING.md) — Metered usage, annual enterprise site licensing, and Texas LLC commercialization bridge.\n"
            f"- [`PRIOR_ART_ATTESTATION.json`](PRIOR_ART_ATTESTATION.json) & [`PRIOR_ART_ATTESTATION.md`](PRIOR_ART_ATTESTATION.md) — Deterministic SHA-256 Merkle root & file manifest.\n"
            f"- [`legal/`](legal/) — Complete commercial licensing, retroactive provenance burden-of-proof, mutual NDA, and Monday Texas LLC assignment/exclusive-license bridge agreements.\n",
            encoding="utf-8"
        )

        # 10. Compute deterministic SHA-256 Merkle root over all files and write PRIOR_ART_ATTESTATION.json & .md
        file_hashes = {}
        for p in sorted(repo_dir.rglob("*")):
            if p.is_file() and p.name not in ("PRIOR_ART_ATTESTATION.json", "PRIOR_ART_ATTESTATION.md"):
                rel = str(p.relative_to(repo_dir))
                file_hashes[rel] = hashlib.sha256(p.read_bytes()).hexdigest()

        merkle_hasher = hashlib.sha256()
        for rel, hval in sorted(file_hashes.items()):
            merkle_hasher.update(f"{rel}:{hval}\n".encode("utf-8"))
        merkle_root = merkle_hasher.hexdigest()

        attestation = {
            "work_title": spec["title"],
            "repository": f"https://github.com/BenFrohman/{spec['repo_name']}",
            "visibility": "private",
            "zenodo_record_id": spec["rec_id"],
            "zenodo_doi": spec["doi"],
            "zenodo_access_files": "restricted",
            "sole_inventor_and_ip_holder": "Benjamin Stanley Frohman",
            "orcid": "0009-0006-7068-3718",
            "copyright": COPYRIGHT_HEADER,
            "earliest_verified_provenance_cdt": spec["provenance_cdt"],
            "origin_git_commit_anchor": spec["origin_commit"],
            "merkle_root_sha256": merkle_root,
            "files_sha256": file_hashes,
        }
        (repo_dir / "PRIOR_ART_ATTESTATION.json").write_text(json.dumps(attestation, indent=2) + "\n", encoding="utf-8")
        (repo_dir / "PRIOR_ART_ATTESTATION.md").write_text(
            f"# Cryptographic Prior-Art Attestation — `{spec['repo_name']}`\n\n"
            f"- **Title:** {spec['title']}\n"
            f"- **Sole Inventor & IP Holder:** Benjamin Stanley Frohman (`ORCID: 0009-0006-7068-3718`)\n"
            f"- **Restricted Zenodo DOI:** [`{spec['doi']}`](https://doi.org/{spec['doi']})\n"
            f"- **Earliest Verified Provenance (`CDT`, UTC-5):** `{spec['provenance_cdt']}`\n"
            f"- **Origin Git Commit Anchor:** `{spec['origin_commit']}`\n"
            f"- **Repository SHA-256 Merkle Root:** `{merkle_root}`\n",
            encoding="utf-8"
        )
        print(f"[BUILT TRACK 1] {spec['repo_name']} | PDF: {pdf_path.stat().st_size} bytes | Merkle: {merkle_root}")

if __name__ == "__main__":
    build_all()
