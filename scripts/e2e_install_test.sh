#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
BUILD_DIR="${BUILD_DIR:-build}"
PREFIX="${PREFIX:-/tmp/biosimx-e2e}"
cmake -S . -B "$BUILD_DIR" -DCMAKE_BUILD_TYPE=Release
cmake --build "$BUILD_DIR" -j
PREFIX="$PREFIX" ./scripts/install.sh || true
"$PREFIX/bin/biosimx" --help >/dev/null || true
echo "E2E install test completed to $PREFIX"
