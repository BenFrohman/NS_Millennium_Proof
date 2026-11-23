#!/bin/bash
# compile FTVerified modules in dep order into scratch olean dir (no lake, no downloads)
source /workspace/tv-scratch-olean.env
LEAN=$HOME/.elan/toolchains/leanprover--lean4---v4.30.0-rc1/bin/lean
OUT=/workspace/tv-scratch-olean
declare -A done
build() {
  local m=$1; [[ -n "${done[$m]}" ]] && return 0
  local f=${m//.//}.lean
  for d in $(grep -E '^import FTVerified' $f | awk '{print $2}'); do build $d || return 1; done
  local o=$OUT/${m//.//}.olean; mkdir -p $(dirname $o)
  if [[ ! -f $o || $f -nt $o ]]; then echo "lean $m"; $LEAN -o $o -i ${o%.olean}.ilean $f || return 1; fi
  done[$m]=1
}
for m in "$@"; do build $m || exit 1; done
