SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Project Governance

## Roles
- **Maintainers**: Own technical direction and releases; rotate triage weekly.
- **Reviewers**: Merge authority via CODEOWNERS; at least 2 LGTMs for risky changes.
- **Contributors**: Welcome PRs with tests and docs; DCO + Conventional Commits required.

## Decision Making
- Lazy consensus. For breaking changes, use ADRs and a 72h public window.
- Security fixes may be under embargo; see Coordinated Disclosure policy.

## Releases
- Tag `vX.Y.Z` triggers secure release (Cosign keyless, SBOM, provenance).
- Backports per Backport Policy; Support Policy defines lifetimes.
