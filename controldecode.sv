module controldecode #(
  parameter REG_WIDTH
)(
  input logic [REG_WIDTH-1:0] immext,
  input logic [REG_WIDTH-1:0] ins,
  output logic nzen,
  output logic cven,
  output logic[3:0] jmpcond,
  output logic jmp,
  output logic [REG_WIDTH-1:0] joffset
);

assign jmp = ins[15:12] == 4'b1100;
assign jmpcond = ins[11:8];
assign joffset = immext;
assign nzen = !ins[15];

always_comb begin
  case (ins[14:12])
    3 'b000, 3'b101: cven = 0;
    default: cven = !ins[15];
  endcase
end

endmodule
