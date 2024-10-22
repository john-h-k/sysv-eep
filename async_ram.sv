module async_ram #(
    parameter ADDR_WIDTH, 
    parameter DATA_WIDTH, 
    parameter FILE="",
    localparam DEPTH=2**ADDR_WIDTH - 1
    ) (
    input wire logic wen,
    input wire logic [ADDR_WIDTH-1:0] addr,
    input wire logic [DATA_WIDTH-1:0] din,
    output     logic [DATA_WIDTH-1:0] dout
    );

    logic [DATA_WIDTH-1:0] mem [DEPTH];

    initial begin
        if (FILE != 0) begin
            $display("Loading DRAM", FILE);
            $readmemh(FILE, mem);
        end
    end

    always_latch begin
        if (wen) begin
            mem[addr] = din;
        end
    end

    always_comb begin
        dout = mem[addr];
    end
endmodule
