#include "Veep.h"
#include "Veep_reg16x8__A3_D10.h"
#include "Veep_async_rom__A10_D10.h"
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
  top->clk = 0;

  // run simulation for many clock cycles
  for (i = 0; i < 300; i++) {

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
