#===============================================================================
# Makefile (v0.2.0)
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

help:
	@echo "Usage: make [TARGET]"
	@echo "  Runs a sanity check."
	@echo "  TARGET can be 'modelsim', 'questa', 'xlm', 'incisive', or 'vcs'."

# constants

SV_TOP ?= test_from_examples.sv

src_dir  := ../src
test_dir := ../test
compile_files := $(src_dir)/cl_pkg.sv $(src_dir)/cl_dpi.cc $(test_dir)/$(SV_TOP)
compile_opts  := +incdir+$(src_dir)+$(test_dir)
top_module    := $(basename $(SV_TOP))

include xcelium.mk
include incisive.mk
include modelsim.mk
include questa.mk
include vcs.mk

#===============================================================================
# Copyright (c) 2013, 2014 ClueLogic, LLC
# http://cluelogic.com/
#===============================================================================
