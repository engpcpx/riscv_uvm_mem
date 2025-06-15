// tb/env/agents/mem_monitor.sv
`ifndef MEM_MONITOR_SV
`define MEM_MONITOR_SV

`include "uvm_macros.svh"
`include "../sequences/mem_transaction.sv"

import uvm_pkg::*;

class mem_monitor extends uvm_monitor;
    `uvm_component_utils(mem_monitor)
    
    virtual mem_interface vif;
    uvm_analysis_port #(mem_transaction) item_collected_port;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual mem_interface)::get(this, "", "mem_if", vif)) begin
            `uvm_fatal("MONITOR", "Virtual interface not found")
        end
    endfunction
    
    task run_phase(uvm_phase phase);
        mem_transaction trans;
        forever begin
            trans = mem_transaction::type_id::create("trans");
            @(posedge vif.clk);
            
            if (vif.mem_read || vif.mem_write) begin
                trans.addr = vif.addr;
                trans.is_write = vif.mem_write;
                
                if (vif.mem_write) begin
                    trans.data = vif.data_in;
                    `uvm_info("MONITOR", $sformatf("WRITE: addr=0x%h, data=0x%h", 
                              trans.addr, trans.data), UVM_HIGH)
                end
                else begin
                    @(posedge vif.clk);
                    trans.data = vif.data_out;
                    `uvm_info("MONITOR", $sformatf("READ: addr=0x%h, data=0x%h", 
                              trans.addr, trans.data), UVM_HIGH)
                end
                
                item_collected_port.write(trans);
            end
        end
    endtask
endclass

`endif // MEM_MONITOR_SV