class subscriber extends uvm_subscriber#(seq_item);
    `uvm_component_utils(subscriber)
    seq_item tr;

    covergroup cg;
        cp_AWADDR:coverpoint tr.AWADDR[5:2]{
            bins aw[]={[0:9],[13:15]};
        }
        cp_ARADDR:coverpoint tr.ARADDR[5:2]{
            bins ar[]={[0:12],15};
        }
        cp_WDATA: coverpoint tr.WDATA{
            bins low={[0:32'h0000FFFF]};
            bins med={[32'h00010000:32'h7FFFFFFF]};
            bins high={[32'h80000000:32'hFFFFFFFF]};
        }
        cp_WSTRB:coverpoint tr.WSTRB{
            bins strb[]={0,1,2,4,8,15};
        }

        cp_WDATA_WSTRB:cross cp_WDATA,cp_WSTRB;
    endgroup

    function new(string name="subscriber",uvm_component parent);
        super.new(name,parent);
        cg=new();
    endfunction

    virtual function void write(seq_item t);
        tr=t;
        cg.sample();
    endfunction

endclass
