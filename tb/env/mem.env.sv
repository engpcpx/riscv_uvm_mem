// tb/env/mem_env.sv
// UVM Environment for memory verification

class mem_env extends uvm_env;
  `uvm_component_utils(mem_env)
  
  mem_agent agent;          // Agent instance
  mem_scoreboard scoreboard; // Scoreboard instance
  
  // Constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
  
  // Build phase - create components
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    // Create agent
    agent = mem_agent::type_id::create("agent", this);
    
    // Create scoreboard
    scoreboard = mem_scoreboard::type_id::create("scoreboard", this);
  endfunction
  
  // Connect phase - connect components
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // Connect monitor to scoreboard
    agent.monitor.ap.connect(scoreboard.item_collected_export);
  endfunction
  
  // End of elaboration phase (optional)
  function void end_of_elaboration_phase(uvm_phase phase);
    `uvm_info("ENV", "Memory environment setup complete", UVM_MEDIUM)
  endfunction
endclass