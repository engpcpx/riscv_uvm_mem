// tb/env/mem_transaction.sv
`ifndef MEM_TRANSACTION_SV
`define MEM_TRANSACTION_SV

import uvm_pkg::*;
`include "uvm_macros.svh"

class mem_transaction extends uvm_sequence_item;
    rand bit [31:0] addr;
    rand bit [31:0] data;
    rand bit is_write;
    
    // Constraints para transações válidas
    constraint aligned_addr {
        addr % 4 == 0;   // 32-bit aligned
        addr < 1024;     // Within memory range
    }
    
    `uvm_object_utils_begin(mem_transaction)
        `uvm_field_int(addr, UVM_ALL_ON)
        `uvm_field_int(data, UVM_ALL_ON)
        `uvm_field_int(is_write, UVM_ALL_ON)
    `uvm_object_utils_end
    
    // Constructor
    function new(string name = "mem_transaction");
        super.new(name);
    endfunction
    
    // Método para formatação de string
    function string convert2string();
        return $sformatf("addr=0x%h data=0x%h is_write=%0d", addr, data, is_write);
    endfunction
    
    // Adicione quaisquer métodos adicionais necessários aqui
endclass

`endif // MEM_TRANSACTION_SV