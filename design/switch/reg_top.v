`include "reg_block.v"
`include "reg_fsm.v"

module reg_top # (
  parameter NUM_OF_REG = 4
)(
  input clk, rst_n,
  input sel_en, wr_rd_s,
  input [7:0] addr, wr_data,

  output [7:0] rd_data,
  output [7:0] reg_data2port_out_0, reg_data2port_out_1, reg_data2port_out_2, reg_data2port_out_3,
  output ack
);

  wire [7:0] reg_data2port_w [NUM_OF_REG-1:0];
  wire [7:0] wr_en_w;

  reg_block BLOCK_DUT_REG(
    .clk(clk), 
    .rst_n(rst_n), 
    .wr_en(wr_en_w), 
    .wr_data(wr_data), 
    .reg_data2port_out_0(reg_data2port_w[0]),
    .reg_data2port_out_1(reg_data2port_w[1]),
    .reg_data2port_out_2(reg_data2port_w[2]),
    .reg_data2port_out_3(reg_data2port_w[3])
  );

  reg_fsm FSM_DUT_REG(
    .clk(clk), 
    .rst_n(rst_n),
    .sel_en(sel_en),
    .wr_rd_s(wr_rd_s),
    .addr(addr),
    .reg_data2port_in_0(reg_data2port_w[0]),
    .reg_data2port_in_1(reg_data2port_w[1]),
    .reg_data2port_in_2(reg_data2port_w[2]),
    .reg_data2port_in_3(reg_data2port_w[3]),
    .wr_en(wr_en_w),
    .rd_data(rd_data),
    .ack(ack)
  );

  assign reg_data2port_out_0 = reg_data2port_w[0];
  assign reg_data2port_out_1 = reg_data2port_w[1];
  assign reg_data2port_out_2 = reg_data2port_w[2];
  assign reg_data2port_out_3 = reg_data2port_w[3];
endmodule : reg_top
