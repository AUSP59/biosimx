SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Secure Release Flow (Mermaid)

```mermaid
sequenceDiagram
  participant Dev
  participant CI
  participant Sigstore
  participant GH as GitHub Release

  Dev->>CI: push tag vX.Y.Z
  CI->>CI: build + SBOM
  CI->>Sigstore: keyless sign artifacts
  Sigstore-->>CI: cert + signature
  CI->>GH: upload artifacts, SBOM, signatures, SLSA attestation
```
