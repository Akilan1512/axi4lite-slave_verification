`include "uvm_macros.svh"
//`include "test_pkg.sv"
//`include "axi4lite_if.sv"
//`include "axi_lt_sva.sv"
//`include "design.sv"

import uvm_pkg::*;
import test_pkg::*;

module top();

bit ACLK;
bit ARESETn;

initial begin
    ACLK=0;
    forever #5 ACLK=~ACLK;
end

initial begin
    ARESETn=0;
    #5;
    ARESETn=1;
    #5;
    ARESETn=0;
    #20;
    ARESETn=1;
end

axi4lite_if vif(ACLK,ARESETn);

axi4_lite_slave DUT (
        .ACLK    (vif.ACLK),
        .ARESETn (vif.ARESETn),
        .AWADDR  (vif.AWADDR),
        .AWVALID (vif.AWVALID),
        .AWREADY (vif.AWREADY),
        .WDATA (vif.WDATA),
        .WSTRB   (vif.WSTRB),
        .WVALID  (vif.WVALID),
        .WREADY  (vif.WREADY),
        .BRESP  (vif.BRESP),
        .BVALID  (vif.BVALID),
        .BREADY  (vif.BREADY),
        .ARADDR  (vif.ARADDR),
        .ARVALID (vif.ARVALID),
        .ARREADY (vif.ARREADY),
        .RDATA   (vif.RDATA),
        .RRESP   (vif.RRESP),
        .RVALID  (vif.RVALID),
        .RREADY  (vif.RREADY),
        .ARPROT  (vif.ARPROT),
        .AWPROT  (vif.AWPROT)
);
 
/*bind axi4_lite_slave axi_lt_sva ast(
  .ACLK  (ACLK),
  .ARESETn (ARESETn),
  .AWADDR  (AWADDR),
  .AWVALID (AWVALID),
  .AWREADY (AWREADY),
  .WDATA (WDATA),
  .WSTRB   (WSTRB),
  .WVALID  (WVALID),
  .WREADY  (WREADY),
  .BRESP  (BRESP),
  .BVALID  (BVALID),
  .BREADY  (BREADY),
  .ARADDR  (ARADDR),
  .ARVALID (ARVALID),
  .ARREADY (ARREADY),
  .RDATA   (RDATA),
  .RRESP   (RRESP),
  .RVALID  (RVALID),
  .RREADY  (RREADY),
  .ARPROT  (ARPROT),
  .AWPROT  (AWPROT)
); */


initial begin
    uvm_top.set_timeout(50000ns,1);
    uvm_config_db#(virtual axi4lite_if)::set(null,"*","vif",vif);
    run_test("test");
end

initial begin
    $fsdbDumpvars(0,top);
   // $fsdbDumpSVA;
end
  
endmodule
