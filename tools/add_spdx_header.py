#!/usr/bin/env python3
import sys, pathlib
SPDX = "// SPDX-License-Identifier: MIT\n"
for p in sys.argv[1:]:
    fp = pathlib.Path(p)
    if not fp.is_file(): continue
    txt = fp.read_text(encoding="utf-8", errors="ignore")
    if "SPDX-License-Identifier" not in txt.splitlines()[0]:
        fp.write_text(SPDX + txt, encoding="utf-8")
        print("Added SPDX to", p)
