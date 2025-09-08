SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Memory Safety Policy
- ASan/UBSan/TSan required to be green on C++ changes.
- No unchecked casts; use optional/variant.
- Public APIs document ownership and mutability.
- clang-tidy/cppcheck/CodeQL issues must be fixed or justified.
