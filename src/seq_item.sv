`include "defines.svh"
class seq_item extends uvm_sequence_item;
    `uvm_object_utils(seq_item)

    rand bit write_req;
    rand bit read_req;
    rand int delay_addr;
    rand int delay_data;
    rand bit [`AW-1:0] AWADDR;
    rand bit [`DW-1:0] WDATA;
    rand bit [(`DW/8)-1:0] WSTRB;
    rand bit [`AW-1:0] ARADDR;
    rand bit [2:0] AWPROT;
    rand bit [2:0] ARPROT;
    bit [1:0] RRESP;
    bit [1:0] BRESP;
    bit [`DW-1:0] RDATA;

    function new(string name="seq_item");
        super.new(name);
    endfunction

    function void do_copy(uvm_object rhs);
    seq_item rhs_;
    if (!$cast(rhs_, rhs)) begin
        `uvm_fatal("DO_COPY", "Cast failed - wrong object type");
    end
    super.do_copy(rhs);
    this.write_req  = rhs_.write_req;
    this.read_req   = rhs_.read_req;
    this.delay_addr = rhs_.delay_addr;
    this.delay_data = rhs_.delay_data;
    this.AWADDR     = rhs_.AWADDR;
    this.WDATA      = rhs_.WDATA;
    this.WSTRB      = rhs_.WSTRB;
    this.ARADDR     = rhs_.ARADDR;
    this.AWPROT     = rhs_.AWPROT;
    this.ARPROT     = rhs_.ARPROT;
    this.RRESP      = rhs_.RRESP;
    this.BRESP      = rhs_.BRESP;
    this.RDATA      = rhs_.RDATA;
    endfunction

    constraint valid_req{
        (write_req==1)||(read_req==1);
    }

    constraint address_delay{
       soft delay_addr == 0;
    }

    constraint data_delay{
       soft delay_data == 0;
    }

    constraint addr_align{
        soft AWADDR[1:0]==2'b00;
        soft ARADDR[1:0]==2'b00;
    }

    constraint addr_range{
        soft ARADDR<=32'h3C;
        soft AWADDR<=32'h3C;
    }

    constraint prot{
        ARPROT inside {[0:7]};
        AWPROT inside {[0:7]};
    }

endclass
