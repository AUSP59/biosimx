SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# ABI Stability Policy

- Public headers under `include/` define the stable ABI surface.
- Breaking changes require a major version bump (SemVer) and migration notes.
- Exported symbols are minimized via default-hidden visibility; only intended API is visible.
