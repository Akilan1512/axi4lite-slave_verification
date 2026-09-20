class error_test extends test;
    `uvm_component_utils(error_test)
    write2_seq w2_seq;
    read2_seq r2_seq;

    function new(string name="error_test", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        driver::type_id::set_type_override(error_driver::get_type());
        super.build_phase(phase);        
        `uvm_info("TEST", "Factory override applied: Error Driver is active!", UVM_NONE)
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        w2_seq=write2_seq::type_id::create("w2_seq");
        r2_seq=read2_seq::type_id::create("r2_seq");
        w2_seq.start(env1.inp_agt.w_seqr);
        r2_seq.start(env1.inp_agt.r_seqr);
        phase.drop_objection(this);

    endtask

endclass
