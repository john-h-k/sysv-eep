module dpdecode #(
  parameter REG_WIDTH
)(
  input logic [REG_WIDTH-1:0] ins,
  output logic op2sel,
  output logic ad1selc,
  output logic wen1,
  output logic pcwrite,
  output logic ext,
  output logic [2:0] a,
  output logic [2:0] b,
  output logic [2:0] c,
  output logic [2:0] aluopc,
  output logic [3:0] scnt,
  output logic [1:0] shiftopc,
  output logic [15:0] imms8,
  output logic [15:0] imms5,
  output logic memldr,
  output logic memstr
);

logic alu_ins;
logic shift_ins;
logic cmp_ins;

always_comb begin
  case (ins[14:12])
    3'b000: begin
      alu_ins = 0;
      shift_ins = 0;
      cmp_ins = 0;
    end
    3'b110: begin
      alu_ins = 0;
      shift_ins = 0;
      cmp_ins = 1;
    end
    3'b111: begin
      alu_ins = 0;
      shift_ins = 1;
      cmp_ins = 0;
    end
    default: begin
      alu_ins = !ins[15];
      shift_ins = 0;
    end
  endcase
end

assign memldr = ins[15:13] == 4;
assign memstr = ins[15:13] == 5;

assign op2sel = !(shift_ins & !ins[15]) & ins[8];
assign ad1selc = !(!(alu_ins & !ins[15]) | ins[8]);
assign pcwrite = ins[15:8] == 'b11001110;
assign wen1 = memldr | pcwrite | (!cmp_ins & !ins[15]);
assign ext = ins[15:8] == 'hD0;
assign a = ins[11:9];
assign b = ins[7:5];
assign c = ins[4:2];
assign aluopc = ins[14:12];
assign scnt = ins[3:0];
assign shiftopc = {ins[8], ins[4]};
assign imms8 = {{8{ins[7]}}, ins[7:0]};
assign imms5 = {{11{ins[4]}}, ins[4:0]};

endmodule
