# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# Profile-Guided Optimization toggles
option(BIOSIMX_ENABLE_PGO_GENERATE "Build with -fprofile-generate" OFF)
option(BIOSIMX_ENABLE_PGO_USE "Build with -fprofile-use (needs profdata)" OFF)
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
  if (BIOSIMX_ENABLE_PGO_GENERATE)
    add_compile_options(-fprofile-generate)
    add_link_options(-fprofile-generate)
  endif()
  if (BIOSIMX_ENABLE_PGO_USE)
    add_compile_options(-fprofile-use -fprofile-correction)
    add_link_options(-fprofile-use -fprofile-correction)
  endif()
endif()
