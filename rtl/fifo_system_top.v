`timescale 1ns/1ps

module fifo_system_top
(
    input  wire         CLOCK_50,

    input  wire [9:0]   SW,
    input  wire [3:0]   KEY,

    output wire [9:0]   LEDR,

    output wire [6:0]   HEX0,
    output wire [6:0]   HEX1
);

wire clk;
wire rst_n;

wire valid_in;
wire ready_in;
wire fault_mode;

wire [7:0] data_in;
wire [7:0] data_out;

wire ready_out;
wire valid_out;

wire full;
wire empty;

assign clk = CLOCK_50;

assign rst_n = KEY[3];

assign data_in    = SW[7:0];
assign valid_in   = SW[8];
assign fault_mode = SW[9];

assign ready_in   = ~KEY[0];

fifo_comm_wrapper
#(
    .WIDTH(8),
    .DEPTH(16)
)
u_wrapper
(
    .clk(clk),
    .rst_n(rst_n),

    .valid_in(valid_in),
    .ready_in(ready_in),
    .fault_mode(fault_mode),

    .data_in(data_in),

    .ready_out(ready_out),
    .valid_out(valid_out),

    .data_out(data_out),

    .full(full),
    .empty(empty)
);

assign LEDR[0] = ready_out;
assign LEDR[1] = valid_out;
assign LEDR[2] = fault_mode;
assign LEDR[3] = full;
assign LEDR[4] = empty;

assign LEDR[9:5] = 5'b0;

hex_decoder h0
(
    .bin(data_out[3:0]),
    .seg(HEX0)
);

hex_decoder h1
(
    .bin(data_out[7:4]),
    .seg(HEX1)
);

endmodule



module hex_decoder
(
    input  [3:0] bin,
    output reg [6:0] seg
);

always @(*)
begin
    case(bin)

        4'h0: seg = 7'b1000000;
        4'h1: seg = 7'b1111001;
        4'h2: seg = 7'b0100100;
        4'h3: seg = 7'b0110000;
        4'h4: seg = 7'b0011001;
        4'h5: seg = 7'b0010010;
        4'h6: seg = 7'b0000010;
        4'h7: seg = 7'b1111000;
        4'h8: seg = 7'b0000000;
        4'h9: seg = 7'b0010000;
        4'hA: seg = 7'b0001000;
        4'hB: seg = 7'b0000011;
        4'hC: seg = 7'b1000110;
        4'hD: seg = 7'b0100001;
        4'hE: seg = 7'b0000110;
        4'hF: seg = 7'b0001110;

        default: seg = 7'b1111111;

    endcase
end

endmodule
