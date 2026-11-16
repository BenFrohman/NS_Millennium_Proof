/-
Copyright (c) 2026 Benjamin Stanley Frohman. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Benjamin Stanley Frohman
-/

import Lean

/-!
# Truth Gate: the semantics-lock checker

`TruthGate.runTruthGate` reads `truth-gate.lock.json` and raises an error (so the
enclosing `lake build` or `lake env lean` fails) unless every lock satisfies all of:

* `paper_claim`, `formal_claim` and `intended_correspondence : formal_claim ↔ paper_claim`
  exist (status `locked`); a lock with status `drift` always fails (DRIFT);
* `paper_claim` is an independent transcription: its project-local dependency closure
  contains no `formal_claim`, no formal proof, no public theorem and no correspondence of any
  lock (ALIAS), and every project-local constant it shares with `formal_claim`'s closure lies
  in the closure of the declared `shared_vocabulary` (ALIAS);
* the correspondence is not `rfl`/`Iff.rfl`/`Iff.refl`/`Eq.refl` (RFL) and the two claims are
  not definitionally equal (TRIVIAL);
* no lock declaration and no public theorem depends on `sorryAx` (SORRY, from `sorry` or
  `admit`), on `Lean.ofReduceBool`/`Lean.trustCompiler` (NATIVE_DECIDE), or on any axiom other
  than `propext`, `Classical.choice`, `Quot.sound` (AXIOM);
* the SHA-256 of each claim's canonical statement (its project-local closure, printed) and of
  the paper file match the lock file (HASH, PAPER_SHA), and the verbatim quote occurs in the
  paper file (QUOTE);
* each public theorem has type exactly `paper_claim` and its proof is
  `intended_correspondence.mp <formal proof>` (UNTRANSPORTED);
* (library mode) the Semantics module is imported by the root and directly by every module
  that declares a public theorem (NO_SEMANTICS_IMPORT), and every theorem whose conclusion is
  a headline proposition or a locked claim is public, a registered formal proof, or listed
  as intermediate (UNREGISTERED).

A pass only means the kernel-checked certificate inhabits the locked proposition. Whether the
transcription matches the author's intent is the author's sign-off, not a kernel fact.
-/

namespace TruthGate

open Lean Elab Command Meta

/-! ## SHA-256 (FIPS 180-4) -/

private def kTable : Array UInt32 := #[
  0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
  0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
  0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
  0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
  0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
  0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
  0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
  0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2]

private def rotr (x n : UInt32) : UInt32 := (x >>> n) ||| (x <<< (32 - n))

private def hex32 (x : UInt32) : String :=
  let s := String.ofList (Nat.toDigits 16 x.toNat)
  "".pushn '0' (8 - s.length) ++ s

/-- SHA-256 of a byte array, lowercase hex. -/
def sha256 (msg : ByteArray) : String := Id.run do
  let ml := msg.size
  let mut data := msg.push 0x80
  while data.size % 64 != 56 do
    data := data.push 0
  let bitLen : UInt64 := ml.toUInt64 * 8
  for i in [0:8] do
    data := data.push (bitLen >>> (UInt64.ofNat (56 - 8 * i))).toUInt8
  let mut h : Array UInt32 := #[0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a,
    0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19]
  for chunk in [0:data.size / 64] do
    let mut w : Array UInt32 := Array.mkEmpty 64
    for i in [0:16] do
      let o := chunk * 64 + 4 * i
      w := w.push ((data.get! o).toUInt32 <<< 24 ||| (data.get! (o+1)).toUInt32 <<< 16 |||
        (data.get! (o+2)).toUInt32 <<< 8 ||| (data.get! (o+3)).toUInt32)
    for i in [16:64] do
      let s0 := rotr w[i-15]! 7 ^^^ rotr w[i-15]! 18 ^^^ (w[i-15]! >>> 3)
      let s1 := rotr w[i-2]! 17 ^^^ rotr w[i-2]! 19 ^^^ (w[i-2]! >>> 10)
      w := w.push (w[i-16]! + s0 + w[i-7]! + s1)
    let mut a := h[0]!
    let mut b := h[1]!
    let mut c := h[2]!
    let mut d := h[3]!
    let mut e := h[4]!
    let mut f := h[5]!
    let mut g := h[6]!
    let mut hh := h[7]!
    for i in [0:64] do
      let S1 := rotr e 6 ^^^ rotr e 11 ^^^ rotr e 25
      let ch := (e &&& f) ^^^ ((~~~e) &&& g)
      let t1 := hh + S1 + ch + kTable[i]! + w[i]!
      let S0 := rotr a 2 ^^^ rotr a 13 ^^^ rotr a 22
      let maj := (a &&& b) ^^^ (a &&& c) ^^^ (b &&& c)
      let t2 := S0 + maj
      hh := g; g := f; f := e; e := d + t1; d := c; c := b; b := a; a := t1 + t2
    h := #[h[0]! + a, h[1]! + b, h[2]! + c, h[3]! + d, h[4]! + e, h[5]! + f, h[6]! + g,
      h[7]! + hh]
  return h.foldl (fun s x => s ++ hex32 x) ""

