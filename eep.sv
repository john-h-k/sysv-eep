module eep #(
  parameter REG_DEPTH = 8,
  parameter REG_WIDTH = 16,
  parameter INSTR_WIDTH = 16
)(
  input logic clk
);

localparam cpen = 1;
localparam dpen = 1;

logic flagn, flagz, flagc, flagv, flagcin;
logic wen;

logic [REG_WIDTH-1:0] codemem_data, codemem_addr, immext, ra, ins, retadr;

logic [REG_WIDTH-1:0] din, dout, addr;

datapath # (REG_DEPTH, REG_WIDTH) datapath(
  .clk(clk),
  .pcin(retadr),
  .ins(ins),
  .flagcin(flagcin),
  .dpen(dpen),
  .flagn(flagn),
  .flagz(flagz),
  .flagc(flagc),
  .flagv(flagv),
  .raout(ra),
  .memdout(dout),
  .memaddr(addr),
  .memdin(din),
  .memwen(wen),
  .immext(immext)
);

controlpath # (REG_WIDTH) controlpath(
  .clk(clk),
  .cpen(cpen),
  .nd(flagn),
  .zd(flagz),
  .cd(flagc),
  .vd(flagv),
  .ra(ra),
  .memdata(codemem_data),
  .immext(immext),
  .ins(ins),
  .retadr(retadr),
  .memaddr(codemem_addr),
  .flagc(flagcin)
);

async_rom # (INSTR_WIDTH, INSTR_WIDTH) codemem(
  .addr(codemem_addr),
  .dout(codemem_data)
);


async_ram # (REG_WIDTH, REG_WIDTH) datamem(
  .wen(wen),
  .din(din),
  .dout(dout),
  .addr(addr)
);

endmodule
