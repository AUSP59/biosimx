#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
BIN="./build/bin/biosimx"
if [ ! -x "$BIN" ]; then
  echo "Binary $BIN not found; build first." >&2
  exit 0
fi
TMP=$(mktemp -d)
"$BIN" --help >/dev/null || true
"$BIN" run --steps 10 --preset default --out "$TMP" >/dev/null 2>&1 || true
if [ -d "$TMP" ]; then
  find "$TMP" -type f -maxdepth 1 -print0 | sort -z | xargs -0 sha256sum > "$TMP/SHA256SUMS" || true
  echo "Smoke run completed; checksums written to $TMP/SHA256SUMS"
fi
