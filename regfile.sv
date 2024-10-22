module regfile # (
  parameter ADDR_WIDTH,
  parameter DATA_WIDTH
)(
  input logic clk, 
  input logic wen1,
  input logic [ADDR_WIDTH-1:0] ad1,
  input logic [ADDR_WIDTH-1:0] ad2,
  input logic [ADDR_WIDTH-1:0] ad3,
  input logic [DATA_WIDTH-1:0] din1,
  output logic [DATA_WIDTH-1:0] dout2,
  output logic [DATA_WIDTH-1:0] dout3
);

logic [DATA_WIDTH-1:0] registers [2**ADDR_WIDTH-1:0];

always_comb begin
  dout2 = registers[ad2];
  dout3 = registers[ad3];
end

always @(negedge clk) begin
if(wen1)
        registers[ad1] <= din1;
end
endmodule
