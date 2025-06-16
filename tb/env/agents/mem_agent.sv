// ========================================================
// File: mem_agent.sv
// Description: Complete UVM agent implementation for memory interface
// ========================================================

`ifndef MEM_AGENT_SV
`define MEM_AGENT_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

// Include transaction definition first
`include "../sequencer/mem_transaction.sv"


// Include subcomponent definitions with correct paths
`include "mem_driver.sv"
`include "mem_monitor.sv"
`include "mem_sequencer.sv"

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
    
    // Connect Phase - connects components
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        
        // Connect monitor to agent's analysis port
        monitor.analysis_port.connect(this.analysis_port);
        
        // Connect driver to sequencer if active
        if(get_is_active() == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction
    
    // Additional agent functionality can be added here
    // (run_phase, report_phase, etc. as needed)
    
endclass

`endif // MEM_AGENT_SV