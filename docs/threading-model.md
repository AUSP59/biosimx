SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Threading Model

- Deterministic stepping is single-thread by default.
- Parallel execution may be enabled behind a flag with identical results guaranteed.
- Any parallel mode must avoid shared mutable state without proper synchronization.
