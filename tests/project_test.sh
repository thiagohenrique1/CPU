#!/bin/bash
set -e

iverilog -y ../ -I ../ -o project_test.vvp project_test.v;
vvp project_test.vvp;
