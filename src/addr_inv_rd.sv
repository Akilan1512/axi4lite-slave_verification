class addr_inv_rd extends uvm_sequence#(seq_item);
    `uvm_object_utils(addr_inv_rd)
    function new(string name="addr_inv_rd");
        super.new(name);
    endfunction

    task body();
        seq_item tr;
        tr=seq_item::type_id::create("tr");
      `uvm_info("DEBUG", "START ADDR VIOLATION READ", UVM_LOW)
        start_item(tr);
        if(!tr.randomize() with {write_req==0;read_req==1;ARADDR inside {[32'h40:32'hFFFFFFFF]};})
            `uvm_error("SEQ","Randomization failed");
        finish_item(tr);
      `uvm_info("DEBUG", "COMPLETED ADDR VIOLATION READ", UVM_LOW)
    endtask

endclass
