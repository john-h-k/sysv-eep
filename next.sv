module next #(
  parameter REG_WIDTH
)(
  input logic flagn,
  input logic flagz,
  input logic flagc,
  input logic flagv,
  input logic[3:0] jmpcond,
  input logic jmp,
  input logic[REG_WIDTH-1:0] offset,
  input logic[REG_WIDTH-1:0] ra,
  input logic[REG_WIDTH-1:0] pc,
  output logic[REG_WIDTH-1:0] pcnext
);

logic cond_jmp, cond_ret;
cond cond(
  .flagn(flagn),
  .flagz(flagz),
  .flagc(flagc),
  .flagv(flagv),
  .jmpcond(jmpcond),
  .jump(cond_jmp),
  .ret(cond_ret)
);

logic[REG_WIDTH-1:0] add;
assign add = pc + (jmp & cond_jmp ? offset : 1);

always_comb begin
  if (jmp & cond_ret)
    pcnext = ra;
  else
    pcnext = add;
end

endmodule
