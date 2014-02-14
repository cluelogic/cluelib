#
# modelsim.mk
#

# user definable variables

LIB_DIR  := $(HOME)/documents/work
LIB_NAME := work

# constants

src_dir  := ../src
test_dir := ../test

compile_files := $(src_dir)/cl_pkg.sv $(src_dir)/cl_dpi.cc $(test_dir)/test_from_examples.sv
compile_opts  := +incdir+$(src_dir)+$(test_dir) +define+CL_USE_MODELSIM
run_cmd_file  := modelsim.cmd
run_opts      :=
top_module    := test_from_examples

# targets

all: run

prep:
	vlib $(LIB_DIR)
	vmap $(LIB_NAME) $(LIB_DIR)

run: 
	vlog $(compile_opts) $(compile_files)
	vsim $(run_opts) $(top_module) < $(run_cmd_file)

clean:
	vdel -lib $(LIB_NAME) -all
