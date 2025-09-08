SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Performance Guide
- Use `perf record/report` on Linux; `Instruments` on macOS; `ETW/WPA` on Windows.
- Prefer stable, representative datasets; pin CPU governor and disable turbo for repeatability.
- Consider PGO and LTO trade-offs; measure tail latencies, not solo medias.
