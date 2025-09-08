#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
BUILD=build-pgo-gen
cmake -S . -B $BUILD -G Ninja -DCMAKE_BUILD_TYPE=Release -DBIOSIMX_ENABLE_PGO_GENERATE=ON
cmake --build $BUILD -j
# Run representative workloads here (replace with real dataset)
./$BUILD/bin/biosimx --help >/dev/null || true
echo "Now rebuild with BIOSIMX_ENABLE_PGO_USE=ON pointing to generated profiles."
