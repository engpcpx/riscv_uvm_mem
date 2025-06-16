// ========================================================
// File: mem_agent.sv (corrected version)
// ========================================================

`ifndef MEM_AGENT_SV
`define MEM_AGENT_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

// Include transaction definition first
`include "../sequences/mem_transaction.sv"

// Include subcomponent definitions with correct paths
`include "tb/env/agents/mem_driver.sv"
`include "tb/env/agents/mem_monitor.sv"
`include "tb/env/agents/mem_sequencer.sv"

class mem_agent extends uvm_agent;
    `uvm_component_utils(mem_agent)
    
    // Component handles
    mem_driver    driver;     // Driver instance
    mem_sequencer sequencer;  // Sequencer instance
    mem_monitor   monitor;    // Monitor instance
    
    // Analysis port for monitoring transactions
    uvm_analysis_port #(mem_transaction) analysis_port;
    
    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        analysis_port = new("analysis_port", this);
    endfunction
    
    // Build Phase - creates subcomponents
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // Create monitor (always present)
        monitor = mem_monitor::type_id::create("monitor", this);
        
        // Only create active components if agent is active
        if(get_is_active() == UVM_ACTIVE) begin
            driver = mem_driver::type_id::create("driver", this);
            sequencer = mem_sequencer::type_id::create("sequencer", this);
        end
    endfunction
    
    // Connect Phase - connects components (corrected)
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // Corrected connection: use monitor's item_collected_port
        monitor.item_collected_port.connect(this.analysis_port);
        
        // Connect driver to sequencer if active
        if(get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction
    
endclass

`endif // MEM_AGENT_SV