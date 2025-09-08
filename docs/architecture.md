SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Architecture Notes

- Public headers remain minimal and stable (see API review checklist).
- Error handling is explicit; [[nodiscard]] on status-returning functions.
- All modules avoid global state; initialization is explicit.
