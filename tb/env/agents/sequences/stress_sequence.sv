// tb/env/sequences/stress_sequence.sv
class stress_sequence extends base_sequence;
  `uvm_object_utils(stress_sequence)
  
  // Configuração de estresse
  rand int back_to_back_ops = 50;
  rand int mixed_ratio = 30; // % de operações de write
  
  constraint stress_params {
    back_to_back_ops inside {[50:1000]};
    mixed_ratio inside {[10:90]};
  }

  task body();
    super.body();
    mem_transaction tr;
    
    `uvm_info(get_type_name(), $sformatf("Starting stress test with %0d ops (Write ratio: %0d%%)", 
              back_to_back_ops, mixed_ratio), UVM_LOW)

    for (int i = 0; i < back_to_back_ops; i++) begin
      tr = mem_transaction::type_id::create("tr");
      
      // Aleatoriza tipo de operação baseado na ratio
      assert(tr.randomize() with {
        is_write dist {1 := mixed_ratio, 0 := 100 - mixed_ratio};
        addr == get_aligned_addr();
        if (is_write) {
          data inside {[32'h0000_0001:32'hFFFF_FFFE]};
        }
      });
      
      start_item(tr);
      finish_item(tr);
      
      // Intervalo aleatório entre operações
      #($urandom_range(0, 10));
    end
  endtask
endclass