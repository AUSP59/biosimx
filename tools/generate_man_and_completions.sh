#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
BIN="build/bin/biosimx"
mkdir -p man completions
if [ -x "$BIN" ]; then
  command -v help2man >/dev/null 2>&1 && help2man -N -n "BioSimX CLI" -o man/biosimx.1 "$BIN" || true
  for sh in bash zsh fish; do
    "$BIN" --generate-completion "$sh" > "completions/biosimx.$sh" 2>/dev/null || true
  done
else
  echo "Binary $BIN not found; build first."
fi
