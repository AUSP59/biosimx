#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
echo "== Formatting check =="
if command -v clang-format >/dev/null; then ./tools/run_clang_format_check.sh || true; fi
echo "== Configure & Build =="
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=RelWithDebInfo
cmake --build build -j
echo "== Tests =="
ctest --test-dir build --output-on-failure || true
echo "== Lints (best-effort) =="
pre-commit run --all-files || true
echo "== Coverage (best-effort) =="
if command -v lcov >/dev/null; then echo "Run coverage workflow in CI for full report."; fi
echo "== DONE =="
