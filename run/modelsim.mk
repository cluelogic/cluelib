#===============================================================================
# modelsim.mk (v0.2.0)
#
# The MIT License (MIT)
#
# Copyright (c) 2013, 2014 ClueLogic, LLC
# http:#cluelogic.com/
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#===============================================================================

# user definable variables

MODELSIM_LIB_DIR  := ./work
MODELSIM_LIB_NAME := work

# constants

modelsim_compile_opts := $(compile_opts) +define+CL_USE_MODELSIM
modelsim_run_opts     :=
modelsim_run_cmd_file := modelsim.cmd

# targets

modelsim: prep_modelsim run_modelsim

prep_modelsim:
	vlib $(MODELSIM_LIB_DIR)
	vmap $(MODELSIM_LIB_NAME) $(MODELSIM_LIB_DIR)

run_modelsim:
	vlog $(modelsim_compile_opts) $(compile_files)
	vsim $(modelsim_run_opts) $(top_module) < $(modelsim_run_cmd_file)

clean_modelsim:
	vdel -lib $(MODELSIM_LIB_NAME) -all

#===============================================================================
# Copyright (c) 2013, 2014 ClueLogic, LLC
# http://cluelogic.com/
#===============================================================================
