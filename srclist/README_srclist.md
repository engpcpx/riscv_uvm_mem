# Source List Files Documentation

## Overview
The `.lst` files in this project define the compilation order for the RTL and UVM components. These files are critical for proper simulation setup and ensure that dependencies are resolved correctly during compilation.

## Purpose and Importance
1. **Compilation Order Control**: 
   - Ensures that base classes are compiled before derived classes
   - Guarantees interface definitions are available before components using them
   - Maintains proper dependency resolution for both RTL and UVM components

2. **Project Organization**:
   - Provides a single source of truth for all project source files
   - Enables easy integration with different simulation tools (XSIM, VCS, etc.)
   - Facilitates team collaboration by documenting the code structure

3. **Verification Quality**:
   - Proper ordering prevents subtle initialization bugs
   - Ensures consistent compilation across different environments
   - Supports regression testing by maintaining stable build procedures

## File Descriptions

### rtl_sources.lst
Defines the compilation order for the RTL (Register Transfer Level) implementation of the 5-stage RISC-V pipeline. The order follows the data flow through the pipeline stages:
1. Instruction Fetch
2. Instruction Decode
3. Execution
4. Memory Access
5. Write Back (hazard control)

### uvm_sources.lst
Defines the compilation order for the UVM (Universal Verification Methodology) testbench components. The order follows the UVM component hierarchy:
1. Interfaces and transactions
2. Sequences
3. Agents (sequencer, driver, monitor)
4. Environment and scoreboard
5. Test cases
6. Top-level testbench

## Usage Guidelines
1. Always maintain the specified order when adding new files
2. Update both files when adding or removing source files
3. Verify paths are correct relative to the project root
4. Use these files with your simulator's filelist option (e.g., `-f rtl_sources.lst`)

## Best Practices
- Keep these files under version control
- Document any non-obvious ordering requirements
- Review compilation order when adding major new features
- Validate with a clean rebuild after modifications