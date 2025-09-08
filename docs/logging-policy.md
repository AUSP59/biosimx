SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Logging Policy
- Avoid sensitive data; redact tokens and user paths when feasible.
- Provide `--log-level` and respect `NO_COLOR`.
- Prefer structured lines: `LEVEL TS module msg key=value` (human-friendly).