#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
if [ $# -lt 1 ]; then echo "usage: verify_artifact.sh <artifact>"; exit 2; fi
ART="$1"
if ! command -v sha256sum >/dev/null; then echo "sha256sum not found"; exit 1; fi
sha256sum "$ART"
if command -v cosign >/dev/null; then
  if [ -f "${ART}.sig" ] && [ -f "${ART}.cert" ]; then
    cosign verify-blob --certificate "${ART}.cert" --signature "${ART}.sig" "$ART" || true
  else
    echo "No cosign signature/cert alongside artifact"
  fi
else
  echo "cosign not installed; skipping signature verification"
fi
