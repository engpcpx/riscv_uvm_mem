// ========================================================
// File: mem_monitor.sv
// Description: UVM Monitor for RISC-V memory subsystem
//              Captures load operations from DUT interface
// ========================================================

class mem_monitor extends uvm_monitor;
  // UVM macro for factory registration and utilities
  `uvm_component_utils(mem_monitor)
  
  // Virtual interface to observe DUT signals
  virtual mem_interface vif;
  
  // Analysis port to broadcast captured transactions
  uvm_analysis_port #(mem_transaction) ap;

  // ------------------------------------------------------
  // Constructor: new()
  // Arguments:
  //   name   - Component name for UVM hierarchy
  //   parent - Parent component in UVM tree
  // ------------------------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Initialize analysis port with instance name
    ap = new("ap", this);
  endfunction

  // ------------------------------------------------------
  // Task: run_phase()
  // Description:
  //   Main monitoring process triggered by UVM phasing
  //   Continuously watches for read operations on interface
  // ------------------------------------------------------
  task run_phase(uvm_phase phase);
    forever begin
      // Synchronize to clock rising edge
      @(posedge vif.clk);
      
      // Trigger capture when read operation detected
      if (vif.mem_read) begin
        capture_load();
      end
    end
  endtask

  // ------------------------------------------------------
  // Task: capture_load()
  // Description:
  //   Captures load operation details:
  //   - Address being read
  //   - Data returned by memory
  //   Packages into transaction and broadcasts via analysis port
  // ------------------------------------------------------
  task capture_load();
    // Create new transaction object
    mem_transaction tr = new("tr");
    
    // Capture address and data from interface
    tr.addr = vif.addr;          // Memory address being read
    tr.data = vif.data_out;      // Data returned by memory
    
    // Mark transaction as read operation
    tr.is_write = 0;
    
    // Write transaction to analysis port
    // (Connected to scoreboard/coverage subscribers)
    ap.write(tr);
    
    // Debug message (commented for production)
    // `uvm_info("MON", $sformatf("Captured LOAD @0x%h=0x%h", 
    //          tr.addr, tr.data), UVM_HIGH)
  endtask
endclass