// tb/env/mem_env.sv
`ifndef MEM_ENV_SV
`define MEM_ENV_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

// Inclusões corretas com caminhos absolutos relativos
`include "../env/agents/mem_agent.sv"
`include "mem_scoreboard.sv"

class mem_env extends uvm_env;
  `uvm_component_utils(mem_env)
  
  mem_agent agent;          // Agent instance
  mem_scoreboard scoreboard; // Scoreboard instance
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent = mem_agent::type_id::create("agent", this);
    scoreboard = mem_scoreboard::type_id::create("scoreboard", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent.monitor.item_collected_port.connect(scoreboard.item_collected_export);
  endfunction
  
  function void end_of_elaboration_phase(uvm_phase phase);
    `uvm_info("ENV", "Memory environment setup complete", UVM_MEDIUM)
  endfunction
endclass

`endif // MEM_ENV_SV