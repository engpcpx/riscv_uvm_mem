// ========================================================
// File: top_tb.sv
// Description: Top-level testbench for RISC-V memory verification
// ========================================================

`ifndef TOP_TB_SV
`define TOP_TB_SV

`timescale 1ns/1ps

// Include UVM
`include "uvm_macros.svh"
import uvm_pkg::*;

// Include test
`include "../tests/load_store_test.sv"

// Include interfaces
`include "../interfaces/mem_interface.sv"
`include "../interfaces/riscv_wrapper.sv"

module top_tb;
    
    // Clock and reset
    logic clk = 0;
    logic rst_n = 0;
    
    // Interface instance  
    mem_interface mem_if(clk);
    
    // DUT wrapper instance
    riscv_wrapper dut (
        .clk(clk),
        .rst_n(rst_n),
        .mem_if(mem_if.dut_mp)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end
    
    // Reset generation
    initial begin
        rst_n = 0;
        #100;
        rst_n = 1;
    end
    
    // UVM configuration and test execution
    initial begin
        // Set interface in config_db
        uvm_config_db#(virtual mem_interface)::set(null, "*", "mem_if", mem_if);
        
        // Run the test
        run_test("load_store_test");
    end
    
    // Timeout protection
    initial begin
        #1000000; // 1ms timeout
        $display("Timeout reached!");
        $finish;
    end
    
    // Dump VCD for debugging (opcional)
    initial begin
        $dumpfile("waveform.vcd");
        $dumpvars(0, top_tb);
    end
    
endmodule

`endif // TOP_TB_SV