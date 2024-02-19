// Code your design here
`include "port_top.v"
`include "mem_top.v"


module switch_top (
  clk, rst_n,
  //Input interface signals
  sw_enable_in, read_out, data_in,
  //output ports interface signals
  port_out, port_ready, port_read,
  //mem addr interface signals
  mem_sel_en, mem_addr, mem_wr_rd_s, mem_wr_data, mem_rd_data, mem_ack
);

  parameter NUM_OF_PORTS = 4;
  parameter FIFO_SIZE = 64;
  parameter WORD_WIDTH = 8; //biti

  input clk, rst_n;

  //input interface signals
  input [WORD_WIDTH-1:0] data_in;
  input sw_enable_in;
  output read_out;

  //port interface signals
  input port_read[NUM_OF_PORTS];
  output [WORD_WIDTH-1:0] port_out[NUM_OF_PORTS];
  output port_ready[NUM_OF_PORTS];

  //mem interface signals
  input mem_sel_en, mem_wr_rd_s;
  input [WORD_WIDTH-1:0] mem_addr;
  input [WORD_WIDTH-1:0] mem_wr_data; 
  output [WORD_WIDTH-1:0] mem_rd_data;
  output mem_ack;

  wire [WORD_WIDTH-1:0] mem_reg2port [NUM_OF_PORTS];
  wire rd_port2out[NUM_OF_PORTS];

  assign read_out = rd_port2out.or();//.or() works only in SV

  //============================================

  reg_top # (
    .NUM_OF_REG(NUM_OF_PORTS),
    .W_WIDTH(W_WIDTH)
  ) DUT_MEM (
    .clk(clk),
    .rst_n(rst_n),
    .sel_en(mem_sel_en),
    .wr_rd_s(mem_wr_rd_s),
    .addr(mem_addr),
    .wr_data(mem_wr_data),
    .rd_data(mem_rd_data),
    .ack(mem_ack),
    .mem_out(mem_reg2port)
  );

  genvar i;
  generate 
    for(i = 0; i < NUM_OF_PORTS; i++) begin
      port_top # (
        .NUM_OF_PORTS(NUM_OF_PORTS),
        .FIFO_SIZE(FIFO_SIZE),
        .W_WIDTH(WORD_WIDTH)
      ) DUT_PORT (
        .clk(clk),
        .rst_n(rst_n),
        .sw_en(sw_enable_in),
        .port_data(data_in),
        .rd_out(rd_port2out[i]),
        .port_addr(mem_reg2port[i]),
        .port_out(port_out[i]),
        .port_rdy(port_ready[i]),
        .port_rd(port_read[i])
      );
    end
  endgenerate
endmodule : switch_top