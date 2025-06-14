// ========================================================
// File: load_store_test.sv
// Description: Functional test for LW/SW verification
// ========================================================

class load_store_test extends uvm_test;
    `uvm_component_utils(load_store_test)
    
    mem_env env;
    
    function new(string name = "load_store_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = mem_env::type_id::create("env", this);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        load_store_sequence seq;
        
        phase.raise_objection(this);
        
        `uvm_info("TEST", "Starting Load/Store verification test", UVM_LOW)
        
        // Create and run sequence
        seq = load_store_sequence::type_id::create("seq");
        seq.start(env.agent.sequencer);
        
        // Add delay for completion
        #1000;
        
        `uvm_info("TEST", "Load/Store test completed", UVM_LOW)
        
        phase.drop_objection(this);
    endtask
    
endclass