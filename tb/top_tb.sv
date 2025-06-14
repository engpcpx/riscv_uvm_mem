// ========================================================
// File: top_tb.sv
// Description: Top-level testbench for RISC-V memory verification
// ========================================================

`include "uvm_macros.svh"
import uvm_pkg::*;

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
        $fatal("Testbench timeout!");
    end
    
endmodule