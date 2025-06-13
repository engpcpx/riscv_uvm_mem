class load_store_test extends uvm_test;
  import riscv_pkg::*;

  // UVM component utilities
  `uvm_component_utils(load_store_test)

  // Constructor
  function new(string name = "load_store_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual task run_phase(uvm_phase phase);
    // Initialize memory transaction
    mem_transaction_t mem_txn;
    logic [XLEN-1:0] base_addr = 32'h0000_1000;

    // Phase raising
    phase.raise_objection(this);

    // =============================================
    // Test 1: Verify aligned LW/SW operations
    // =============================================
    `uvm_info("TEST", "Starting aligned memory access test", UVM_LOW)

    // Generate aligned address
    if (!is_mem_aligned(base_addr)) begin
      base_addr = (base_addr + 3) & ~3; // Force alignment
    end

    // --------------------------------------------------
    // LW Test: Load from memory
    // --------------------------------------------------
    mem_txn = '{
      address: base_addr + 16,
      data:    32'h0,       // Will be overwritten by load
      is_load: 1'b1,        // Load operation
      size:    3'b010       // Word (4B)
    };

    // Generate corresponding LW instruction
    lw_instr_t lw_instr = gen_lw_instr(
      .rd       (5'd1),     // Destination: x1
      .base_reg (5'd2),     // Base register: x2
      .offset   (12'h10)    // Offset: +16
    );

    `uvm_info("LW_TEST", 
      $sformatf("Executing LW: x1 = [x2(0x%0h) + 0x10]", base_addr), 
      UVM_MEDIUM)

    // --------------------------------------------------
    // SW Test: Store to memory
    // --------------------------------------------------
    mem_txn = '{
      address: base_addr + 32,
      data:    32'hDEADBEEF,
      is_load: 1'b0,        // Store operation
      size:    3'b010       // Word (4B)
    };

    // Generate corresponding SW instruction
    sw_instr_t sw_instr = gen_sw_instr(
      .base_reg (5'd4),     // Base register: x4
      .src_reg  (5'd3),     // Source: x3
      .offset   (12'h20)    // Offset: +32
    );

    `uvm_info("SW_TEST", 
      $sformatf("Executing SW: [x4(0x%0h) + 0x20] = x3(0x%0h)", 
      base_addr, mem_txn.data), 
      UVM_MEDIUM)

    // =============================================
    // Test 2: Verify misaligned access detection
    // =============================================
    `uvm_info("TEST", "Starting misaligned access test", UVM_LOW)

    // Force misaligned address
    logic [XLEN-1:0] misaligned_addr = base_addr + 1;

    if (is_mem_aligned(misaligned_addr)) begin
      `uvm_error("ALIGN_ERR", "Alignment check failed to detect misaligned address")
    end
    else begin
      `uvm_info("ALIGN_TEST", 
        $sformatf("Correctly detected misaligned address: 0x%0h", misaligned_addr), 
        UVM_MEDIUM)
    end

    // Phase dropping
    phase.drop_objection(this);
  endtask

endclass