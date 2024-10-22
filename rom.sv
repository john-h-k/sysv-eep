module rom #(
    parameter ADDR_WIDTH, 
    parameter DATA_WIDTH, 
    parameter FILE="",
    localparam DEPTH=2**ADDR_WIDTH - 1
    ) (
    input wire logic clk,
    input wire logic we,
    input wire logic [ADDR_WIDTH-1:0] addr_read,
    output     logic [DATA_WIDTH-1:0] data_out
    );

    logic [DATA_WIDTH-1:0] mem [DEPTH];

    initial begin
        if (FILE != 0) begin
            $display("Loading ROM", FILE);
            $readmemh(FILE, mem);
        end
    end

    always_ff @(posedge clk) begin
        data_out <= mem[addr_read];
    end
endmodule
