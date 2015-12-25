##How to deploy
```bash
cd dev
```
###  If this is the first time to use `~/Documents/work` for ModelSim:
```bash
make lib
```
### If a new class has been added:
- Update `cl_files_to_run` in the `dev/Makefile`, `src/overview.txt`, and `dev/api/proj/Menu.txt`

### If `crc/scrambler` TeX files have been updated:
```bash
make tex 
```

### Common:
- Update `dev/bin/revisionize.sed` to the new revision number

```bash
cd ..
```

- Update the revision in `README.md`

```bash
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
#
# Expected result:
# ==========starting test_from_examples==========
# 24 81 09 63 0d 8d 65 12 01 0d 76 3d ed 8c f9 c6
# d6 0c 47 e4 42 a9 93 ce
# display me in red
# ==========finished test_from_examples==========

cp -r ./api/framed_html ../api
cd ..
git status
git commit -a
git push
```

- Upload the API to `cluelogic.com/tools/cluelib/api/framed_html` using FileZilla

### If you need to clean the ModelSim work directory:

```bash
make clean_lib 
```

