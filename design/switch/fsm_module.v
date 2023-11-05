typedef enum { ADDR_WAIT, PARITY_LOAD, DATA_LOAD, PORT_BUSY, IDLE} state_m;

module fsm # (
    parameter W_WIDTH = 8
)(
    clk, rst_n,
    sw_en,
    port_addr,
    data_in,
    port_busy,
    wr_en
);

    input clk, rst_n;
    input sw_en, port_busy;
    input [W_WIDTH-1:0] port_addr, data_in;
    output wr_en; 

    state_m state_ff, state_nxt;
    reg wr_en_ff, wr_en_nxt, port_busy_ff, port_busy_nxt;

    assign wr_en = wr_en_ff;

    always @(posedge clk or rst_n) begin
        if(!rst_n) begin
            state_ff <= IDLE;
            wr_en_ff <= 1'b0;
            port_busy_ff <= 1'b0;
        end 
        else begin
            state_ff <= state_nxt;
            wr_en_ff <= wr_en_nxt;
            port_busy_ff <= port_busy_nxt;
        end 
    end

    always @( * ) begin
        state_nxt = state_ff;
        wr_en_nxt = wr_en_ff;
        port_busy_nxt = port_busy_ff;

        case(state_ff)
            IDLE: begin
                if(!sw_en) begin
                    state_nxt = IDLE;
                    wr_en_nxt = 1'b0;
                end 
                else if(port_busy) begin
                    state_nxt = PORT_BUSY;
                end 
                else begin
                    state_nxt = ADDR_WAIT;
                end 
            end
        
            //this approach just passes byte after bytes to the output, if one of the bytes coresponds with one of the ports address
            //there is no packet delimitation known to the FSM
            ADDR_WAIT : begin
                if(!sw_en) begin
                    state_nxt = IDLE;
                    wr_en_nxt = 1'b0;
                end 
                else if(port_busy) begin
                    state_nxt = PORT_BUSY;
                    wr_en_nxt = 1'b0;
                end
                else if(data_in == port_addr) begin
                    state_nxt = DATA_LOAD;
                    wr_en_nxt = 1'b1;
                end 
                else begin
                    state_nxt = ADDR_WAIT;
                    wr_en_nxt = 1'b0;
                end
            end 

            DATA_LOAD : begin
                if(!sw_en) begin
                    state_nxt = IDLE;
                    wr_en_nxt = 1'b0;
                end 
                else if(port_busy) begin
                    state_nxt = PORT_BUSY;
                    wr_en_nxt = 1'b0;
                end
                else if (!sw_en && !port_busy) begin
                    state_nxt = PARITY_LOAD;
                    wr_en_nxt = 1'b1;
                end
                else begin
                    state_nxt = DATA_LOAD;
                    wr_en_nxt = 1'b1;
                end 
            end 

            PARITY_LOAD : begin
                if(!sw_en) begin
                    state_nxt = IDLE;
                    wr_en_nxt = 1'b0;
                end 
                else begin
                    state_nxt = ADDR_WAIT;
                    wr_en_nxt = 1'b0;
                end
            end

            PORT_BUSY : begin
                if(!sw_en) begin
                    state_nxt = IDLE;
                    wr_en_nxt = 1'b0;
                end 
                else if(port_busy) begin
                    state_nxt = PORT_BUSY;
                    wr_en_nxt = 1'b0;
                end 
            end 
        endcase
    end
endmodule : fsm