// tb/env/sequences/load_store_sequence.sv
class load_store_sequence extends base_sequence;
  `uvm_object_utils(load_store_sequence)
  
  // Padrões de teste conhecidos
  localparam bit [31:0] TEST_PATTERNS[] = {
    32'hCAFE_BABE, 32'hDEAD_BEEF, 
    32'h1234_5678, 32'hFFFF_FFFF
  };

  task body();
    super.body();
    mem_transaction tr;

    // Standard test padrão: write seguido de read
    foreach (TEST_PATTERNS[i]) begin
      // Store operation
      tr = mem_transaction::type_id::create("tr");
      assert(tr.randomize() with {
        is_write == 1;
        addr == get_aligned_addr();
        data == TEST_PATTERNS[i];
      });
      start_item(tr);
      finish_item(tr);

      // Load operation
      tr = mem_transaction::type_id::create("tr");
      assert(tr.randomize() with {
        is_write == 0;
        addr == local::tr.addr;
      });
      start_item(tr);
      finish_item(tr);
    end
  endtask
endclass