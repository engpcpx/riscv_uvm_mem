// tb/env/sequences/base_sequence.sv
class base_sequence extends uvm_sequence #(mem_transaction);
  `uvm_object_utils(base_sequence)
  
  // Configurações comuns
  rand int min_addr = 32'h0000_0100;
  rand int max_addr = 32'h0000_0FFF;
  rand int num_transactions = 10;
  
  // Constraints básicas
  constraint addr_range {
    min_addr % 4 == 0;
    max_addr % 4 == 0;
    min_addr < max_addr;
  }
  
  constraint transaction_count {
    num_transactions inside {[1:100]};
  }

  function new(string name = "");
    super.new(name);
  endfunction

  // Standart method for all sequences
  virtual task body();
    `uvm_info(get_type_name(), "Starting base sequence", UVM_MEDIUM)
  endtask
  
  // Address aligned generation
  function logic [31:0] get_aligned_addr();
    return $urandom_range(min_addr, max_addr) & 32'hFFFF_FFFC;
  endfunction
endclass