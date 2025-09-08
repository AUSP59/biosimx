SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# BioSimX — Security Policy (SECURITY.md)

## 0) Summary
BioSimX is a local, deterministic C++17 biosimulation CLI with no network-facing services. Its primary attack surfaces are: command-line parsing, JSON configuration, file I/O (CSV/PPM), multithreading, and the build/supply chain. This policy explains how to report vulnerabilities, how we triage and fix them, what we consider “in scope,” and how we ship secure releases.

## 1) Contact & Reporting (Private Only)
Please do not file public issues for suspected vulnerabilities.

Preferred channels (private):
- Email: alanursapu@gmail.com (Lead Maintainer: AUSP59)
- GitHub Security Advisory: “Report a vulnerability” in the repository (encrypted to maintainers)

Optional encryption:
- If you require PGP, state this in your first email; we will reply with a key/fingerprint or set up an Advisory thread.

What to include (as much as possible):
- A clear description of the issue and impact
- Steps to reproduce (repro config/args, minimal PoC)
- Affected commit/release, OS/arch/toolchain
- Crash logs, sanitizers output, backtraces, screenshots where relevant
- Your disclosure preference (credit vs. anonymity)

We will keep your report confidential, share details only with people who need to know, and follow Coordinated Vulnerability Disclosure (CVD).

## 2) Service Levels (Target)
- Acknowledgement: within 72 hours
- Initial triage: within 7 calendar days (CVSS v3.1 prelim score + scope)
- Fix plan: within 14 days for High/Critical; 30 days for Medium; best effort for Low
- Patch release: typically within 30 days (High/Critical) after confirmation; subject to complexity and backports
- Public disclosure: after a fix is available and users have a reasonable update window, or sooner if exploitation is observed

These are goals, not guarantees, but we aim to meet them.

## 3) Severity & Scoring
We use CVSS v3.1 as guidance. Practical impact (on typical BioSimX deployments) influences prioritization. Examples:
- Critical/High: memory-safety bugs enabling RCE when opening config or via malformed environment; path traversal writing outside intended output; TOCTOU + symlink overwrite of arbitrary files; UB exploitable for code execution; container escape vectors introduced by our image.
- Medium: denial-of-service via unbounded allocation (extreme dims), uncontrolled resource consumption, logic-related data corruptions.
- Low/Informational: minor info leaks, error-message disclosure, build-time warnings that do not affect runtime security.

## 4) Scope (What We Consider Vulnerabilities)
- Memory safety: heap/stack buffer overflows, UAF, double-free, iterator invalidation with write, data races causing corruptions
- Integer safety: overflow/underflow leading to OOB or logic bypass
- Path handling: directory traversal, symlink races, unintended overwrites in “--out”
- Config parsing/validation: schema bypass leading to unsafe states or crashes
- Concurrency: data races, deadlocks exploitable for DoS
- Build & supply chain: malicious dependency resolution, compromised toolchains, poisoned artifacts, release tampering
- Container image: running as root, missing non-root user, unsafe entrypoint, privileged defaults

Out of scope (normally):
- Social engineering, phishing, non-project infrastructure
- Vulnerabilities in third-party dependencies without a PoC showing impact on BioSimX
- Purely theoretical floating-point inaccuracies, non-security numeric instability
- Local denial-of-service through intentionally extreme, obviously hostile parameters when documented and bounded

## 5) Coordinated Vulnerability Disclosure (CVD)
- Report privately (email or Security Advisory).
- We triage, confirm, and assign a provisional severity.
- We develop a fix in a private patch branch or security fork, prepare tests, and stage releases.
- We may request a CVE ID via GitHub Security Advisories (if applicable).
- We credit reporters in release notes and SECURITY.md (unless anonymity requested).
- Public disclosure occurs once a fix is released and update guidance exists.

Embargo: fixes remain private until release artifacts and upgrade notes are ready.

Safe harbor: research conducted and reported in good faith, within legal boundaries, will not be met with legal threats from maintainers.

## 6) Supported Versions (Security Updates)
- main: actively supported; receives all security fixes
- last minor release: supported for at least 6 months after the next minor release
End-of-life branches receive no fixes. If you cannot upgrade, vendor a patch (per license) and notify us.

## 7) Secure Development Requirements (for Contributors)
- Never use unsafe C functions or equivalent patterns; prefer safe STL and bounds-checked operations.
- Keep file operations explicit: create directories with correct perms, use canonical paths, and fail safely on errors.
- Validate all untrusted inputs: CLI flags (range checking), JSON config (schema validation), environment variables.
- No dynamic loading of code or plugins without strict verification.
- No network I/O in core unless explicitly introduced with threat modeling and opt-in flags.
- Use constant-time patterns only where appropriate; do not claim cryptographic properties we do not provide.

