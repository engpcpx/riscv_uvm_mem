// mem_driver.sv
// UVM driver class that converts transactions to signal-level activity

class mem_driver extends uvm_driver #(mem_transaction);
  `uvm_component_utils(mem_driver)  // UVM factory registration
  virtual mem_interface vif;        // Virtual interface to DUT

  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Main run task - executes forever during simulation
  task run_phase(uvm_phase phase);
    forever begin
      // Get next transaction from sequencer
      seq_item_port.get_next_item(req);
      
      // Execute appropriate drive method based on transaction type
      if (req.is_write) drive_store();
      else drive_load();
      
      // Notify sequencer that item is complete
      seq_item_port.item_done();
    end
  endtask

  // Handles Store operations (memory writes)
  task drive_store();
    @(posedge vif.clk);
    vif.mem_write <= 1;            // Assert write enable
    vif.addr <= req.addr;          // Drive address bus
    vif.data_in <= req.data;       // Drive data bus
    `uvm_info("DRIVER", $sformatf("Store: addr=0x%h data=0x%h", 
             req.addr, req.data), UVM_LOW)
    @(posedge vif.clk);
    vif.mem_write <= 0;            // Deassert write enable
  endtask

  // Handles Load operations (memory reads)
  task drive_load();
    @(posedge vif.clk);
    vif.mem_read <= 1;             // Assert read enable
    vif.addr <= req.addr;          // Drive address bus
    `uvm_info("DRIVER", $sformatf("Load: addr=0x%h", req.addr), UVM_LOW)
    @(posedge vif.clk);
    vif.mem_read <= 0;             // Deassert read enable
  endtask
endclass