#!/bin/bash
# Ativa ambiente Vivado
source /opt/Xilinx/Vivado/2024.1/settings64.sh

# Compilação
xvlog -sv --incr --relax -f sim/rtl_sources.lst
xvlog -sv --incr --relax -f sim/uvm_sources.lst top_tb.sv

# Elaboração
xelab -debug typical -top top_tb -L uvm -timescale 1ns/1ps

# Simulação (substitua pelo teste desejado)
xsim -R top_tb -testplusarg UVM_TESTNAME=load_store_test