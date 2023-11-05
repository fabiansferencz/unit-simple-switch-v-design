module mem_reg(
    clk, rst_, d, q
);
    input clk, rst_;
    input [7:0] d;
    output reg [7:0] q;
  
    always @(posedge clk or negedge rst_) begin
      if(!rst_) begin 
            q <= 0;
        end 
        else begin
            q <= d;
        end 
    end 
endmodule : mem_reg