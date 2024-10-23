module aludecode (
  input logic flagcin,
  input logic [2:0] aluopc,
  output logic addsubcin,
  output logic invert
);

always_comb begin
  case (aluopc)
    0, 1, 5, 7: addsubcin = 0;
    2, 6: addsubcin = 1;
    3, 4: addsubcin = flagcin;
  endcase

  case (aluopc)
    0, 1, 3, 5, 7: invert = 0;
    2, 4, 6: invert = 1;
  endcase
end

endmodule
