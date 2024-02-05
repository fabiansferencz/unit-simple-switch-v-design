// module fifo_mem #(
//   parameter FIFO_SIZE = 64,
//   parameter W_WIDTH = 8
// )(
//   input clk, rst_n, 
//   input wr_en,
//   input [W_WIDTH-1:0] d,
//   output [W_WIDTH-1:0] q
// );

    
//   reg [W_WIDTH-1:0] ram [FIFO_SIZE-1:0];//a memory with 64 locations depth and 8 bits word

//   always @(posedge clk or negedge rst_n) begin
//     if(!rst_n) begin 
      
//     end 
//     else begin
//         if(wr_en) begin
//         end 

//         if(rd_en) begin
//         end
//     end 
//   end 

//   assign q = reg_data;
// endmodule : fifo_mem