`uvm_analysis_imp_decl (_in)
`uvm_analysis_imp_decl (_out)

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    uvm_analysis_imp_in #(seq_item,scoreboard) port_in;
    uvm_analysis_imp_out #(seq_item,scoreboard) port_out;

    bit [31:0] ref_mem[int];
    seq_item exp_wr_q[$];
    seq_item exp_rd_q[$];

    function new(string name="scoreboard",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        port_in = new("port_in",this);
        port_out = new("port_out",this);
    endfunction

    function void write_in(seq_item tr);
        seq_item exp_tr;
        bit [3:0] word_idx;
        bit [31:0] exp_data;
        `uvm_info("SCB","Cloning transaction",UVM_MEDIUM)
      $cast(exp_tr,tr.clone());

        if(exp_tr.write_req == 1) begin
            word_idx = exp_tr.AWADDR[5:2];
            exp_tr.BRESP = 2'b00;

            if(word_idx > 15 || exp_tr.AWADDR>32'h3C) begin
                exp_tr.BRESP = 2'b11;
            end
            else if(word_idx >= 10 && word_idx <= 12 || exp_tr.AWADDR[1:0]!=2'b00) begin
                exp_tr.BRESP = 2'b10;
            end
            if(exp_tr.BRESP == 2'b00) begin
                exp_data = ref_mem.exists(word_idx) ? ref_mem[word_idx] : 32'd0;
                
                for(int i=0; i<4; i++) begin
                    if(exp_tr.WSTRB[i] == 1) begin
                        exp_data[i*8+:8]=exp_tr.WDATA[i*8+:8];
                    end
                end
                ref_mem[word_idx] = exp_data;
            end
            `uvm_info("SCB","Push write tx in write queue",UVM_MEDIUM)
            exp_wr_q.push_back(exp_tr);
        end
        else if(exp_tr.read_req == 1) begin
            word_idx = exp_tr.ARADDR[5:2];
            exp_tr.RRESP = 2'b00;

            if(word_idx > 15 || exp_tr.ARADDR>32'h3C) begin
                exp_tr.RRESP = 2'b11;
            end
            else if(word_idx >= 13 && word_idx <= 14 || exp_tr.ARADDR[1:0]!=2'b00) begin
                exp_tr.RRESP = 2'b10;
            end
            if(exp_tr.RRESP == 2'b00) begin
                if(ref_mem.exists(word_idx)) begin
                    exp_tr.RDATA = ref_mem[word_idx];
                end else begin
                    exp_tr.RDATA = 32'd0; 
                end
            end
            `uvm_info("SCB","Push read tx in read queue",UVM_MEDIUM)
            exp_rd_q.push_back(exp_tr);
        end
    endfunction

    function void write_out(seq_item tr);
        seq_item exp_tr;
        
        if (tr.write_req == 1) begin
            if(exp_wr_q.size() == 0) begin
                `uvm_error("SCB","Expected write queue is empty!")
                return;
            end
            exp_tr = exp_wr_q.pop_front();
            
            if (tr.BRESP !== exp_tr.BRESP) begin
                `uvm_error("SCB_FAIL", $sformatf("Write resp mismatch! Addr: %0h | Act: %0b | Exp: %0b", exp_tr.AWADDR, tr.BRESP, exp_tr.BRESP))
            end else begin
              `uvm_info("SCB_PASS",$sformatf("Write response matched for Addr:%0h| resp:%0b", exp_tr.AWADDR,tr.BRESP), UVM_MEDIUM)
            end
        end
        else if (tr.read_req == 1) begin
            if(exp_rd_q.size() == 0) begin
                `uvm_error("SCB", "Expected read queue is empty!")
                return;
            end
            exp_tr = exp_rd_q.pop_front();
            
            if(tr.RRESP !== exp_tr.RRESP) begin
                `uvm_error("SCB_FAIL", $sformatf("Read resp mismatch! Addr: %0h | Act: %0b | Exp: %0b", exp_tr.ARADDR, tr.RRESP, exp_tr.RRESP))
            end
            else if(exp_tr.RRESP == 2'b00 && tr.RDATA !== exp_tr.RDATA) begin
              `uvm_error("SCB_FAIL", $sformatf("Read data mismatch! Addr: %0h | Act: %0h | Exp: %0h", exp_tr.ARADDR, tr.RDATA, exp_tr.RDATA))
            end
            else begin
              `uvm_info("SCB_PASS",$sformatf("Read data and response matched for Addr:%0h|Data:%0h|Resp:%0b", exp_tr.ARADDR,exp_tr.RDATA,exp_tr.RRESP), UVM_MEDIUM)
            end
        end
    endfunction
endclass
