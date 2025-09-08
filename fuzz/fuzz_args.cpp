// SPDX-License-Identifier: Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

#include <cstdint>
#include <cstddef>
#include <vector>
#include <string>
#include "biosimx/config.hpp"
extern "C" int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size){ if(size<1) return 0; std::string s((const char*)data,size); std::vector<std::string> toks; size_t i=0; while(i<s.size()){ while(i<s.size()&&s[i]==' ')++i; size_t j=i; while(j<s.size()&&s[j]!=' ')++j; if(j>i) toks.emplace_back(s.substr(i,j-i)); i=j; } std::vector<char*> argv; argv.reserve(toks.size()+2); const char* prog="biosimx"; argv.push_back((char*)prog); argv.push_back((char*)"run"); for(auto& t: toks) argv.push_back((char*)t.data()); try{ (void)biosimx::parse_args((int)argv.size(), argv.data()); }catch(...){} return 0; }
