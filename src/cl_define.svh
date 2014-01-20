//==============================================================================
// cl_define.svh (v0.1.0)
//
// The MIT License (MIT)
//
// Copyright (c) 2013, 2014 ClueLogic, LLC
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
// Define CL_USE_DPI_C
//   If defined, several functions are delegated to C functions through
//   DPI-C. If not defined, only SystemVerilog is used.
//------------------------------------------------------------------------------

`define CL_USE_DPI_C

//------------------------------------------------------------------------------
// Define: CL_NAME_OF_JOURNAL
//   Defines the name of a journal file used by the <journal> class.
//------------------------------------------------------------------------------

`define CL_NAME_OF_JOURNAL "journal.log"

//------------------------------------------------------------------------------
// Defines: Simulator Selection
//   These macros are used to enable the features supported by a selected
//   simulator. Only one simulator should be enabled.
//
//   `CL_USE_INCISIVE - Use Cadence Incisive.
//   `CL_USE_MODELSIM - Use Mentor ModelSim.
//   `CL_USE_QUESTA   - Use Mentor QUesta.
//   `CL_USE_VCS      - Use Synopsys VCS.
//------------------------------------------------------------------------------

//`define CL_USE_INCISIVE
`define CL_USE_MODELSIM
//`define CL_USE_QUESTA
//`define CL_USE_VCS

//------------------------------------------------------------------------------
// Derived macros
//------------------------------------------------------------------------------

`ifdef CL_USE_INCISIVE
`endif

`ifdef CL_USE_MODELSIM
 `define CL_SUPPORT_BIT_STREAM_CASTING
 `undef  CL_SUPPORT_COUNTBITS
 `define CL_SUPPORT_COUNTONES
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
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