Local checks before PR:
    clang-format -i $(git ls-files '*.hpp' '*.cpp' '*.h' | tr '\n' ' ')
    clang-tidy -p build $(git ls-files '*.cpp' | tr '\n' ' ')
    cmake --preset asan && cmake --build --preset asan -j && ctest --test-dir build --output-on-failure
    cmake --preset tsan && cmake --build --preset tsan -j && ctest --test-dir build --output-on-failure
    python3 tools/check_spdx_headers.py
    python3 tools/check_conventional_commits.py
    python3 tools/check_dco.py

Fuzzing (examples):
    cmake -S . -B build-fuzz -G Ninja -DCMAKE_CXX_FLAGS="-fsanitize=fuzzer,address" -DCMAKE_BUILD_TYPE=RelWithDebInfo
    cmake --build build-fuzz -j
    ./build-fuzz/bin/fuzz_args

## 8) Threat Model Snapshot (Current)
Assets:
- Executable biosimx, local file outputs (CSV/PPM), logs

Trust boundaries:
- Untrusted: user-provided JSON config, CLI args, filesystem state (existing paths, symlinks)
- Trusted: compiled binary, embedded defaults, repository scripts under maintainer control

Primary risks:
- Memory safety and concurrency issues on parsing/stepping loops
- Path traversal or symlink clobber on output
- Resource exhaustion via extreme dimensions or intervals
- Supply chain tampering in CI or releases

Mitigations in repo:
- JSON Schema validation for configs
- Strict warnings and sanitizer presets (ASan/TSan)
- Distroless runtime container; non-root (65532) entry
- Banned APIs and style policies (headers under include/biosimx/)
- Property tests and fuzz entrypoints

## 9) Hardening Guidance (Users)
- Prefer released binaries or build with:
    cmake --preset release && cmake --build --preset release -j
- On containers: run as non-root (default image already does), use read-only rootfs, scoped volumes, and no extra capabilities:
    docker run --rm --read-only -u 65532:65532 -v "$PWD/out":/out biosimx:latest run --preset lotka --steps 100
- Limit resources for untrusted workloads (ulimits/cgroups); avoid running with elevated privileges.
- Validate configs with:
    ./build/bin/biosimx validate-config --config examples/example-config.json

## 10) Output & Filesystem Safety
- BioSimX writes to “--out” only; the CLI will create directories and refuse dangerous paths when checks are enabled.
- When automating, use separate, dedicated output directories; avoid reusing system paths.
- Beware of symlink races if others can write to parent directories; prefer private workspaces.

## 11) Supply Chain & Releases
- SBOM and scanning (recommended tools):
    syft packages dir: > sbom.json
    grype sbom: > report.json
- Reproducible builds: pin toolchains via CMakePresets/toolchains; capture compiler versions in releases.
- Container signing (recommended):
    cosign sign --key cosign.key ghcr.io/ausp59/biosimx:TAG
- Provenance/attestations (recommended):
    cosign attest --predicate provenance.json ghcr.io/ausp59/biosimx:TAG
- GitHub Actions: use OIDC for registry pushes; least-privilege PATs.

## 12) Patch Process (Maintainers)
- Prepare minimal, auditable fix with tests
- Run all sanitizer presets and CI gates
- Cut a security release with clear notes (impact, CVSS, upgrade steps)
- Request CVE via GitHub Advisory (if warranted)
- Credit reporters (unless anonymity requested)
- Consider backports to the last supported minor branch

## 13) Responsible Proof-of-Concepts
- Non-destructive PoCs only; do not exfiltrate data or clobber arbitrary files
- Minimize runtime duration and resource usage
- Provide exact commands/config used; redacted if sensitive
- Coordinate on timelines; do not publish PoC until a fix is available or by mutual agreement

Template:
    Title:
    Impact:
    Affected versions/commits:
    Reproduction steps:
    Expected vs. actual:
    Suggested fix/mitigation:
    Disclosure preference (credit/anonymity):

## 14) Non-Qualifying Issues (Examples)
- Cosmetic typos in docs; non-security bugs; wish-list features
- Crashes only under debuggers with flags we do not ship
- Issues in downstream packages or forks without BioSimX changes
- Local DoS with absurd parameters when bounds are documented

## 15) Hall of Fame (Acknowledgments)
We thank all researchers and contributors who help make BioSimX safer. If you want public credit, tell us how to attribute you (name/link/handle). If you prefer anonymity, we will honor it.

## 16) License & Policy Updates
This policy is licensed under CC BY 4.0. We may update it as project scope evolves (changes will be noted in CHANGELOG or Releases). For questions or requests, contact:
- AUSP59 — alanursapu@gmail.com