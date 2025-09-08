# SPDX-License-Identifier: Apache-2.0 OR MIT
# SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

from conan import ConanFile
from conan.tools.cmake import CMake, CMakeToolchain, cmake_layout

class BioSimXConan(ConanFile):
    name = "biosimx"
    version = "1.0.0"
    license = "MIT"
    url = "https://example.org/biosimx"
    description = "Deterministic C++ biosimulation engine"
    settings = "os", "compiler", "build_type", "arch"
    options = {"shared": [True, False]}
    default_options = {"shared": False}

    def layout(self): cmake_layout(self)
    def generate(self): CMakeToolchain(self).generate()
    def build(self):
        cmake = CMake(self); cmake.configure(); cmake.build()
    def package(self):
        cmake = CMake(self); cmake.install()
    def package_info(self):
        self.cpp_info.libs = ["biosimx"]
