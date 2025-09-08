# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>


# cmake/Version.cmake
function(biosimx_compute_version OUT_VAR)
  # Try git
  find_package(Git QUIET)
  if (Git_FOUND)
    execute_process(COMMAND ${GIT_EXECUTABLE} describe --tags --always --dirty
      WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
      OUTPUT_VARIABLE GIT_DESCRIBE OUTPUT_STRIP_TRAILING_WHITESPACE
      ERROR_QUIET)
  endif()
  if (GIT_DESCRIBE)
    set(${OUT_VAR} "${GIT_DESCRIBE}" PARENT_SCOPE)
  else()
    set(${OUT_VAR} "0.0.0" PARENT_SCOPE)
  endif()
endfunction()
