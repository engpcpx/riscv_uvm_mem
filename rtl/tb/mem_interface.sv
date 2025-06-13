// mem_interface.sv
// SystemVerilog interface for memory bus signals

interface mem_interface(input logic clk);
  // Signal declarations
  logic [31:0] addr;       // 32-bit memory address
  logic [31:0] data_in;    // Data to memory (write)
  logic [31:0] data_out;   // Data from memory (read)
  logic        mem_read;   // Read enable
  logic        mem_write;  // Write enable

  // Modport for DUT connection
  modport dut_mp (
    input  addr, data_in, mem_read, mem_write,  // DUT inputs
    output data_out                              // DUT output
  );

  // Modport for UVM testbench connection
  modport uvm_mp (
    input  data_out, clk,        // TB inputs
    output addr, data_in,        // TB outputs
    output mem_read, mem_write   // Control signals
  );
endinterface