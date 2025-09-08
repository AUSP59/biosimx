#!/usr/bin/env python3
# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

import json, sys, pathlib
schema = json.loads(pathlib.Path("schema/config.schema.json").read_text(encoding="utf-8"))
def validate(obj, schema):
    if not isinstance(obj, dict): raise ValueError("config must be an object")
    for k in schema["required"]:
        if k not in obj: raise ValueError(f"missing required field: {k}")
    if not isinstance(obj["steps"], int) or obj["steps"] < 1: raise ValueError("steps must be integer >=1")
    if obj["preset"] not in ["default","fast","accurate"]: raise ValueError("preset must be default|fast|accurate")
    if not isinstance(obj["output"], str) or not obj["output"]: raise ValueError("output must be non-empty string")
    for k in obj:
        if k not in schema["properties"]: raise ValueError(f"unknown field: {k}")
    return True
def main():
    if len(sys.argv) < 2:
        print("usage: validate_config.py <config.json>", file=sys.stderr); sys.exit(2)
    data = json.loads(pathlib.Path(sys.argv[1]).read_text(encoding="utf-8"))
    validate(data, schema)
    print("config OK")
if __name__ == "__main__": main()
