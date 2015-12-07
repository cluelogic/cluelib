##How to deploy
```bash
cd dev
make lib # if this is the first time to use "~/Documents/work" for ModelSim
```

1. Update `cl_files_to_run` in the `dev/Makefile`, `src/overview.txt`, and `dev/api/proj/Menu.txt` if a new class has been added.
1. Update `dev/bin/revisionize.sed` to the new revision number

```bash
make revision # to update the revision numbers
make tex # if crc/scrambler TeX files have been updated
make # make sure there is no assertion errors
cp -r ./api/framed_html ../api
cd ..
git status
git commit -a
git push

make clean_lib # if you need to clean the ModelSim work directory
```

1. Upload the API to `cluelogic.com/tools/cluelib/api/framed_html` using FileZilla