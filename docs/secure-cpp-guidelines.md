SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Secure C++ Guidelines
- Prefer RAII and smart pointers; avoid raw new/delete.
- Bound-check indices; prefer .at() when safety-critical.
- [[nodiscard]] on status-returning APIs.
- Document thread-safety and ownership.
- Zero-warnings policy; sanitize inputs and resource usage.
