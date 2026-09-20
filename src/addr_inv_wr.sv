class addr_inv_wr extends uvm_sequence#(seq_item);
  `uvm_object_utils(addr_inv_wr)

  function new(string name="addr_inv_wr");
    super.new(name);
  endfunction

  task body();
    seq_item tr;
    tr=seq_item::type_id::create("tr");
    start_item(tr);
    `uvm_info("DEBUG", "START ADDR VIOLATION WRITE", UVM_LOW)
    if(!tr.randomize() with {write_req==1;read_req==0;WSTRB==15;delay_addr==1;delay_data==0;AWADDR inside {[32'h40:32'hFFFFFFFF]};})
      `uvm_error("SEQ","Randomization failed");
    finish_item(tr);
    `uvm_info("DEBUG", "COMPLETED ADDR VIOLATION WRITE", UVM_LOW)
  endtask
endclass
