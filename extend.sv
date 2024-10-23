module extend #(
  parameter REG_WIDTH
)(
  input logic clk,
  input logic [REG_WIDTH-1:0] data,
  input logic ext,
  output logic [REG_WIDTH-1:0] immext
);

logic [7:0] reg1;
logic ff1;
always_ff @(posedge clk) begin
  reg1 <= data[7:0];
  ff1 <= ext;
end

always_comb begin
  if (ff1)
    immext = {reg1, data[7:0]};
  else
    immext = data;
end

endmodule