/-! ## Dependency closures and canonical statements -/

/-- Direct constant dependencies used for closures (proof bodies of theorems excluded). -/
def directDeps (ci : ConstantInfo) : Array Name :=
  let fromType := ci.type.getUsedConstants
  match ci with
  | .defnInfo v => fromType ++ v.value.getUsedConstants
  | .opaqueInfo v => fromType ++ v.value.getUsedConstants
  | .inductInfo v => fromType ++ v.ctors.toArray
  | .ctorInfo v => fromType.push v.induct
  | _ => fromType

/-- Project-local dependency closure of `roots` (roots included when local). -/
def localClosure (env : Environment) (isLocal : Name → Bool) (roots : Array Name) : NameSet :=
  Id.run do
    let mut seen : NameSet := {}
    let mut todo := roots.toList
    let mut fuel := 200000
    while fuel > 0 do
      fuel := fuel - 1
      match todo with
      | [] => break
      | n :: rest =>
        todo := rest
        if seen.contains n || !isLocal n then continue
        seen := seen.insert n
        if let some ci := env.find? n then
          todo := (directDeps ci).toList ++ todo
    return seen

private def sortNames (s : NameSet) : Array Name :=
  (s.toList.toArray).qsort (fun a b => a.toString < b.toString)

/-- Canonical statement text: every constant in the local closure, sorted, with its type and
(for definitions) its body. Its SHA-256 is what the lock file stores. -/
def canonicalStatement (env : Environment) (isLocal : Name → Bool) (root : Name) : String :=
  Id.run do
    let mut out := ""
    for n in sortNames (localClosure env isLocal #[root]) do
      if let some ci := env.find? n then
        out := out ++ s!"{n} : {ci.type}"
        match ci with
        | .defnInfo v => out := out ++ s!" := {v.value}"
        | .opaqueInfo v => out := out ++ s!" := {v.value}"
        | _ => pure ()
        out := out ++ "\n"
    return out

/-! ## Lock file -/

structure PaperRef where
  path : String
  sha256 : String
  section_ : String
  quote : String

structure Lock where
  id : String
  ns : Name
  status : String
  paper : PaperRef
  paperClaimSha : String
  formalClaimSha : String
  formalProof : Option Name
  sharedVocabulary : Array Name
  publics : Array Name
  drift : String

private def getStr (j : Json) (k : String) : Except String String := j.getObjValAs? String k

private def parseLock (j : Json) : Except String Lock := do
  let p ← j.getObjVal? "paper"
  let fp := (j.getObjValAs? String "formal_proof").toOption.filter (· ≠ "")
  return {
    id := ← getStr j "id"
    ns := (← getStr j "namespace").toName
    status := ← getStr j "status"
    paper := { path := ← getStr p "path", sha256 := ← getStr p "sha256",
               section_ := ← getStr p "section", quote := ← getStr p "quote" }
    paperClaimSha := (getStr j "paper_claim_sha256").toOption.getD ""
    formalClaimSha := (getStr j "formal_claim_sha256").toOption.getD ""
    formalProof := fp.map String.toName
    sharedVocabulary := ((j.getObjValAs? (Array String) "shared_vocabulary").toOption.getD #[]).map
      String.toName
    publics := ((j.getObjValAs? (Array String) "public").toOption.getD #[]).map String.toName
    drift := (getStr j "drift").toOption.getD "" }

/-! ## The gate -/

/-- Axioms the kernel accepts in this project. -/
def standardAxioms : List Name := [``propext, ``Classical.choice, ``Quot.sound]

private def axiomFailures (decl : Name) : CoreM (Array String) := do
  let axs ← collectAxioms decl
  let mut out := #[]
  for a in axs do
    if a == ``sorryAx then
      out := out.push s!"SORRY {decl}: depends on sorryAx (sorry or admit)"
    else if a == ``Lean.ofReduceBool || a == ``Lean.trustCompiler ||
        a.components.contains `_native then
      out := out.push s!"NATIVE_DECIDE {decl}: depends on {a} (native_decide / compiler trust)"
    else if a ∉ standardAxioms then
      out := out.push s!"AXIOM {decl}: depends on non-standard axiom {a}"
  return out

private def rflHeads : List Name :=
  [``Iff.rfl, ``Iff.refl, ``rfl, ``Eq.refl, ``HEq.refl, ``Iff.of_eq]

/-- Strip leading lambdas/mdata to find the head constant of a proof term. -/
private partial def proofHead (e : Expr) : Option Name :=
  match e with
  | .mdata _ b => proofHead b
  | .lam _ _ b _ => proofHead b
  | _ =>
    -- `unfold`/`show` wrap the term in `id`; look through it (so `id Iff.rfl` is still caught)
    if e.isAppOfArity ``id 2 then proofHead e.appArg! else e.getAppFn.constName?

/-- Run the gate. `libraryMode := true` adds the import and catch-all scans over modules whose
name starts with `scanPrefix`; fixture tests use `false` and treat the current file as local. -/
def runTruthGate (lockPath : System.FilePath) (libraryMode : Bool := true) :
    CommandElabM Unit := do
  let raw ← IO.FS.readFile lockPath
  let j ← match Json.parse raw with
    | .ok j => pure j
    | .error e => throwError "TRUTH GATE FAIL: cannot parse {lockPath}: {e}"
  let locksJ ← match j.getObjValAs? (Array Json) "locks" with
    | .ok a => pure a
    | .error e => throwError "TRUTH GATE FAIL: lock file has no locks: {e}"
  let mut locks : Array Lock := #[]
  for lj in locksJ do
    match parseLock lj with
    | .ok l => locks := locks.push l
    | .error e => throwError "TRUTH GATE FAIL: malformed lock entry: {e}"
  let scanPrefix := ((j.getObjValAs? String "scan_prefix").toOption.getD "NS_Millennium_Proof").toName
  let semModule := ((j.getObjValAs? String "semantics_module").toOption.getD "").toName
  let headline := ((j.getObjValAs? (Array String) "headline_conclusions").toOption.getD #[]).map
    String.toName
  let intermediate : Array Name :=
    ((j.getObjValAs? (Array Json) "intermediate").toOption.getD #[]).filterMap fun e =>
      (e.getObjValAs? String "name").toOption.map String.toName
  let env ← getEnv
  let isLocal : Name → Bool := fun n =>
    match env.getModuleIdxFor? n with
    | some idx =>
        libraryMode && scanPrefix.isPrefixOf (env.header.moduleNames[idx.toNat]!)
    | none => env.contains n
  let mut fails : Array String := #[]
  -- names that a paper side must never reach
  let mut forbidden : NameSet := {}
  for l in locks do
    forbidden := forbidden.insert (l.ns ++ `formal_claim)
    forbidden := forbidden.insert (l.ns ++ `intended_correspondence)
    if let some fp := l.formalProof then forbidden := forbidden.insert fp
    for p in l.publics do forbidden := forbidden.insert p
  if libraryMode then
    unless env.header.moduleNames.contains semModule do
      fails := fails.push s!"NO_SEMANTICS_IMPORT: {semModule} is not imported by the root"
  let mut registered : NameSet := {}
  for n in intermediate do registered := registered.insert n
  for l in locks do
    let pc := l.ns ++ `paper_claim
    let fc := l.ns ++ `formal_claim
    let ic := l.ns ++ `intended_correspondence
    for p in l.publics do registered := registered.insert p
    if let some fp := l.formalProof then registered := registered.insert fp
    -- observation pass: print the locked paper side first
    unless env.contains pc do
      fails := fails.push s!"MISSING {l.id}: {pc} not found"
      continue
    logInfo m!"TRUTH GATE OBSERVE {l.id}: paper_claim [{l.paper.path} § {l.paper.section_}] := {(env.find? pc).get!.value!}"
    -- paper file, quote, statement hashes
    let paperBytes ← (IO.FS.readBinFile l.paper.path : IO ByteArray).toBaseIO
    match paperBytes with
    | .error e => fails := fails.push s!"PAPER_SHA {l.id}: cannot read {l.paper.path}: {e}"
    | .ok bytes =>
      let sha := sha256 bytes
      unless sha == l.paper.sha256 do
        fails := fails.push s!"PAPER_SHA {l.id}: {l.paper.path} sha256 {sha} ≠ locked {l.paper.sha256}"
      let txt := String.fromUTF8! bytes
      unless (txt.splitOn l.paper.quote).length > 1 do
        fails := fails.push s!"QUOTE {l.id}: verbatim quote not found in {l.paper.path}"
    let pSha := sha256 (canonicalStatement env isLocal pc).toUTF8
    unless pSha == l.paperClaimSha do
      fails := fails.push s!"HASH {l.id}: paper_claim statement sha256 {pSha} ≠ locked {l.paperClaimSha}"
    -- alias: the paper side never reaches the formal side
    let pClos := localClosure env isLocal #[pc]
    for n in sortNames pClos do
      if forbidden.contains n then
        fails := fails.push s!"ALIAS {l.id}: paper_claim depends on formal-side constant {n}"
    let fcExists := env.contains fc
    if fcExists then
      let fSha := sha256 (canonicalStatement env isLocal fc).toUTF8
      unless fSha == l.formalClaimSha do
        fails := fails.push s!"HASH {l.id}: formal_claim statement sha256 {fSha} ≠ locked {l.formalClaimSha}"
      let fClos := (localClosure env isLocal #[fc]).erase fc
      let vocab := localClosure env isLocal l.sharedVocabulary
      for n in sortNames fClos do
        -- auxiliary `_proof_i` terms are proofs (irrelevant to meaning) that Lean deduplicates
        -- across a module; they are still covered by the forbidden-constant check above
        let auxProof := match n with
          | .str _ s => s.startsWith "_proof_"
          | _ => false
        if pClos.contains n && !vocab.contains n && !auxProof then
          fails := fails.push s!"ALIAS {l.id}: paper_claim shares {n} with formal_claim outside the declared shared_vocabulary"
      for n in l.sharedVocabulary do
        if forbidden.contains n then
          fails := fails.push s!"ALIAS {l.id}: shared_vocabulary lists formal-side constant {n}"
    if l.status == "drift" then
      fails := fails.push s!"DRIFT {l.id}: {l.drift}"
      -- formal_claim must at least describe each public theorem accurately
      if fcExists then
        for p in l.publics do
          let some pci := env.find? p | fails := fails.push s!"MISSING {l.id}: public {p} not found"
          let ok ← liftTermElabM <| withTransparency .default <| isDefEq pci.type (mkConst fc)
          unless ok do
            fails := fails.push s!"DRIFT {l.id}: {p}'s type is not formal_claim either"
      continue
    unless l.status == "locked" do
      fails := fails.push s!"STATUS {l.id}: unknown status {l.status}"
      continue
    unless fcExists do
      fails := fails.push s!"MISSING {l.id}: {fc} not found"
      continue
    let some ici := env.find? ic
      | fails := fails.push s!"MISSING {l.id}: {ic} not found"; continue
    unless ici.type == mkApp2 (mkConst ``Iff) (mkConst fc) (mkConst pc) do
      fails := fails.push s!"SHAPE {l.id}: {ic} is not `formal_claim ↔ paper_claim`"
    -- theorem bodies are only returned with `allowOpaque := true`
    match ici.value? (allowOpaque := true) with
    | some v =>
      if let some h := proofHead v then
        if rflHeads.contains h then
          fails := fails.push s!"RFL {l.id}: correspondence proved by {h}"
    | none => fails := fails.push s!"MISSING {l.id}: no proof term available for {ic}"
    let isTriv : Bool ← liftTermElabM do
      try withTransparency .default (isDefEq (mkConst fc) (mkConst pc))
      catch _ => pure true
    if isTriv then
      fails := fails.push s!"TRIVIAL {l.id}: formal_claim and paper_claim are definitionally equal (or undecided); the correspondence is vacuous"
    for d in #[pc, fc, ic] do
      fails := fails ++ (← liftCoreM <| axiomFailures d)
    if let some fp := l.formalProof then
      match env.find? fp with
      | none => fails := fails.push s!"MISSING {l.id}: formal proof {fp} not found"
      | some fci =>
        let ok ← liftTermElabM <| withTransparency .default <| isDefEq fci.type (mkConst fc)
        unless ok do fails := fails.push s!"SHAPE {l.id}: {fp} does not prove formal_claim"
        fails := fails ++ (← liftCoreM <| axiomFailures fp)
    for p in l.publics do
      let some pci := env.find? p
        | fails := fails.push s!"MISSING {l.id}: public {p} not found"; continue
      unless pci.type == mkConst pc do
        fails := fails.push s!"UNTRANSPORTED {p}: type is not exactly {pc}"
      let transported := match pci.value? (allowOpaque := true) with
        | some v =>
          let v := v.consumeMData
          v.isAppOfArity ``Iff.mp 4 && v.getArg! 2 == mkConst ic &&
            (match l.formalProof with
             | some fp => v.getArg! 3 == mkConst fp
             | none => true)
        | none => false
      unless transported do
        fails := fails.push s!"UNTRANSPORTED {p}: proof is not `intended_correspondence.mp <formal proof>`"
      fails := fails ++ (← liftCoreM <| axiomFailures p)
      if libraryMode then
        if let some idx := env.getModuleIdxFor? p then
          let imps := env.header.moduleData[idx.toNat]!.imports
          unless imps.any (·.module == semModule) do
            fails := fails.push s!"NO_SEMANTICS_IMPORT {p}: its module does not import {semModule} directly"
  -- catch-all: no unregistered theorem concludes a headline or locked proposition
  if libraryMode then
    let mut watched : NameSet := {}
    for n in headline do watched := watched.insert n
    for l in locks do
      watched := watched.insert (l.ns ++ `paper_claim)
      watched := watched.insert (l.ns ++ `formal_claim)
    let mut cands : Array (Name × Expr) := #[]
    for (n, ci) in env.constants.toList do
      if n.isInternal then continue
      unless ci matches .thmInfo _ do continue
      unless isLocal n do continue
      cands := cands.push (n, ci.type)
    let hits ← liftTermElabM do
      let mut hits := #[]
      for (n, ty) in cands do
        let head ← forallTelescope ty fun _ b => pure b.getAppFn.constName?
        if let some h := head then
          if watched.contains h then hits := hits.push n
      return hits
    for n in hits do
      unless registered.contains n do
        fails := fails.push s!"UNREGISTERED {n}: concludes a headline/locked proposition but is neither a transported public theorem, a registered formal proof, nor listed as intermediate"
  for l in locks do
    let mut keys : Array String := #[s!" {l.id}:", s!" {l.ns}."]
    for p in l.publics do keys := keys.push s!" {p}:"
    if let some fp := l.formalProof then keys := keys.push s!" {fp}:"
    let mine := fails.filter fun s => keys.any fun k => (s.splitOn k).length > 1
    if mine.isEmpty then
      logInfo m!"TRUTH GATE PASS {l.id}"
    else
      logInfo m!"TRUTH GATE RED {l.id}: {mine.size} failure(s)"
  for s in fails do logInfo m!"TRUTH GATE FAIL {s}"
  logInfo m!"TRUTH GATE SUMMARY locks={locks.size} failures={fails.size}"
  unless fails.isEmpty do
    throwError "TRUTH GATE FAILED: {fails.size} failure(s); see TRUTH GATE FAIL lines"

end TruthGate
