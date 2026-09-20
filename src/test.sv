class test extends uvm_test;
    `uvm_component_utils(test)
    env env1;
    write_seq wseq;
    write2_seq w2seq;
   // write3_seq w3seq;
    read_seq rseq;
    read2_seq r2seq;
    addr_f afseq;
    data_f dfseq;
    wo_inv woseq;
    ro_inv roseq;
    addr_inv_wr awseq;
    addr_inv_rd arseq;
    addr_un_rd urseq;
    addr_un_wr uwseq;
    wstrb_seq wtseq;


    function new(string name="test",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env1=env::type_id::create("env1",this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

    virtual task run_phase(uvm_phase phase);
        `uvm_info("DBG","sequences start,raise objection", UVM_LOW)
        phase.raise_objection(this);
        afseq=addr_f::type_id::create("afseq");
        dfseq=data_f::type_id::create("dfseq");
        woseq=wo_inv::type_id::create("woseq");
        roseq=ro_inv::type_id::create("roseq");
        rseq=read_seq::type_id::create("rseq");
        awseq=addr_inv_wr::type_id::create("awseq");
        arseq=addr_inv_rd::type_id::create("arseq");
        urseq=addr_un_rd::type_id::create("urseq");
        uwseq=addr_un_wr::type_id::create("uwseq");
        wtseq=wstrb_seq::type_id::create("wtseq");
        r2seq=read2_seq::type_id::create("r2seq");
        wseq=write_seq::type_id::create("wseq");
        w2seq=write2_seq::type_id::create("w2seq");
     //   w3seq=write3_seq::type_id::create("w3seq");
       //  w2seq.start(env1.inp_agt.w_seqr);

        repeat(50) begin
            `uvm_info("TST","start addr/data delay check",UVM_MEDIUM)
            afseq.start(env1.inp_agt.w_seqr);
            dfseq.start(env1.inp_agt.w_seqr);
            rseq.start(env1.inp_agt.r_seqr);
           `uvm_info("TST","addr/data delay check complete",UVM_MEDIUM)
            woseq.start(env1.inp_agt.r_seqr);
            roseq.start(env1.inp_agt.w_seqr);
            awseq.start(env1.inp_agt.w_seqr);
            arseq.start(env1.inp_agt.r_seqr);
            uwseq.start(env1.inp_agt.w_seqr);
            urseq.start(env1.inp_agt.r_seqr);
            `uvm_info("TST","start write strobe test",UVM_MEDIUM)
            wtseq.start(env1.inp_agt.w_seqr);
            rseq.start(env1.inp_agt.r_seqr);
            `uvm_info("TST","write strobe test completed",UVM_MEDIUM)
            `uvm_info("TST","write at addr 15",UVM_MEDIUM)
            wseq.start(env1.inp_agt.w_seqr);
            r2seq.start(env1.inp_agt.r_seqr);
        end
        //    w3seq.start(env.inp_agt.w_seqr);
         //  `uvm_info("TST","Start parallel channel test",UVM_MEDIUM)
          /*  fork
              w2seq.start(env1.inp_agt.w_seqr);
              rseq.start(env1.inp_agt.r_seqr);
            join */

        `uvm_info("DBG","sequences finished,drop objection", UVM_LOW)
        phase.drop_objection(this);
    endtask

endclass
