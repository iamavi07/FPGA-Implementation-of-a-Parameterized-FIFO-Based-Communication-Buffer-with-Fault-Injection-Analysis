`timescale 1ns/1ps

module fifo_comm_wrapper #
(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input  wire                 clk,
    input  wire                 rst_n,

    input  wire                 valid_in,
    input  wire                 ready_in,
    input  wire                 fault_mode,

    input  wire [WIDTH-1:0]     data_in,

    output wire                 ready_out,
    output wire                 valid_out,
    output wire [WIDTH-1:0]     data_out,

    output wire                 full,
    output wire                 empty
);

wire wr_en;
wire rd_en;

wire [$clog2(DEPTH+1)-1:0] count;

assign wr_en =
            fault_mode ?
            valid_in :
            (valid_in && !full);

assign rd_en =
            fault_mode ?
            ready_in :
            (ready_in && !empty);

assign ready_out = !full;
assign valid_out = !empty;

fifo_core
#(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
)
u_fifo
(
    .clk(clk),
    .rst_n(rst_n),

    .wr_en(wr_en),
    .rd_en(rd_en),

    .data_in(data_in),
    .data_out(data_out),

    .full(full),
    .empty(empty),
    .count(count)
);

endmodule
