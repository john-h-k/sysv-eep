module addsub #(
  parameter REG_WIDTH
)(
  input logic [REG_WIDTH-1:0] inb,
  input logic [REG_WIDTH-1:0] ina,
  input logic invert,
  input logic carryin,
  output logic flagv,
  output logic carryout,
  output logic [REG_WIDTH-1:0] out
);

logic [REG_WIDTH-1:0] inb_with_invert;
logic [REG_WIDTH:0] sum;

assign inb_with_invert = invert ? ~inb : inb;
assign sum = ina + inb_with_invert + {16'b0, carryin};

assign out = sum[REG_WIDTH-1:0];
assign carryout = sum[REG_WIDTH];

assign flagv = (ina[15] ^ inb_with_invert[15]) & (ina[15] | sum[15]);

endmodule

