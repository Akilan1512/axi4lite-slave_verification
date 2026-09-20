class read2_seq extends uvm_sequence #(seq_item);
    `uvm_object_utils(read2_seq)

    function new(string name="read2_seq");
        super.new(name);
    endfunction

    task body();
        seq_item tr;
        tr=seq_item::type_id::create("tr");
        start_item(tr);
        if(!tr.randomize() with { write_req==0;read_req==1;ARADDR==32'd0;})
            `uvm_error("SEQ","Randomization failed");
        finish_item(tr);
    endtask

endclass

