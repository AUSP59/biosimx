SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# PGO Guide
1) Build with `-DBIOSIMX_ENABLE_PGO_GENERATE=ON`.
2) Run representative workloads (see `tools/pgo/train.sh`).
3) Rebuild with `-DBIOSIMX_ENABLE_PGO_USE=ON` pointing to generated profiles.
