// ========================================================
// File: mem_interface.sv
// Description: Memory interface for RISC-V UVM testbench
// ========================================================

interface mem_interface(input logic clk);
  // Main Signals
  logic [31:0] data_addr;    // Memory address (renamed from 'addr')
  logic [31:0] data_wr;      // Write data (renamed from 'data_in')
  logic [31:0] data_rd;      // Read data (renamed from 'data_out')
  logic        data_rd_en_ma; // Read enable (from memory access)
  logic        data_wr_en_ma; // Write enable (from memory access)
  logic        data_rd_en_ctrl; // Read enable (from controller)

  // Modport for DUT (Memory Side)
  modport dut_mp (
    input  data_addr, data_wr, data_rd_en_ma, data_wr_en_ma, data_rd_en_ctrl,
    output data_rd,
    input  clk  // Added clock to DUT modport
  );

  // Modport for UVM (Testbench Side)
  modport uvm_mp (
    input  data_rd, clk,
    output data_addr, data_wr, data_rd_en_ma, data_wr_en_ma, data_rd_en_ctrl
  );
endinterface