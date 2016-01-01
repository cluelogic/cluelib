//==============================================================================
//
// cl_putil.svh (v0.6.1)
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

`ifndef CL_PUTIL_SVH
`define CL_PUTIL_SVH

//------------------------------------------------------------------------------
// Class: putil
//   (VIRTUAL) Provides a parameterized utility function.
//
// Parameter:
//   T - (OPTIONAL) The type of function arguments. The default is *int*.
//
// See Also:
//   <util>
//------------------------------------------------------------------------------

virtual class putil #( type T = int );

   //---------------------------------------------------------------------------
   // Function: swap
   //   (STATIC) Swaps two objects.
   //
   // Arguments:
   //   x - An object of type *T*.
   //   y - Another object of type *T*.
   //
   // Example:
   // | int x = 0;
   // | int y = 1;
   // | putil#(int)::swap( x, y );
   // | assert( x == 1 );
   // | assert( y == 0 );
   //---------------------------------------------------------------------------

   static function void swap( ref T x, ref T y );
      T tmp;

      tmp = x;
      x = y;
      y = tmp;
   endfunction: swap

endclass: putil

`endif //  `ifndef CL_PUTIL_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
