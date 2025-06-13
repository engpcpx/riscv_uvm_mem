// mem_interface.sv 
interface mem_interface(input logic clk);
  logic [31:0] data_addr;
  logic [31:0] data_wr;
  logic [31:0] data_rd;
  logic [3:0] data_rd_en_ctrl;
  logic data_rd_en_ma;
  logic data_wr_en_ma;

  modport dut_mp (
    input  data_addr, data_wr, data_rd_en_ma, data_wr_en_ma, data_rd_en_ctrl,
    output data_rd
  );

  modport uvm_mp (
    input  data_rd, clk,
    output data_addr, data_wr, data_rd_en_ma, data_wr_en_ma, data_rd_en_ctrl
  );
endinterface