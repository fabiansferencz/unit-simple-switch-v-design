`include "wd_module.v"
`include "fsm_in_module.v"

module fsm_in_top # (
    parameter W_WIDTH = 8
)(
    input clk, rst_n,
    input sw_en, port_busy,
    input [W_WIDTH-1:0] port_addr,
    input [W_WIDTH-1:0] data_in,
    output wr_en
);

    wire feed_w, wdog_w;

    watchdog # () WD_DUT (
        .clk(clk),
        .rst_n(rst_n),
        .feed(feed_w),
        .wdog(wdog_w)
    );

    fsm_in # (
        .W_WIDTH(W_WIDTH)
    ) FSM_IN_DUT (
        .clk(clk),
        .rst_n(rst_n),
        .sw_en(sw_en),
        .port_busy(port_busy),
        .wdog(wdog_w),
        .port_addr(port_addr),
        .data_in(data_in),
        .wr_en(wr_en),
        .feed(feed_w)
    );
endmodule : fsm_in_top