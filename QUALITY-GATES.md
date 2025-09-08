SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Quality Gates

- CI green on Linux/macOS/Windows
- Sanitizers: ASan/UBSan/TSan clean
- Static analysis: clang-tidy, cppcheck
- Format: clang-format clean
- Unit/Integration tests >= 80% changed lines
- Fuzz: nightly, no new crashes in 7 days
- Scorecard: no critical findings
