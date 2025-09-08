#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

set -euo pipefail
if command -v apt-get >/dev/null; then
  sudo apt-get update
  sudo apt-get install -y cmake ninja-build g++ clang-tidy cppcheck valgrind lcov python3-pip
elif command -v brew >/dev/null; then
  brew install cmake ninja llvm cppcheck valgrind lcov python
fi
pip3 install --user pre-commit
pre-commit install || true
echo "Bootstrap complete."
