#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

import os, subprocess, sys, re
base = os.environ.get("GITHUB_BASE_REF") or "main"
try:
    logs = subprocess.check_output(["git", "log", "--pretty=%H%x09%B", "origin/"+base+".."], text=True)
except Exception:
    logs = subprocess.check_output(["git", "log", "--pretty=%H%x09%B"], text=True)
bad = []
for entry in logs.strip().split("\n\n"):
    if not entry.strip():
        continue
    commit, msg = entry.split("\t", 1) if "\t" in entry else ("<unknown>", entry)
    if "Signed-off-by:" not in msg:
        bad.append(commit[:12])
if bad:
    print("DCO sign-off missing in commits:", ", ".join(bad))
    sys.exit(1)
print("DCO check passed.")
