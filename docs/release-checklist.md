SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Release Checklist

- [ ] Ensure CI green across matrix and sanitizers
- [ ] Bump version (CMake/CPack) and tag `vX.Y.Z`
- [ ] Run secure-release (Cosign keyless + SLSA + SBOM)
- [ ] Update Homebrew/Scoop/Chocolatey/RPM/DEB hashes
- [ ] Post release notes using template
- [ ] Verify signatures and provenance with provided script
