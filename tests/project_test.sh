#!/bin/bash
set -e

iverilog -y ../ -y ../aux/ -I ../ -I ../aux/ -o project_test.vvp project_test.v;
vvp project_test.vvp;
