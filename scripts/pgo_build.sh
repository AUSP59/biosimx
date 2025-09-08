#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
cmake -S . -B build-pgo -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS='-fprofile-generate'
cmake --build build-pgo -j
./build-pgo/bin/biosimx --help >/dev/null || true
cmake -S . -B build-pgo-use -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_FLAGS='-fprofile-use -fprofile-correction'
cmake --build build-pgo-use -j
