module alu #(
  parameter REG_WIDTH
)(
  input logic clk,
  input logic [REG_WIDTH-1:0] ra,
  input logic [REG_WIDTH-1:0] rb,
  input logic flagcin,
  input logic[2:0] aluopc,
  input logic shiftopc,
  input logic scnt,
  input logic op2sel,
  input logic imm,
  output logic flagc,
  output logic flagv,
  output logic [REG_WIDTH-1:0] out
);

logic [REG_WIDTH:0] res;

always_comb begin
  case (aluopc)
    2'b00: begin
      // ADD
      res = ra + rb;
      out = res[REG_WIDTH-1:0];
      res = ra + rb;
      out = res[REG_WIDTH-1:0];
      flagc = out[REG_WIDTH];
      flagc = out[REG_WIDTH];
    end
    2'b01: begin
      // SUB
      res = ra - rb;
      out = res[REG_WIDTH-1:0];
      flagc = out[REG_WIDTH];
    end
    // 2'b10: begin
    // end
    // 2'b11: begin
    // end
    default:
      out = 'b0;
  endcase
end


endmodule
