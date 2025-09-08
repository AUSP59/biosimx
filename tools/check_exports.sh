#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
command -v nm >/dev/null || exit 0
find ./build/bin -maxdepth 1 -type f -executable -print0 | xargs -0 -r nm -D 2>/dev/null | head -n 200 || true
