SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Architecture Diagram (Mermaid)

```mermaid
flowchart LR
  CLI-->Core
  Core-->Model[Simulation Model]
  Core-->IO[Metrics/Export]
  Model-->Grid[Grid State]
  Core-->API[Public C++ API]
```
