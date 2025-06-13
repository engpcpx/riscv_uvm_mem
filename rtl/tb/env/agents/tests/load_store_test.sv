// load_store_test.sv
// UVM test class for basic load/store verification

class load_store_test extends uvm_test;
  `uvm_component_utils(load_store_test)  // UVM factory registration
  mem_sequencer sequencer;               // Sequencer handle

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Main test execution
  task run_phase(uvm_phase phase);
    mem_transaction tr;
    
    // Required for UVM synchronization
    phase.raise_objection(this);
    
    // Test sequence: Store followed by Load
    // 1. Perform Store operation
    tr = mem_transaction::type_id::create("tr");
    assert(tr.randomize() with {
      is_write == 1;       // Store operation
      addr == 32'h100;     // Test address
      data == 32'hCAFEBABE; // Test pattern
    });
    sequencer.start_item(tr);
    sequencer.finish_item(tr);

    // 2. Perform Load operation
    tr = mem_transaction::type_id::create("tr");
    assert(tr.randomize() with {
      is_write == 0;       // Load operation
      addr == 32'h100;     // Same address
    });
    sequencer.start_item(tr);
    sequencer.finish_item(tr);

    // Required for UVM synchronization
    phase.drop_objection(this);
  endtask
endclass