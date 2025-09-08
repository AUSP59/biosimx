SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Reproducible Builds

- Pin compiler versions in CI jobs.
- Avoid non-deterministic macros (e.g., __DATE__, __TIME__).
- Provide SBOM (SPDX) and checksums for all artifacts.
- Publish exact CMake flags and presets used for releases.
