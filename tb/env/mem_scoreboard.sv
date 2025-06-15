// tb/env/mem_scoreboard.sv
`ifndef MEM_SCOREBOARD_SV
`define MEM_SCOREBOARD_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

// Inclua a definição da transação
`include "./sequences/mem_transaction.sv"

class mem_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(mem_scoreboard)
  
  uvm_analysis_export #(mem_transaction) item_collected_export;
  uvm_tlm_analysis_fifo #(mem_transaction) item_fifo;
  
  // Memory model
  bit [31:0] memory[bit [31:0]];
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    item_collected_export = new("item_collected_export", this);
    item_fifo = new("item_fifo", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    item_collected_export.connect(item_fifo.analysis_export);
  endfunction
  
  task run_phase(uvm_phase phase);
    mem_transaction tr;
    forever begin
      item_fifo.get(tr);
      if(tr.is_write) begin
        memory[tr.addr] = tr.data;
        `uvm_info("SCOREBOARD", $sformatf("Store @0x%h = 0x%h", 
                  tr.addr, tr.data), UVM_HIGH)
      end
      else begin
        if(memory.exists(tr.addr)) begin
          if(tr.data != memory[tr.addr]) begin
            `uvm_error("SCOREBOARD", 
              $sformatf("Load mismatch @0x%h: Exp=0x%h Act=0x%h", 
              tr.addr, memory[tr.addr], tr.data))
          end
          else begin
            `uvm_info("SCOREBOARD", 
              $sformatf("Load match @0x%h = 0x%h", 
              tr.addr, tr.data), UVM_HIGH)
          end
        end
        else begin
          `uvm_warning("SCOREBOARD", 
            $sformatf("Load from uninitialized addr 0x%h", tr.addr))
        end
      end
    end
  endtask
endclass

`endif // MEM_SCOREBOARD_SV