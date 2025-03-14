#!/bin/bash -e

sed -i 's/$(BPF_DEPENDS)//g' sources/InfinityDuck/duck/Makefile