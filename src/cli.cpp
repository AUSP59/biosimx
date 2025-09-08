// SPDX-License-Identifier: Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2025 AUSP59 <alanursapu@gmail.com>

#include <iostream>
#include <filesystem>
#include <fstream>
#include <iomanip>
#include "biosimx/model.hpp"
#include "biosimx/config.hpp"
#include "biosimx/cli_helpers.hpp"
namespace fs = std::filesystem; using namespace biosimx;
static void write_csv_header(std::ofstream& f){ f<<"time_days,prey,predator,infected\n"; }
static void write_csv_row(std::ofstream& f,const Metrics& m){ f<<std::fixed<<std::setprecision(6)<<m.time_days<<","<<m.prey_sum<<","<<m.predator_sum<<","<<m.infected_sum<<"\n"; }
static void write_ppm(const Field& g,const std::string& path,double scale){ std::ofstream f(path,std::ios::binary); int W=g.w,H=g.h; f<<"P6\n"<<W<<" "<<H<<"\n255\n";
  for(int y=0;y<H;y++) for(int x=0;x<W;x++){ unsigned char r=(unsigned char)std::min(255.0,g.pred[y*W+x]*255.0*scale); unsigned char gch=(unsigned char)std::min(255.0,g.prey[y*W+x]*255.0*scale); unsigned char b=(unsigned char)std::min(255.0,g.inf[y*W+x]*255.0*scale); f.put(r); f.put(gch); f.put(b);} }
int main(int argc,char** argv){
  try{
    auto args=parse_args(argc,argv);
    if(argc>=2 && std::string(argv[1])=="validate-config") return 0;
    auto params=make_params(args); Model model(params);
    fs::create_directories(args.out); std::ofstream csv(args.out+"/metrics.csv"); write_csv_header(csv);
    for(int i=1;i<=args.steps;i++){
      model.step();
      if(i%args.metrics_interval==0){ auto m=model.metrics(); write_csv_row(csv,m); }
      if(args.metrics_stream>0 && (i%args.metrics_stream==0)){ auto m=model.metrics();
        std::cout<<"{\"step\":"<<i<<",\"time_days\":"<<m.time_days<<",\"prey\":"<<m.prey_sum<<",\"predator\":"<<m.predator_sum<<",\"infected\":"<<m.infected_sum<<"}\n"; }
      if(args.snapshot_interval>0 && (i%args.snapshot_interval==0)){ write_ppm(model.current(), args.out+"/frame_"+std::to_string(i)+".ppm", args.ppm_scale); }
      if(args.tui_interval>0 && (i%args.tui_interval==0)){ const Field& g=model.current(); std::cout<<"Step "<<i<<"\n";
        for(int y=0;y<g.h;y++){ for(int x=0;x<g.w;x++){ double P=g.prey[y*g.w+x],R=g.pred[y*g.w+x]; char ch='.'; if(R>P && R>0.2) ch='X'; else if(P>R && P>0.2) ch='o'; std::cout<<ch; } std::cout<<"\n"; } std::cout<<"\n"; }
    }
    if(args.json){ auto m=model.metrics(); std::cout<<"{\"time_days\":"<<m.time_days<<",\"prey\":"<<m.prey_sum<<",\"predator\":"<<m.predator_sum<<",\"infected\":"<<m.infected_sum<<"}\n"; }
    return 0;
  }catch(const std::exception& e){ std::cerr<<"Error: "<<e.what()<<"\n"; return 2; }
}
