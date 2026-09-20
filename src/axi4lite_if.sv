`include "defines.svh"
interface axi4lite_if(input bit ACLK, ARESETn);
    logic [`AW-1:0] AWADDR;
    logic [2:0] AWPROT;
    logic  AWVALID;
    logic  AWREADY;
    logic [`DW-1:0] WDATA;
    logic [(`DW/8)-1:0] WSTRB;
    logic WVALID;
    logic WREADY;
    logic [1:0] BRESP;
    logic  BVALID;
    logic  BREADY;
    logic [`AW-1:0] ARADDR;
    logic [2:0] ARPROT;
    logic ARVALID;
    logic ARREADY;
    logic [`DW-1:0] RDATA;
    logic [1:0]RRESP;
    logic RREADY;
    logic RVALID;
    clocking drv_cb @(posedge ACLK);
        default input #1 output #1;
        output AWADDR,AWVALID,WDATA,WSTRB,WVALID,BREADY,ARADDR,ARVALID,RREADY,AWPROT,ARPROT;
        input  AWREADY,WREADY,BVALID,BRESP,ARREADY,RVALID,RDATA,RRESP;
    endclocking
    clocking inp_mon_cb @(posedge ACLK);
        default input #1 output #1;
        input AWADDR,AWVALID,AWREADY,WDATA,WSTRB,WVALID,WREADY,ARADDR,ARVALID,ARREADY,AWPROT,ARPROT;
    endclocking
    clocking out_mon_cb @(posedge ACLK);
        default input #1 output #1;
        input BRESP,BVALID,BREADY,RDATA,RRESP,RVALID,RREADY;
    endclocking
    modport drv(clocking drv_cb, input ACLK, ARESETn);
    modport inp_mon(clocking inp_mon_cb, input ACLK, ARESETn);
    modport out_mon(clocking out_mon_cb, input ACLK, ARESETn);

    property p1;
      @(posedge ACLK) disable iff (!ARESETn)
      (AWVALID && !AWREADY) |=> AWVALID;
    endproperty

    assert property (p1)
      else $error("awvalid dropped before awready");


    property p2;
      @(posedge ACLK) disable iff (!ARESETn)
      (WVALID && !WREADY) |=> WVALID;
    endproperty

    assert property (p2)
      else $error("wvalid dropped before wready");

    property p3;
      @(posedge ACLK) disable iff (!ARESETn)
     (ARVALID && !ARREADY) |=> ARVALID;
    endproperty

    assert property (p3)
      else $error("arvalid dropped before arready");

    property p4;
      @(posedge ACLK) disable iff (!ARESETn)
     (RVALID && !RREADY) |=> RVALID;
    endproperty

    assert property (p4)
       else $error("rvalid dropped before rready");


endinterface
                                                
