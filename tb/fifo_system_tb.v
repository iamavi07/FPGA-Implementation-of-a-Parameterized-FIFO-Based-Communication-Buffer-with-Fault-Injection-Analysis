`timescale 1ns/1ps

module fifo_system_tb;

parameter WIDTH = 8;
parameter DEPTH = 16;

reg clk;
reg rst_n;

reg valid_in;
reg ready_in;
reg fault_mode;

reg [WIDTH-1:0] data_in;

wire ready_out;
wire valid_out;
wire [WIDTH-1:0] data_out;

wire full;
wire empty;

fifo_comm_wrapper
#(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
)
dut
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

always #10 clk = ~clk;

integer i;

initial
begin

    clk = 0;
    rst_n = 0;

    valid_in = 0;
    ready_in = 0;
    fault_mode = 0;
    data_in = 0;

    #50;
    rst_n = 1;

    //--------------------------------------------------
    // PHASE 1 : FAULT MODE
    //--------------------------------------------------

    $display("FAULT MODE START");

    fault_mode = 1;

    for(i=0;i<20;i=i+1)
    begin

        @(posedge clk);

        valid_in <= 1;
        ready_in <= (i%2);

        data_in <= i + 8'h10;

    end

    #100;

    //--------------------------------------------------
    // PHASE 2 : NORMAL MODE
    //--------------------------------------------------

    $display("NORMAL MODE START");

    fault_mode = 0;

    for(i=0;i<20;i=i+1)
    begin

        @(posedge clk);

        valid_in <= 1;
        ready_in <= 1;

        data_in <= i + 8'h40;

    end

    @(posedge clk);

    valid_in <= 0;
    ready_in <= 1;

    #300;

    $stop;

end

endmodule
