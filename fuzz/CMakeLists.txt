SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

cmake_minimum_required(VERSION 3.16)
project(biosimx_fuzz CXX)
add_executable(biosimx_fuzz fuzz_main.cpp)
target_compile_features(biosimx_fuzz PRIVATE cxx_std_17)
if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
  target_compile_options(biosimx_fuzz PRIVATE -fsanitize=fuzzer,address,undefined -fno-omit-frame-pointer)
  target_link_libraries(biosimx_fuzz PRIVATE -fsanitize=fuzzer,address,undefined)
endif()
