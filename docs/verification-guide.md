SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Release Verification Guide

## Verify SBOM
Download `sbom.spdx.json` from the release and inspect for expected packages.

## Verify signatures (Cosign keyless)
```bash
cosign verify-blob --certificate <artifact>.cert --signature <artifact>.sig <artifact>
```

## Verify provenance (SLSA)
Follow the SLSA GitHub Generator docs to validate the attestation on `biosimx` artifacts.
