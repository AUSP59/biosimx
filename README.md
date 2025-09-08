SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# BioSimX — Deterministic C++17 Biosimulation Engine

A production-grade, deterministic biosimulation engine for multi-species ecosystems with optional epidemic dynamics and seasonal climate forcing. Fast multithreaded core, clean CLI, JSON (schema-validated) configuration, CSV/PPM/TUI outputs, strong CI hooks, first-class CMake/Docker support, and clear governance.

[Features](#features) · [Quick Start](#quick-start) · [Configuration](#configuration) · [Models & Presets](#models--presets) · [Outputs](#outputs) · [Performance](#performance) · [Testing](#testing) · [Project Layout](#project-layout) · [Roadmap](#roadmap) · [Contributing](#contributing) · [Security](#security) · [License](#license) · [Citation](#citation) · [Contact](#contact)

---

## Why BioSimX?

- Determinism by design (seeded RNG, reproducible pipelines).
- Developer experience focused: strict warnings, presets for sanitizers, distroless Docker, devcontainer, helper tools.
- Simple yet extensible model core (prey–predator, climate factors, optional disease), designed for growth into richer models and analyses.
- Clear separation of concerns (core engine, CLI, config/schema, outputs, tests, fuzz, docs).

## Features

- **Engine**: C++17, 2D toroidal grid, double-buffer stepping, multithreaded row partitioning.
- **Dynamics**: prey–predator (Lotka–Volterra style), optional epidemic (SIR-like), seasonal climate multiplier.
- **Config**: JSON, validated via `schema/config.schema.json`; presets for quick runs.
- **CLI**: `run`, `validate-config`, `version`, `help`.
- **Outputs**: streaming JSON, CSV metrics, PPM frames, ASCII TUI preview.
- **Tooling**: CMakePresets (default/release/asan/tsan), optional LTO and PGO, CPU baseline flags, devcontainer.
- **Quality**: unit tests, property tests, fuzz targets, scripts for SPDX/DCO/conventional commits/changelog.
- **Ops**: Docker multi-stage (distroless runtime), Makefile helpers, portable toolchains (musl, mingw).

---

## Quick Start

### Build (CMake presets)

    cmake --preset release
    cmake --build --preset release -j
    ./build/bin/biosimx --version
    ./build/bin/biosimx help

### First run (Lotka preset, 1000 steps, CSV + frames + TUI)

    ./build/bin/biosimx run \
      --preset lotka \
      --steps 1000 \
      --metrics-interval 10 \
      --snapshot-interval 100 \
      --tui-interval 50 \
      --out out \
      --json

### Validate a config

    ./build/bin/biosimx validate-config --config examples/example-config.json

### Sanitizers (debugging undefined behavior and data races)

    cmake --preset asan && cmake --build --preset asan -j
    cmake --preset tsan && cmake --build --preset tsan -j

### Docker (distroless runtime, reproducible)

    docker build -t biosimx:latest .
    docker run --rm -v "$PWD/out":/out biosimx:latest run \
      --preset lotka --steps 500 \
      --metrics-interval 10 \
      --snapshot-interval 100 \
      --out /out

---

## Configuration

All runtime parameters can be provided via CLI flags or a JSON file validated against `schema/config.schema.json`.

### Example (minimal) JSON

    {
      "steps": 1000,
      "preset": "lotka",
      "output": "out/",
      "width": 128,
      "height": 96,
      "dt": 1.0,
      "seed": 42,
      "threads": 0,
      "snapshot_interval": 100,
      "metrics_interval": 10,
      "metrics_stream": 0,
      "tui_interval": 0,
      "ppm_scale": 1.0
    }

### CLI usage

    biosimx run [--preset lotka|multi|plague] [--config path.json]
                [--steps N] [--dt FLOAT]
                [--width W --height H] [--seed S] [--threads N]
                [--snapshot-interval K] [--metrics-interval K] [--metrics-stream K]
                [--ppm-scale FLOAT] [--out DIR] [--tui-interval K] [--json]

    biosimx validate-config --config path.json [--json]
    biosimx version
    biosimx help

Notes:
- `--threads 0` uses the hardware concurrency; set an explicit value for deterministic scheduling across hosts.
- `--json` prints a final metrics object and may stream metrics at `--metrics-stream` frequency.

---

## Models & Presets

- **lotka**: canonical prey–predator dynamics with climate factor.
- **multi**: multi-species extension with predator–prey interactions tuned for stability demos.
- **plague**: enables SIR-like disease overlay (β, γ), infecting prey and reporting infected mass.

Each preset can be customized via config fields (dimensions, dt, seed, intervals, output).

---

## Outputs

- **CSV** (`metrics.csv`): `time_days,prey,predator,infected`.
- **PPM frames** (`frame_<step>.ppm`): quick density snapshots for visualization.
- **TUI**: ASCII preview at `--tui-interval`.
- **JSON**: optional stream (`--metrics-stream`) plus final summary (`--json`).

Tip: convert PPM to PNGs and assemble videos with your favorite tool; or consume CSV in Python/R for analysis.

---

## Performance

- **Threads**: set `--threads` for reproducible parallelism; row-partitioned stepping minimizes contention.
- **CPU baseline**: use `-DBIOSIMX_CPU_BASELINE=x86-64-v3` (or `v4/native`) when building with Clang/GCC on x86_64.
- **LTO/IPO**: `-DBIOSIMX_ENABLE_LTO=ON` (Release).
- **PGO**: generate with `-DBIOSIMX_ENABLE_PGO_GENERATE=ON`, run representative workload, then rebuild with `-DBIOSIMX_ENABLE_PGO_USE=ON`.
- **Data layout**: the core uses cache-friendly structures; further SIMD/vectorization paths may be enabled by your compiler at higher baselines.

Benchmark helper:

    python3 tools/bench/compare_runs.py

---

## Testing

- **Unit/property tests** (determinism, invariants, boundedness, finite values).
- **Fuzzing** (argument/config fuzz).
- **Sanitizers** (ASan/UBSan/TSan presets).
- **Coverage** (example with llvm-cov; adapt to your toolchain).

Run tests:

    ctest --test-dir build --output-on-failure

Fuzz (example):

    cmake -S . -B build-fuzz -G Ninja \
      -DCMAKE_CXX_FLAGS="-fsanitize=fuzzer,address" \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo
    cmake --build build-fuzz -j
    ./build-fuzz/bin/fuzz_args

Coverage (example workflow):

    cmake -S . -B build-cov -G Ninja \
      -DCMAKE_BUILD_TYPE=Debug \
      -DCMAKE_CXX_FLAGS="--coverage" \
      -DCMAKE_EXE_LINKER_FLAGS="--coverage"
    cmake --build build-cov -j
    ctest --test-dir build-cov

---

## Project Layout

    .
    ├── src/                    # core engine and CLI
    ├── include/biosimx/        # public headers (API, config, version)
    ├── tests/                  # unit & property tests
    ├── fuzz/                   # libFuzzer entry points
    ├── examples/               # example configs
    ├── schema/                 # JSON schema(s)
    ├── cmake/                  # helper modules (CPU baseline, PGO, etc.)
    ├── .devcontainer/          # ready-to-code environment
    ├── docs/                   # architecture, whitepaper, risk register
    ├── CMakePresets.json
    ├── CMakeLists.txt
    └── Dockerfile

---

## Roadmap

- Richer models: reaction–diffusion (Gray–Scott), SIRS with immunity waning and mobility, multi-pathogen overlays.
- Numerical schemes: optional RK2/RK4 integrators, stability tooling, CFL-like guidance.
- I/O: Arrow/Parquet outputs, binary snapshots with metadata.
- Bindings: pybind11-based Python bindings for rapid analysis.
- Packaging: vcpkg formula, Homebrew tap, Debian packages, GitHub Releases artifacts.

---

## Contributing

We welcome code, docs, tests, and discussions. Please read:
- `CODE_OF_CONDUCT.md` for community standards.
- `CONTRIBUTING.md` for workflow, DCO, conventional commits, style, and quality gates.
- `GOVERNANCE.md` for roles and decision-making.

Quick checks before opening a PR:

    clang-format -i $(git ls-files '*.hpp' '*.cpp' '*.h' | tr '\n' ' ')
    clang-tidy -p build $(git ls-files '*.cpp' | tr '\n' ' ')
    python3 tools/check_spdx_headers.py
    python3 tools/check_conventional_commits.py
    python3 tools/check_dco.py
    python3 tools/check_changelog.py

Sign commits (DCO):

    git commit -s -m "feat: amazing improvement"

---

## Security

Do not open public issues for sensitive vulnerabilities. Report privately per `SECURITY.md`.

Primary security contact:
- AUSP59 (Lead Maintainer)
- alanursapu@gmail.com

We aim to acknowledge within 72 hours and coordinate fixes/disclosure responsibly.

---

## License

- **Source code**: dual-licensed **Apache-2.0 OR MIT** (choose either).
- **Documentation & prose**: **CC BY 4.0**.
See `LICENSE` for full terms. Trademarks are not licensed.

SPDX headers are used across files for machine-readable compliance.

---

## Citation

If you use BioSimX in academic or industrial work, please cite it. Example BibTeX:

    @software{BioSimX,
      title   = {BioSimX — Deterministic C++17 Biosimulation Engine},
      author  = {AUSP59 and BioSimX Contributors},
      year    = {2025},
      url     = {https://github.com/AUSP59/biosimx},
      version = {see biosimx --version}
    }

A `CITATION.cff` file may also be provided for reference managers.

---

## Versioning & Changelog

We follow semantic versioning where practical; `biosimx --version` prints the runtime version. Changes are documented in `CHANGELOG.md`.

---

## Contact

- Maintainer: **AUSP59**
- Email: **alanursapu@gmail.com**
- Issues & discussions: GitHub repository tracker

Thank you for using and improving BioSimX. PRs, benchmarks, and real-world case studies are especially welcome!