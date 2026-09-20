class input_monitor extends uvm_monitor;
    `uvm_component_utils(input_monitor)
    virtual axi4lite_if vif;
    uvm_analysis_port #(seq_item) ap_in;
    bit aw_done;
    bit w_done;
    bit [31:0] c_awaddr;
    bit [31:0] c_wdata;
    bit [3:0] c_wstrb;

    function new(string name="input_monitor",uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap_in=new("ap_in",this);
        if(!uvm_config_db#(virtual axi4lite_if)::get(this,"","vif",vif)) begin
            `uvm_fatal("MON", "Failed to get virtual interface")
        end
    endfunction

    task run_phase(uvm_phase phase);
        wait(vif.ARESETn==1);
        aw_done=0;
        w_done=0;
        fork
            mon_write_addr();
            mon_write_data();
            mon_read_addr();
        join_none
    endtask

    task mon_read_addr();
        seq_item tr;
        forever begin
            @(vif.inp_mon_cb);
            if(vif.inp_mon_cb.ARVALID && vif.inp_mon_cb.ARREADY) begin
                tr=seq_item::type_id::create("tr");
                tr.ARADDR=vif.inp_mon_cb.ARADDR;
                tr.read_req=1;
                ap_in.write(tr);
            end
        end
    endtask

    task mon_write_addr();
        forever begin
            @(vif.inp_mon_cb iff (vif.inp_mon_cb.AWVALID && vif.inp_mon_cb.AWREADY));
            c_awaddr=vif.inp_mon_cb.AWADDR;
            aw_done=1;
            check_done();
            @(vif.inp_mon_cb iff (!vif.inp_mon_cb.AWVALID || !vif.inp_mon_cb.AWREADY));
        end
    endtask

    task mon_write_data();
        forever begin
            @(vif.inp_mon_cb iff (vif.inp_mon_cb.WVALID && vif.inp_mon_cb.WREADY));
            c_wdata=vif.inp_mon_cb.WDATA;
            c_wstrb=vif.inp_mon_cb.WSTRB;
            w_done=1;
            check_done();
            @(vif.inp_mon_cb iff (!vif.inp_mon_cb.WVALID || !vif.inp_mon_cb.WREADY));
        end
    endtask


    task check_done();
        seq_item tr;
        if(aw_done && w_done) begin
            tr=seq_item::type_id::create("tr");
            tr.AWADDR=c_awaddr;
            tr.WDATA=c_wdata;
            tr.WSTRB=c_wstrb;
            tr.write_req=1;
           `uvm_info("MON",$sformatf("Sending write tX to scoreboard Addr:%0h|Data:%0h|wstrb:%0d",tr.AWADDR,tr.WDATA,tr.WSTRB),UVM_LOW)
            ap_in.write(tr);
            aw_done=0;
            w_done=0;
        end
    endtask
endclass
