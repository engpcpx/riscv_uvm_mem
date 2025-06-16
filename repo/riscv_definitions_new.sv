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
        OP_LUI    = 7'b0110111,  // Load Upper Immediate
        OP_AUIPC  = 7'b0010111,  // Add Upper Immediate to PC

        // J-Type Instructions
        OP_JAL    = 7'b1101111,  // Jump and Link

        // I-Type Instructions
        OP_JALR   = 7'b1100111,  // Jump and Link Register
        OP_LOAD   = 7'b0000011,  // Load instructions
        OP_OP_IMM = 7'b0010011,  // Immediate ALU operations

        // B-Type Instructions
        OP_BRANCH = 7'b1100011,  // Branch instructions

        // S-Type Instructions
        OP_STORE  = 7'b0100011,  // Store instructions

        // R-Type Instructions
        OP_OP     = 7'b0110011   // Register ALU operations
    } opcode_t;

    // ====================================================
    // ALU Operation Types
    // ====================================================
    typedef enum logic [3:0] {
        ALU_ADD    = 4'b0000,  // Addition
        ALU_SUB    = 4'b1000,  // Subtraction
        ALU_SLL    = 4'b0001,  // Shift Left Logical
        ALU_SLT    = 4'b0010,  // Set Less Than (signed)
        ALU_SLTU   = 4'b0011,  // Set Less Than (unsigned)
        ALU_XOR    = 4'b0100,  // XOR
        ALU_SRL    = 4'b0101,  // Shift Right Logical
        ALU_SRA    = 4'b1001,  // Shift Right Arithmetic
        ALU_OR     = 4'b0110,  // OR
        ALU_AND    = 4'b0111,  // AND
        
        // Special operations
        ALU_BYPASS = 4'b1010,  // Bypass operation
        ALU_EQ     = 4'b1011,  // Equality comparison
        ALU_NE     = 4'b1100,  // Inequality comparison
        ALU_GE     = 4'b1101,  // Greater/Equal (signed)
        ALU_GEU    = 4'b1111   // Greater/Equal (unsigned)
    } aluOp_t;

    // ====================================================
    // Immediate Format Types
    // ====================================================
    typedef enum logic [2:0] {
        IMM_I,  // I-type (arithmetic)
        IMM_S,  // S-type (stores)
        IMM_B,  // B-type (branches)
        IMM_U,  // U-type (upper immediates)
        IMM_J   // J-type (jumps)
    } immFormat_t;

    // ====================================================
    // ALU Source Selection
    // ====================================================
    typedef enum logic [1:0] {
        ALU_SRC_REG,  // Select register value
        ALU_SRC_IMM,  // Select immediate value
        ALU_SRC_PC    // Select PC value
    } aluSrcSel_t;

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
    // Control Signals Structure
    // ====================================================
    typedef struct packed {
        logic        regWrite;     // Register write enable
        logic        memRead;      // Memory read enable
        logic        memWrite;     // Memory write enable
        logic        memToReg;     // Memory to register
        logic        pcToReg;      // PC to register
        logic        aluSrc1;      // ALU source 1 select
        logic [1:0]  aluSrc2;      // ALU source 2 select
        aluOp_t      aluOp;        // ALU operation
        branchType_t branchType;   // Branch comparison type
        logic        jump;         // Jump instruction
        logic        auipc;        // AUIPC instruction
        logic        lui;          // LUI instruction
    } controlSignals_t;

endpackage

`endif // RISCV_DEFINITIONS_SV