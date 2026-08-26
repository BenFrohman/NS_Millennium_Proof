# Actions / Dependabot / CodeQL note

## Dependabot tip: "Insufficient permission for ignore"

This GitHub tip appears when Dependabot ignore (UI or PR comment like
`[dependabot ignore this dependency]`) is attempted without sufficient permissions.

**Fix checklist**

1. Merge this PR so `.github/dependabot.yml` exists for `github-actions`.
2. Repo **Settings → Actions → General → Workflow permissions**:
   - set **Read and write permissions**
   - enable **Allow GitHub Actions to create and approve pull requests** if shown
3. Repo **Settings → Code security** (or Dependency graph):
   - enable **Dependabot alerts**
   - enable **Dependabot security updates** (and version updates if desired)
4. Retry the ignore, or close the Dependabot PR manually as repo admin.

## CodeQL Advanced `startup_failure`

`main` currently uses `.github/workflows/lean.yml`. Older **CodeQL Advanced** runs
came from a prior `codeql.yml` that was removed in the professional-polish merge.
If CodeQL default setup is enabled under **Settings → Code security → Code scanning**,
either disable default setup or restore a Lean-friendly `codeql.yml` that only scans
`python` + `actions` (Lean is not a CodeQL language).

Restoring any file under `.github/workflows/` via `git push` over HTTPS requires a
token with the **`workflow`** scope:

```bash
gh auth refresh -h github.com -s workflow
git push -u origin HEAD
```
