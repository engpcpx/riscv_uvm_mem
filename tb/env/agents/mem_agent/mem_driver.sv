// Converts transactions to signal-level activity
class mem_driver extends uvm_driver #(mem_transaction);
  `uvm_component_utils(mem_driver)
  virtual mem_interface vif;

  task run_phase(uvm_phase phase);
    forever begin
      seq_item_port.get_next_item(req);
      if (req.is_write) drive_store();
      else drive_load();
      seq_item_port.item_done();
    end
  endtask

  task drive_store();
    @(posedge vif.clk);
    vif.mem_write <= 1;
    vif.addr <= req.addr;
    vif.data_in <= req.data;
    @(posedge vif.clk);
    vif.mem_write <= 0;
  endtask

  task drive_load();
    @(posedge vif.clk);
    vif.mem_read <= 1;
    vif.addr <= req.addr;
    @(posedge vif.clk);
    vif.mem_read <= 0;
  endtask
endclass