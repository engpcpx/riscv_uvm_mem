#!/bin/bash

# ========================================================
# Script: compile_and_run.sh
# Description: Compilation and simulation script for Vivado 2024.1
# ========================================================

echo "=== RISC-V Memory Verification Setup ==="

# Set Vivado environment
source /tools/Xilinx/Vivado/2024.1/settings64.sh

# Clean previous compilation
rm -rf xsim.dir/
rm -f *.jou *.log *.pb

echo "=== Compiling RTL Sources ==="

# Compile RTL in dependency order
xvlog -sv \
    includes/riscv_pkg.sv \
    rtl/riscv_definitions.sv \
    rtl/instruction_fetch.sv \
    rtl/instruction_decode.sv \
    rtl/execution.sv \
    rtl/memory_access.sv \
    rtl/hazard_control.sv \
    rtl/RISCV.sv \
    rtl/riscv_wrapper.sv

echo "=== Compiling UVM Testbench ==="

# Compile UVM sources
xvlog -sv -L uvm \
    interfaces/mem_interface.sv \
    tb/env/mem_transaction.sv \
    tb/env/sequences/base_sequence.sv \
    tb/env/sequences/load_store_sequence.sv \
    tb/env/agents/mem_sequencer.sv \
    tb/env/agents/mem_driver.sv \
    tb/env/agents/mem_monitor.sv \
    tb/env/agents/mem_agent.sv \
    tb/env/mem_scoreboard.sv \
    tb/env/mem_env.sv \
    tb/tests/load_store_test.sv \
    tb/top_tb.sv

echo "=== Elaborating Design ==="

# Elaborate
xelab -debug typical -L uvm top_tb -s sim

echo "=== Running Simulation ==="

# Run simulation
xsim sim -runall

echo "=== Simulation Complete ==="