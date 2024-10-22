module async_rom #(
    parameter ADDR_WIDTH, 
    parameter DATA_WIDTH, 
    parameter FILE="",
    localparam DEPTH=2**ADDR_WIDTH - 1
    ) (
    input wire logic [ADDR_WIDTH-1:0] addr,
    output     logic [DATA_WIDTH-1:0] dout
    );

    logic [DATA_WIDTH-1:0] mem [DEPTH];

    initial begin
        if (FILE != 0) begin
            $display("Loading ROM", FILE);
            $readmemh(FILE, mem);
        end
    end

    always_comb begin
        dout = mem[addr];
    end
endmodule
