module mem_reg(
  clk, rst_n, d, q
);
  input clk, rst_n;
  input [7:0] d;
  output reg [7:0] q;

  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin 
      q <= 0;
    end 
    else begin
      q <= d;
    end 
  end 
endmodule : mem_reg