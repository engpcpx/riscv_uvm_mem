// ========================================================
// File: path_definitions_pkg.sv
// Description: Corrected path definitions matching project structure
// ========================================================

`ifndef PATH_DEFINITIONS_PKG_SV
`define PATH_DEFINITIONS_PKG_SV

package path_definitions_pkg;

    // Base directory (confirm this is correct)
    localparam string PROJECT_ROOT = "/home/paulocezar/Documentos/UVM/riscv_uvm_mem/";

    // Interface paths (correct)
    localparam string MEM_INTERFACE_PATH = {PROJECT_ROOT, "interfaces/mem_interface.sv"};
    localparam string RISCV_WRAPPER_PATH = {PROJECT_ROOT, "interfaces/riscv_wrapper.sv"};

    // TB environment paths (adjusted to match top_tb.sv)
    localparam string MEM_AGENT_PATH = {PROJECT_ROOT, "tb/env/agents/mem_agent.sv"};
    localparam string MEM_DRIVER_PATH = {PROJECT_ROOT, "tb/env/agents/mem_driver.sv"};
    localparam string MEM_MONITOR_PATH = {PROJECT_ROOT, "tb/env/agents/mem_monitor.sv"};
    localparam string MEM_SEQUENCER_PATH = {PROJECT_ROOT, "tb/env/agents/mem_sequencer.sv"};
    
    // Corrected these to match where files actually are:
    localparam string MEM_SCOREBOARD_PATH = {PROJECT_ROOT, "tb/env/mem_scoreboard.sv"};
    localparam string MEM_ENV_PATH = {PROJECT_ROOT, "tb/env/mem_env.sv"};
    localparam string MEM_TRANSACTION_PATH = {PROJECT_ROOT, "tb/env/sequencer/mem_transaction.sv"};

    // Sequence paths (adjusted)
    localparam string BASE_SEQUENCE_PATH = {PROJECT_ROOT, "tb/env/sequences/base_sequence.sv"};
    localparam string LOAD_STORE_SEQUENCE_PATH = {PROJECT_ROOT, "tb/env/sequences/load_store_sequence.sv"};

    // Test paths (adjusted)
    localparam string LOAD_STORE_TEST_PATH = {PROJECT_ROOT, "tests/load_store_test.sv"};
    localparam string TOP_TB_PATH = {PROJECT_ROOT, "tb/top_tb.sv"};

endpackage

`endif // PATH_DEFINITIONS_PKG_SV