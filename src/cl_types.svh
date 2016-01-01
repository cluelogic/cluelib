//==============================================================================
// cl_types.svh (v0.6.1)
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

// Title: Type Definitions

`ifndef CL_TYPES_SVH
`define CL_TYPES_SVH

//------------------------------------------------------------------------------
// Typedef: string_q
//   The queue of strings.
//------------------------------------------------------------------------------

typedef string string_q[$];

//------------------------------------------------------------------------------
// Typedef: three_strings
//   The array of three strings.
//------------------------------------------------------------------------------

typedef string three_strings[3];

//------------------------------------------------------------------------------
// Typedef: fg_color_e
//   The enumerated type of foreground colors.
//------------------------------------------------------------------------------

typedef enum { FG_BLACK   = 30,
	       FG_RED     = 31,
	       FG_GREEN   = 32,
	       FG_YELLOW  = 33,
	       FG_BLUE    = 34,
	       FG_MAGENTA = 35,
	       FG_CYAN    = 36,
	       FG_WHITE   = 37 } fg_color_e;

//------------------------------------------------------------------------------
// Typedef: bg_color_e
//   The enumerated type of background colors.
//------------------------------------------------------------------------------

typedef enum { BG_BLACK   = 40,
	       BG_RED     = 41,
	       BG_GREEN   = 42,
	       BG_YELLOW  = 43,
	       BG_BLUE    = 44,
	       BG_MAGENTA = 45,
	       BG_CYAN    = 46,
	       BG_WHITE   = 47 } bg_color_e;

`endif

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
