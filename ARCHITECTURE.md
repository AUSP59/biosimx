SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Architecture Overview

BioSimX uses a toroidal grid and structure-of-arrays layout for performance. The engine steps are deterministic and operate on a ping-pong buffer between `Field` instances. The CLI composes the model, runs steps, and emits metrics to CSV/JSON as configured.

## Modules
- `include/biosimx/` public headers
- `src/` core engine, CLI, C API
- `tests/`, `benchmarks/`, `fuzz/` quality gates
