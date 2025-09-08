SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Hardening Flags
- Enable FORTIFY, stack protector, RELRO/now where applicable.
- Consider LTO in Release builds when reproducibility allows.
- Strip symbols in release; provide separate debug info when packaging.
