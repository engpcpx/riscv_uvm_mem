// ========================================================
// File: riscv_wrapper.sv  
// Description: Wrapper to connect RISCV DUT with UVM interface
// ========================================================


// /interfaces/mem_riscv_wrapper.sv

`ifndef RISCV_WRAPPER_SV
`define RISCV_WRAPPER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

module riscv_wrapper(
    input logic clk,          // System clock
    input logic rst_n,        // Active-low reset
    mem_interface.dut_mp mem_if  // Memory interface connection
);

    // DUT instance
    RISCV dut_inst (
        .clk(clk),
        .rst_n(rst_n),
        
        // Instruction memory interface (simplified for memory testing)
        .i_instr_ready(1'b1),               // Always ready for testing
        .i_instr_data(32'h00000013),        // NOP instruction as default
        .o_inst_rd_en(),                    // Instruction read enable (unused)
        .o_inst_addr(),                     // Instruction address (unused)
        
        // Data memory interface - connected to testbench
        .i_data_ready(1'b1),                // Always ready for testing
        .i_data_rd(mem_if.data_out),        // Read data from memory
        .o_data_wr(mem_if.data_in),         // Write data to memory
        .o_data_addr(mem_if.addr),          // Memory address
        .o_data_rd_en_ctrl(mem_if.data_rd_en_ctrl), // Control read enable
        .o_data_rd_en_ma(mem_if.mem_read),  // Memory read enable
        .o_data_wr_en_ma(mem_if.mem_write)  // Memory write enable
    );

    // Simple memory model for testing
    logic [31:0] test_memory [0:1023]; // 1KB memory (1024 x 32-bit)
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset memory output
            mem_if.data_out <= '0;
        end
        else begin
            // Write operation
            if (mem_if.mem_write) begin
                test_memory[mem_if.addr[11:2]] <= mem_if.data_in; // Word addressing
            end
            // Read operation
            if (mem_if.mem_read) begin
                mem_if.data_out <= test_memory[mem_if.addr[11:2]]; // Word addressing
            end
        end
    end

endmodule

`endif // RISCV_WRAPPER_SV