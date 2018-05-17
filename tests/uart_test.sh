#!/bin/bash
set -e

iverilog -y ../ -o uart_tb.vvp uart_tb.v;
vvp uart_tb.vvp;
gtkwave dump_uart.vcd
