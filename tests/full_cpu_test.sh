#!/bin/bash
set -e

iverilog -y ../ -I ../ -o full_cpu_test.vvp full_cpu_test.v;
vvp full_cpu_test.vvp;
