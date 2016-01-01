//==============================================================================
// cl_pkg.sv (v0.6.1)
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

// Title: Package

`ifndef CL_PKG_SV
`define CL_PKG_SV

`timescale 1ns/1ns

//------------------------------------------------------------------------------
// Package: cl
//   The ClueLib package. All library files are included in this package. A
//   class declared within the package can be accessed using one of the
//   following:
//
// - The class scope resolution operator *::*
// | int i = cl::choice#(int)::min( 1, 2 );
// - An explicit *import* declaration
// | import cl::choice;
// | int i = choice#(int)::min( 1, 2 );
// - A wildcard *import*
// | import cl::*;
// | int i = choice#(int)::min( 1, 2 );
//------------------------------------------------------------------------------

package cl;
   `include "cl_define.svh"
   `include "cl_types.svh"

`ifdef CL_USE_DPI_C
   import "DPI-C" function int c_find( string s, string sub, int start_pos );
`endif

   `include "cl_util.svh"
   `include "cl_putil.svh"
   `include "cl_text.svh"

   `include "cl_formatter.svh"
   `include "cl_string_formatter.svh"
   `include "cl_decimal_formatter.svh"
   `include "cl_decimal_min_formatter.svh"
   `include "cl_hex_formatter.svh"
   `include "cl_hex_min_formatter.svh"
   `include "cl_comma_formatter.svh"
   `include "cl_global.svh"

   `include "cl_crc.svh"
   `include "cl_scrambler.svh"
   `include "cl_network.svh"

   `include "cl_comparator.svh"
   `include "cl_default_comparator.svh"
   `include "cl_choice.svh"
   `include "cl_pair_comparator.svh"
   `include "cl_pair.svh"
   `include "cl_tuple_comparator.svh"
   `include "cl_tuple.svh"

   `include "cl_common_array.svh"
   `include "cl_packed_array.svh"
   `include "cl_unpacked_array.svh"
   `include "cl_dynamic_array.svh"
   `include "cl_queue.svh"
   `include "cl_data_stream.svh"
   `include "cl_bit_stream.svh"

   `include "cl_iterator.svh"
   `include "cl_collection.svh"

   `include "cl_set_base.svh"
   `include "cl_set_iterator.svh"
   `include "cl_set.svh"

   `include "cl_deque_iterator.svh"
   `include "cl_deque_descending_iterator.svh"
   `include "cl_deque.svh"

//   `include "cl_bidir_iterator.svh"
//   `include "cl_list_base.svh"
//   `include "cl_sub_list_base.svh"
//   `include "cl_list_iterator.svh"
//   `include "cl_list_bidir_iterator.svh"
//   `include "cl_list.svh"

   `include "cl_tree_breadth_first_iterator.svh"
   `include "cl_tree_node.svh"
   `include "cl_tree.svh"

   `include "cl_route_breadth_first_iterator.svh"
   `include "cl_route_node.svh"
   `include "cl_route.svh"

   `include "cl_random_num.svh"
   `include "cl_kitchen_timer.svh"
   `include "cl_journal.svh"

endpackage: cl

`endif //  `ifndef CL_PKG_SV

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
