#===============================================================================
# xcelium.mk
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

# NONE

# constants

xcelium_compile_opts := $(compile_opts) +define+CL_USE_INCISIVE
xcelium_run_opts     :=

# targets
.PHONY: xcelium xlm run_xcelium clean_xcelium

xcelium: run_xcelium
xlm: xcelium

run_xcelium:
	xrun $(xcelium_compile_opts) $(xcelium_run_opts) $(compile_files)

clean_xcelium:
	rm -rf xcelium.d/ .simvision/ waves.shm/ xrun.log xmsc.log xrun.history

#===============================================================================
# Copyright (c) 2013, 2014 ClueLogic, LLC
# http://cluelogic.com/
#===============================================================================
