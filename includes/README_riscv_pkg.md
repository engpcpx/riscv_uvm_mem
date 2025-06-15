# 📦 `riscv_pkg.sv` — Why and How to Use

## 1️⃣ Why use `riscv_pkg.sv`?

- **Avoid code duplication**: Defines constants, structs, enums, and utility functions in a single place.
- **Ease maintenance**: If a definition changes (e.g., instruction field size), you only need to update it once.
- **Better organization**: Separates architectural definitions from RTL/UVM code.
- **UVM compatibility**: Allows sharing types between transactions, sequences, and checkers.

---

## 2️⃣ What is it for?

The `riscv_pkg.sv` can contain:

**Common RISC-V definitions**
- Instruction types (LW, SW, ADD, etc.)
- Function codes (FUNCT3, FUNCT7)
- OpCodes
- Registers (x0 to x31, sp, ra, etc.)
- Data widths (XLEN = 32 or 64)

**Data structures (structs/typedefs)**
- RISC-V instruction formats (R-type, I-type, S-type, etc.)
- UVM transactions (e.g., `mem_transaction_t` for load/store)

**Utility functions**
- Instruction decoding
- Random address generation
- Memory alignment checking

---

## 3️⃣ How should it be used?

### Basic structure of the file

```systemverilog
package riscv_pkg;

  // Architecture definitions
  parameter XLEN = 32;  // 32-bit RISC-V
  typedef enum logic [6:0] {
    OP_LOAD   = 7'b0000011,
    OP_STORE  = 7'b0100011,
    OP_ALU    = 7'b0110011
  } opcode_t;

  // Memory transaction structure
  typedef struct {
    logic [XLEN-1:0] addr;
    logic [XLEN-1:0] data;
    logic            is_load;  // 1=load, 0=store
  } mem_transaction_t;

  // Alignment check function
  function automatic logic is_aligned(logic [XLEN-1:0] addr, logic [1:0] size);
    return (addr % (2**size) == 0);
  endfunction

endpackage
