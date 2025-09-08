SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Release Signing & Provenance Policy

- All official release artifacts are keylessly signed using Sigstore Cosign via GitHub OIDC.
- Every artifact ships with `.sig` (signature) and `.cert` (certificate) files.
- A SPDX SBOM (`sbom.spdx.json`) is generated for each release.
- Users can verify signatures offline via `cosign verify-blob` against the attached certificate.
