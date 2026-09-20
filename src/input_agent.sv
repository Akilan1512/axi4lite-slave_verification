class input_agent extends uvm_agent;
    `uvm_component_utils(input_agent)
    seqr w_seqr;
    seqr r_seqr;
    driver drv;
    input_monitor inp_mon;

    function new(string name="input_agent",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        inp_mon=input_monitor::type_id::create("inp_mon",this);
        if(get_is_active()==UVM_ACTIVE) begin
            drv=driver::type_id::create("drv",this);
            w_seqr=seqr::type_id::create("w_seqr",this);
            r_seqr=seqr::type_id::create("r_seqr",this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if(get_is_active()==UVM_ACTIVE) begin
            drv.seq_item_port.connect(w_seqr.seq_item_export);
            drv.seq_item_port_rd.connect(r_seqr.seq_item_export);
        end
    endfunction

endclass
