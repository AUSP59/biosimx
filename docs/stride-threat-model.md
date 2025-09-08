SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# STRIDE Threat Model (Summary)

| Category | Example Risk | Mitigation |
|---------:|--------------|------------|
| Spoofing | Impersonating release artifacts | Cosign keyless signatures, SLSA provenance |
| Tampering | Malicious PR modifies build | Required reviews, CI gates, CodeQL |
| Repudiation | Lack of audit trail | Signed tags, PR reviews, issue templates |
| Information Disclosure | Verbose logs | Sanitized logs, redact secrets |
| Denial of Service | Huge inputs | Limits, validation, fuzzing corpus |
| Elevation of Privilege | CI token misuse | Least-privilege permissions, OIDC |
