class output_monitor extends uvm_monitor;
    `uvm_component_utils(output_monitor)
    virtual axi4lite_if vif;
    uvm_analysis_port #(seq_item) ap_out;

    function new(string name="output_monitor",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_out=new("ap_out",this);
        uvm_config_db#(virtual axi4lite_if)::get(this,"","vif",vif);
    endfunction

    task run_phase(uvm_phase phase);
        wait(vif.ARESETn==1);
        fork
            mon_read_resp();
            mon_write_resp();
        join_none
    endtask

    task mon_read_resp();
        seq_item tr;
        forever begin
            @(vif.out_mon_cb);
            if(vif.out_mon_cb.RREADY && vif.out_mon_cb.RVALID) begin
                tr=seq_item::type_id::create("tr");
                tr.RDATA=vif.out_mon_cb.RDATA;
                tr.RRESP=vif.out_mon_cb.RRESP;
                tr.read_req=1;
                ap_out.write(tr);
            end
        end
    endtask

    task mon_write_resp();
        seq_item tr;
        forever begin
            @(vif.out_mon_cb);
            if(vif.out_mon_cb.BREADY && vif.out_mon_cb.BVALID) begin
                tr=seq_item::type_id::create("tr");
                tr.BRESP=vif.out_mon_cb.BRESP;
                tr.write_req=1;
                ap_out.write(tr);
            end
        end
    endtask

endclass
