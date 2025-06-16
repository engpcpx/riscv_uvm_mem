// ========================================================
// File: mem_interface.sv
// Description: Memory interface for RISC-V UVM testbench
// ========================================================

// /interfaces/mem_interface.sv
`ifndef MEM_INTERFACE_SV
`define MEM_INTERFACE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

interface mem_interface(input logic clk);
    // Main Signals
    logic [31:0] addr;         // Memory address
    logic [31:0] data_in;      // Write data (to memory)
    logic [31:0] data_out;     // Read data (from memory)
    logic        mem_read;     // Read enable signal
    logic        mem_write;    // Write enable signal
    logic        data_rd_en_ctrl; // Additional read control signal

    // Modport for DUT (Memory Side)
    modport dut_mp (
        input  addr, data_in, mem_read, mem_write, data_rd_en_ctrl,
        output data_out,
        input  clk  // Clock signal for synchronous operation
    );

    // Modport for UVM (Testbench Side)
    modport uvm_mp (
        input  data_out, clk,
        output addr, data_in, mem_read, mem_write, data_rd_en_ctrl
    );
endinterface

`endif // MEM_INTERFACE_SV