//==============================================================================
// cl_define.svh (v0.6.1)
//
// The MIT License (MIT)
//
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//==============================================================================

`ifndef CL_DEFINE_SVH
`define CL_DEFINE_SVH

// Title: Macro Definitions

//------------------------------------------------------------------------------
// Define: CL_USE_DPI_C
//   If defined, some functions are delegated to C functions via DPI-C. If not
//   defined, only SystemVerilog is used. This macro is *not defined* by
//   default.
//------------------------------------------------------------------------------

//`define CL_USE_DPI_C

//---->OBSOLETE---->OBSOLETE---->OBSOLETE---->OBSOLETE---->OBSOLETE---->OBSOLETE

//------------------------------------------------------------------------------
// Define CL_NAME_OF_LOG
//   Defines the name of a log file used by the <journal> class.
//------------------------------------------------------------------------------

//`define CL_NAME_OF_LOG "journal.log"

//------------------------------------------------------------------------------
// Define CL_NAME_OF_CSV
//   Defines the name of a CSV (comma separated value) file used by the
//   <journal> class.
//------------------------------------------------------------------------------

//`define CL_NAME_OF_CSV "journal.csv"

//<----OBSOLETE<----OBSOLETE<----OBSOLETE<----OBSOLETE<----OBSOLETE<----OBSOLETE

//------------------------------------------------------------------------------
// Defines: Simulator Selection
//   These macros enable a set of <Supported Features> based on the selected
//   simulator. Only one simulator should be enabled at one time.
//
//   CL_USE_INCISIVE - Use Incisive Enterpirse Simulator from Cadence Design Systems.
//   CL_USE_MODELSIM - Use ModelSim from Mentor Graphics.
//   CL_USE_QUESTA   - Use Questa from Mentor Graphics.
//   CL_USE_VCS      - Use VCS from Synopsys.
//------------------------------------------------------------------------------

//`define CL_USE_INCISIVE
//`define CL_USE_MODELSIM
//`define CL_USE_QUESTA
//`define CL_USE_VCS

//------------------------------------------------------------------------------
// Defines: Supported Features
//   These macros enable an individual feature of a simulator.
//
//   CL_SUPPORT_COUNTBITS - If defiend, *$countbits* bit vector system function
//                          is used. See Section 20.9 of IEEE 1800-2012.
//   CL_SUPPORT_COUNTONES - If defiend, *$countones* bit vector system function
//                          is used. See Section 20.9 of IEEE 1800-2012.
//   CL_SUPPORT_FATAL_SEVERITY_TASK - If defined, *$fatal* elaboration system
//                                    task is used. See Section 20.11 of IEEE
//                                    1800-2012.
//   CL_SUPPORT_PARAMETERIZED_NESTED_CLASS - If defined, a parameterized nested
//                                           class is used. See Section 8.25 of
//                                           IEEE 1800-2012.
//   CL_SUPPORT_POP_FROM_AN_EMPTY_QUEUE - If defined, a pop from an empty queue
//                                        is supported. See Section 7.10.2.4 and
//                                        7.10.2.5 of IEEE 1800-2012.
//   CL_SUPPORT_RANDOMIZE - If defined, constrained random value generation is
//                          supported. See Section 18 of IEEE 1800-2012.
//------------------------------------------------------------------------------

`ifdef CL_USE_INCISIVE
//`undef CL_SUPPORT_BIT_STREAM_CASTING
 `undef CL_SUPPORT_FATAL_SEVERITY_TASK
`endif

`ifdef CL_USE_MODELSIM
//`define CL_SUPPORT_BIT_STREAM_CASTING
 `undef  CL_SUPPORT_COUNTBITS
 `define CL_SUPPORT_COUNTONES
 `define CL_SUPPORT_FATAL_SEVERITY_TASK
 `undef  CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
 `undef  CL_SUPPORT_POP_FROM_AN_EMPTY_QUEUE
 `undef  CL_SUPPORT_RANDOMIZE
`endif

`ifdef CL_USE_QUESTA
`endif

`ifdef CL_USE_VCS
`endif

`endif //  `ifndef CL_DEFINE_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
