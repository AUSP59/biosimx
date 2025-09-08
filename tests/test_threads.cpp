// SPDX-License-Identifier: Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

#include <cassert>
#include "biosimx/model.hpp"
int main(){using namespace biosimx; Params p{}; p.dim={64,48}; p.dt=0.05; p.seed=777; p.threads=1; Model m1(p); for(int i=0;i<50;i++) m1.step(); auto a=m1.metrics(); p.threads=4; Model m2(p); for(int i=0;i<50;i++) m2.step(); auto b=m2.metrics(); assert(std::abs(a.prey_sum-b.prey_sum)<1e-12); assert(std::abs(a.predator_sum-b.predator_sum)<1e-12); assert(std::abs(a.infected_sum-b.infected_sum)<1e-12); return 0;}
