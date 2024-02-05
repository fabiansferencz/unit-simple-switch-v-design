module fifo_fsm # (
  parameter FIFO_SIZE = 64,
  parameter W_WIDTH = 8
)(
  input clk, rst_n,
  input wr_en, rd_en,
  input [$clog2(FIFO_SIZE)-1:0] wr_pos, rd_pos,
  input [W_WIDTH-1:0] data_in,
  output [W_WIDTH-1:0] data_out,
  output fsm2mem_wr_en, fsm2mem_rd_en,
  output full_s, empty_s
); 

reg fsm2mem_wr_en_nxt, fsm2mem_wr_en_ff;
reg fsm2mem_rd_en_nxt, fsm2mem_rd_en_ff;
reg empty_s_nxt, empty_s_ff;
reg full_s_nxt, full_s_ff;
reg [W_WIDTH-1:0] fsm2mem_data_nxt, fsm2mem_data_ff;

always @ (*) begin
    fsm2mem_wr_en_nxt = fsm2mem_wr_en_ff;
    fsm2mem_rd_en_nxt = fsm2mem_rd_en_ff;
    fsm2mem_data_nxt = fsm2mem_data_ff;
    empty_s_nxt = empty_s_ff;
    full_s_nxt = full_s_ff;

    if(wr_en && !full_s_ff) begin
      $display("%t debug1", $time);
      empty_s_nxt = 1'b0;
      if((wr_pos - 1 == rd_pos) || (wr_pos == FIFO_SIZE-1)) begin
        $display("debug2");
        full_s_nxt = 1'b1;
      end
      // else begin
      //   fsm2mem_wr_en_nxt = 1'b1;
      // end 
    end
    // else fsm2mem_wr_en_nxt = 1'b0; 

    if(rd_en && !empty_s_ff) begin
      fsm2mem_rd_en_nxt = 1'b1;
      full_s_nxt = 1'b0;
      if((wr_pos == rd_pos) || (rd_pos == 0)) begin
        empty_s_nxt = 1'b1;
      end 
    end 
    else fsm2mem_rd_en_nxt = 1'b0;

    //ff delay fpr data in to correspond with fsm2mem_wr_en generated
    fsm2mem_data_nxt = data_in;
    fsm2mem_wr_en_nxt = wr_en;
end

always @ (posedge clk or negedge rst_n) begin
     if(!rst_n) begin
        fsm2mem_wr_en_ff <= 0;
        fsm2mem_rd_en_ff <= 0;
        fsm2mem_data_ff <= 0;
        empty_s_ff <= 0;
        full_s_ff <= 0;
    end 
    else begin
        fsm2mem_wr_en_ff <= fsm2mem_wr_en_nxt;
        fsm2mem_rd_en_ff <= fsm2mem_rd_en_nxt;
        fsm2mem_data_ff <= fsm2mem_data_nxt;
        empty_s_ff <= empty_s_nxt;
        full_s_ff <= full_s_nxt;
    end 
end 

assign fsm2mem_wr_en = (full_s_ff) ? 0 : fsm2mem_wr_en_ff;
assign fsm2mem_rd_en = fsm2mem_rd_en_ff;
assign full_s = full_s_ff;
assign empty_s = empty_s_ff;
assign data_out = fsm2mem_data_ff;
endmodule : fifo_fsm