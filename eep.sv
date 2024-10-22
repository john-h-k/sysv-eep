module eep #(
  parameter REG_DEPTH = 8,
  parameter REG_WIDTH = 16,
  parameter INSTR_WIDTH = 16,
  localparam REG_ADDR_WIDTH=$clog2(REG_DEPTH)
)(
  input logic clk,
  input logic [REG_WIDTH-1:0] pc,
  input logic wen1,
  input logic [REG_ADDR_WIDTH-1:0] ad1,
  input logic [REG_ADDR_WIDTH-1:0] ad2,
  input logic [REG_ADDR_WIDTH-1:0] ad3,
  input logic [REG_WIDTH-1:0] din1,
  output logic [REG_WIDTH-1:0] dout2,
  output logic [REG_WIDTH-1:0] dout3
);

typedef logic [REG_WIDTH-1:0] register;
typedef logic [INSTR_WIDTH-1:0] instr;

logic dram_we;

register dram_rd_ad;
register dram_wt_ad;

register dram_in;
register dram_out;

logic code_we;
instr n_instr;

rom # (INSTR_WIDTH, INSTR_WIDTH) code(
  clk,
  code_we,
  pc,
  n_instr
);

dram # (REG_WIDTH, REG_WIDTH) data(
  clk,
  dram_we,
  dram_rd_ad,
  dram_wt_ad,
  dram_in,
  dram_out
);

regfile # (REG_ADDR_WIDTH, REG_WIDTH) regfile(
  clk,
  wen1,
  ad1,
  ad2,
  ad3,
  din1,
  dout2,
  dout3
);

endmodule
