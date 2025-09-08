#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
BASE="${GITHUB_BASE_REF:-main}"
git fetch origin "$BASE" --depth=1 >/dev/null 2>&1 || true
if git diff --name-only "origin/$BASE"... | grep -qE '^(src/|include/|CMakeLists\.txt|Dockerfile)'; then
  if ! git diff --name-only "origin/$BASE"... | grep -q '^CHANGELOG.md$'; then
    echo "::error ::CHANGELOG.md must be updated for code changes"
    exit 1
  fi
fi
echo "Changelog check passed."
