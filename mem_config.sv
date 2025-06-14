class mem_config extends uvm_object;
  `uvm_object_utils(mem_config)
  
  bit active = 1;
  int num_transactions = 100;
  bit [31:0] mem_base_addr = 32'h1000;
  bit [31:0] mem_size = 32'h1000;
  
  function new(string name = "mem_config");
    super.new(name);
  endfunction
endclass