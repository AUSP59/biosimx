SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Threat Model (STRIDE-lite)
| Category | Example | Mitigation |
|---|---|---|
| Spoofing | Tampered binaries | Cosign keyless signatures, provenance |
| Tampering | Malicious PR | CI required checks, CODEOWNERS, merge queue |
| Repudiation | Untraceable releases | SBOM + provenance + signatures |
| Info Disclosure | Secrets in repo | trufflehog + gitleaks |
| DoS | Pathological inputs | Input size limits; timeouts (doc'd) |
| Elevation | CI token abuse | Least-privilege perms in workflows |
