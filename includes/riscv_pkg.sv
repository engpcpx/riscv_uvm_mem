// ========================================================
// File: riscv_pkg.sv
// Description: RISC-V definitions and utility functions
// ========================================================

package riscv_pkg;
    
    // Core parameters
    parameter int XLEN = 32;
    parameter int REG_COUNT = 32;
    
    // Memory transaction structure
    typedef struct packed {
        logic [XLEN-1:0] address;
        logic [XLEN-1:0] data;
        logic            is_load;  // 1=load, 0=store
        logic [2:0]      size;     // 000=byte, 001=half, 010=word
    } mem_transaction_t;
    
    // RISC-V Instruction formats
    typedef struct packed {
        logic [11:0] imm;
        logic [4:0]  rs1;
        logic [2:0]  funct3;
        logic [4:0]  rd;
        logic [6:0]  opcode;
    } i_type_instr_t;
    
    typedef struct packed {
        logic [6:0]  imm_11_5;
        logic [4:0]  rs2;
        logic [4:0]  rs1;
        logic [2:0]  funct3;
        logic [4:0]  imm_4_0;
        logic [6:0]  opcode;
    } s_type_instr_t;
    
    // Load/Store instruction types
    typedef i_type_instr_t lw_instr_t;
    typedef s_type_instr_t sw_instr_t;
    
    // Opcodes
    parameter logic [6:0] LOAD_OPCODE  = 7'b0000011;
    parameter logic [6:0] STORE_OPCODE = 7'b0100011;
    
    // funct3 codes for load/store
    parameter logic [2:0] LW_FUNCT3 = 3'b010;
    parameter logic [2:0] SW_FUNCT3 = 3'b010;
    
    // Utility functions
    function automatic logic is_mem_aligned(logic [XLEN-1:0] addr);
        return (addr[1:0] == 2'b00);
    endfunction
    
    function automatic lw_instr_t gen_lw_instr(
        logic [4:0] rd,
        logic [4:0] base_reg,
        logic [11:0] offset
    );
        if (rd >= REG_COUNT || base_reg >= REG_COUNT) begin
            $error("Invalid register index in gen_lw_instr");
        end
        lw_instr_t instr;
        instr.imm = offset;
        instr.rs1 = base_reg;
        instr.funct3 = LW_FUNCT3;
        instr.rd = rd;
        instr.opcode = LOAD_OPCODE;
        return instr;
    endfunction
    
    function automatic sw_instr_t gen_sw_instr(
        logic [4:0] base_reg,
        logic [4:0] src_reg,
        logic [11:0] offset
    );
        if (base_reg >= REG_COUNT || src_reg >= REG_COUNT) begin
            $error("Invalid register index in gen_sw_instr");
        end
        sw_instr_t instr;
        instr.imm_11_5 = offset[11:5];
        instr.rs2 = src_reg;
        instr.rs1 = base_reg;
        instr.funct3 = SW_FUNCT3;
        instr.imm_4_0 = offset[4:0];
        instr.opcode = STORE_OPCODE;
        return instr;
    endfunction
    
endpackage