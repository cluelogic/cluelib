#!/bin/bash
#
# testify.sh - creates a test from examples
#

sv_files=$*
bin_dir=./bin
test=test_from_examples

echo "//"
echo "// $test.sv - a test generated from code examples"
echo "//"
echo
echo "import cl::*;"
echo
echo "module $test;"
echo "  task automatic test;"
echo "    \$display( \"==========starting $test==========\" );"
for sv in $sv_files
do
    $bin_dir/testify.py --sv $sv
done
echo "    \$display( \"==========finished $test==========\" );"
echo "  endtask: test"
echo
echo "  initial test();"
echo "endmodule: $test"
