class write2_seq extends uvm_sequence#(seq_item);
    `uvm_object_utils(write2_seq)

    function new(string name="write2_seq");
        super.new(name);
    endfunction

    task body();
        seq_item tr;
            tr=seq_item::type_id::create("tr");
            start_item(tr);
          if(!tr.randomize() with {write_req==1; read_req==0;AWADDR==32'd0; WDATA inside {[1:100]}; WSTRB==15;})
                `uvm_error("SEQ","Randomization failed");
        `uvm_info("DBG", "Randomization done", UVM_LOW)
            finish_item(tr);
        `uvm_info("DBG", "Write sequence completed", UVM_LOW)
    endtask

endclass
