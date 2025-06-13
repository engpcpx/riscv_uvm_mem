`include "uvm_macros.svh"
import uvm_pkg::*;
`include "riscv_definitions.sv"
`include "mem_interface.sv"

module top_tb;
  // Interface e clock
  mem_if mem_vif();
  logic clk = 0;

  // DUT (exemplo)
  RISCV dut (.clk(clk), .mem_if(mem_vif));

  // Configuração UVM
  initial begin
    uvm_config_db#(virtual mem_if)::set(null, "*", "mem_if", mem_vif);
    run_test();
  end

  // Clock generator
  always #5 clk = ~clk;
endmodule