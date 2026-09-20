class ro_inv extends uvm_sequence#(seq_item);
  `uvm_object_utils(ro_inv)

  function new(string name="ro_inv");
    super.new(name);
  endfunction

  task body();
    seq_item tr;
    tr=seq_item::type_id::create("tr");
    `uvm_info("DEBUG", "START RO VIOLATION", UVM_LOW)
    start_item(tr);
    if(!tr.randomize() with {write_req==1;read_req==0;WSTRB==15;delay_data==0;delay_addr==1;AWADDR inside {32'h28,32'h2C,32'h30};})
      `uvm_error("SEQ","Randomization failed");
    finish_item(tr);
    `uvm_info("DEBUG", "COMPLETED RO VIOLATION", UVM_LOW)
  endtask

endclass
