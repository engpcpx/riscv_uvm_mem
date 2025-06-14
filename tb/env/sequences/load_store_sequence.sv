class load_store_sequence extends base_sequence;
  `uvm_object_utils(load_store_sequence)
  
  localparam bit [31:0] TEST_PATTERNS[] = {
    32'hCAFE_BABE, 32'hDEAD_BEEF, 
    32'h1234_5678, 32'hFFFF_FFFF
  };

  task body();
    super.body();
    mem_transaction store_tr, load_tr;
    logic [31:0] test_addr;

    foreach (TEST_PATTERNS[i]) begin
      test_addr = get_aligned_addr();
      
      // Store operation
      store_tr = mem_transaction::type_id::create("store_tr");
      assert(store_tr.randomize() with {
        is_write == 1;
        addr == test_addr;
        data == TEST_PATTERNS[i];
      });
      start_item(store_tr);
      finish_item(store_tr);

      // Load operation no mesmo endereço
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