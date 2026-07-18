`timescale 1ns/1ps

module fifo_core #
(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input  wire                 clk,
    input  wire                 rst_n,

    input  wire                 wr_en,
    input  wire                 rd_en,
    input  wire [WIDTH-1:0]     data_in,

    output reg  [WIDTH-1:0]     data_out,
    output wire                 full,
    output wire                 empty,
    output reg  [$clog2(DEPTH+1)-1:0] count
);

localparam ADDR_WIDTH = $clog2(DEPTH);

reg [WIDTH-1:0] mem [0:DEPTH-1];

reg [ADDR_WIDTH-1:0] wr_ptr;
reg [ADDR_WIDTH-1:0] rd_ptr;

assign full  = (count == DEPTH);
assign empty = (count == 0);

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
    begin
        wr_ptr   <= 0;
        rd_ptr   <= 0;
        count    <= 0;
        data_out <= 0;
    end
    else
    begin

        case ({wr_en, rd_en})

            2'b10:
            begin
                if(!full)
                begin
                    mem[wr_ptr] <= data_in;
                    wr_ptr <= wr_ptr + 1'b1;
                    count  <= count + 1'b1;
                end
            end

            2'b01:
            begin
                if(!empty)
                begin
                    data_out <= mem[rd_ptr];
                    rd_ptr <= rd_ptr + 1'b1;
                    count  <= count - 1'b1;
                end
            end

            2'b11:
            begin
                if(!full && !empty)
                begin
                    mem[wr_ptr] <= data_in;
                    data_out <= mem[rd_ptr];

                    wr_ptr <= wr_ptr + 1'b1;
                    rd_ptr <= rd_ptr + 1'b1;
                end
            end

            default:
            begin
            end

        endcase
    end
end

endmodule
