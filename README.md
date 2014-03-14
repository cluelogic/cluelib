##ClueLib: A SystemVerilog generic library
ClueLib is a free, open-source generic library written in SystemVerilog. ClueLib is
provided under MIT license and is available on GitHub for forking.

###Documents
- [Online Documentation](http://cluelogic.com/tools/cluelib/api/framed_html/index.html)
- Offline Documentation is available at `api/framed_html/index.html` after installation.

###You can try ClueLib without installing it!
- ClueLib is now on [EDA Playground](http://www.edaplayground.com/x/ua). Check it out!

###How to install
1. Visit https://github.com/cluelogic/cluelib (this page) and click the **Download ZIP** button.
2. Unzip the source code: `unzip cluelib-master.zip`
3. Go to the **run** directory: `cd cluelib-master/run`
4. Check makefile options: `make help`
5. Run a satity check. Use one of the simulators listed in the previous step: 
   Do `make vcs` for example.
6. If you see no errors, the library is in good shape. See the list of
   compatible simulators below.

####Compatible simulators
The library has been tested on the following simulators:
- *Incisive Enterprise Simulator* (Version 12.20-s031) of Cadence Design Systems, Inc.
- *Questa Advanced Simulator* (Version 10.2c) of Mentor Graphics Corporation
- *VCS* (Version G-2012.09-SP1) of Synopsys, Inc.

###How to use
Compile `src/cl_pkg.sv` and `src/cl_dpi.cc` with your files.
- The `src/cl_pkg.sv` includes all library files.  Make sure your `+incdir`
  option points to the **src** directory when you compile.
- If you don't want to use the DPI-C, undefine the **CL_USE_DPI_C** macro in
  `src/cl_define.svh` and compile the `src/cl_pkg.sv` only (the `src/cl_dpi.cc`
  is not necessary).
- Sample makefiles are available under the **run** directory.

###Pull requests policy
Unlike other open-source projects, in which contributors use their own time and
software, the verification libraries are usually developed using their
employer’s resources. Typically, the copyright of such libraries belong to
their employer. **To avoid potential risks with lawsuits, we have decided not to
accept any _Pull Requests_ from individual contributors.** This may not be the
ideal eco-system, but the users can still make comments on the library and fork
the library to extend it by themselves.  Although we will not accept the source
code in itself, we will accept a request for developing a new class or a
function. Because the new function might immediately benefit other users, we
will try to add it on a regular basis to make the library more useful.

####Trademarks
  - *Cadence* is a registered trademark (#3474136) of Cadence Design Systems, Inc.
  - *Incisive* is a registered trademark (#2890264) of Cadence Design Systems, Inc.
  - *Mentor* is a registered trademark (#2388156) of Mentor Graphics Corporation.
  - *Questa* is a registered trademark (#3308638) of Mentor Graphics Corporation.
  - *Synopsys* is a registered trademark (#1618482) of Synopsys, Inc.
  - *VCS* is a registered trademark (#2777162) of Synopsys, Inc.


