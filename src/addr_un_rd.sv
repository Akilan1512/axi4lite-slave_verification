class addr_un_rd extends uvm_sequence#(seq_item);
  `uvm_object_utils(addr_un_rd)
    function new(string name="addr_un_rd");
        super.new(name);
    endfunction

    task body();
        seq_item tr;
        tr=seq_item::type_id::create("tr");
        `uvm_info("DEBUG", "START ADDR UNALIGN READ", UVM_LOW)
        start_item(tr);
        if(!tr.randomize() with {write_req==0;read_req==1;ARADDR inside {[32'h0:32'h24]}; ARADDR[1:0]!=2'b00;})
            `uvm_error("SEQ","Randomization failed");
        finish_item(tr);
      `uvm_info("DEBUG", "COMPLETED ADDR UNALIGN READ", UVM_LOW)
    endtask

endclass
