`include "fifo_mem.v"
`include "fifo_fsm.v"

module fifo_top # (
  parameter FIFO_SIZE = 64,//2^FIFO_SIZE = number of locations in FIFO
  parameter W_WIDTH = 8
)(
  input clk, rst_n,
  input wr_en, rd_en,
  input [W_WIDTH-1:0] data_in,
  output [W_WIDTH-1:0] data_out,
  output empty, full
);  

wire [$clog2(FIFO_SIZE)-1:0] wr_pos_w, rd_pos_w;
wire fsm2mem_wr_en_w, fsm2mem_rd_en_w;
wire [W_WIDTH-1:0] fsm2mem_data_w;

fifo_fsm  # (
  .FIFO_SIZE(FIFO_SIZE),
  .W_WIDTH(W_WIDTH)
) FSM_DUT_FIFO (
  .clk(clk), 
  .rst_n(rst_n), 
  .wr_en(wr_en), 
  .rd_en(rd_en),
  .wr_pos(wr_pos_w),
  .rd_pos(rd_pos_w),
  .data_in(data_in),
  .fsm2mem_wr_en(fsm2mem_wr_en_w),
  .fsm2mem_rd_en(fsm2mem_rd_en_w), 
  .data_out(fsm2mem_data_w),
  .full_s(full),
  .empty_s(empty)
);

fifo_mem  # (
  .FIFO_SIZE(FIFO_SIZE),
  .W_WIDTH(W_WIDTH)
) MEM_DUT_FIFO (
  .clk(clk), 
  .rst_n(rst_n), 
  .wr_en(fsm2mem_wr_en_w), 
  .rd_en(fsm2mem_rd_en_w),
  .data_in(fsm2mem_data_w),
  .data_out(data_out),
  .wr_pos(wr_pos_w),
  .rd_pos(rd_pos_w) 
);
endmodule : fifo_top
