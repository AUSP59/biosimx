SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Test Plan

- Unit tests for core stepping logic
- Property-based tests with randomized seeds to assert invariants (determinism given seed)
- Integration tests for CLI `biosimx`: config parsing, preset runs, CSV/JSON output
- Fuzzers for parsers and file readers
- Coverage target >= 60% global (threshold gate in CI)
