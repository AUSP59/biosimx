#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
shopt -s globstar
files=( $(git ls-files '*.h' '*.hpp' '*.c' '*.cc' '*.cpp') )
[ ${#files[@]} -eq 0 ] && exit 0
fail=0
for f in "${files[@]}"; do
  clang-format --dry-run --Werror "$f" || fail=1
done
exit $fail
