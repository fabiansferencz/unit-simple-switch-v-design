// Code your design here
`include "port_top.v"
`include "reg_top.v"


module switch_top # (
  parameter NUM_OF_PORTS = 4,
  parameter FIFO_SIZE = 64,
  parameter WORD_WIDTH = 8
)(
  input clk, rst_n,

  input sw_enable_in,
  input [WORD_WIDTH-1:0] data_in,

  input [NUM_OF_PORTS-1:0] port_read,
  
  input mem_sel_en, mem_wr_rd_s,
  input [$clog2(NUM_OF_PORTS)-1:0] mem_addr,
  input [WORD_WIDTH-1:0] mem_wr_data, 

  output read_out,
  output [WORD_WIDTH-1:0] port_out_0,
  output [WORD_WIDTH-1:0] port_out_1,
  output [WORD_WIDTH-1:0] port_out_2,
  output [WORD_WIDTH-1:0] port_out_3,
  output [NUM_OF_PORTS-1:0] port_ready,
  output [(NUM_OF_PORTS*WORD_WIDTH)-1:0] mem_rd_data,
  output mem_ack
);

  wire [WORD_WIDTH-1:0] mem_rd_data_w [NUM_OF_PORTS-1:0];
  wire [WORD_WIDTH-1:0] mem_reg2port [NUM_OF_PORTS-1:0];
  wire [NUM_OF_PORTS-1:0] rd_port2out, ack_w;
  wire [WORD_WIDTH-1:0] port_out_w [NUM_OF_PORTS-1:0];
 

  //============================================

  genvar i;
  generate 
    for(i = 0; i < NUM_OF_PORTS; i = i + 1) begin
      reg_top # (
        .NUM_OF_PORTS(NUM_OF_PORTS),
        .REG_ADDR(i),
        .W_WIDTH(WORD_WIDTH)
      ) DUT_REG (
        .clk(clk),
        .rst_n(rst_n),
        .sel_en(mem_sel_en),
        .wr_rd_s(mem_wr_rd_s),
        .addr(mem_addr),
        .wr_data(mem_wr_data),
        .rd_data(mem_rd_data_w[i]),
        .ack(ack_w[i]),
        .reg_data2port_out(mem_reg2port[i])
      );


      port_top # (
        .FIFO_SIZE(FIFO_SIZE),
        .W_WIDTH(WORD_WIDTH)
      ) DUT_PORT (
        .clk(clk),
        .rst_n(rst_n),
        .sw_en(sw_enable_in),
        .port_data(data_in),
        .rd_out(rd_port2out[i]),
        .port_addr(mem_reg2port[i]),
        .port_out(port_out_w[i]),
        .port_rdy(port_ready[i]),
        .port_rd(port_read[i])
      );
    end
  endgenerate

  assign read_out = |rd_port2out;
  assign mem_ack = |ack_w;
  assign mem_rd_data = {mem_rd_data_w[3], mem_rd_data_w[2], mem_rd_data_w[1], mem_rd_data_w[0]};
  assign port_out_0 = port_out_w[0];
  assign port_out_1 = port_out_w[1];
  assign port_out_2 = port_out_w[2];
  assign port_out_3 = port_out_w[3];
endmodule : switch_top