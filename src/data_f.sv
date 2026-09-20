class data_f extends uvm_sequence#(seq_item);
  `uvm_object_utils(data_f)

  function new(string name="data_f");
    super.new(name);
  endfunction

  task body();
    seq_item tr;
    for(int i=5;i<10;i++) begin
    	tr=seq_item::type_id::create("tr");
    	start_item(tr);
      if(!tr.randomize() with {write_req==1;read_req==0;delay_addr inside {[1:3]};delay_data==0;AWADDR==i*4;WSTRB==15;})
      		`uvm_error("SEQ","Randomization failed");
    	finish_item(tr);
    end
  endtask

endclass
