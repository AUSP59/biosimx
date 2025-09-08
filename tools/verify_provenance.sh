#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
ART="$1"
cosign verify-blob --certificate "${ART}.cert" --signature "${ART}.sig" "$ART"
echo "Signature ok for $ART"
