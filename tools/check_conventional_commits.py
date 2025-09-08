#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

import os, re, subprocess, sys

PAT = re.compile(r"^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?:")
base = os.environ.get("GITHUB_BASE_REF") or "main"
try:
    logs = subprocess.check_output(["git","log","--pretty=%s","origin/"+base+".."], text=True).splitlines()
except Exception:
    logs = subprocess.check_output(["git","log","--pretty=%s"], text=True).splitlines()

bad = [m for m in logs if m and not PAT.match(m)]
if bad:
    print("Non-conventional commit messages detected:")
    for b in bad:
        print(" -", b)
    sys.exit(1)
print("Conventional commits check passed.")
