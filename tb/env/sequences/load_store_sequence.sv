// tb/env/sequences/load_store_sequence.sv
`ifndef LOAD_STORE_SEQUENCE_SV
`define LOAD_STORE_SEQUENCE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
`include "../sequences/mem_transaction.sv"

class load_store_sequence extends uvm_sequence #(mem_transaction);
  `uvm_object_utils(load_store_sequence)
  
  // Padrões de teste como parâmetro local
  localparam bit [31:0] TEST_PATTERNS[4] = '{
    32'hCAFE_BABE, 
    32'hDEAD_BEEF, 
    32'h1234_5678, 
    32'hFFFF_FFFF
  };

  function new(string name = "load_store_sequence");
    super.new(name);
  endfunction

  task body();
    mem_transaction store_tr, load_tr;
    logic [31:0] test_addr;

    foreach (TEST_PATTERNS[i]) begin
      test_addr = i * 4; // Endereços alinhados
      
      // Store operation
      store_tr = mem_transaction::type_id::create("store_tr");
      assert(store_tr.randomize() with {
        is_write == 1;
        addr == test_addr;
        data == TEST_PATTERNS[i];
      });
      start_item(store_tr);
      finish_item(store_tr);

      // Load operation
      load_tr = mem_transaction::type_id::create("load_tr");
      assert(load_tr.randomize() with {
        is_write == 0;
        addr == test_addr;
      });
      start_item(load_tr);
      finish_item(load_tr);
    end
  endtask
endclass

`endif // LOAD_STORE_SEQUENCE_SV