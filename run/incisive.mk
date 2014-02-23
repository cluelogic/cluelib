#
# incisive.mk
#

# user definable variables

# NONE

# constants

incisive_compile_opts := +incdir+$(src_dir)+$(test_dir) +define+CL_USE_INCISIVE
incisive_run_opts     :=

# targets

incisive: run_incisive

prep_incisive:

run_incisive: 
	irun $(incisive_compile_opts) $(incisive_run_opts) $(compile_files)

clean_incisive:
