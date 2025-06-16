// ========================================================
// File: riscv_definitions.sv
// Description: Complete RISC-V core definitions package
// Includes: ALU operations, instruction opcodes, and core parameters
// ========================================================

`ifndef RISCV_DEFINITIONS_SV
`define RISCV_DEFINITIONS_SV

package riscv_definitions;

    // ====================================================
    // Core Parameters
    // ====================================================
    localparam DATA_WIDTH  = 32;      // 32-bit architecture
    localparam REG_ADDR    = 5;       // 5-bit register addresses (32 registers)
    localparam REG_COUNT   = 32;      // Number of registers
    localparam RAM_AMOUNT  = 4;       // Memory configuration
    localparam IMM_WIDTH   = 32;      // Immediate width
    localparam PC_WIDTH    = 32;      // Program counter width

    // Main data bus type
    typedef logic [DATA_WIDTH-1:0] dataBus_t;
    typedef logic [REG_ADDR-1:0]   regAddr_t;
    typedef logic [PC_WIDTH-1:0]   pc_t;

    // ====================================================
    // Instruction Opcodes (RV32I Base Set)
    // ====================================================
    typedef enum logic [6:0] {
        // U-Type Instructions
        LUI    = 7'b0110111,  // Load Upper Immediate
        AUIPC  = 7'b0010111,  // Add Upper Immediate to PC

        // J-Type Instructions
        JAL    = 7'b1101111,  // Jump and Link

        // I-Type Instructions
        JALR   = 7'b1100111,  // Jump and Link Register
        LOAD_S = 7'b0000011,  // Load instructions
        ALUI_S = 7'b0010011,  // Immediate ALU operations

        // B-Type Instructions
        BRCH_S = 7'b1100011,  // Branch instructions

        // S-Type Instructions
        STORE_S= 7'b0100011,  // Store instructions

        // R-Type Instructions
        ALU_S  = 7'b0110011   // Register ALU operations
    } opcodeType;

    // ====================================================
    // ALU Operation Types
    // ====================================================
    typedef enum logic [3:0] {
        ALU_ADD    = 4'b0000,  // Addition
        ALU_SUB    = 4'b0001,  // Subtraction
        ALU_SLL    = 4'b0010,  // Shift Left Logical
        ALU_SLT    = 4'b0011,  // Set Less Than (signed)
        ALU_SLTU   = 4'b0100,  // Set Less Than (unsigned)
        ALU_XOR    = 4'b0101,  // XOR
        ALU_SRL    = 4'b0110,  // Shift Right Logical
        ALU_SRA    = 4'b0111,  // Shift Right Arithmetic
        ALU_OR     = 4'b1000,  // OR
        ALU_AND    = 4'b1001,  // AND
        ALU_EQUAL  = 4'b1010,  // Equality comparison
        ALU_NEQUAL = 4'b1011,  // Inequality comparison
        ALU_LT     = 4'b1100,  // Less than (signed)
        ALU_GT     = 4'b1101,  // Greater than (signed)
        ALU_LTU    = 4'b1110,  // Less than (unsigned)
        ALU_GTU    = 4'b1111,  // Greater than (unsigned)
        ALU_BPS2   = 4'b0010   // Bypass source B (shared with SLL when needed)
    } aluOp_t;

    // ====================================================
    // ALU Source Selection
    // ====================================================
    typedef enum logic {
        RS1 = 1'b0,  // Register source 1
        PC  = 1'b1   // Program Counter
    } aluSrc1_e;

    typedef enum logic {
        RS2 = 1'b0,  // Register source 2
        IMM = 1'b1   // Immediate value
    } aluSrc2_e;

    // ====================================================
    // Immediate Format Types (for sign_extend)
    // ====================================================
    typedef enum logic [2:0] {
        IMM_I,   // I-type (arithmetic)
        IMM_IS,  // I-type shift (SLLI/SRLI/SRAI)
        IMM_S,   // S-type (stores)
        IMM_B,   // B-type (branches)
        IMM_U,   // U-type (upper immediates)
        IMM_J    // J-type (jumps)
    } imm_src_t;

    // ====================================================
    // Branch Types
    // ====================================================
    typedef enum logic [2:0] {
        BR_EQ,   // Equal
        BR_NE,   // Not Equal
        BR_LT,   // Less Than (signed)
        BR_GE,   // Greater/Equal (signed)
        BR_LTU,  // Less Than (unsigned)
        BR_GEU   // Greater/Equal (unsigned)
    } branchType_t;

    // ====================================================
    // Memory Access Types
    // ====================================================
    typedef enum logic [2:0] {
        MEM_BYTE,     // Byte access
        MEM_HALF,     // Half-word access
        MEM_WORD,     // Word access
        MEM_BYTE_U,   // Byte unsigned
        MEM_HALF_U    // Half-word unsigned
    } memAccessType_t;

    // ====================================================
    // Result Source Selection
    // ====================================================
    typedef enum logic [1:0] {
        RESULT_ALU,     // ALU result
        RESULT_MEM,     // Memory read data
        RESULT_PC_PLUS4 // PC + 4 (for JAL/JALR)
    } resultSrc_t;

    // Alias for backward compatibility
    typedef aluOp_t aluOpType;

endpackage

`endif // RISCV_DEFINITIONS_SV