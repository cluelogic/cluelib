##ClueLib: A SystemVerilog generic library
ClueLib is a free, open-source generic library written in SystemVerilog. ClueLib is
provided under MIT license and is available on GitHub for forking.

###Documents
- [Online Documentation](http://cluelogic.com/tools/cluelib/api/framed_html/index.html)
- Offline Documentation is available at `api/framed_html/index.html` after installation.

###How to Install
1. Click the **Download ZIP** button.
2. Unzip the source code: `unzip cluelib-master.zip`
3. Go to the **run** directory: `cd cluelib-master/run`
4. Check Makefile options: `make help`
5. Run a satity check. Use one of the simulators listed in the previous step: 
   Do `make modelsim` for example.
6. If you see no errors, the library is in good shape.

###How to Use

Compile `src/cl_pkg.sv` and `src/cl_dpi.cc` with your files.

- The `src/cl_pkg.sv` includes the library files.
  Make sure your `+incdir` option points to the **src** directory when you compile.
- If you don't want to use the DPI-C, undefine the **CL_USE_DPI_C** macro in
  `src/cl_define.svh` and compile `src/cl_pkg.sv` only (`src/cl_dpi.cc` is not
  necessary).
- Sample makefiles are available under the **run** directory.




