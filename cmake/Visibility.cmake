# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>


# cmake/Visibility.cmake
function(biosimx_set_default_visibility target)
  if (MSVC)
    target_compile_definitions(${target} PRIVATE BIOSIMX_EXPORT=__declspec(dllexport))
  else()
    target_compile_options(${target} PRIVATE -fvisibility=hidden -fvisibility-inlines-hidden)
    target_compile_definitions(${target} PRIVATE BIOSIMX_EXPORT=__attribute__((visibility("default"))))
  endif()
endfunction()
