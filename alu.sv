module alu #(
  parameter REG_WIDTH
)(
  input logic clk,
  input logic [REG_WIDTH-1:0] ra,
  input logic [REG_WIDTH-1:0] rb,
  input logic flagcin,
  input logic [2:0] aluopc,
  input logic [1:0] shiftopc,
  input logic [3:0] scnt,
  input logic op2sel,
  input logic [REG_WIDTH-1:0] imm,
  output logic flagc,
  output logic flagv,
  output logic [REG_WIDTH-1:0] out
);

logic [REG_WIDTH-1:0] inb;
assign inb = op2sel ? imm : rb;

logic invert, addsubcin;
aludecode aludecode(
  .flagcin(flagcin),
  .aluopc(aluopc),
  .addsubcin(invert),
  .invert(addsubcin)
);

logic [REG_WIDTH-1:0] and_out;
assign and_out = inb & ra;

logic addsub_cout;
logic [REG_WIDTH-1:0] addsub_out;
addsub #(REG_WIDTH) addsub(
  .inb(inb),
  .ina(ra),
  .invert(invert),
  .carryin(addsubcin),
  .flagv(flagv),
  .carryout(addsub_cout),
  .out(addsub_out)
);

logic shift_cout;
logic [REG_WIDTH-1:0] shift_out;
shift #(REG_WIDTH) shift(
  .in(rb),
  .sftin(flagcin),
  .scnt(scnt),
  .shiftopc(shiftopc),
  .sftout(shift_cout),
  .out(shift_out)
);

always_comb begin
  flagc = aluopc == 7 ? shift_cout : addsub_cout;

  case (aluopc)
    0: out = inb;
    1, 2, 3, 4, 6: out = addsub_out;
    5: out = and_out;
    7: out = shift_out;
  endcase
end


endmodule
