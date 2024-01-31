module reg_fsm # (
  parameter NUM_OF_REG = 4
)(
  input clk, rst_n,
  input sel_en, wr_rd_s,
  input [7:0] addr,
  input [7:0] reg_data2port_in_0, reg_data2port_in_1, reg_data2port_in_2, reg_data2port_in_3,
  
  output [7:0] wr_en,
  output [7:0] rd_data,
  output ack
);

  reg ack_nxt, ack_ff;
  reg [7:0] rd_data_nxt, rd_data_ff;
  reg [7:0] wr_en_nxt, wr_en_ff;

  //combinational
  always @(*) begin
    ack_nxt = ack_ff;
    rd_data_nxt = rd_data_ff;
    wr_en_nxt = wr_en_ff;

    if(sel_en) begin
      if(wr_rd_s) begin
        wr_en_nxt = 0;//cleare previous wr_en for continous writting
        wr_en_nxt[addr] = 1;
        ack_nxt = 1;
      end	
      else begin
        case(addr)
            0 : rd_data_nxt = reg_data2port_in_0;
            1 : rd_data_nxt = reg_data2port_in_1;
            2 : rd_data_nxt = reg_data2port_in_2;
            3 : rd_data_nxt = reg_data2port_in_3;
        endcase
        ack_nxt = 1;
      end	
    end
    else begin
      ack_nxt = 0;
      rd_data_nxt = 0;
      wr_en_nxt = 0;
    end	
  end	

  //sequential
  always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
      ack_ff <= 0;
      rd_data_ff <= 0;
      wr_en_nxt <= 0;
    end 
    else begin
      ack_ff <= ack_nxt;
      rd_data_ff <= rd_data_nxt;
      wr_en_ff <= wr_en_nxt;
    end 
  end 

  assign rd_data = rd_data_ff;
  assign ack = ack_ff;
  assign wr_en = wr_en_ff;

endmodule : reg_fsm
