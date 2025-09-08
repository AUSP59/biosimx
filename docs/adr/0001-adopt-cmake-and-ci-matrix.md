SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# ADR 0001: Adopt CMake & Multi-OS CI Matrix
* Status: accepted
* Deciders: Maintainers
* Date: 2025-08-27

## Context
We need portable, reproducible builds and tests across major OSes.
## Decision
Adopt CMake with presets and a GitHub Actions matrix (Linux/macOS/Windows).
## Consequences
Consistent build/test UX and simpler onboarding; CI time balanced via cache.
