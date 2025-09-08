SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Distribution Guides
- **Deb/RPM**: skeletons under `debian/` and `packaging/rpm/`. Use CPack or native builders.
- **Homebrew/Scoop/Chocolatey**: publish checksums; update formulas/manifests referencing `SHA256SUMS`.
- **Snap/AppImage**: see `snap/snapcraft.yaml` and `packaging/appimage/` scripts.
- **Completions/Manpages**: generate via `tools/gen_shell_completions.sh` / `tools/gen_manpage.sh`, install with CMake toggles.
