#!/bin/bash
# xsim_run.sh atualizado

# Ativa o ambiente do Vivado
source /opt/Xilinx/Vivado/2024.1/settings64.sh

# Compila RTL, UVM e testes
xvlog -sv --incr --relax \
  -f sim/rtl_sources.lst \
  -f sim/uvm_sources.lst \
  top_tb.sv

xelab -debug typical -top top_tb -L uvm -timescale 1ns/1ps

xsim -R top_tb -testplusarg UVM_TESTNAME=load_store_test