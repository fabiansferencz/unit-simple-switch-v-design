module mem_top # (
  parameter NUM_OF_REG = 4
)(
  clk, rst_n, 
  sel_en, 
  addr, wr_data, rd_data, wr_rd_s,
  mem_out,
  ack
);
  input clk, rst_n;
  input sel_en, wr_rd_s;
  input [7:0] addr, wr_data;
  output [7:0] rd_data;
  output [7:0] mem_out [NUM_OF_REG];
  output ack;

  reg[7:0] data_in[NUM_OF_REG] = '{default : 0};
  reg[7:0] data_out[NUM_OF_REG];

  reg ack_nxt, ack_ff;
  reg [7:0] out_data_nxt, out_data_ff;

  genvar i;
  generate for(i = 0; i < NUM_OF_REG; i++) begin
      mem_reg DUT_REG(.clk(clk), .rst_n(rst_n), .d(data_in[i]), .q(data_out[i]));
      assign mem_out[i] = data_out[i];
  end	
  endgenerate 
  
  //combinational
  always @(*) begin
      ack_nxt = ack_ff;
      out_data_nxt = out_data_ff;

      if(sel_en) begin
          if(wr_rd_s) begin
            data_in[addr] = wr_data;
            ack_nxt = 1;
          end	
          else begin
            out_data_nxt = data_out[addr];
            ack_nxt = 1;
          end	
      end
      else begin
          ack_nxt = 0;
          out_data_nxt = 0;
      end	
  end	

  //sequential
  always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
        ack_ff <= 0;
        out_data_ff <= 0;

      end 
      else begin
          ack_ff <= ack_nxt;
          out_data_ff <= out_data_nxt;
      end 
  end 

  assign rd_data = out_data_ff;
  assign ack = ack_ff;
endmodule : mem_top
