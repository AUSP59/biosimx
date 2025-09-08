SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# ADR 0001: Initial Architecture

## Context
We require deterministic grid-based biosimulation with a clean C++ API and CLI.

## Decision
Use toroidal grid + SoA layout with double-buffer stepping; zero external runtime deps.

## Consequences
Deterministic results, easy packaging, stable ABI for C API.
