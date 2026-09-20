class write_seq extends uvm_sequence#(seq_item);
    `uvm_object_utils(write_seq)

    function new(string name="write_seq");
        super.new(name);
    endfunction

    task body();
        seq_item tr;
        `uvm_info("DBG","write sequence start", UVM_LOW)
        tr=seq_item::type_id::create("tr");
        start_item(tr);
        if(!tr.randomize() with {write_req==1;read_req==0;AWADDR==32'h3C;WDATA inside{[50:100]};WSTRB inside {1,2,4,8,15};delay_data==0;delay_addr==1;})
            `uvm_error("SEQ","Randomization failed");
        finish_item(tr);
        `uvm_info("DBG","write sequence complete", UVM_LOW)
    endtask

endclass
