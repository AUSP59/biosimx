SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Risk Register
- **Build Supply Chain**: mitigated with SBOM (SPDX/CycloneDX), signed releases, SLSA provenance, Dependency Review, Scorecard.
- **Memory Safety**: mitigated with sanitizers (ASan/UBSan/TSan/MSan), static analysis, and CI gates.
- **Reproducibility**: mitigated using SOURCE_DATE_EPOCH, deterministic flags, and diffoscope checks.
- **Docs Rot**: mitigated with markdown-link-check CI and ownership via CODEOWNERS.
