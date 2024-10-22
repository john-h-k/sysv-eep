#include "Veep.h"
#include "verilated.h"
#include "verilated_vcd_c.h"
#include <iostream>

#ifdef VBD
#include "../vbuddy.cpp"
#endif

int main(int argc, char **argv, char **env) {
  int i;
  int clk;

  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Veep *top = new Veep;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC *tfp = new VerilatedVcdC;
  top->trace(tfp, 99);
  tfp->open("eep.vcd");

  #ifdef VBD
  if (vbdOpen() != 1) {
    return -1;
  }

  vbdHeader("Lab 1: Counter");
  #endif

  // initialize simulation inputs
  top->clk = 1;
  top->wen1 = 1;
  top->ad1 = 1;
  top->ad2 = 1;
  top->ad3 = 1;
  top->din1 = 0;
  // run simulation for many clock cycles
  for (i = 0; i < 300; i++) {
    top->din1 = i;

    // dump variables into VCD file and tog
    for (clk = 0; clk < 2; clk++) {
      tfp->dump(2 * i + clk);
      // unit is
      top->clk = !top->clk;
      top->eval();
    }

    // int shifts[4] = { 0, 4, 8, 16 };
    // for (int j = 4; j > 0; j--) {
    //   vbdHex(i, (int(top->count) >> (shifts[j - 1])) & 0xF);
    // }

    #ifdef VBD
    vbdPlot(int(top->dout2), 0, 255);
    vbdCycle(i + 1);
    #endif

    std::cout << "Register " << top->ad2 << " = " << top->dout2 << std::endl;

    // top->en = (i > 4);
    if (Verilated::gotFinish()) {
      exit(0);
    }
  }

  #ifdef VBD
  vbdClose();
  #endif

  tfp->close();
  exit(0);
}
