#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"
cmake -S . -B build-rel -DCMAKE_BUILD_TYPE=Release
cmake --build build-rel -j
mkdir -p dist
tar -C build-rel/bin -czf dist/biosimx-linux-amd64.tar.gz . || true
if ! command -v syft >/dev/null; then echo "Install syft for SBOM (optional)"; else syft dir:. -o spdx-json=dist/sbom.spdx.json || true; fi
if ! command -v cosign >/dev/null; then echo "Install cosign to sign (optional)"; fi
sha256sum dist/* || true
echo "Dry run complete. Artifacts in ./dist"
