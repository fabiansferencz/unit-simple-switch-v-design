module fifo_mem # (
  parameter FIFO_SIZE = 64,
  parameter W_WIDTH = 8
)(
  input clk, rst_n,
  input wr_en, rd_en,
  input [W_WIDTH-1:0] data_in,
  output [W_WIDTH-1:0] data_out,
  output [$clog2(FIFO_SIZE)-1:0] wr_pos, rd_pos
);  

reg [W_WIDTH-1:0] ram [FIFO_SIZE-1:0];//a memory with 64 locations depth and 8 bits word

reg [$clog2(FIFO_SIZE)-1:0] wr_pos_nxt, wr_pos_ff;
reg [$clog2(FIFO_SIZE)-1:0] rd_pos_nxt, rd_pos_ff;
reg [W_WIDTH-1:0] data_out_s_nxt, data_out_s_ff;

always @ (*) begin
    wr_pos_nxt = wr_pos_ff;
    rd_pos_nxt = rd_pos_ff;
    data_out_s_nxt = data_out_s_ff;

    if(wr_en) begin
        ram[wr_pos_ff] = data_in;
        if(wr_pos_ff == FIFO_SIZE-1) begin
            wr_pos_nxt = 0;
        end
        else begin
            wr_pos_nxt = wr_pos_nxt + 1;
        end
    end 

    if(rd_en) begin
        data_out_s_nxt = ram[rd_pos_ff];
        if(rd_pos_ff == FIFO_SIZE-1) begin
            rd_pos_nxt = 0;
        end
        else begin
            rd_pos_nxt = rd_pos_nxt + 1;
        end
    end 
    else data_out_s_nxt = 0;
end 

always @ (posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_out_s_ff <= 0;
        rd_pos_ff <= 0;
        wr_pos_ff <= 0;
    end 
    else begin
        data_out_s_ff <= data_out_s_nxt;
        wr_pos_ff <= wr_pos_nxt;
        rd_pos_ff <= rd_pos_nxt;
    end 
end 

assign wr_pos = wr_pos_ff;
assign rd_en = rd_pos_ff;
assign data_out = data_out_s_ff;

endmodule : fifo_mem