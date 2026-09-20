class error_driver extends driver;
    `uvm_component_utils(error_driver)

    function new(string name = "error_driver", uvm_component parent);
        super.new(name, parent);
    endfunction

 task drive_write(seq_item req);
        @(vif.drv_cb);
      `uvm_info("EDRV","Send first data",UVM_MEDIUM)
        vif.drv_cb.WDATA <= req.WDATA;
        vif.drv_cb.WSTRB <=req.WSTRB;
        vif.drv_cb.WVALID <= 1;
        `uvm_info("EDRV", $sformatf("data:%0h", req.WDATA),UVM_MEDIUM)
        `uvm_info("EDRV","Waiting for first wready",UVM_MEDIUM)
        @(vif.drv_cb iff vif.drv_cb.WREADY == 1);
        `uvm_info("EDRV","Got wready",UVM_MEDIUM)
        vif.drv_cb.WVALID <= 0;
        repeat(3) @(vif.drv_cb);
        `uvm_info("EDRV", "Send second data", UVM_MEDIUM)
        vif.drv_cb.WDATA<=100;
        vif.drv_cb.WSTRB <=req.WSTRB;
        vif.drv_cb.WVALID<=1;
        `uvm_info("EDRV", $sformatf("data:%0h",req.WDATA),UVM_MEDIUM)
        `uvm_info("EDRV","Waiting for second wready",UVM_MEDIUM)
        @(vif.drv_cb iff vif.drv_cb.AWREADY == 1);
        `uvm_info("EDRV","Got wready",UVM_MEDIUM)
        vif.drv_cb.WVALID<=0;
        vif.drv_cb.AWADDR<=req.AWADDR;
        vif.drv_cb.AWVALID<=1;
        @(vif.drv_cb iff vif.drv_cb.AWREADY == 1);
        vif.drv_cb.AWVALID <= 0;
        vif.drv_cb.BREADY <= 1;
        @(vif.drv_cb iff vif.drv_cb.BVALID == 1);
        vif.drv_cb.BREADY <= 0;
        `uvm_info("EDRV", "Error tx done", UVM_MEDIUM)
    endtask
endclass
