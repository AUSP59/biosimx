#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
BIN="${1:-./build/bin/biosimx}"
OUTDIR="${2:-completions}"
CLI="biosimx"
mkdir -p "$OUTDIR"
HELP="$("$BIN" --help 2>/dev/null || true)"
OPTS=$(printf "%s" "$HELP" | grep -Eo -- '--[a-zA-Z0-9][a-zA-Z0-9-]+' | sort -u)

# bash
cat > "$OUTDIR/${CLI}.bash" <<'BASH'
__CLI__()
{
  COMPREPLY=()
  local cur="${COMP_WORDS[COMP_CWORD]}"
  local opts="__OPTS__"
  COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
  return 0
}
complete -F __CLI__ __CLI__
BASH

# zsh
cat > "$OUTDIR/_${CLI}" <<'ZSH'
#compdef __CLI__
_arguments '*::args:->args'
local -a opts
opts=( __OPTS__ )
_describe 'values' opts
ZSH

# fish
cat > "$OUTDIR/${CLI}.fish" <<'FISH'
complete -c __CLI__ __FISHOPTS__
FISH

# Replace placeholders
sed -i "s/__CLI__/${CLI}/g" "$OUTDIR/${CLI}.bash" "$OUTDIR/_${CLI}" "$OUTDIR/${CLI}.fish" || true
BASH_OPTS=$(echo "$OPTS" | tr '\n' ' ')
sed -i "s/__OPTS__/${BASH_OPTS}/g" "$OUTDIR/${CLI}.bash" "$OUTDIR/_${CLI}" || true
FISH_OPTS=$(printf "%s" "$OPTS" | sed 's/^/ -l /' | tr '\n' ' ')
sed -i "s/__FISHOPTS__/${FISH_OPTS}/g" "$OUTDIR/${CLI}.fish" || true

echo "Generated completions in $OUTDIR"
