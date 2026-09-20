class addr_un_wr extends uvm_sequence#(seq_item);
  `uvm_object_utils(addr_un_wr)

  function new(string name="addr_un_wr");
    super.new(name);
  endfunction

  task body();
    seq_item tr;
    tr=seq_item::type_id::create("tr");
    start_item(tr);
    `uvm_info("DEBUG", "START ADDR UNALIGN WRITE", UVM_LOW)
    if(!tr.randomize() with {write_req==1;read_req==0;WSTRB==15;delay_addr==0;delay_data==1;AWADDR inside {[32'h0:32'h24]}; AWADDR[1:0]!=2'b00;})
      `uvm_error("SEQ","Randomization failed");
    finish_item(tr);
    `uvm_info("DEBUG", "COMPLETED ADDR UNALIGN WRITE", UVM_LOW)
  endtask
endclass
