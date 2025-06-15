RISC-V UVM Project - Solution Guide
Problem Summary

Your simulation script is failing because:

    Vivado not found: The path /opt/Xilinx/Vivado/2024.1/settings64.sh doesn't exist
    Tools unavailable: xvlog, xelab, and xsim commands are not in your PATH
    Environment not configured: Vivado environment variables are not set

Solution Steps
Step 1: Find Your Vivado Installation

First, let's locate where Vivado is actually installed on your system:

bash

# Search for Vivado installations
find /opt /usr/local /home -name "settings64.sh" -path "*/Vivado/*" 2>/dev/null

# Alternative: search for Vivado directories
find /opt /usr/local /home -type d -name "Vivado" 2>/dev/null

# Check common locations
ls -la /opt/xilinx/ 2>/dev/null
ls -la /opt/Xilinx/ 2>/dev/null
ls -la ~/Xilinx/ 2>/dev/null

Step 2: Setup Vivado Environment

Once you find the correct path, source the settings file:

bash

# Replace with your actual path
source /path/to/your/vivado/settings64.sh

# Verify the setup
which xvlog
xvlog --version

Step 3: Use the Improved Scripts

I've created improved scripts that will:

    Automatically detect your Vivado installation
    Handle missing files gracefully
    Provide better error messages

Option A: Use the Diagnostics Script

bash

# Make the script executable
chmod +x project_diagnostics.sh

# Run diagnostics
./project_diagnostics.sh

Option B: Use the Improved Simulation Script

bash

# Make the script executable
chmod +x improved_xsim_run.sh

# Run simulation
./improved_xsim_run.sh

Step 4: Manual Vivado Setup (if auto-detection fails)

If the scripts can't find Vivado automatically:

    Locate Vivado manually:

    bash

    sudo find / -name "settings64.sh" -path "*/Vivado/*" 2>/dev/null

    Create a permanent setup:

    bash

    # Add to your ~/.bashrc
    echo "source /path/to/vivado/settings64.sh" >> ~/.bashrc

    # Reload your shell
    source ~/.bashrc

    Test the setup:

    bash

    xvlog --version

Common Vivado Installation Paths

Check these locations for your Vivado installation:

    /opt/Xilinx/Vivado/2024.1/settings64.sh
    /opt/xilinx/Vivado/2024.1/settings64.sh
    /tools/Xilinx/Vivado/2024.1/settings64.sh
    /usr/local/xilinx/Vivado/2024.1/settings64.sh
    ~/Xilinx/Vivado/2024.1/settings64.sh
    /home/xilinx/Vivado/2024.1/settings64.sh

Replace 2024.1 with your actual Vivado version (could be 2023.2, 2023.1, etc.)
Project Structure Check

Ensure your project has this structure:

riscv_uvm_mem/
├── includes/
│   ├── riscv_pkg.sv
│   └── riscv_definitions.sv (optional)
├── interfaces/
│   └── mem_interface.sv
├── rtl/
│   ├── RISCV.sv
│   ├── instruction_fetch.sv
│   ├── instruction_decode.sv
│   ├── execution.sv
│   ├── memory_access.sv
│   └── hazard_control.sv
├── tb/
│   ├── top_tb.sv
│   ├── env/
│   └── tests/
└── scripts/
    ├── xsim_run.sh
    └── compile_debug.sh

Troubleshooting Tips
If Vivado is not installed:

    Download from: https://www.xilinx.com/support/download.html
    Install following AMD/Xilinx instructions
    Make sure to install the full Vivado suite, not just Vitis

If you get permission errors:

bash

# Check file permissions
ls -la /opt/Xilinx/Vivado/
ls -la /opt/xilinx/Vivado/

# You might need to be added to the xilinx group
sudo usermod -a -G xilinx $USER

If compilation fails:

    Check SystemVerilog syntax in your files
    Verify module names match file names
    Ensure proper dependency order in compilation
    Check for missing include statements

Quick Commands Reference

bash

# Check if Vivado is working
which xvlog && echo "Vivado OK" || echo "Vivado not found"

# Clean compilation files
rm -rf xsim.dir work *.log *.jou *.str *.wdb

# Basic compilation test
xvlog --sv --work work ./includes/riscv_pkg.sv

# Run simulation in GUI mode
xsim work.tb_snapshot -gui

# Run simulation in batch mode
xsim work.tb_snapshot -runall

## Next Steps

    Run the diagnostics script to identify specific issues
    Use the improved simulation script for better error handling
    Check the project structure to ensure all files are present
    Set up permanent Vivado environment in your ~/.bashrc

If you continue to have issues, please share:

    The output of the diagnostics script
    Your actual Vivado installation path
    Any specific error messages you encounter


# 1. riscv_pkg.sv

    Propósito:
    Este é um arquivo SystemVerilog que define um pacote (package) contendo estruturas, parâmetros e funções utilitárias para um núcleo RISC-V. Ele serve como uma biblioteca centralizada para compartilhar definições comuns em todo o projeto.

    Conteúdo principal:

        Parâmetros globais:

            XLEN: Tamanho da arquitetura (32 bits).

            REG_COUNT: Número de registradores (32).

        Estruturas de dados:

            mem_transaction_t: Define transações de memória (load/store) com campos como endereço, dados e tamanho.

            Tipos de instruções RISC-V (i_type_instr_t, s_type_instr_t, lw_instr_t, sw_instr_t).

        Códigos de operação:

            Opcodes (e.g., LOAD_OPCODE, STORE_OPCODE) e funct3 (e.g., LW_FUNCT3).

        Funções utilitárias:

            is_mem_aligned: Verifica se um endereço está alinhado.

            gen_lw_instr/gen_sw_instr: Geram instruções de load/store pré-formatadas.

    Uso:
    Esse pacote é incluído em outros módulos SystemVerilog (como TB, RTL, ou agentes UVM) para garantir consistência nas definições de instruções, transações de memória e parâmetros.

# 2. xsim_run.sh

    Propósito:
    É um script Bash que automatiza a simulação do projeto RISC-V usando o simulador XSIM (parte do Vivado). Ele realiza:

        Configuração do ambiente Vivado.

        Verificação da estrutura de arquivos do projeto.

        Compilação dos arquivos SystemVerilog.

        Execução da simulação e limpeza de artefatos anteriores.

    Etapas principais:

        Configuração do Vivado:

            Carrega o ambiente do Vivado 2024.1.

        Verificação de arquivos:

            Checa se todos os arquivos necessários estão presentes (e.g., RTL, TB, agentes UVM).

            Lista inclui interfaces, pacotes, módulos RISC-V, testes UVM e componentes do ambiente de verificação.

        Compilação e simulação:

            Usa xvlog para compilar arquivos SystemVerilog.

            Usa xelab para elaborar o TB (top_tb).

            Executa a simulação com xsim.

    Uso:

        Garante que o projeto esteja completo antes da simulação.

        Automatiza o fluxo de simulação, evitando erros manuais.

        Típico para projetos de verificação UVM com RISC-V.

## Relação entre os scripts

    O riscv_pkg.sv fornece as definições usadas pelos arquivos listados no xsim_run.sh (e.g., transações de memória para o mem_agent.sv, opcodes para o instruction_decode.sv).

    O xsim_run.sh depende do riscv_pkg.sv (listado em FILES_TO_CHECK) para compilar corretamente o projeto.

##Em resumo:

    riscv_pkg.sv: Biblioteca de definições RISC-V.

    xsim_run.sh: Script de automação para simulação UVM/XSIM.

