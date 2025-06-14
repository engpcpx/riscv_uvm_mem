
# XSIM Configuration Guide - Troubleshooting

## Problem: Commands not found
```
xsim_run.sh: line 8: xvlog: command not found
xsim_run.sh: line 24: xelab: command not found
xsim_run.sh: line 27: xsim: command not found
```

The error indicates that the Xilinx tools (xvlog, xelab, xsim) are not in the system PATH. You need to set up the Vivado/XSIM environment first.

## Solutions

### 1. Set up the Vivado environment (most common)

#### Locate the Vivado installation:
```bash
# Search for the setup file
find /opt -name "settings64.sh" 2>/dev/null | grep vivado
# or
find /tools -name "settings64.sh" 2>/dev/null | grep vivado
```

#### Run the setup script:
```bash
# Replace with the correct path found above
source /opt/Xilinx/Vivado/2024.1/settings64.sh
# or
source /tools/Xilinx/Vivado/2024.1/settings64.sh
```

#### Then run your script:
```bash
bash xsim_run.sh
```

### 2. If you have XSIM only installed

#### Search for XSIM:
```bash
find /opt -name "*xsim*" 2>/dev/null
find /tools -name "*xsim*" 2>/dev/null
```

#### Set up the XSIM environment:
```bash
source /path/to/xsim/settings64.sh
```

### 3. Check if Vivado is installed

```bash
which vivado
ls /opt/Xilinx/
ls /tools/Xilinx/
```

### 4. Common installation paths

- `/opt/Xilinx/Vivado/2024.1/`
- `/tools/Xilinx/Vivado/2024.1/`
- `/usr/local/Xilinx/Vivado/2024.1/`

### 5. Set up permanently

So you don’t need to run `source` every time you open a new terminal:

```bash
echo "source /path/to/vivado/settings64.sh" >> ~/.bashrc
source ~/.bashrc
```

### 6. If Vivado is not installed

You need to install Xilinx Vivado (which includes XSIM) or XSIM standalone if available.

## Test after setup

Run the commands below to check if the tools are available:

```bash
which xvlog
which xelab  
which xsim
```

If the commands are found, your script will work!

## Running the original script

### Method 1: Make the file executable
```bash
# Grant execute permission to the file
chmod +x xsim_run.sh

# Run the script
./xsim_run.sh
```

### Method 2: Run directly with bash
```bash
bash xsim_run.sh
```

### Method 3: Run with sh
```bash
sh xsim_run.sh
```

## Important prerequisites

1. **Xilinx Vivado/XSIM installed** - The script uses tools like `xvlog`, `xelab`, and `xsim`
2. **Environment variables set up** - Run Vivado setup script
3. **File structure** - Make sure all referenced files exist:
   - `includes/riscv_pkg.sv`
   - `interfaces/mem_interface.sv`
   - `tb/env/mem_transaction.sv`
   - And all other files listed in the script

## What the script does

- **Cleanup**: Removes previous simulation files
- **Analysis**: Compiles SystemVerilog files with UVM
- **Elaboration**: Prepares testbench for simulation
- **Simulation**: Runs `load_store_test`

## Checking file permissions

### View current permissions:
```bash
ls -l xsim_run.sh
```

### Result before chmod:
```
-rw-rw-r-- 1 ar ar 1234 date time xsim_run.sh
```

### Result after chmod +x:
```
-rwxrwxr-x 1 ar ar 1234 date time xsim_run.sh
```

### Permissions explanation:
- `r` = read
- `w` = write  
- `x` = execute

The `chmod +x` command adds execute permission for owner, group, and other users.