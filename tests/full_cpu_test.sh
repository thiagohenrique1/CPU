#!/bin/bash
set -e

iverilog -y ../ -o full_cpu_test.vvp full_cpu_test.v;
vvp full_cpu_test.vvp;
gtkwave dump_full_cpu.vcd
