# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# cmake/Reproducible.cmake
function(biosimx_enable_reproducible)
  if (NOT DEFINED ENV{SOURCE_DATE_EPOCH})
    set(ENV{SOURCE_DATE_EPOCH} "0")
  endif()
  if (CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
    add_compile_options(-ffile-prefix-map=${CMAKE_SOURCE_DIR}=. -fno-record-gcc-switches)
  endif()
  add_definitions(-D__DATE__="redacted" -D__TIME__="redacted")
endfunction()
