`include "reg_rtl.v"

module reg_block # (
  parameter NUM_OF_REG = 4
)(
  input clk, rst_n,
  input [7:0] wr_en, wr_data,
  output [7:0] reg_data2port_out_0, reg_data2port_out_1, reg_data2port_out_2, reg_data2port_out_3
);

  wire [7:0] reg_data2port_out [NUM_OF_REG-1:0];

  //register addr
  //reg_0 -> 8'h00
  //reg_1 -> 8'h02
  //reg_2 -> 8'h04
  //reg_3 -> 8'h08

  genvar i;
  generate for(i = 0; i < NUM_OF_REG; i=i+1) begin
    reg_rtl CONFIG_DUT_REG(.clk(clk), .rst_n(rst_n), .wr_en(wr_en[i]), .d(wr_data), .q(reg_data2port_out[i]));
  end	
  endgenerate 

  assign reg_data2port_out_0 = reg_data2port_out[0];
  assign reg_data2port_out_1 = reg_data2port_out[1];
  assign reg_data2port_out_2 = reg_data2port_out[2];
  assign reg_data2port_out_3 = reg_data2port_out[3];
endmodule : reg_block
