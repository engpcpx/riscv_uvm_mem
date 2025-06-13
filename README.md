# RISC-V Memory Subsystem UVM Testbench

![UVM Verification](https://img.shields.io/badge/UVS-1.2-blue) 
![Vivado XSIM](https://img.shields.io/badge/Vivado-2024.1-purple)
![RISCV](https://img.shields.io/badge/RISC--V-32bit-green)

## Core Verification Targets

Verifies the **Memory Access Stage (MEM)** of a 5-stage RISC-V pipeline with:

| Feature               | Specification                          | Test Mechanism          |
|-----------------------|---------------------------------------|-------------------------|
| **Data Width**        | 32-bit words                          | Aligned access checks   |
| **Memory Ports**      | 1 read/write port                     | Protocol assertions     |
| **Operations**        | LW, SW                                | Sequence generation     |
| **Addressing**        | Byte-addressable (word-aligned)       | Boundary tests          |
| **Hazards**           | Structural (no cache)                 | Pipeline stall checks   |

## Component Details

### Key UVM Components
| Component            | Purpose                                | Key Features                         |
|----------------------|----------------------------------------|--------------------------------------|
| `mem_transaction`    | Packet structure for memory ops        | Constraints for aligned addresses    |
| `mem_driver`         | Converts UVM seq to signals            | Implements 2-cycle memory protocol   |
| `mem_monitor`        | Captures DUT responses                 | Detects read/write collisions        |
| `mem_interface`      | DUT-TB connection                     | Dual modport (DUT/TB views)          |

### Interface Signals
```systemverilog
interface mem_interface(input logic clk);
  logic [31:0] addr;      
  logic [31:0] data_in;   
  logic [31:0] data_out;  
  logic mem_read;         
  logic mem_write;        
  modport dut_mp(...);    
  modport uvm_mp(...);    
endinterface
```

## Simulation Flow
1. Compilation
```bash
xvlog -sv -L uvm   -f sim/rtl.scrlist \    
  -f sim/uvm.scrlist      
```
2. Elaboration
```bash
xelab -debug typical   -L uvm   -timescale "1ns/1ps"   riscv_tb_top
```
3. Run Tests
```bash
xsim riscv_tb_top   -gui   -testplusarg UVM_TESTNAME=load_store_test
```

## Example Test Results

### Waveform Example (Store → Load Sequence)
```
┌──────────┬──────────┬──────────────┬──────────────────────┐
│ Time(ns) │ Operation│ Address      │ Data                 │
├──────────┼──────────┼──────────────┼──────────────────────┤
│ 10       │ STORE    │ 0x00000100   │ 0xCAFEBABE           │
│ 50       │ LOAD     │ 0x00000100   │ 0xCAFEBABE (captured)│
└──────────┴──────────┴──────────────┴──────────────────────┘
```

## License

MIT License - See LICENSE for details.
