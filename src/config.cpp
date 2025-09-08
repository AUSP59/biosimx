// SPDX-License-Identifier: Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

#include "biosimx/config.hpp"
#include <fstream>
#include <stdexcept>
#include <cctype>
namespace biosimx {
static std::string trim(const std::string& s){ size_t a=0,b=s.size(); while(a<b&&std::isspace((unsigned char)s[a]))++a; while(b>a&&std::isspace((unsigned char)s[b-1]))--b; return s.substr(a,b-a); }
Args load_cfg_file(const std::string& path, Args base){
  std::ifstream f(path); if(!f) throw std::runtime_error("cannot open config: "+path);
  std::string sec,line;
  while(std::getline(f,line)){ line=trim(line); if(line.empty()||line[0]=='#'||line[0]==';') continue;
    if(line.front()=='['&&line.back()==']'){ sec=line.substr(1,line.size()-2); continue; }
    auto pos=line.find('='); if(pos==std::string::npos) continue;
    std::string key=trim(line.substr(0,pos)), val=trim(line.substr(pos+1));
    auto seti=[&](int& d){ d=std::stoi(val); }; auto setd=[&](double& d){ d=std::stod(val); }; auto setu=[&](unsigned long long& d){ d=std::stoull(val); };
    if(sec=="model"){ if(key=="steps")seti(base.steps); else if(key=="dt")setd(base.dt); else if(key=="width")seti(base.width); else if(key=="height")seti(base.height); else if(key=="seed")setu(base.seed); else if(key=="threads")seti(base.threads); else if(key=="tui_interval")seti(base.tui_interval); }
    else if(sec=="io"){ if(key=="out")base.out=val; else if(key=="snapshot_interval")seti(base.snapshot_interval); else if(key=="metrics_interval")seti(base.metrics_interval); else if(key=="metrics_stream")seti(base.metrics_stream); else if(key=="ppm_scale")setd(base.ppm_scale); else if(key=="json")base.json=(val=='1'||val=="true"); }
    else if(sec=="preset"){ if(key=="name")base.preset=val; }
  } return base;
}
Args parse_args(int argc,char** argv){
  Args a{}; if(argc<2){ print_help(); std::exit(1); }
  std::string cmd=argv[1];
  if(cmd=="help"||cmd=="--help"||cmd=="-h"){ print_help(); std::exit(0); }
  if(cmd=="version"||cmd=="--version"||cmd=="-v"){ std::cout<<BIOSIMX_VERSION_STR<<"\n"; std::exit(0); }
  if(cmd=="validate-config"){
    for(int i=2;i<argc;i++){ std::string s=argv[i]; if(s=="--config") a.config_path=argv[++i]; else if(s=="--json") a.json=true; }
    if(a.config_path.empty()) throw std::invalid_argument("validate-config requires --config <path>");
    a=load_cfg_file(a.config_path,a);
    if(a.json){ std::cout<<"{\"preset\":\""<<a.preset<<"\",\"steps\":"<<a.steps<<",\"dt\":"<<a.dt
                          <<",\"width\":"<<a.width<<",\"height\":"<<a.height<<",\"seed\":"<<a.seed
                          <<",\"threads\":"<<a.threads<<",\"snapshot_interval\":"<<a.snapshot_interval
                          <<",\"metrics_interval\":"<<a.metrics_interval<<",\"metrics_stream\":"<<a.metrics_stream
                          <<",\"ppm_scale\":"<<a.ppm_scale<<",\"out\":\""<<a.out<<"\",\"tui_interval\":"<<a.tui_interval
                          <<",\"json\":"<<(a.json? "true":"false")<<"}\n"; }
    else { std::cout<<"Config OK\n"; }
    std::exit(0);
  }
  if(cmd!="run"){ print_help(); std::exit(1); }
  for(int i=2;i<argc;i++){
    std::string s=argv[i]; auto next=[&](int& i){ if(i+1>=argc) throw std::runtime_error("missing value for "+s); return std::string(argv[++i]); };
    if(s=="--preset") a.preset=next(i);
    else if(s=="--config") a.config_path=next(i);
    else if(s=="--steps") a.steps=std::stoi(next(i));
    else if(s=="--dt") a.dt=std::stod(next(i));
    else if(s=="--width") a.width=std::stoi(next(i));
    else if(s=="--height") a.height=std::stoi(next(i));
    else if(s=="--seed") a.seed=std::stoull(next(i));
    else if(s=="--threads") a.threads=std::stoi(next(i));
    else if(s=="--snapshot-interval") a.snapshot_interval=std::stoi(next(i));
    else if(s=="--metrics-interval") a.metrics_interval=std::stoi(next(i));
    else if(s=="--metrics-stream") a.metrics_stream=std::stoi(next(i));
    else if(s=="--ppm-scale") a.ppm_scale=std::stod(next(i));
    else if(s=="--out") a.out=next(i);
    else if(s=="--tui-interval") a.tui_interval=std::stoi(next(i));
    else if(s=="--json") a.json=true;
  }
  if(!a.config_path.empty()) a=load_cfg_file(a.config_path,a);
  if(a.steps<1) throw std::invalid_argument("steps must be >=1");
  if(a.dt<=0) throw std::invalid_argument("dt must be >0");
  if(a.width<8||a.height<8) throw std::invalid_argument("grid too small (<8)");
  if(a.threads<1) throw std::invalid_argument("threads must be >=1");
  if(a.metrics_interval<1) throw std::invalid_argument("metrics-interval must be >=1");
  if(a.metrics_stream<0) throw std::invalid_argument("metrics-stream must be >=0");
  if(a.ppm_scale<=0) throw std::invalid_argument("ppm-scale must be >0");
  return a;
}
Params make_params(const Args& a){
  Params p{}; p.dim={a.width,a.height}; p.dt=a.dt; p.seed=a.seed; p.threads=a.threads;
  if(a.preset=="multi"){ p.inter.alpha_prey=0.8; p.inter.beta_predation=0.03; p.inter.delta_predator=0.6; p.inter.gamma_growth=0.015; }
  if(a.preset=="plague"){ p.disease.enabled=true; p.disease.beta=0.08; p.disease.gamma=0.02; }
  return p;
}
}
