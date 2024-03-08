module fsm_out # (
    parameter W_WIDTH = 8
)(
    input clk, rst_n,
    input sw_en,
    input [W_WIDTH-1:0] port_addr, fifo_data,
    input port_rd, port_empty,
    output rd_en,
    output [W_WIDTH-1:0] port_out
);

    localparam IDLE_ST = 3;
    localparam ADD_SOF_ST = 0;
    localparam ADD_ADDR_ST = 1;
    localparam READ_FIFO_PKT_ST = 2;

    localparam SOF_BYTE = 8'hFF;
    localparam DELIMITER = 8'h55;

    //Solution for missing first byte of the pkt fromk fifo in between packets
    reg ovr_rd_en;//flag
    reg rd_en_ff, rd_en_nxt;
    reg [2:0] state_ff, state_nxt;
    reg [W_WIDTH-1:0] port_out_ff, port_out_nxt;

    always @( * ) begin
        state_nxt = state_ff;
        rd_en_nxt = rd_en_ff;
        port_out_nxt = port_out_ff;

        case(state_ff)
            IDLE_ST: begin
                if(sw_en == 0 || port_rd == 0 || port_empty == 1) begin
                    port_out_nxt = 8'h00;
                    state_nxt = IDLE_ST;
                end 
                else begin
                    state_nxt = ADD_SOF_ST;
                end 
            end

            ADD_SOF_ST: begin
                ovr_rd_en = 0;
                port_out_nxt = SOF_BYTE;
                rd_en_nxt = 1;//start reading data from packet
                state_nxt = ADD_ADDR_ST;
            end 

            ADD_ADDR_ST : begin
                port_out_nxt = port_addr;
                state_nxt = READ_FIFO_PKT_ST;
            end 

            READ_FIFO_PKT_ST : begin
                port_out_nxt = fifo_data;

                if(fifo_data == DELIMITER) begin
                    rd_en_nxt = 0;//disable reading for fifo and preapre the SOF and ADDR bytes
                    if(port_rd == 1 && port_empty == 0 && sw_en == 1) begin
                        ovr_rd_en = 1;//flag used for placing the fifo on hold until the SOF and ADDR are appended back to the packet
                        state_nxt = ADD_SOF_ST;
                    end    
                    else begin
                        state_nxt = IDLE_ST;
                    end 
                end 
                else begin
                    state_nxt = READ_FIFO_PKT_ST;
                end 
            end
        endcase
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            state_ff <= IDLE_ST;
            rd_en_ff <= 1'b0;
            port_out_ff <= 0;
        end 
        else begin
            state_ff <= state_nxt;
            rd_en_ff <= rd_en_nxt;
            port_out_ff <= port_out_nxt;
        end 
    end

    assign rd_en = (ovr_rd_en) ? 0 : rd_en_ff;
    assign port_out = port_out_ff;
endmodule : fsm_out