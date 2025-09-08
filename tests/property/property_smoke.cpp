// SPDX-License-Identifier: MIT
#include <cassert>
#include <random>
#include <string>
#include <vector>

static bool property_reverse_reverse_is_identity(const std::string& in) {
  std::string s = in;
  std::reverse(s.begin(), s.end());
  std::reverse(s.begin(), s.end());
  return s == in;
}

int main() {
  std::mt19937 rng(123456u);
  std::uniform_int_distribution<int> len(0, 256);
  for (int i = 0; i < 200; ++i) {
    int n = len(rng);
    std::string s; s.resize(n);
    for (int j = 0; j < n; ++j) s[j] = static_cast<char>(rng() % 128);
    assert(property_reverse_reverse_is_identity(s));
  }
  return 0;
}
