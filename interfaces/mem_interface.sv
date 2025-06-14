// ========================================================
// ARQUIVO 1: mem_interface.sv
// ========================================================

// mem_interface.sv 
interface mem_interface(input logic clk);
  logic [31:0] addr;        // Padronizado
  logic [31:0] data_in;     // Para writes
  logic [31:0] data_out;    // Para reads  
  logic        mem_read;    // Enable read
  logic        mem_write;   // Enable write

  modport dut_mp (
    input  data_addr, data_wr, data_rd_en_ma, data_wr_en_ma, data_rd_en_ctrl,
    output data_rd
  );

  modport uvm_mp (
    input  data_rd, clk,
    output data_addr, data_wr, data_rd_en_ma, data_wr_en_ma, data_rd_en_ctrl
  );
endinterface