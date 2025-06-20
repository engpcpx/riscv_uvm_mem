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

## Verification Capabilities

With this structure you can now:

- **Generate load/store transactions**
- **Drive signals to the DUT**
- **Monitor DUT responses**
- **Run basic directed tests**

For full verification, you'll eventually want to add:

- ➕ **A scoreboard for automatic checking**
- ➕ **Functional coverage**
- ➕ **Randomized test sequences**

---

⚡ **This structure gives you a minimal but fully functional UVM testbench for load/store operations that compiles and runs in Vivado XSIM.**



# Simplified UVM Testbench Structure

```plaintext

RISCV_UVM_MEM/
├── includes/
│   └── riscv_pkg.sv
├── interfaces/
│   └── mem_interface.sv
├── rtl/
│   ├── RISCV.sv
│   ├── memory_access.sv
│   ├── riscv_wrapper.sv
│   └── [outros módulos RTL]
├── tb/
│   ├── env/
│   │   ├── agents/
│   │   │   ├── mem_agent.sv
│   │   │   ├── mem_driver.sv
│   │   │   ├── mem_monitor.sv
│   │   │   └── mem_sequencer.sv
│   │   ├── sequences/
│   │   │   ├── base_sequence.sv
│   │   │   └── load_store_sequence.sv
│   │   ├── mem_env.sv
│   │   ├── mem_scoreboard.sv
│   │   └── mem_transaction.sv
│   ├── tests/
│   │   └── load_store_test.sv
│   └── top_tb.sv
├── scripts/
│   └── compile_and_run.sh
└── sim/
    └── [arquivos de simulação]

```

# Key Files with Purposes

## 1️Core UVM Components

| File               | Purpose                                      |
|--------------------|----------------------------------------------|
| mem_transaction.sv | Defines load/store operations as UVM transactions |
| mem_sequencer.sv   | Controls transaction flow from sequences to driver |
| mem_driver.sv      | Converts UVM transactions to signal-level activity |
| mem_monitor.sv     | Captures DUT responses for verification |

## 2️Infrastructure

| File              | Purpose                                 |
|-------------------|-----------------------------------------|
| mem_interface.sv  | Physical signals connecting TB to DUT    |
| riscv_tb_top.sv   | Instantiates DUT and UVM environment     |

## 3️Control Files

| File         | Purpose                                          |
|--------------|--------------------------------------------------|
| rtl.scrlist  | Compiles RTL files in correct order              |
| uvm.scrlist  | Compiles UVM components in dependency order      |
| sim.scrlist  | Master file combining RTL and UVM lists          |


## Key Design Patterns

- **Factory Pattern**: Used throughout UVM for object creation (`type_id::create`)
- **Observer Pattern**: Driver observes sequencer for new transactions
- **Virtual Interface**: Bridges between UVM and signal-level DUT
- **Constrained Random**: Transaction randomization with alignment rules
- **Protocol Conversion**: Driver translates abstract transactions to signal timing

Each component follows the **Single Responsibility Principle** while working together through well-defined interfaces.

The testbench architecture enables:

- **Reusability**: Components can be extended for new tests
- **Maintainability**: Clear separation of concerns
- **Scalability**: Easy to add monitors, scoreboard, etc.

# Command Execution Line
bash xsim_run.sh

## License

MIT License - See LICENSE for details.
