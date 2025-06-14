#!/bin/bash
# Compilação otimizada para XSIM 2024.1

# Limpeza
rm -rf xsim.dir *.jou *.log *.pb

# Análise (Compile)
xvlog -sv -L uvm \
  includes/riscv_pkg.sv \
  interfaces/mem_interface.sv \
  tb/env/mem_transaction.sv \
  tb/env/agents/mem_sequencer.sv \
  tb/env/agents/mem_driver.sv \
  tb/env/agents/mem_monitor.sv \
  tb/env/agents/mem_agent.sv \
  tb/env/sequences/base_sequence.sv \
  tb/env/sequences/load_store_sequence.sv \
  tb/env/mem_scoreboard.sv \
  tb/env/mem_env.sv \
  tb/tests/load_store_test.sv \
  tb/top_tb.sv

# Elaboração
xelab -L uvm -top top_tb -snapshot tb_snapshot

# Simulação
xsim tb_snapshot -testplusarg UVM_TESTNAME=load_store_test \
  -testplusarg UVM_VERBOSITY=UVM_MEDIUM \
  -log simulation.log