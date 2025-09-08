// SPDX-License-Identifier: MIT
#include <cstdint>
#include <cstddef>
#include <string>
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
  // Trivial fuzz: construct a string and exercise a couple of operations.
  std::string s(reinterpret_cast<const char*>(data), size);
  // Basic transformations (no-ops if not applicable)
  (void)s.find("x");
  (void)s.substr(0, s.size() ? (s.size() - 1) : 0);
  return 0;
}
