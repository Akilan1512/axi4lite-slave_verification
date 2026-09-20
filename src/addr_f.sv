class addr_f extends uvm_sequence#(seq_item);
  `uvm_object_utils(addr_f)

  function new(string name="addr_f");
    super.new(name);
  endfunction

  task body();
    seq_item tr;
    for(int i=0;i<5;i++) begin
    	tr=seq_item::type_id::create("tr");
    	start_item(tr);
      if(!tr.randomize() with {write_req==1;read_req==0;delay_addr==0;delay_data inside {[1:3]};AWADDR==i*4;WSTRB==15;})
      		`uvm_error("SEQ","Randomization failed");
    	finish_item(tr);
    end
  endtask

endclass
