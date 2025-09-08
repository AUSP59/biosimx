SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Zero-Trust CI Guidelines

- Principle of least privilege in all workflows (scoped tokens, `permissions:` blocks).
- Pin actions by version digest when feasible.
- Separate build/test from release; release requires tags and human review.
