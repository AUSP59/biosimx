#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
for loc in C en_US.UTF-8 fr_FR.UTF-8 es_MX.UTF-8; do
  echo "== $loc =="
  LC_ALL=$loc ./build/bin/biosimx --help >/dev/null || true
done
