module controlpath #(
  parameter REG_WIDTH
)(
  input logic clk,
  input logic cpen,
  input logic nd,
  input logic zd,
  input logic cd,
  input logic vd,
  input logic[REG_WIDTH-1:0] ra,
  input logic[REG_WIDTH-1:0] memdata,
  input logic [REG_WIDTH-1:0] immext,
  output logic[REG_WIDTH-1:0] ins,
  output logic[REG_WIDTH-1:0] retadr,
  output logic[REG_WIDTH-1:0] memaddr,
  output logic flagc
);

logic [REG_WIDTH-1:0] pc, pcnext;

logic [3:0] jmpcond;
logic jmp;
logic [REG_WIDTH-1:0] offset;

logic ffn, ffz, ffc, ffv;

next #(REG_WIDTH) next(
  .flagn(ffn),
  .flagz(ffz),
  .flagc(ffc),
  .flagv(ffv),
  .jmpcond(jmpcond),
  .jmp(jmp),
  .offset(offset),
  .ra(ra),
  .pc(pc),
  .pcnext(pcnext)
);

always_ff @ (posedge clk) begin
  pc <= pcnext;
end

logic cven, nzen;

logic ffn_en, ffz_en, ffc_en, ffv_en;
always_comb begin
  ffn_en = nzen & cpen;
  ffz_en = nzen & cpen;
  ffc_en = cven & cpen;
  ffv_en = cven & cpen;
end

always_ff @ (posedge clk) begin
  if (ffn_en)
    ffn <= nd;

  if (ffz_en)
    ffz <= zd;

  if (ffc_en)
    ffc <= cd;

  if (ffv_en)
    ffv <= vd;
end

controldecode #(REG_WIDTH) controldecode(
  .immext(immext),
  .ins(memdata),
  .jmpcond(jmpcond),
  .jmp(jmp),
  .joffset(offset),
  .cven(cven),
  .nzen(nzen)
);

assign flagc = ffc;
assign ins = memdata;
assign memaddr = pc;
assign retadr = pc + 1;

endmodule
