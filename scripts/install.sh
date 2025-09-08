#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
PREFIX="{{ PREFIX:-/usr/local }}"
install -d "$PREFIX/bin"
install -m 0755 build/bin/biosimx "$PREFIX/bin/biosimx"
echo "Installed to $PREFIX/bin/biosimx"
