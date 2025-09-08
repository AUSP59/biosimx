SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59

# Contributing to BioSimX

Thank you for your interest in contributing to **BioSimX**, a production-grade, deterministic biosimulation engine in C++17. This guide explains how to propose changes, file issues, submit pull requests, and uphold quality, security, and community standards.

## Table of Contents
1. Principles & Ground Rules
2. Ways to Contribute
3. Before You Start
4. Development Environment
5. Build, Test, Run
6. Code Style & Quality Gates
7. Commit Policy (Conventional Commits) + DCO
8. Pull Request Process
9. Adding Features (Models, Presets, CLI, I/O)
10. Tests, Fuzzing, Benchmarks, Coverage
11. Security, Responsible Disclosure
12. Governance, Licensing, and Attribution
13. Maintainers & Contact

## 1) Principles & Ground Rules
- Be kind, clear, and constructive; follow the Code of Conduct.
- Prefer small, focused changes that are easy to review and revert.
- Maintain determinism and reproducibility (fix seeds, document randomness).
- Do not regress performance or memory without strong justification.
- Update docs and tests alongside code changes.

## 2) Ways to Contribute
- Report bugs and propose enhancements.
- Improve docs (READMEs, architecture notes, tutorials).
- Add tests (unit, property, fuzz), and harden invariants.
- Optimize performance (SIMD, tiling, threading) with evidence.
- Build packaging, CI, and developer experience improvements.

## 3) Before You Start
- Read: CODE_OF_CONDUCT.md, GOVERNANCE.md, SECURITY.md, README.md.
- Search existing issues/PRs to avoid duplicates.
- For significant changes, open an “RFC” issue to discuss scope and design.

## 4) Development Environment
Prerequisites (choose your platform toolchain):
- CMake ≥ 3.23, Ninja, a modern C++ compiler (Clang/GCC/MSVC).
- Python 3.x for helper tools in tools/.
- Optional: Docker (build + distroless runtime), devcontainer.

Recommended: use the devcontainer in .devcontainer/ or a local toolchain that mirrors CI presets.

## 5) Build, Test, Run

Minimal local build (Release):
    cmake --preset release
    cmake --build --preset release -j

Run the CLI:
    ./build/bin/biosimx help
    ./build/bin/biosimx run --preset lotka --steps 1000 --metrics-interval 50 --snapshot-interval 200 --out out --json

Validate config against schema:
    ./build/bin/biosimx validate-config --config examples/example-config.json

Address sanitizer preset (debugging UB):
    cmake --preset asan
    cmake --build --preset asan -j

Thread sanitizer preset:
    cmake --preset tsan
    cmake --build --preset tsan -j

Docker (multi-stage, distroless runtime):
    docker build -t biosimx:latest .
    docker run --rm -v "$PWD/out":/out biosimx:latest run --preset lotka --steps 500 --metrics-interval 10 --snapshot-interval 100 --out /out

## 6) Code Style & Quality Gates

Formatting & lint:
- Use the repository’s .clang-format and .clang-tidy.
- Treat warnings as errors (CI enforces -Werror/strict warnings).
- Prefer modern, safe C++17 constructs; avoid undefined behavior.
- Keep headers minimal and stable; respect include order and export macros.

Run local checks (examples; adjust paths as needed):
    clang-format -i $(git ls-files '*.hpp' '*.cpp' '*.h' | tr '\n' ' ')
    clang-tidy -p build $(git ls-files '*.cpp' | tr '\n' ' ')
    python3 tools/check_spdx_headers.py
    python3 tools/check_conventional_commits.py
    python3 tools/check_dco.py
    python3 tools/check_changelog.py

Documentation:
- Write clear, precise English.
- Update README.md, docs/architecture.md, and docs/whitepaper.md when applicable.
- Add usage notes for any new flags or outputs.

## 7) Commit Policy (Conventional Commits) + DCO

We follow Conventional Commits; common types: feat, fix, perf, refactor, docs, test, ci, build, chore, revert.

Examples:
    feat(core): add SIRS model with seasonal forcing and immunity waning
    fix(cli): validate snapshot-interval ≥ 0 and improve error messages
    perf(sim): add cache tiling and AVX2 path for prey-predator update
    test(model): property test for non-negativity and boundedness
    docs(readme): quick start for Docker users

Breaking changes:
    feat(api)!: rename Field::predAt to Field::predatorAt for clarity

All commits must be signed with the Developer Certificate of Origin (DCO):
    git commit -s -m "feat: awesome change"

