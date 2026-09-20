class read_seq extends uvm_sequence #(seq_item);
    `uvm_object_utils(read_seq)

    function new(string name="read_seq");
        super.new(name);
    endfunction

    task body();
        seq_item tr;
        `uvm_info("DBG","starting read sequence",UVM_LOW)
        for(int i=0;i<10;i++) begin
            tr=seq_item::type_id::create("tr");
            start_item(tr);
            if(!tr.randomize() with { write_req==0;read_req==1;ARADDR==i*4;})
                `uvm_error("SEQ","Randomization failed");
            finish_item(tr);
        end
        `uvm_info("DBG","read sequence complete",UVM_LOW)
    endtask

endclass
