// tb/env/mem_scoreboard.sv
`ifndef MEM_SCOREBOARD_SV
`define MEM_SCOREBOARD_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

`include "tb/env/sequences/mem_transaction.sv"

class mem_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(mem_scoreboard)
    
    uvm_analysis_export #(mem_transaction) item_collected_export;
    uvm_tlm_analysis_fifo #(mem_transaction) item_fifo;
    
    bit [31:0] memory[bit [31:0]];
    
    int unsigned num_writes = 0;
    int unsigned num_reads = 0;
    int unsigned num_errors = 0;
    
    // Coverage group modificado para usar variável local
    covergroup mem_cg;
        option.per_instance = 1;
        
        addr_range: coverpoint tr.addr {
            bins low    = {[32'h0000_0100:32'h0000_03FF]};
            bins mid    = {[32'h0000_0400:32'h0000_07FF]};
            bins high   = {[32'h0000_0800:32'h0000_0FFF]};
        }
        
        data_patt: coverpoint tr.data {
            bins zeros      = {32'h0000_0000};
            bins ones       = {32'hFFFF_FFFF};
            bins alternating= {32'hAAAA_AAAA, 32'h5555_5555};
            bins random     = default;
        }
        
        op_type: coverpoint tr.is_write {
            bins write = {1};
            bins read  = {0};
        }
    endgroup
    
    // Variável local para uso no coverage
    mem_transaction tr;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
        mem_cg = new();
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        item_collected_export = new("item_collected_export", this);
        item_fifo = new("item_fifo", this);
    endfunction
    
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        item_collected_export.connect(item_fifo.analysis_export);
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            item_fifo.get(tr);  // Atribui à variável tr
            
            // Sample coverage after getting the transaction
            mem_cg.sample();
            
            if(tr.is_write) begin
                memory[tr.addr] = tr.data;
                num_writes++;
                `uvm_info("SCOREBOARD", 
                    $sformatf("Store verified @0x%h = 0x%h (Total writes: %0d)", 
                    tr.addr, tr.data, num_writes), UVM_MEDIUM)
            end
            else begin
                num_reads++;
                if(memory.exists(tr.addr)) begin
                    if(tr.data !== memory[tr.addr]) begin
                        num_errors++;
                        `uvm_error("SCOREBOARD", 
                            $sformatf("LOAD MISMATCH @0x%h: Expected=0x%h Actual=0x%h (Error #%0d)", 
                            tr.addr, memory[tr.addr], tr.data, num_errors))
                    end
                    else begin
                        `uvm_info("SCOREBOARD", 
                            $sformatf("Load match @0x%h = 0x%h (Total reads: %0d)", 
                            tr.addr, tr.data, num_reads), UVM_HIGH)
                    end
                end
                else begin
                    num_errors++;
                    `uvm_error("SCOREBOARD", 
                        $sformatf("Load from uninitialized addr 0x%h (Error #%0d)", 
                        tr.addr, num_errors))
                end
            end
        end
    endtask
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("SCOREBOARD SUMMARY",
            $sformatf("\nTransactions Processed: %0d\nWrites: %0d\nReads: %0d\nErrors: %0d",
            num_writes + num_reads, num_writes, num_reads, num_errors), UVM_MEDIUM)
        
        if(num_errors == 0) begin
            `uvm_info("SCOREBOARD", "*** TEST PASSED - No mismatches detected ***", UVM_NONE)
        end
        else begin
            `uvm_error("SCOREBOARD", $sformatf("*** TEST FAILED - %0d mismatches detected ***", num_errors))
        end
    endfunction
endclass

`endif // MEM_SCOREBOARD_SV