This appends a Signed-off-by trailer:
    Signed-off-by: Your Name <your.email@example.com>

You declare that you have the right to submit the work under the project license.

## 8) Pull Request Process

Checklist:
- Small, focused PR; reference issue(s).
- Code builds and tests pass in all CI presets that apply.
- Add/adjust tests and docs relevant to your change.
- Provide benchmarks or reasoning for perf-affecting changes.
- No unrelated refactors in the same PR.

Discussion & review:
- Be responsive and open to feedback.
- Keep a high signal-to-noise ratio in threads.
- Squash or rebase as requested to maintain a clean history.

Merging:
- Maintainers use “squash and merge” or “rebase and merge”.
- PR must be green in CI and approved by at least one maintainer.

## 9) Adding Features (Models, Presets, CLI, I/O)

New model (typical steps):
- Extend data structures in include/biosimx/model.hpp as needed; maintain ABI stability where possible.
- Implement stepping logic in src/model.cpp; keep it branch-predictable and parallel-friendly.
- Update CLI flags and help in include/biosimx/cli_helpers.hpp and src/cli.cpp.
- Add a preset:
    - Parse in config (include/biosimx/config.hpp, src/config.cpp).
    - Add an example config in examples/ and update schema/config.schema.json if new fields are introduced.
- Tests:
    - Unit tests for invariants, determinism (fixed seeds), boundary conditions.
    - Property tests for non-negativity, conservation, or boundedness.
- Docs:
    - Document equations, parameters, and assumptions in docs/ (math, references, limitations).
    - Update README’s Features and Running sections.

I/O and outputs:
- CSV is for metrics; PPM frames for snapshots (keep formats stable or versioned).
- Consider adding Arrow/Parquet for bulk analysis; maintain backward compatibility.

Performance:
- Provide micro-benchmarks or before/after comparisons (see tools/bench/compare_runs.py).
- Avoid premature generalization; measure first.

## 10) Tests, Fuzzing, Benchmarks, Coverage

Run tests:
    ctest --test-dir build --output-on-failure

Property tests (examples in tests/property/):
- Add invariants that must hold even under randomized states.
- Keep runs deterministic with fixed RNG seeds.

Fuzzing (libFuzzer-based helpers in fuzz/):
    cmake -S . -B build-fuzz -G Ninja -DCMAKE_CXX_FLAGS="-fsanitize=fuzzer,address" -DCMAKE_BUILD_TYPE=RelWithDebInfo
    cmake --build build-fuzz -j
    ./build-fuzz/bin/fuzz_args

Benchmarks:
    python3 tools/bench/compare_runs.py  # document your setup and results

Coverage (example with llvm-cov; adjust for your toolchain):
    cmake -S . -B build-cov -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_CXX_FLAGS="--coverage" -DCMAKE_EXE_LINKER_FLAGS="--coverage"
    cmake --build build-cov -j
    ctest --test-dir build-cov
    llvm-profdata merge -sparse build-cov/*.profraw -o build-cov/coverage.profdata
    llvm-cov report build-cov/bin/biosimx -instr-profile=build-cov/coverage.profdata

## 11) Security, Responsible Disclosure

- Do not file public issues for sensitive vulnerabilities.
- Report privately (see SECURITY.md). If unsure, email the maintainers.

Private contact for security reports:
- AUSP59 (Lead Maintainer)
- alanursapu@gmail.com

Provide: description, impact, PoC, affected versions, environment, and suggested mitigations. We acknowledge within 72h and coordinate a fix and disclosure per policy.

## 12) Governance, Licensing, and Attribution

Governance:
- See GOVERNANCE.md for roles, decision making, and elections.
- Maintainers must disclose conflicts of interest and recuse where required.

Licensing:
- Code contributions are accepted under the repository’s LICENSE (MIT).
- Documentation and prose are under CC BY 4.0 unless stated otherwise.
- By contributing, you agree to license your work accordingly.

Attribution:
- Keep SPDX headers; run the SPDX check tool before submitting:
    python3 tools/check_spdx_headers.py

## 13) Maintainers & Contact

Maintainers:
- AUSP59

Primary contact:
- Email: alanursapu@gmail.com

Community expectations:
- Follow the Code of Conduct.
- Be patient; maintainers are volunteers or time-constrained. We aim to acknowledge within a few business days.

Thank you for helping make BioSimX robust, performant, and useful to the scientific and engineering community!