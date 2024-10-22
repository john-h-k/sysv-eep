module nzgen #(
  parameter REG_WIDTH
)(
  input logic [REG_WIDTH-1:0] data,
  output logic flagn,
  output logic flagz
);

always_comb begin
  flagn = data[15];
  flagz = data == 0;
end

endmodule
