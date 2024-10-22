module datapath #(
  parameter REG_DEPTH,
  parameter REG_WIDTH,
  localparam REG_ADDR_WIDTH=$clog2(REG_DEPTH)
)(
  input logic clk,
  input logic [REG_WIDTH-1:0] pcin,
  input logic [REG_WIDTH-1:0] ins,
  input logic flagcin,
  input logic dpen,
  input logic [REG_WIDTH-1:0] memdout,
  output logic flagn,
  output logic flagz,
  output logic flagc,
  output logic flagv,
  output logic [REG_WIDTH-1:0] immext,
  output logic [REG_WIDTH-1:0] raout,
  output logic [REG_WIDTH-1:0] memaddr,
  output logic [REG_WIDTH-1:0] memdin,
  output logic memwen
);

logic [2:0] a, b, c;
logic [2:0] aluopc;
logic [3:0] scnt;
logic [1:0] shiftopc;

logic op2sel, ad1selc, dp_wen1, pcwrite, ext, memldr, memstr;

logic [15:0] imms8, imms5;

dpdecode # (REG_WIDTH) decode(
   .ins(ins),
   .op2sel(op2sel),
   .ad1selc(ad1selc),
   .wen1(dp_wen1),
   .pcwrite(pcwrite),
   .ext(ext),
   .a(a),
   .b(b),
   .c(c),
   .aluopc(aluopc),
   .scnt(scnt),
   .shiftopc(shiftopc),
   .imms8(imms8),
   .imms5(imms5),
   .memldr(memldr),
   .memstr(memstr)
);

logic wen1;
assign wen1 = dpen & dp_wen1;

logic ad1;
assign ad1 = ad1selc ? c : a;

logic [REG_WIDTH-1:0] ra, rb;

logic [REG_WIDTH-1:0] memdout_mux;
assign memdout_mux = memldr ? memdout : alu_out;

logic [REG_WIDTH-1:0] din1;
assign din1 = pcwrite ? pcin : memdout_mux;

reg16x8 # (REG_ADDR_WIDTH, REG_WIDTH) regfile(
  .clk(clk),
  .wen1(wen1),
  .ad1(ad1),
  .ad2(a),
  .ad3(b),
  .din1(din1),
  .dout2(ra),
  .dout3(rb)
);

extend # (REG_WIDTH) extend(
  .clk(clk),
  .data(imms8),
  .ext(ext),
  .immext(immext)
);

logic [REG_WIDTH-1:0] nz_data, alu_out;

always_comb begin
  if (memldr)
    nz_data = alu_out;
  else
    nz_data = memdout;
end

nzgen # (REG_WIDTH) nzgen(
  .data(nz_data),
  .flagn(flagn),
  .flagz(flagz)
);

alu # (REG_WIDTH) alu(
  .clk(clk),
  .ra(ra),
  .rb(rb),
  .flagcin(flagcin),
  .aluopc(aluopc),
  .shiftopc(shiftopc),
  .scnt(scnt),
  .op2sel(op2sel),
  .imm(immext),
  .flagc(flagc),
  .flagv(flagv),
  .out(alu_out)
);

endmodule
