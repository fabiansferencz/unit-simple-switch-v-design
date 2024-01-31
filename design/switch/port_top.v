`include "fsm_module.v"
`include "fifo_module.v"


module port_top # (
  parameter NUM_OF_PORTS = 4,
  parameter FIFO_SIZE = 64,
  parameter W_WIDTH = 8 //WORD width
)(
  clk, rst_n,
  //input interface
  sw_en, port_data, rd_out,
  //port output interface
  port_out, port_rdy, port_rd, port_addr
);  

  input clk, rst_n;
  //-----------------------
  input sw_en;
  input [W_WIDTH-1:0] port_data, port_addr;
  output rd_out;
  //------------------------
  input port_rd;
  output [W_WIDTH-1:0] port_out;
  output port_rdy;

  wire port_busy, wr_enable, ffe;

  fifo # (
    .FIFO_SIZE(FIFO_SIZE),
    .W_WIDTH(W_WIDTH)
  ) DUT_PORT_FIFO (
    .clk(clk),
    .rst_n(rst_n),
    .wr_en(wr_enable),
    .rd_en(port_rd),
    .data_in(port_data),
    .data_out(port_out),
    .empty(port_rdy),
    .full(port_busy)
  );

  fsm # (
    .W_WIDTH(W_WIDTH)
  ) DUT_PORT_FSM (
    .clk(clk),
    .rst_n(rst_n),
    .sw_en(sw_en),
    .port_addr(port_addr),
    .data_in(port_data),
    .port_busy(port_busy),
    .wr_en(wr_enable)
  );

  assign rd_out = !port_busy;
endmodule : port_top