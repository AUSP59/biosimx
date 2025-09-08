// SPDX-License-Identifier: Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

#include "biosimx/capi.h"
#include "biosimx/model.hpp"
using namespace biosimx;
extern "C" {
biosimx_model biosimx_create(const biosimx_params* p){
  if(!p) return nullptr; Params pp{};
  pp.dim={p->width,p->height}; pp.dt=p->dt; pp.inter.alpha_prey=p->alpha_prey; pp.inter.beta_predation=p->beta_predation; pp.inter.delta_predator=p->delta_predator; pp.inter.gamma_growth=p->gamma_growth;
  pp.disease.enabled=p->disease_enabled!=0; pp.disease.beta=p->disease_beta; pp.disease.gamma=p->disease_gamma;
  pp.climate.seasonality_amp=p->climate_amp; pp.climate.seasonality_period=p->climate_period; pp.climate.baseline=p->climate_baseline;
  pp.seed=p->seed; pp.threads=p->threads;
  try { return reinterpret_cast<biosimx_model>(new Model(pp)); } catch (...) { return nullptr; }
}
void biosimx_step(biosimx_model m){ if(m) reinterpret_cast<Model*>(m)->step(); }
void biosimx_metrics(biosimx_model m,double* t,double* a,double* b,double* c){
  if(!m) return; auto mm=reinterpret_cast<Model*>(m)->metrics();
  if(t)*t=mm.time_days; if(a)*a=mm.prey_sum; if(b)*b=mm.predator_sum; if(c)*c=mm.infected_sum;
}
void biosimx_destroy(biosimx_model m){ delete reinterpret_cast<Model*>(m); }
}
