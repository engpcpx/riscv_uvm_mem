// mem_sequencer.sv
// UVM sequencer class for memory transactions


`ifndef MEM_SEQUENCE_SV
`define MEM_SEQUENCE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "../sequences/mem_transaction.sv"

class mem_sequencer extends uvm_sequencer #(mem_transaction);
  `uvm_component_utils(mem_sequencer)  // UVM factory registration
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass


`endif  // MEM_SEQUENCE