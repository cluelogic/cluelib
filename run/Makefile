#
# Makefile
#

help:
	@echo "Usage: make [TARGET]"
	@echo "  Runs a sanity check."
	@echo "  TARGET can be 'modelsim', 'questa', 'incisive', or 'vcs'."

# constants

src_dir  := ../src
test_dir := ../test
compile_files := $(src_dir)/cl_pkg.sv $(src_dir)/cl_dpi.cc $(test_dir)/test_from_examples.sv
compile_opts  := +incdir+$(src_dir)+$(test_dir)
top_module    := test_from_examples

include modelsim.mk
include incisive.mk
include vcs.mk