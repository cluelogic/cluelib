//==============================================================================
//
// cl_choice.svh (v0.6.1)
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

`ifndef CL_CHOICE_SVH
`define CL_CHOICE_SVH

//------------------------------------------------------------------------------
// Class: choice
//   (VIRTUAL) Provides functions to choose an item.
//
// Parameter:
//   T - (OPTIONAL) The type of items. The default is *int*.
//------------------------------------------------------------------------------

virtual class choice #( type T = int );

   local static default_comparator#(T) default_cmp = new();

   //---------------------------------------------------------------------------
   // Function: min
   //   (STATIC) Returns the smaller item.
   //
   // Arguments:
   //   x - An item of type *T*.
   //   y - Another item of type *T*.
   //   cmp - (OPTIONAL) A strategy object used to compare the items. If not
   //         specified or *null*, <comparator> *#(T)* is used. The default is
   //         *null*.
   //
   // Example:
   // | assert( choice#(int)::min( 1, 2 ) == 1 );
   //---------------------------------------------------------------------------

   static function T min( T x, T y, comparator#(T) cmp = null );
      if ( cmp ) begin
	 if ( cmp.lt( x, y ) ) return x;
	 else                  return y;
      end else begin
	 if ( default_cmp.lt( x, y ) ) return x;
	 else                          return y;
      end
   endfunction: min

   //---------------------------------------------------------------------------
   // Function: max
   //   (STATIC) Returns the larger item.
   //
   // Arguments:
   //   x - An item of type *T*.
   //   y - Another item of type *T*.
   //   cmp - (OPTIONAL) A strategy object used to compare the items. If not
   //         specified or *null*, <comparator> *#(T)* is used. The default is
   //         *null*.
   //
   // Example:
   // | assert( choice#(int)::max( 1, 2 ) == 2 );
   //---------------------------------------------------------------------------

   static function T max( T x, T y, comparator#(T) cmp = null );
      if ( cmp ) begin
	 if ( cmp.gt( x, y ) ) return x;
	 else                  return y;
      end else begin
	 if ( default_cmp.gt( x, y ) ) return x;
	 else                          return y;
      end
   endfunction: max

endclass: choice

`endif //  `ifndef CL_CHOICE_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
