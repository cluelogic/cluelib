//==============================================================================
// cl_bit_stream.svh (v0.6.1)
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

`ifndef CL_BIT_STREAM_SVH
`define CL_BIT_STREAM_SVH

//------------------------------------------------------------------------------
// Class: bit_stream
//    A parameterized class that manages a bit stream.
//
// Parameter:
//   T - (OPTIONAL) The type of the bit stream. The *T* must be the single bit
//       data types (*bit*, *logic*, or *reg*). The default type is *bit*.
//------------------------------------------------------------------------------

virtual class bit_stream #( type T = bit ) extends data_stream #( T, 1 );

   //---------------------------------------------------------------------------
   // Typedef: bs_type
   //   The bit stream type. The shorthand of the dynamic array of type *T*.
   //---------------------------------------------------------------------------

   typedef T bs_type[];

   //---------------------------------------------------------------------------
   // Function: alternate
   //   (STATIC) Returns a new bit stream with the elements whose values
   //   alternate between 0 and 1.
   //
   // Argument:
   //   length     - The length of the output bit stream.
   //   init_value - (OPTIONAL) The value of the first element (0 or 1). The
   //                default is 0.
   //   randomize_init_value - (OPTIONAL) If 1, the value of the first element
   //                          is randomized (the *init_value* argument is
   //                          ignored). The default is 0.
   //
   // Returns:
   //   A _new_ bit stream with the elements whose values alternate between 0
   //   and 1.
   //
   // Example:
   // | bit expected[] = new[8]( '{ 1, 0, 1, 0, 1, 0, 1, 0 } );
   // | assert( bit_stream#(bit)::alternate( 8, .init_value( 1 ) ) == expected );
   //---------------------------------------------------------------------------

   static function bs_type alternate( int unsigned length,
				      T init_value = 0,
				      bit randomize_init_value = 0 );
      return sequential( length, init_value, 1, randomize_init_value );
   endfunction: alternate

   //---------------------------------------------------------------------------
   // Function: count_zeros
   //    (STATIC) Counts the number of bit-stream items having value 0.
   // 
   // Argument:
   //   bs - A bit stream.
   //
   // Returns:
   //   The number of items having value 0. If the type *T* is not a single-bit
   //   data type, -1 is returned.
   //
   // Example:
   // | bit bs[] = new[16]( '{ 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1 } );
   // | assert( bit_stream#(bit)::count_zeros( bs ) == 8 );
   //---------------------------------------------------------------------------

   static function int count_zeros( bs_type bs );

      // $countbits( bs, '0 ) cannot be used because 'bs' is a dynamic array,
      // not a bit-vector.

      if ( text::is_single_bit_type( $typename( T ) ) ) begin
	 count_zeros = 0;
	 foreach ( bs[i] ) if ( bs[i] === '0 ) count_zeros++;
      end else begin
	 return -1;
      end
   endfunction: count_zeros

   //---------------------------------------------------------------------------
   // Function: count_ones
   //   (STATIC) Counts the number of bit-stream items having value 1.
   //
   // Argument:
   //   bs - A bit stream.
   //
   // Returns:
   //   The number of items having value 1. If the type *T* is not a single-bit
   //   data type, -1 is returned.
   //
   // Example:
   // | bit bs[] = new[16]( '{ 0, 0, 0, 0, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 1 } );
   // | assert( bit_stream#(bit)::count_ones( bs ) == 8 );
   //---------------------------------------------------------------------------

   static function int count_ones( bs_type bs );

      // $countones( bs ) cannot be used as bs is a dynamic array, not a
      // bit-vector.

      if ( text::is_single_bit_type( $typename( T ) ) ) begin
	 count_ones = 0;
	 foreach ( bs[i] ) if ( bs[i] === '1 ) count_ones++;
      end else begin
	 return -1;
      end
   endfunction: count_ones

   //---------------------------------------------------------------------------
   // Function: count_unknowns
   //   (STATIC) Counts the number of bit-stream items having value X.
   //
   // Argument:
   //   bs - A bit stream.
   //
   // Returns:
   //   The number of items having value X. If the type *T* is not a single-bit
   //   data type, -1 is returned.
   //
   // Example:
   // | logic bs[] = new[16]( '{ 0, 0, 0, 0, 1, 1, 1, 1, 'x, 'x, 'x, 'x, 'z, 'z, 'z, 'z } );
   // | assert( bit_stream#(logic)::count_unknowns( bs ) == 4 );
   //---------------------------------------------------------------------------

   static function int count_unknowns( bs_type bs );

      // $countbits( bs, 'x ) cannot be used as bs is a dynamic array, not a
      // bit-vector.

      if ( text::is_single_bit_type( $typename( T ) ) ) begin
	 count_unknowns = 0;
	 foreach ( bs[i] ) if ( bs[i] === 'x ) count_unknowns++;
      end else begin
	 return -1;
      end
   endfunction: count_unknowns

   //---------------------------------------------------------------------------
   // Function: count_hizs
   //   (STATIC) Counts the number of bit-stream items having value Z.
   //
   // Argument:
   //   bs - A bit stream.
   //
   // Returns:
   //   The number of items having value Z. If the type *T* is not a single-bit
   //   data type, -1 is returned.
   //
   // Example:
   // | logic bs[] = new[16]( '{ 0, 0, 0, 0, 1, 1, 1, 1, 'x, 'x, 'x, 'x, 'z, 'z, 'z, 'z } );
   // | assert( bit_stream#(logic)::count_hizs( bs ) == 4 );
   //---------------------------------------------------------------------------

   static function int count_hizs( bs_type bs );

      // $countbits( bs, 'z ) cannot be used as bs is a dynamic array, not a
      // bit-vector.

      if ( text::is_single_bit_type( $typename( T ) ) ) begin
	 count_hizs = 0;
	 foreach ( bs[i] ) if ( bs[i] === 'z ) count_hizs++;
      end else begin
	 return -1;
      end
   endfunction: count_hizs

endclass: bit_stream

`endif //  `ifndef CL_BIT_STREAM_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
