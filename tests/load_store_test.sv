// tests/load_store_test.sv
class load_store_test extends uvm_test;
  `uvm_component_utils(load_store_test)
  
  mem_env env;  // Ambiente UVM
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = mem_env::type_id::create("env", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    load_store_sequence lw_sw_seq;
    stress_sequence stress_seq;
    
    phase.raise_objection(this);
    
    // 1. Executa sequência básica LW/SW
    `uvm_info("TEST", "Starting basic load/store sequence", UVM_MEDIUM)
    lw_sw_seq = load_store_sequence::type_id::create("lw_sw_seq");
    lw_sw_seq.start(env.agent.sequencer);
    
    // 2. Executa sequência de estresse (opcional)
    `uvm_info("TEST", "Starting stress sequence", UVM_MEDIUM)
    stress_seq = stress_sequence::type_id::create("stress_seq");
    assert(stress_seq.randomize() with {
      back_to_back_ops == 200;
      mixed_ratio == 40;
    });
    stress_seq.start(env.agent.sequencer);
    
    phase.drop_objection(this);
  endtask
  
  function void report_phase(uvm_phase phase);
    // Análise final dos resultados
    if (env.scoreboard.error_count == 0) begin
      `uvm_info("TEST", "*** TEST PASSED ***", UVM_NONE)
    end else begin
      `uvm_error("TEST", $sformatf("*** TEST FAILED - %0d errors ***", 
                env.scoreboard.error_count))
    end
  endfunction
endclass