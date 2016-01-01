//==============================================================================
//
// cl_util.svh (v0.6.1)
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

`ifndef CL_UTIL_SVH
`define CL_UTIL_SVH

//------------------------------------------------------------------------------
// Class: util
//   (VIRTUAL) Provides several utility functions.
//
// See Also:
//   <putil>
//------------------------------------------------------------------------------

virtual class util;

   //---------------------------------------------------------------------------
   // Function: num_oct_digits
   //   (STATIC) Returns the number of octal digits required to represent the
   //   specified binary digits.
   //
   // Argument:
   //   num_bin_digits - The number of binary digits.
   //
   // Returns:
   //   The number of octal digits required to represent *num_bin_digits*.
   //
   // Example:
   // | assert( util::num_oct_digits( 3 ) == 1 ); //  3'b111 -> 1'o7
   // | assert( util::num_oct_digits( 4 ) == 2 ); // 4'b1111 -> 2'o17
   //---------------------------------------------------------------------------

   static function int unsigned num_oct_digits( int unsigned num_bin_digits );
      return ( num_bin_digits + 2 ) / 3;
   endfunction: num_oct_digits

   //---------------------------------------------------------------------------
   // Function: num_dec_digits
   //   (STATIC) Returns the number of decimal digits required to represent the
   //   specified binary digits.
   //
   // Argument:
   //   num_bin_digits - The number of binary digits.
   //
   // Returns:
   //   The number of decimal digits required to represent *num_bin_digits*.
   //
   // Example:
   // | assert( util::num_dec_digits( 3 ) == 1 ); //  3'b111 -> 1'd7
   // | assert( util::num_dec_digits( 4 ) == 2 ); // 4'b1111 -> 2'd15
   //---------------------------------------------------------------------------

   static function int unsigned num_dec_digits( int unsigned num_bin_digits );
      if ( num_bin_digits == 0 ) return 0;

      // log10( 2 ^ n ) + 1 = n * log10( 2 ) + 1
      // $rtoi converts real values to an 'integer' type by truncating the real
      // value.                                             ^^^^^^^^^^

      return $rtoi( num_bin_digits * $log10( 2 ) ) + 1;
   endfunction: num_dec_digits

   //---------------------------------------------------------------------------
   // Function: num_hex_digits
   //   (STATIC) Returns the number of hexadecimal digits required to represent
   //   the specified binary digits.
   //
   // Argument:
   //   num_bin_digits - The number of binary digits.
   //
   // Returns:
   //   The number of hexadecimal digits required to represent *num_bin_digits*.
   //
   // Example:
   // | assert( util::num_hex_digits( 3 ) == 1 ); //  3'b111 -> 1'h7
   // | assert( util::num_hex_digits( 4 ) == 1 ); // 4'b1111 -> 1'hF
   //---------------------------------------------------------------------------

   static function int unsigned num_hex_digits( int unsigned num_bin_digits );
      return ( num_bin_digits + 3 ) / 4;
   endfunction: num_hex_digits

   //---------------------------------------------------------------------------
   // Function normalize
   //---------------------------------------------------------------------------

   static function void normalize( int len,
				   ref int start_pos,
				   ref int end_pos );
      if ( len == 0 ) begin
	 start_pos = 0;
	 end_pos   = 0;
	 return;
      end
      if ( start_pos < 0 ) start_pos += len;
      if ( start_pos < 0 ) start_pos = 0;
      if ( end_pos < 0 )    end_pos += len;
      if ( end_pos >= len ) end_pos = len - 1;
   endfunction: normalize

endclass: util

`endif //  `ifndef CL_UTIL_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
