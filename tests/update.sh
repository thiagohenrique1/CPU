#!/bin/bash
set -e

iverilog -y ../ -o cpu_tb.vvp cpu_tb.v;
vvp cpu_tb.vvp;
