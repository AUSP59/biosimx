SPDX-License-Identifier: CC-BY-4.0
SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

cmake_minimum_required(VERSION 3.23)
project(BioSimX VERSION 1.2.0 LANGUAGES CXX)
option(BIOSIMX_ENABLE_WARNINGS "Enable extra warnings" ON)
option(BIOSIMX_ENABLE_LTO "Enable IPO/LTO in Release" OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
if(BIOSIMX_ENABLE_WARNINGS)
  if(MSVC)  add_compile_options(/W4 /WX)
  else()    add_compile_options(-Wall -Wextra -Wpedantic -Werror)  endif()
endif()
if(BIOSIMX_ENABLE_LTO)
  set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_RELEASE ON)
endif()
add_library(BioSimX STATIC src/model.cpp src/grid.cpp src/config.cpp src/cli_helpers.cpp src/c_api.cpp)
target_include_directories(BioSimX PUBLIC $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include> $<INSTALL_INTERFACE:include>)
target_compile_definitions(BioSimX PUBLIC BIOSIMX_VERSION_STR="$<${PROJECT_VERSION}>")
add_executable(biosimx src/cli.cpp)
target_link_libraries(biosimx PRIVATE BioSimX)
include(CTest)
if(BUILD_TESTING)
  add_executable(test_core tests/test_core.cpp)      ; target_link_libraries(test_core PRIVATE BioSimX) ; add_test(NAME core_tests COMMAND test_core)
  add_executable(test_threads tests/test_threads.cpp); target_link_libraries(test_threads PRIVATE BioSimX); add_test(NAME threads_determinism COMMAND test_threads)
  add_executable(test_properties tests/test_properties.cpp); target_link_libraries(test_properties PRIVATE BioSimX); add_test(NAME property_tests COMMAND test_properties)
endif()
add_executable(bench_step benchmarks/bench_step.cpp); target_link_libraries(bench_step PRIVATE BioSimX)
add_executable(fuzz_args fuzz/fuzz_args.cpp);        target_link_libraries(fuzz_args PRIVATE BioSimX)
include(GNUInstallDirs)
install(TARGETS BioSimX biosimx EXPORT BioSimXTargets RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR} LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR} ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(DIRECTORY include/ DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
include(CMakePackageConfigHelpers)
set(CONFIG_INSTALL_DIR ${CMAKE_INSTALL_LIBDIR}/cmake/BioSimX)
configure_package_config_file(cmake/BioSimXConfig.cmake.in ${CMAKE_CURRENT_BINARY_DIR}/BioSimXConfig.cmake INSTALL_DESTINATION ${CONFIG_INSTALL_DIR})
write_basic_package_version_file(${CMAKE_CURRENT_BINARY_DIR}/BioSimXConfigVersion.cmake VERSION ${PROJECT_VERSION} COMPATIBILITY SameMajorVersion)
install(EXPORT BioSimXTargets NAMESPACE BioSimX:: DESTINATION ${CONFIG_INSTALL_DIR})
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/BioSimXConfig.cmake ${CMAKE_CURRENT_BINARY_DIR}/BioSimXConfigVersion.cmake DESTINATION ${CONFIG_INSTALL_DIR})


# Packaging
include(${CMAKE_SOURCE_DIR}/cmake/CPackOptions.cmake)


# Security hardening
include(${CMAKE_SOURCE_DIR}/cmake/Hardening.cmake)
biosimx_enable_hardening()
include(${CMAKE_SOURCE_DIR}/cmake/Warnings.cmake)
# Call biosimx_enable_warnings(<your-target>) for each target.


# Optional build cache
include(${CMAKE_SOURCE_DIR}/cmake/Cache.cmake)
# Visibility helpers (apply per-target with biosimx_set_default_visibility)
include(${CMAKE_SOURCE_DIR}/cmake/Visibility.cmake)

include(${CMAKE_SOURCE_DIR}/cmake/Reproducible.cmake)
biosimx_enable_reproducible()

# Packaging via CPack
include(${CMAKE_SOURCE_DIR}/CPackConfig.cmake)

# Optional compiler cache
include(${CMAKE_SOURCE_DIR}/cmake/CCache.cmake)

# Optionally force-include banned APIs header across TU
option(BIOSIMX_ENFORCE_BANNED_APIS "Force include banned.h to block unsafe C APIs" OFF)
if (BIOSIMX_ENFORCE_BANNED_APIS)
  if (MSVC)
    add_compile_options(/FI"$(CMAKE_SOURCE_DIR)/include/biosimx/banned.h")
  else()
    add_compile_options(-include ${CMAKE_SOURCE_DIR}/include/biosimx/banned.h)
  endif()
endif()



# === Strict warnings in CI (treat as errors only when CI=1) ===
option(BIOSIMX_STRICT_WARNINGS "Treat warnings as errors in CI" ON)
if (BIOSIMX_STRICT_WARNINGS)
  if (DEFINED ENV{CI} AND NOT "$ENV{CI}" STREQUAL "")
    if (MSVC)
      add_compile_options(/W4 /WX)
    else()
      add_compile_options(-Wall -Wextra -Wpedantic -Werror)
    endif()
  endif()
endif()

# Include CPU baseline and PGO modules
include(${CMAKE_SOURCE_DIR}/cmake/CPUBaseline.cmake)
include(${CMAKE_SOURCE_DIR}/cmake/PGO.cmake)



enable_testing()
add_subdirectory(tests)
