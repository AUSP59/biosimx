# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

# CPU baseline selection (GCC/Clang)
set(BIOSIMX_CPU_BASELINE "default" CACHE STRING "CPU baseline: default|x86-64-v2|x86-64-v3|x86-64-v4|native")
set_property(CACHE BIOSIMX_CPU_BASELINE PROPERTY STRINGS default x86-64-v2 x86-64-v3 x86-64-v4 native)
if (CMAKE_SYSTEM_PROCESSOR MATCHES "x86_64|AMD64" AND CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
  if (NOT BIOSIMX_CPU_BASELINE STREQUAL "default")
    add_compile_options(-march=${BIOSIMX_CPU_BASELINE})
  endif()
endif()
