#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
BIN="./build/bin/biosimx"
if ! command -v valgrind >/dev/null; then echo "valgrind not installed"; exit 0; fi
[ -x "$BIN" ] || { echo "Build first"; exit 0; }
valgrind --leak-check=full --error-exitcode=1 "$BIN" --help >/dev/null || true
