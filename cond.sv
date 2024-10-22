module cond (
  input logic flagn,
  input logic flagz,
  input logic flagc,
  input logic flagv,
  input logic[3:0] jmpcond,
  output logic jump,
  output logic ret
);

logic out;

logic not_n_xor_v;
assign not_n_xor_v = !flagn ^ flagv;

always_comb begin
  case (jmpcond[3:1])
    3'b000, 3'b111: out = 1;
    3'b001: out = flagz;
    3'b010: out = flagc;
    3'b011: out = flagn;
    3'b100: out = not_n_xor_v;
    3'b101: out = not_n_xor_v & !flagz;
    3'b110: out = flagc & !flagz;
  endcase
end
 
assign jump = out ^ jmpcond[0];
assign ret = jmpcond == 4'b1111;

endmodule
