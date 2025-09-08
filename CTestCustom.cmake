# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>


# CTest custom settings for memcheck
set(CTEST_MEMORYCHECK_TYPE Valgrind)
find_program(MEMORYCHECK_COMMAND valgrind)
set(CTEST_MEMORYCHECK_COMMAND "${MEMORYCHECK_COMMAND}")
set(CTEST_MEMORYCHECK_COMMAND_OPTIONS "--leak-check=full --error-exitcode=1")
