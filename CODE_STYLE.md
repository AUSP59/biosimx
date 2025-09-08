SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# C++ Style Guide (Project)

- Modern C++ (C++20 or newer if available); prefer STL over custom containers
- RAII for resource management; no naked new/delete
- Error handling: status objects or exceptions with clear boundaries
- Public headers in `include/` with minimal dependencies
- Strict warnings as errors for project code
