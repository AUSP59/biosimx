SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# CMake Options

- `BIOSIMX_ENABLE_LTO` (default: ON in release presets)
- Optional sanitizers via presets (`asan`, `tsan`)
- Optional ccache via `cmake/Cache.cmake`
- Apply `biosimx_set_default_visibility(<target>)` for shared libs
