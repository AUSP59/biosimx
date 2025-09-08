// SPDX-License-Identifier: Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

#include "biosimx/model.hpp"
namespace biosimx {
void Model::init_random_(){ for(int y=0;y<p_.dim.height;y++) for(int x=0;x<p_.dim.width;x++){ A_.preyAt(x,y)=0.5+0.05*(rng_.uniform()-0.5); A_.predAt(x,y)=0.2+0.05*(rng_.uniform()-0.5); A_.infAt(x,y)=(p_.disease.enabled && rng_.uniform()<0.02)?0.01:0.0; } }
void Model::step_range_(int y0,int y1,const Field& src, Field& dst){
  const double dt=p_.dt, climate=p_.climate.factor(t_); const int W=p_.dim.width;
  for(int y=y0;y<y1;++y){ for(int x=0;x<W;++x){
    double prey_n=0,pred_n=0,inf_n=0; for(int dy=-1;dy<=1;++dy) for(int dx=-1;dx<=1;++dx){ prey_n+=src.preyAt(x+dx,y+dy); pred_n+=src.predAt(x+dx,y+dy); inf_n+=src.infAt(x+dx,y+dy); }
    prey_n/=9.0; pred_n/=9.0; inf_n/=9.0;
    double prey=src.preyAt(x,y)+dt*(climate*p_.inter.alpha_prey*prey_n - p_.inter.beta_predation*prey_n*pred_n);
    double pred=src.predAt(x,y)+dt*(p_.inter.gamma_growth*prey_n*pred_n - p_.inter.delta_predator*pred_n);
    double infected=src.infAt(x,y);
    if(p_.disease.enabled){ double susceptible=std::max(0.0,prey-infected); double new_inf=p_.disease.beta*susceptible*(infected+1e-9)*dt; double recov=p_.disease.gamma*infected*dt; infected=std::max(0.0,std::min(prey, infected+new_inf-recov)); }
    dst.preyAt(x,y)=std::max(0.0,prey); dst.predAt(x,y)=std::max(0.0,pred); dst.infAt(x,y)=infected;
  }}}
Model::Model(const Params& p):A_(p.dim.width,p.dim.height),B_(p.dim.width,p.dim.height),rng_(p.seed),p_(p){ if(p.dim.width<=0||p.dim.height<=0) throw std::invalid_argument("Invalid grid size"); if(p.dt<=0.0) throw std::invalid_argument("dt must be > 0"); if(p.threads<1) throw std::invalid_argument("threads must be >= 1"); init_random_(); }
void Model::step(){ const Field& src=toggle_?B_:A_; Field& dst=toggle_?A_:B_; int H=p_.dim.height, T=std::max(1,p_.threads);
  if(T==1){ step_range_(0,H,src,dst);} else { std::vector<std::thread> ws; ws.reserve(T); int rows=(H+T-1)/T; for(int i=0;i<T;i++){ int y0=i*rows,y1=std::min(H,y0+rows); if(y0>=y1) break; ws.emplace_back([&,y0,y1]{ step_range_(y0,y1,src,dst); }); } for(auto& th:ws) th.join(); }
  toggle_=!toggle_; t_+=p_.dt; }
Metrics Model::metrics() const { const Field& s=current(); Metrics m{}; m.time_days=t_; int N=s.w*s.h; for(int i=0;i<N;i++){ m.prey_sum+=s.prey[i]; m.predator_sum+=s.pred[i]; m.infected_sum+=s.inf[i]; } return m; }
}
