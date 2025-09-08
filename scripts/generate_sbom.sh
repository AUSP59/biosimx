#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
which syft || (echo "Install Syft first" && exit 1)
syft dir:. -o spdx-json=sbom.spdx.json
