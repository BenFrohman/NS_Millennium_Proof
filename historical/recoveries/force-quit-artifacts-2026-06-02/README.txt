RECOVERY ARTIFACTS from force-quit incident on 2026-06-02

These are safety backups created during the post-crash recovery.

- SymplecticTether.lean.bak.pre-snap-20260602T0550 : This is the EXACT content of the core proof file as it was on disk at the moment of the force-quit / freeze. This contains the last edits (including the large "WHAT SPECIFIC CALCS I NEED" scaffolding comment that was inserted in the final search-replace before the long greps hung the app). This was the "last project edition".

- SymplecticTether.lean.bak.current-134k : Intermediate state during recovery attempts.

- REVERT_2026-06-02.md : Note from the initial recovery pass.

The main SymplecticTether.lean has been restored to the above "last edition" content, and these files were moved out of Modules/ so your source tree has the original clean file names and structure you had when the app froze.

All your days of work on the Frohmanian Symplectic Tether (the two-layer architecture, 5-step canonicity, 9-term Jacobi, CE cocycle, etc.) are preserved in the current files under NS_Millennium_Proof/Modules/ + the historical/ tree (which contains the full chat histories and evolution per the June 2 Clay cleanup).

If you need to diff this "last edition" against any of the rewind snapshots (multiple timestamped versions captured at prompt boundaries in the previous session), or against ns_lean_local_clean/, just tell me the specific time or "show me the diff to the 05:38 snap".

The structure (Assumptions.lean, Uniqueness.lean, Skeleton/, etc.) is from the deliberate June 2 "Clay Panel Cleanup" refactor to make the package referee-ready (see historical/CLAY_PANEL_CLEANUP_AUDIT_2026-06-02.md). File names were intentionally changed/organized then as part of the DAYS of work.

