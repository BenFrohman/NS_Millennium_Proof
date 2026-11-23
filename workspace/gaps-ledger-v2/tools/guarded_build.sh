#!/bin/bash
# runs lake build; kills it if any Mathlib/batteries/aesop module starts compiling
LOG=$1; shift
( lake "$@" 2>&1 & echo $! > /tmp/gl_lake.pid; wait ) | while IFS= read -r line; do
  echo "$line" >> "$LOG"
  if echo "$line" | grep -qE '(Building|Built|Compiling) (Mathlib|Batteries|Aesop|Qq|Plausible|ProofWidgets)\.'; then
    echo "GUARD: upstream rebuild detected, killing" >> "$LOG"; pkill -P $(cat /tmp/gl_lake.pid); kill $(cat /tmp/gl_lake.pid); exit 3
  fi
done
echo "EXIT ${PIPESTATUS[0]}" >> "$LOG"
