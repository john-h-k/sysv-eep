module shift #(
  parameter REG_WIDTH
)(
  input logic [REG_WIDTH-1:0] in,
  input logic sftin,
  input logic [3:0] scnt,
  input logic [1:0] shiftopc,
  output logic sftout,
  output logic [REG_WIDTH-1:0] out
);

always_comb begin
  case (shiftopc)
    'b00: begin
      out = in << scnt;
      sftout = in[REG_WIDTH-1];
    end
    'b01: begin
      out = in >> scnt;
      sftout = in[0];
    end
    'b10: begin
      out = in >>> scnt;
      sftout = in[0];
    end
    'b11: begin
      out = in >> scnt | ({sftin, {(REG_WIDTH-1){1'b0}}});
      sftout = in[0];
    end
  endcase
end

endmodule;

