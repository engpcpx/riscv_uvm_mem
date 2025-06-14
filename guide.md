# Guia de Configuração do XSIM - Resolução de Problemas

## Problema: Comandos não encontrados
```
xsim_run.sh: linha 8: xvlog: comando não encontrado
xsim_run.sh: linha 24: xelab: comando não encontrado
xsim_run.sh: linha 27: xsim: comando não encontrado
```

O erro indica que as ferramentas do Xilinx (xvlog, xelab, xsim) não estão no PATH do sistema. Você precisa configurar o ambiente do Vivado/XSIM primeiro.

## Soluções

### 1. Configurar o ambiente do Vivado (mais comum)

#### Localizar a instalação do Vivado:
```bash
# Procurar pelo arquivo de configuração
find /opt -name "settings64.sh" 2>/dev/null | grep vivado
# ou
find /tools -name "settings64.sh" 2>/dev/null | grep vivado
```

#### Executar o script de configuração:
```bash
# Substitua pelo caminho correto encontrado acima
source /opt/Xilinx/Vivado/2024.1/settings64.sh
# ou
source /tools/Xilinx/Vivado/2024.1/settings64.sh
```

#### Depois executar seu script:
```bash
bash xsim_run.sh
```

### 2. Se você tem apenas o XSIM instalado

#### Procurar por XSIM:
```bash
find /opt -name "*xsim*" 2>/dev/null
find /tools -name "*xsim*" 2>/dev/null
```

#### Configurar o ambiente do XSIM:
```bash
source /caminho/para/xsim/settings64.sh
```

### 3. Verificar se o Vivado está instalado

```bash
which vivado
ls /opt/Xilinx/
ls /tools/Xilinx/
```

### 4. Caminhos comuns de instalação

- `/opt/Xilinx/Vivado/2024.1/`
- `/tools/Xilinx/Vivado/2024.1/`
- `/usr/local/Xilinx/Vivado/2024.1/`

### 5. Configurar permanentemente

Para não precisar executar o `source` toda vez que abrir um novo terminal:

```bash
echo "source /caminho/para/vivado/settings64.sh" >> ~/.bashrc
source ~/.bashrc
```

### 6. Se não tiver o Vivado instalado

Você precisa instalar o Xilinx Vivado que inclui o XSIM, ou apenas o XSIM standalone se disponível.

## Teste após configurar

Execute os comandos abaixo para verificar se as ferramentas estão disponíveis:

```bash
which xvlog
which xelab  
which xsim
```

Se os comandos forem encontrados, seu script funcionará!

## Executando o script original

### Método 1: Tornar o arquivo executável
```bash
# Dar permissão de execução ao arquivo
chmod +x xsim_run.sh

# Executar o script
./xsim_run.sh
```

### Método 2: Executar diretamente com bash
```bash
bash xsim_run.sh
```

### Método 3: Executar com sh
```bash
sh xsim_run.sh
```

## Pré-requisitos importantes

1. **Xilinx Vivado/XSIM instalado** - O script usa ferramentas como `xvlog`, `xelab` e `xsim`
2. **Variáveis de ambiente configuradas** - Execute o script de setup do Vivado
3. **Estrutura de arquivos** - Certifique-se de que todos os arquivos referenciados existem:
   - `includes/riscv_pkg.sv`
   - `interfaces/mem_interface.sv`
   - `tb/env/mem_transaction.sv`
   - E todos os outros arquivos listados no script

## O que o script faz

- **Limpeza**: Remove arquivos de simulação anteriores
- **Análise**: Compila os arquivos SystemVerilog com UVM
- **Elaboração**: Prepara o testbench para simulação
- **Simulação**: Executa o teste `load_store_test`

## Verificando permissões de arquivo

### Ver permissões atuais:
```bash
ls -l xsim_run.sh
```

### Resultado antes do chmod:
```
-rw-rw-r-- 1 ar ar 1234 data hora xsim_run.sh
```

### Resultado após chmod +x:
```
-rwxrwxr-x 1 ar ar 1234 data hora xsim_run.sh
```

### Explicação das permissões:
- `r` = read (leitura)
- `w` = write (escrita)  
- `x` = execute (execução)

O comando `chmod +x` adiciona a permissão de execução para o proprietário, grupo e outros usuários.