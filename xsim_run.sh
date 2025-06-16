#!/bin/bash

echo "=== RISC-V UVM Testbench Simulation with XSIM ==="
echo "=== Vivado 2024.1 - UVM 1.2 ==="

# --------------------------------------------------
# Environment Setup
# --------------------------------------------------
echo "--------------------------------------------------"
echo "Environment Setup"
echo "--------------------------------------------------"
source /opt/xilinx/Vivado/2024.1/settings64.sh
vivado_version=$(vivado -version | head -n 1)
echo "Using Vivado version: $vivado_version"

# --------------------------------------------------
# Directory Setup
# --------------------------------------------------
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit 1

# --------------------------------------------------
# File List
# --------------------------------------------------
declare -a RTL_FILES=(
    "./rtl/RISCV.sv"
    "./rtl/instruction_fetch.sv"
    "./rtl/instruction_decode.sv"
    "./rtl/execution.sv"
    "./rtl/memory_access.sv"
    "./rtl/branch_unit.sv"
    "./rtl/mux2to1.sv"
    "./rtl/register_file.sv"
    "./rtl/sign_extend.sv"
    "./rtl/hazard_control.sv"
    "./rtl/alu.sv"
    "./rtl/branch_unit.sv"
    "./rtl/write_back.sv"
    "./rtl/controller.sv"
)

declare -a TB_FILES=(
    "./tb/top_tb.sv"
    "./tb/env/sequences/mem_transaction.sv"
    "./tb/env/agents/mem_driver.sv"
    "./tb/env/agents/mem_monitor.sv"
    "./tb/env/agents/mem_sequencer.sv"
    "./tb/env/agents/mem_agent.sv"
    "./tb/env/mem_scoreboard.sv"
    "./tb/env/mem.env.sv"  
)

declare -a INTERFACES_FILES=(
    "./interfaces/mem_interface.sv"
    "./interfaces/riscv_wrapper.sv"
)

declare -a TESTS_FILES=(
    "./tests/load_store_test.sv"
)

declare -a INCLUDES_FILES=(
    "./includes/riscv_pkg.sv"
    "./includes/riscv_definitions.sv"
)

# --------------------------------------------------
# File Verification
# --------------------------------------------------
echo ""e
cho "--------------------------------------------------"
echo "File Verification"
echo "--------------------------------------------------"
echo "Checking Structure Files.."
MISSING_FILES=0
for file in "${RTL_FILES[@]}" "${TB_FILES[@]}" "${INTERFACES_FILES[@]}" "${TESTS_FILES[@]}" "${INCLUDES_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "✗ Missing: $file"
        MISSING_FILES=$((MISSING_FILES + 1))
    else
        echo "✓ Found: $file"
    fi
done

[ $MISSING_FILES -gt 0 ] && { echo "Error: $MISSING_FILES files missing!"; exit 1; }

# --------------------------------------------------
# Clean Previous Runs
# --------------------------------------------------
echo ""
echo "--------------------------------------------------"
echo "Clean Previous Runs"
echo "--------------------------------------------------"
echo "Cleaning previous simulation..."
rm -rf xsim.dir .Xil *.log *.jou *.pb *.wdb *.str *.vcd
find . -name "*.bak" -delete
echo "✓ Clean complete"

# --------------------------------------------------
# Compilation
# --------------------------------------------------
echo ""
echo "--------------------------------------------------"
echo "Compilation"
echo "--------------------------------------------------"
echo "Compiling files..."


# First compile the package separately
echo "Compiling riscv_definitions package..."
xvlog -sv "./includes/riscv_definitions.sv" || { echo "Failed to compile riscv_definitions.sv"; exit 1; }

# Then compile remaining files
compile_files() {
    local file_type=$1
    shift
    local files=("$@")
    
    echo "Compiling $file_type files..."
    for file in "${files[@]}"; do
        echo ""
        echo "  Processing: $file"
        xvlog -sv -L uvm "$file" || { echo "Failed to compile $file"; exit 1; }
        echo "  ✓ Successfully processed: $file"
    done
}

# 1. Compile packages and definitions first (base dependencies)
xvlog -sv "./includes/riscv_definitions.sv" || { echo "Failed to compile riscv_definitions.sv"; exit 1; }
xvlog -sv "./includes/riscv_pkg.sv" || { echo "Failed to compile riscv_pkg.sv"; exit 1; }

# 2. Interfaces (contains shared communication structures)
compile_files "INTERFACES" "${INTERFACES_FILES[@]}"

# 3. RTL (depends on definitions and interfaces)
compile_files "RTL" "${RTL_FILES[@]}"

# 4. Testbench components (depends on RTL implementation)
compile_files "TESTBENCH" "${TB_FILES[@]}"

# 5. Tests (depends on all above components)
compile_files "TESTS" "${TESTS_FILES[@]}"


# --------------------------------------------------
# Elaboration
# --------------------------------------------------
echo ""
echo "--------------------------------------------------"
echo "Elaboration"
echo "--------------------------------------------------"
echo "Elaborating design..."
xelab -debug typical -L uvm top_tb -timescale 1ns/1ps || { echo "Elaboration failed!"; exit 1; }
echo "✓ Elaboration completed successfully"

# --------------------------------------------------
# Simulation
# --------------------------------------------------
echo ""
echo "--------------------------------------------------"
echo "Simulation"
echo "--------------------------------------------------"
SIM_MODE=${1:-"-batch"}
WAVE_DB="riscv_sim_waves.wdb"

case "$SIM_MODE" in
    "--gui")
        echo "Starting GUI simulation..."
        xsim top_tb -gui -wdb $WAVE_DB &
        ;;
    *)
        echo "Starting batch simulation..."
        xsim top_tb -runall -wdb $WAVE_DB
        ;;
esac

[ $? -ne 0 ] && { echo "Simulation failed!"; exit 1; }

# --------------------------------------------------
# Completion
# --------------------------------------------------
echo ""
echo "--------------------------------------------------"
echo "Completion"
echo "--------------------------------------------------"
echo "✓ Simulation completed successfully"
echo "Waveform database: $WAVE_DB"
exit 0