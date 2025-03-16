#!/bin/bash -e

#duck deps
sed -i 's/$(BPF_DEPENDS)//g' sources/InfinityDuck/duck/Makefile
# v2raygeodata date
sed -i "s/GEOX_VER:=.*/GEOX_VER:=$(date +%Y%m%d)/" sources/packages_net_v2ray-geodata/Makefile