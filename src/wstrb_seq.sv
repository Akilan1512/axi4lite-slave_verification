class wstrb_seq extends uvm_sequence#(seq_item);
  `uvm_object_utils(wstrb_seq)

  function new(string name="wstrb_seq");
    super.new(name);
  endfunction
  bit [3:0] strb[$]='{1,2,4,8,15};
  task body();
    seq_item tr;
   // strb[$]=`{1,2,4,8,15};
    `uvm_info("DEBUG", "START WRITE STRB", UVM_LOW)
    foreach(strb[i]) begin
      tr=seq_item::type_id::create("tr");
      start_item(tr);
      if(!tr.randomize() with {write_req==1;read_req==0;delay_addr==1;delay_data==0; AWADDR==i*4; WSTRB==strb[i];})
        `uvm_error("SEQ","Randomization failed");
      finish_item(tr);
    end
    `uvm_info("DEBUG", "COMPLETED WRITE STRB ", UVM_LOW)
  endtask

endclass
