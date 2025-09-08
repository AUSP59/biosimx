#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
BIN="${1:-./build/bin/biosimx}"
OUTDIR="${2:-man}"
mkdir -p "$OUTDIR"
if command -v help2man >/dev/null; then
  help2man -N -n "BioSimX CLI" -o "$OUTDIR/biosimx.1" "$BIN" || true
  echo "Manpage written to $OUTDIR/biosimx.1"
else
  echo "help2man not installed; skipping manpage generation."
fi
