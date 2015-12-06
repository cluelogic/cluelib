##How to deploy
1. cd dev
1. make lib # if this is the first time to use `Documents\work`
1. Update `cl_files` in the `dev/Makefile`, `src/overview.txt`, and `dev/api/proj/Menu.txt` if a new class has been added.
1. Update `dev/bin/revisionize.sed`
1. make revision # to update the revision numbers
1. make tex # if crc/scrambler TeX was updated
1. make # make sure there is no assertion errors
1. make clean_lib # if you need to clean the ModelSim work directory
1. git status
1. git commit -a
1. git push