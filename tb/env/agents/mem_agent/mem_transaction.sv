// UVM transaction for memory operations
class mem_transaction extends uvm_sequence_item;
  `uvm_object_utils(mem_transaction)
  
  rand logic [31:0] addr;    // Memory address
  rand logic [31:0] data;    // Data payload
  rand bit         is_write; // 1=store, 0=load

  // Constraints for valid transactions
  constraint aligned_addr {
    addr % 4 == 0;   // 32-bit aligned
    addr < 1024;     // Within memory range
  }

  function new(string name = "");
    super.new(name);
  endfunction

  function string convert2string();
    return $sformatf("addr=0x%h data=0x%h is_write=%0d", addr, data, is_write);
  endfunction
  
endclass