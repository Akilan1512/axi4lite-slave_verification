class wo_inv extends uvm_sequence#(seq_item);
  `uvm_object_utils(wo_inv)

  function new(string name="wo_inv");
    super.new(name);
  endfunction

  task body();
    seq_item tr;
    tr=seq_item::type_id::create("tr");
    `uvm_info("DEBUG", "START WO VIOLATION", UVM_LOW)
    start_item(tr);
    if(!tr.randomize() with {write_req==0;read_req==1;ARADDR inside {32'h34, 32'h38};})
      `uvm_error("SEQ","Randomization failed");
    finish_item(tr);
    `uvm_info("DEBUG", "COMPLETED WO VIOLATION", UVM_LOW)
  endtask

endclass
