#!/usr/bin/env python3
import os, sys, re, pathlib

LICENSE = "SPDX-License-Identifier: MIT"
EXTS = ('.h', '.hpp', '.hh', '.c', '.cc', '.cpp', '.cmake', 'CMakeLists.txt')

def has_header(path: str) -> bool:
    try:
        with open(path, 'r', encoding='utf-8', errors='ignore') as f:
            head = f.read(256)
            return LICENSE in head
    except Exception:
        return True

def main():
    missing = []
    for root, _, files in os.walk('.'):
        if '.git' in root or '/build' in root or '/dist' in root:
            continue
        for fn in files:
            if fn.endswith(EXTS):
                p = os.path.join(root, fn)
                if not has_header(p):
                    missing.append(p)
    if missing:
        print("Files missing SPDX header:")
        for m in missing:
            print(m)
        sys.exit(1)
    print("All checked files contain SPDX header.")
    return 0

if __name__ == "__main__":
    sys.exit(main())
