#===============================================================================
# questa.mk (v0.2.0)
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

QUESTA_LIB_DIR  := ./work
QUESTA_LIB_NAME := work

# constants

questa_compile_opts := $(compile_opts) +define+CL_USE_QUESTA
questa_run_opts     :=
questa_run_cmd_file := modelsim.cmd

# targets

questa: prep_questa run_questa

prep_questa:
	vlib $(QUESTA_LIB_DIR)
	vmap $(QUESTA_LIB_NAME) $(QUESTA_LIB_DIR)

run_questa:
	vlog $(questa_compile_opts) $(compile_files)
	vsim $(questa_run_opts) $(top_module) < $(questa_run_cmd_file)

clean_questa:
	vdel -lib $(QUESTA_LIB_NAME) -all

#===============================================================================
# Copyright (c) 2013, 2014 ClueLogic, LLC
# http://cluelogic.com/
#===============================================================================
