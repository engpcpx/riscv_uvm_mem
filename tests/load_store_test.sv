// ========================================================
// File: load_store_test.sv
// Description: Functional test for LW/SW verification
// Location: tb/tests/load_store_test.sv
// ========================================================

`ifndef LOAD_STORE_TEST_SV
`define LOAD_STORE_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

// Caminhos corrigidos baseados na estrutura mostrada
`include "./tb/env/sequences/mem_transaction.sv"       // Transaction primeiro
`include "./tb/env/agents/mem_agent.sv"                 // Componentes do agent
`include "./tb/env/mem.env.sv"                          // Environment (note .env)
`include "./tb/env/sequences/load_store_sequence.sv"    // Sequence específica

class load_store_test extends uvm_test;
    `uvm_component_utils(load_store_test)
    
    mem_env env;
    
    function new(string name = "load_store_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = mem_env::type_id::create("env", this);
    endfunction
    
    task run_phase(uvm_phase phase);
        load_store_sequence seq;
        
        phase.raise_objection(this);
        `uvm_info("TEST", "Starting test sequence", UVM_MEDIUM)
        
        seq = load_store_sequence::type_id::create("seq");
        if (!seq.randomize()) begin
            `uvm_fatal("TEST", "Sequence randomization failed")
        end
        seq.start(env.agent.sequencer);
        
        #1000;
        `uvm_info("TEST", "Test completed", UVM_MEDIUM)
        phase.drop_objection(this);
    endtask
endclass

`endif // LOAD_STORE_TEST_SV