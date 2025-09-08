SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# First Signed Release Guide

1. Push a tag `v1.0.0` to your GitHub repo.
2. The `secure-release` workflow will build, generate **SBOM**, **sign artifacts** (Cosign keyless), and attach **SLSA provenance**.
3. Download artifacts and compute SHA256 for Homebrew/Scoop/Chocolatey manifests.
4. Update:
   - `packaging/homebrew/biosimx.rb` (url/sha256)
   - `packaging/scoop/biosimx.json` (url/hash)
   - `packaging/choco/biosimx.nuspec` (version/urls if needed)
5. Publish packages using their respective registries.
