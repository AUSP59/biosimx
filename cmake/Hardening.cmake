# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>


# cmake/Hardening.cmake
include(CheckCXXCompilerFlag)

function(biosimx_enable_hardening)
  if (MSVC)
    add_compile_options(/W4 /permissive- /guard:cf)
    add_link_options(/guard:cf)
  else()
    add_compile_options(-Wall -Wextra -Wpedantic -fstack-protector-strong -D_FORTIFY_SOURCE=3 -D_GLIBCXX_ASSERTIONS)
    add_link_options(-Wl,-z,relro -Wl,-z,now)
  endif()
endfunction()

option(BIOSIMX_ENABLE_ASAN "Enable AddressSanitizer" OFF)
option(BIOSIMX_ENABLE_UBSAN "Enable UndefinedBehaviorSanitizer" OFF)
option(BIOSIMX_ENABLE_TSAN "Enable ThreadSanitizer" OFF)
option(BIOSIMX_ENABLE_MSAN "Enable MemorySanitizer (Clang/LLVM)" OFF)

function(biosimx_enable_sanitizers)
  if (CMAKE_CXX_COMPILER_ID MATCHES "Clang|GNU")
    if (BIOSIMX_ENABLE_ASAN)
      add_compile_options(-fsanitize=address -fno-omit-frame-pointer)
      add_link_options(-fsanitize=address)
    endif()
    if (BIOSIMX_ENABLE_UBSAN)
      add_compile_options(-fsanitize=undefined -fno-omit-frame-pointer)
      add_link_options(-fsanitize=undefined)
    endif()
    if (BIOSIMX_ENABLE_TSAN)
      add_compile_options(-fsanitize=thread -fno-omit-frame-pointer)
      add_link_options(-fsanitize=thread)
    endif()
    if (BIOSIMX_ENABLE_MSAN)
      add_compile_options(-fsanitize=memory -fno-omit-frame-pointer)
      add_link_options(-fsanitize=memory)
    endif()
  endif()
endfunction()
