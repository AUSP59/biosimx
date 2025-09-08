// SPDX-License-Identifier: Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

#include <cassert>
#include <cmath>
#include "biosimx/model.hpp"
static bool fin(double x){return std::isfinite(x);} int main(){using namespace biosimx; for(unsigned long long seed=1; seed<=50; ++seed){ Params p{}; p.dim={32,24}; p.dt=0.05; p.seed=seed; p.threads=(seed%3==0?3:1); p.disease.enabled=(seed%5==0); Model m(p); for(int i=0;i<30;i++) m.step(); auto s=m.metrics(); assert(fin(s.prey_sum)&&fin(s.predator_sum)&&fin(s.infected_sum)); assert(s.prey_sum>=0.0 && s.predator_sum>=0.0 && s.infected_sum>=0.0); if(p.disease.enabled) assert(s.infected_sum<=s.prey_sum+1e-9);} return 0;}
