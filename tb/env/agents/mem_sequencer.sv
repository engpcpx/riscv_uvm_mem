// mem_sequencer.sv
// UVM sequencer class for memory transactions

class mem_sequencer extends uvm_sequencer #(mem_transaction);
  `uvm_component_utils(mem_sequencer)  // UVM factory registration
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass