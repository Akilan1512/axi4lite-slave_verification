class driver extends uvm_driver #(seq_item);
    `uvm_component_utils(driver)
    uvm_seq_item_pull_port #(seq_item) seq_item_port_rd;
    virtual axi4lite_if vif;

    function new(string name="driver",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq_item_port_rd = new("seq_item_port_rd", this);
        if(!uvm_config_db#(virtual axi4lite_if)::get(this, "","vif",vif)) begin
            `uvm_fatal("DRV","Failed to get virtual interface")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        wait(!vif.ARESETn);
        vif.drv_cb.AWADDR<=0;
        vif.drv_cb.AWVALID<=0;
        vif.drv_cb.WDATA<=0;
        vif.drv_cb.WSTRB<=0;
        vif.drv_cb.WVALID<=0;
        vif.drv_cb.ARADDR<=0;
        vif.drv_cb.ARVALID<=0;
        vif.drv_cb.RREADY<=0;
        vif.drv_cb.BREADY<=0;
        wait(vif.ARESETn==1);
        fork
            forever begin
                seq_item wr_req;
                seq_item_port.get_next_item(wr_req);
                drive_write(wr_req);
                seq_item_port.item_done();
            end
            
            forever begin
                seq_item rd_req;
                seq_item_port_rd.get_next_item(rd_req);
                drive_read(rd_req);
                seq_item_port_rd.item_done();
            end
        join
    endtask

    virtual task drive_write(seq_item req);
       @(vif.drv_cb);
      // vif.drv_cb.BREADY<=1;
        fork
            begin
                repeat(req.delay_addr)@(vif.drv_cb);
                vif.drv_cb.AWADDR<=req.AWADDR;
                vif.drv_cb.AWPROT<=req.AWPROT;
                vif.drv_cb.AWVALID<=1;
                `uvm_info("DRV", "waiting for awready", UVM_LOW)
                @(vif.drv_cb iff vif.drv_cb.AWREADY==1);
                `uvm_info("DRV","got awready", UVM_LOW)
                vif.drv_cb.AWVALID<=0;
            end
            begin
                repeat(req.delay_data)@(vif.drv_cb);
                vif.drv_cb.WDATA<=req.WDATA;
                vif.drv_cb.WSTRB<=req.WSTRB;
                vif.drv_cb.WVALID<=1;
                `uvm_info("DRV", "waiting for wready", UVM_LOW)
                @(vif.drv_cb iff vif.drv_cb.WREADY==1);
                `uvm_info("DRV","got wready", UVM_LOW)
                vif.drv_cb.WVALID<=0;
            end
        join
        vif.drv_cb.BREADY<=1;
        `uvm_info("DRV","waiting for bvalid", UVM_LOW)
        if (vif.drv_cb.BVALID !== 1) begin 
            @(vif.drv_cb iff vif.drv_cb.BVALID == 1);
        end
      `uvm_info("DRV", "got bvalid", UVM_LOW)
        vif.drv_cb.BREADY<=0;
    endtask

    virtual task drive_read(seq_item req);
        @(vif.drv_cb);
        vif.drv_cb.ARADDR<=req.ARADDR;
        vif.drv_cb.ARPROT<=req.ARPROT;
        vif.drv_cb.ARVALID<=1;
        @(vif.drv_cb iff vif.drv_cb.ARREADY==1);
        vif.drv_cb.ARVALID<=0;
        @(vif.drv_cb);
        vif.drv_cb.RREADY<=1;
        @(vif.drv_cb iff vif.drv_cb.RVALID==1);
        vif.drv_cb.RREADY<=0;
    endtask

endclass
