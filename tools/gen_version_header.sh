#!/usr/bin/env bash
set -euo pipefail
VER="${1:-$(git describe --tags --always --dirty 2>/dev/null || echo 0.0.0)}"
OUT="${2:-include/biosimx/version.hpp}"
mkdir -p "$(dirname "$OUT")"
cat > "$OUT" <<EOF
// Auto-generated. Do not edit.
// SPDX-License-Identifier: MIT
#pragma once
#define BIOSIMX_VERSION_STR "${VER}"
EOF
echo "Wrote $OUT with version $VER"
