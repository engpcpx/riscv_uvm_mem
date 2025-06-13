// mem_transaction.sv
// UVM sequence item class defining memory transaction properties

class mem_transaction extends uvm_sequence_item;
  `uvm_object_utils(mem_transaction)  // UVM factory registration
  
  // Transaction fields
  rand logic [31:0] addr;   // Memory address (32-bit aligned)
  rand logic [31:0] data;   // Data to write/read
  rand bit         is_write; // Operation type: 1=Store, 0=Load

  // Constraints to ensure valid transactions
  constraint aligned_addr {
    addr % 4 == 0;          // Force 32-bit aligned addresses
    addr inside {[0:'hFFFF]}; // Limit address range to 64KB
  }

  // Constructor
  function new(string name = "");
    super.new(name);
  endfunction
endclass