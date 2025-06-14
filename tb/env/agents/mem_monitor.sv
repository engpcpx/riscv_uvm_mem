// ========================================================
// File: mem_driver.sv
// Description: Corrected UVM driver for memory operations
// ========================================================

class mem_driver extends uvm_driver #(mem_transaction);
    `uvm_component_utils(mem_driver)
    
    virtual mem_interface vif;
    
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual mem_interface)::get(this, "", "mem_if", vif))
            `uvm_fatal("DRIVER", "Virtual interface not found")
    endfunction
    
    task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(req);
            
            // Drive the transaction
            if (req.is_write) begin
                drive_store();
            end else begin
                drive_load();
            end
            
            seq_item_port.item_done();
        end
    endtask
    
    task drive_store();
        // Wait for clock edge
        @(posedge vif.clk);
        
        // Setup store signals
        vif.mem_write <= 1'b1;
        vif.mem_read  <= 1'b0;
        vif.addr      <= req.addr;
        vif.data_in   <= req.data;
        
        // Hold for one cycle
        @(posedge vif.clk);
        
        // Deassert signals
        vif.mem_write <= 1'b0;
        
        `uvm_info("DRIVER", $sformatf("Store: addr=0x%h, data=0x%h", 
                  req.addr, req.data), UVM_HIGH)
    endtask
    
    task drive_load();
        // Wait for clock edge
        @(posedge vif.clk);
        
        // Setup load signals
        vif.mem_read  <= 1'b1;
        vif.mem_write <= 1'b0;
        vif.addr      <= req.addr;
        
        // Hold for one cycle
        @(posedge vif.clk);
        
        // Capture returned data
        req.data = vif.data_out;
        
        // Deassert signals
        vif.mem_read <= 1'b0;
        
        `uvm_info("DRIVER", $sformatf("Load: addr=0x%h, data=0x%h", 
                  req.addr, req.data), UVM_HIGH)
    endtask
    
endclass