//`include "wd_module.v"
`include "fsm_out_module.v"

module fsm_out_top # (
    parameter W_WIDTH = 8
)(
    input clk, rst_n,
    input [W_WIDTH-1:0] port_addr, fifo_data,
    input port_rd, port_empty,
    output rd_en,
    output [W_WIDTH-1:0] port_out
);

    // wire feed_w, wdog_w;
    wire rd_en_w;
    wire [W_WIDTH-1:0] port_out_w;

    // watchdog # () WD_DUT (
    //     .clk(clk),
    //     .rst_n(rst_n),
    //     .feed(feed_w),
    //     .wdog(wdog_w)
    // );

    fsm_out # (
        .W_WIDTH(W_WIDTH)
    ) FSM_OUT_DUT (
        .clk(clk),
        .rst_n(rst_n),
        .port_addr(port_addr),
        .fifo_data(fifo_data),
        .port_rd(port_rd),
        .port_empty(port_empty),
        .rd_en(rd_en_w),
        .port_out(port_out_w)
    );

    assign rd_en = rd_en_w;
    assign port_out = port_out_w;
endmodule : fsm_out_top