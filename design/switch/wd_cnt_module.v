module watchdog (
    input clk,      // Clock input
    input rst_n,      // Reset input
    input feed,     // Watchdog feed input
    output reg wdog // Watchdog output
);

    // Parameters
    parameter TIMEOUT = 5000; // Timeout value (adjust as needed)

    // State machine states
    localparam IDLE = 2'b00;
    localparam ACTIVE = 2'b01;
    localparam TIMEOUT_STATE = 2'b10;

    // Internal counter
    reg [15:0] count;
    reg wdog_s;

    // State machine variable
    reg [1:0] state;

    // Initializations
    always @(posedge clk or negedge rst_n) begin
        if (!rst) begin
            count <= 0;
            state <= IDLE;
        end else if (state == TIMEOUT_STATE) begin
            count <= 0;
            state <= IDLE;
        end else begin
            count <= count + 1;
        end
    end

    // Watchdog logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wdog_s <= 0;
            end else begin
        case (state)
            IDLE: begin
                wdog_s <= 0;
                if (feed) begin
                    state <= ACTIVE;
                end
            end

            ACTIVE: begin
            wdog_s <= 0;
                if (count == TIMEOUT) begin
                    state <= TIMEOUT_STATE;
                end else if (~feed) begin
                    state <= IDLE;
                end
            end

            TIMEOUT_STATE: begin
                wdog_s <= 1;
            end
        endcase
        end
    end

    assign wdog = wdog_s;
endmodule
