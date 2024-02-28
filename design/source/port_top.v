`include "fifo_module.v"
`include "fsm_in_top.v"
`include "fsm_out_top.v"


module port_top # (
  parameter FIFO_SIZE = 64,
  parameter W_WIDTH = 8 //WORD width
)(
  input clk, rst_n,
  input sw_en,
  input [W_WIDTH-1:0] port_data, port_addr,
  input port_rd,

  output [W_WIDTH-1:0] port_out,
  output port_rdy,
  output rd_out
);  

  wire fifo_full_w, fifo_empty_w;
  wire wr_en_w, rd_en_w;
  wire [W_WIDTH-1:0] fifo_data_w, port_out_w;

  fifo # (
    .FIFO_SIZE(FIFO_SIZE),
    .W_WIDTH(W_WIDTH)
  ) PORT_FIFO_DUT (
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_en_w),
    .rd_en(rd_en_w),
    .data_in(port_data),
    .data_out(fifo_data_w),
    .empty(fifo_empty_w),
    .full(fifo_full_w)
  );

  fsm_in_top # (
    .W_WIDTH(W_WIDTH)
  ) PORT_IN_FSM_DUT (
    .clk(clk),
    .rst_n(rst_n),
    .sw_en(sw_en),
    .port_busy(fifo_full_w),
    .port_addr(port_addr),
    .data_in(port_data),
    .wr_en(wr_en_w)
  );

  fsm_out_top # (
    .W_WIDTH(W_WIDTH)
  ) PORT_OUT_FSM_DUT (
    .clk(clk),
    .rst_n(rst_n),
    .port_addr(port_addr),
    .fifo_data(fifo_data_w),
    .port_rd(port_rd),
    .port_empty(fifo_empty_w),
    .rd_en(rd_en_w),
    .port_out(port_out_w)
  );

  assign rd_out = !fifo_full_w;
  assign port_rdy = !fifo_empty_w;
  assign port_out = port_out_w;
endmodule : port_top