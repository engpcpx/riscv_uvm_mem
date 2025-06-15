// ========================================================
// File: riscv_wrapper.sv  
// Description: Wrapper to connect RISCV DUT with UVM interface
// ========================================================

`ifndef RISCV_WRAPPER_SV
`define RISCV_WRAPPER_SV

module riscv_wrapper(
    input logic clk,
    input logic rst_n,
    mem_interface.dut_mp mem_if
);

    // DUT instance
    RISCV dut_inst (
        .clk(clk),
        .rst_n(rst_n),
        
        // Instruction memory interface (simplified for memory testing)
        .i_instr_ready(1'b1),
        .i_instr_data(32'h00000013), // NOP instruction
        .o_inst_rd_en(),
        .o_inst_addr(),
        
        // Data memory interface - connected to testbench
        .i_data_ready(1'b1),
        .i_data_rd(mem_if.data_out),
        .o_data_wr(mem_if.data_in),
        .o_data_addr(mem_if.addr),
        .o_data_rd_en_ctrl(),
        .o_data_rd_en_ma(mem_if.mem_read),
        .o_data_wr_en_ma(mem_if.mem_write)
    );

    // Simple memory model for testing
    logic [31:0] test_memory [0:1023]; // Índice explícito
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset logic if needed
            mem_if.data_out <= '0;
        end
        else begin
            if (mem_if.mem_write) begin
                test_memory[mem_if.addr[11:2]] <= mem_if.data_in;
            end
            if (mem_if.mem_read) begin
                mem_if.data_out <= test_memory[mem_if.addr[11:2]];
            end
        end
    end

endmodule

`endif // RISCV_WRAPPER_SV