#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
PREFIX="{{ PREFIX:-/usr/local }}"
rm -f "$PREFIX/bin/biosimx"
echo "Removed $PREFIX/bin/biosimx"
