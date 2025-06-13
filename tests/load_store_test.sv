// load_store_test.sv 
class load_store_test extends uvm_test;
  `uvm_component_utils(load_store_test)
  
  mem_agent agent;
  mem_env env;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = mem_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    load_store_sequence seq;
    
    phase.raise_objection(this);
    
    seq = load_store_sequence::type_id::create("seq");
    seq.start(env.agent.sequencer);
    
    phase.drop_objection(this);
  endtask
endclass