class env extends uvm_env;
    `uvm_component_utils(env);
    input_agent inp_agt;
    output_agent out_agt;
    scoreboard scb;
    subscriber sub;

    function new(string name="env",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        inp_agt=input_agent::type_id::create("inp_agt",this);
        out_agt=output_agent::type_id::create("out_agt",this);
        scb=scoreboard::type_id::create("scb",this);
        sub=subscriber::type_id::create("sub",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        inp_agt.inp_mon.ap_in.connect(scb.port_in);
        out_agt.out_mon.ap_out.connect(scb.port_out);
        inp_agt.inp_mon.ap_in.connect(sub.analysis_export);
    endfunction

endclass
