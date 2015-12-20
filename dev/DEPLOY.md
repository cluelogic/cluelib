##How to deploy
```bash
cd dev
make lib # if this is the first time to use "~/Documents/work" for ModelSim
```

- Update `cl_files_to_run` in the `dev/Makefile`, `src/overview.txt`, and `dev/api/proj/Menu.txt` if a new class has been added.
- Update `dev/bin/revisionize.sed` to the new revision number
- Update the revision in `README.md`
- Update `RELEASE.md`

```bash
# to update the revision numbers

make revision 

# if crc/scrambler TeX files have been updated

make tex 

# make sure there is no subdirectory under src/, otherwise HTML will be created for the subdirectories, too
# make sure there is no assertion errors

make

cp -r ./api/framed_html ../api
cd ..
git status
git commit -a
git push

# if you need to clean the ModelSim work directory

make clean_lib 
```

- Upload the API to `cluelogic.com/tools/cluelib/api/framed_html` using FileZilla