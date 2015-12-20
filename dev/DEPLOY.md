#How to deploy
```bash
cd dev
```
##  If this is the first time to use `~/Documents/work` for ModelSim:
```bash
make lib
```
## If a new class has been added:
- Update `cl_files_to_run` in the `dev/Makefile`, `src/overview.txt`, and `dev/api/proj/Menu.txt`

## If `crc/scrambler` TeX files have been updated:
```bash
make tex 
```

## Common:
- Update `dev/bin/revisionize.sed` to the new revision number
- Update the revision in `README.md`

```bash
cd ..
git diff | cat
```

- Update `RELEASE.md`

```bash
cd dev
make revision # update the revision numbers

# Make sure there is no subdirectory under src/, 
# otherwise HTML will be created for the subdirectories, too.

make

# Make sure there was no assertion errors.

cp -r ./api/framed_html ../api
cd ..
git status
git commit -a
git push
```

- Upload the API to `cluelogic.com/tools/cluelib/api/framed_html` using FileZilla

## If you need to clean the ModelSim work directory:

```bash
make clean_lib 
```

