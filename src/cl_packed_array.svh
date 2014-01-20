//==============================================================================
// cl_packed_array.svh (v0.1.0)
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

`ifndef CL_PACKED_ARRAY_SVH
`define CL_PACKED_ARRAY_SVH

//------------------------------------------------------------------------------
// Class: packed_array
//   A parameterized class that manages a packed array.  The type *T* must be
//   the single bit data types (*bit*, *logic*, *reg*), enumerated types, or
//   other packed arrays or packed structures. The default type is *bit*.
//------------------------------------------------------------------------------

virtual class packed_array #( type T = bit, int WIDTH = 1 );

   //---------------------------------------------------------------------------
   // Typedef: pa_type
   //   The shorthand of the packed array of type *T*.
   //---------------------------------------------------------------------------

   typedef T [WIDTH-1:0] pa_type;

   //---------------------------------------------------------------------------
   // Typedef: da_type
   //   The shorthand of the dynamic array of type *T*.
   //---------------------------------------------------------------------------

   typedef T da_type[];

   //---------------------------------------------------------------------------
   // Typedef: ua_type
   //   The shorthand of the unpacked array of type *T*.
   //---------------------------------------------------------------------------

   typedef T ua_type[WIDTH];

   //---------------------------------------------------------------------------
   // Typedef: q_type
   //   The shorthand of the queue of type *T*.
   //---------------------------------------------------------------------------

   typedef T q_type[$];

   //---------------------------------------------------------------------------
   // Function: from_dynamic_array
   //   Converts a dynamic array of type *T* to the packed array of the same
   //   type.  If the size of the dynamic array is larger than *WIDTH*, excess
   //   elements are ignored.
   //
   // Arguments:
   //   da            - An input dynamic array.
   //   little_endian - (OPTIONAL) If 1, the item at index 0 of the dynamic
   //                   array occupies the LSBs.  If 0, the item at index 0 of
   //                   the dynamic array occupies the MSBs.  The default is 0.
   //
   // Returns:
   //   The packed array converted from *da*.
   //
   // Examples:
   // | bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } ); // da[0] to da[7]
   // | assert( packed_array#(bit,8)::from_dynamic_array( da                      ) == 8'h1B ); // bit[7:0]
   // | assert( packed_array#(bit,8)::from_dynamic_array( da, .little_endian( 1 ) ) == 8'hD8 );
   //---------------------------------------------------------------------------

   static function pa_type from_dynamic_array( da_type da,
					       bit little_endian = 0 );
      pa_type pa;
      da_type size_adjusted_da;

      if ( da.size() == WIDTH )	size_adjusted_da = da;
      else                      size_adjusted_da = new[WIDTH]( da );

      if ( little_endian ) size_adjusted_da.reverse();

`ifdef CL_SUPPORT_BIT_STREAM_CASTING
      pa = pa_type'( size_adjusted_da );
`else
      foreach ( size_adjusted_da[i] ) pa[WIDTH-1-i] = size_adjusted_da[i];
`endif

      return pa;
   endfunction: from_dynamic_array

   //---------------------------------------------------------------------------
   // Function: from_unpacked_array
   //   Converts an unpacked array of type *T* to the packed array of the same
   //   type.
   //
   // Arguments:
   //   ua            - An input unpacked array.
   //   little_endian - (OPTIONAL) If 1, the item at index 0 of the unpacked
   //                   array occupies the LSBs.  If 0, the item at index 0 of
   //                   the unpacked array occupies the MSBs.  The default is 0.
   //
   // Returns:
   //   The packed array converted from *ua*.
   //
   // Examples:
   // | bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // same as ua[0:7]
   // | assert( packed_array#(bit,8)::from_unpacked_array( ua                      ) == 8'h1B ); // bit[7:0]
   // | assert( packed_array#(bit,8)::from_unpacked_array( ua, .little_endian( 1 ) ) == 8'hD8 );
   //---------------------------------------------------------------------------

   static function pa_type from_unpacked_array( ua_type ua,
						bit little_endian = 0 );
      pa_type pa;

      if ( little_endian ) ua.reverse();

`ifdef CL_SUPPORT_BIT_STREAM_CASTING
      pa = pa_type'( ua );
`else
      foreach ( ua[i] ) pa[WIDTH-1-i] = ua[i];
`endif

      return pa;
   endfunction: from_unpacked_array

   //---------------------------------------------------------------------------
   // Function: from_queue
   //   Converts a queue of type *T* to the packed array of the same type.  If
   //   the size of the queue is larger than *WIDTH*, excess elements are
   //   ignored.
   //
   // Arguments:
   //   da            - An input dynamic array.
   //   little_endian - (OPTIONAL) If 1, the item at index 0 of the queue
   //                   occupies the LSBs.  If 0, the item at index 0 of the
   //                   queue occupies the MSBs.  The default is 0.
   //
   // Returns:
   //   The packed array converted from *q*.
   //
   // Examples:
   // | bit q[$] = { 0, 0, 0, 1, 1, 0, 1, 1 }; // q[0] to q[7]
   // | assert( packed_array#(bit,8)::from_queue( q                      ) == 8'h1B ); // bit[7:0]
   // | assert( packed_array#(bit,8)::from_queue( q, .little_endian( 1 ) ) == 8'hD8 );
   //---------------------------------------------------------------------------

   static function pa_type from_queue( q_type q,
				       bit little_endian = 0 );
      pa_type pa;

      // The size of 'q' can be different from the 'WIDTH', but a bit-stream
      // casting requires the same size. To support such a case, always use a
      // 'foreach'.
      
// `ifdef CL_SUPPORT_BIT_STREAM_CASTING
//       if ( little_endian ) q.reverse();
//       pa = pa_type'( q );
// `else
      foreach ( q[i] ) begin
	 if ( little_endian ) pa[i]         = q[i];
	 else                 pa[WIDTH-1-i] = q[i];
      end
// `endif

      return pa;
   endfunction: from_queue

   //---------------------------------------------------------------------------
   // Function: to_dynamic_array
   //   Converts a packed array of type *T* to the dynamic array of the same
   //   type.
   //
   // Arguments:
   //   pa            - An input packed array.
   //   little_endian - (OPTIONAL) If 1, the LSBs of a packed array occupy the
   //                   index 0 of the dynamic array. If 0, the MSBs of a packed
   //                   array occupy the index 0 of the dynamic array. The
   //                   default is 0.
   //
   // Returns:
   //   The dynamic array converted from *pa*.
   //
   // Examples:
   // | bit [7:0] pa = 8'hD8;
   // | assert( packed_array#(bit,8)::to_dynamic_array( pa                      ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // | assert( packed_array#(bit,8)::to_dynamic_array( pa, .little_endian( 1 ) ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   //---------------------------------------------------------------------------

   static function da_type to_dynamic_array( pa_type pa,
					     bit little_endian = 0 );
      da_type da = new[WIDTH];

`ifdef CL_SUPPORT_BIT_STREAM_CASTING
      da = da_type'( pa );
`else
      foreach( pa[i] ) da[WIDTH-1-i] = pa[i];
`endif
      
      if ( little_endian ) da.reverse();
      return da;
   endfunction: to_dynamic_array
   
   //---------------------------------------------------------------------------
   // Function: to_unpacked_array
   //   Converts a packed array of type *T* to the unpacked array of the same
   //   type.
   //
   // Arguments:
   //   pa            - An input packed array.
   //   little_endian - (OPTIONAL) If 1, the LSBs of a packed array occupy the
   //                   index 0 of the unpacked array. If 0, the MSBs of a
   //                   packed array occupy the index 0 of the unpacked
   //                   array. The default is 0.
   //
   // Returns:
   //   The unpacked array converted from *pa*.
   //
   // Examples:
   // | bit [7:0] pa = 8'hD8;
   // | assert( packed_array#(bit,8)::to_unpacked_array( pa                      ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // | assert( packed_array#(bit,8)::to_unpacked_array( pa, .little_endian( 1 ) ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   //---------------------------------------------------------------------------

   static function ua_type to_unpacked_array( pa_type pa,
					      bit little_endian = 0 );
      ua_type ua;

`ifdef CL_SUPPORT_BIT_STREAM_CASTING
      ua = ua_type'( pa );
`else
      foreach ( pa[i] ) ua[WIDTH-1-i] = pa[i];
`endif
      
      if ( little_endian ) ua.reverse();
      return ua;
   endfunction: to_unpacked_array
   
   //---------------------------------------------------------------------------
   // Function: to_queue
   //   Converts a packed array of type *T* to the queue of the same type.
   //
   // Arguments:
   //   pa            - An input packed array.
   //   little_endian - (OPTIONAL) If 1, the LSBs of a packed array occupy the
   //                   index 0 of the queue. If 0, the MSBs of a packed array
   //                   occupy the index 0 of the queue.  The default is 0.
   //
   // Returns:
   //   The queue converted from *pa*.
   //
   // Examples:
   // | bit [7:0] pa = 8'hD8;
   // | assert( packed_array#(bit,8)::to_queue( pa                      ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // | assert( packed_array#(bit,8)::to_queue( pa, .little_endian( 1 ) ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   //---------------------------------------------------------------------------

   static function q_type to_queue( pa_type pa,
				    bit little_endian = 0 );
      q_type q;

`ifdef CL_SUPPORT_BIT_STREAM_CASTING
      q = q_type'( pa );
`else
      foreach ( pa[i] ) q.push_back( pa[i] ); // pa[WIDTH-1] to pa[0]
`endif
      
      if ( little_endian ) q.reverse();
      return q;
   endfunction: to_queue

   //---------------------------------------------------------------------------
   // Function: reverse
   //   Returns a copy of the given packed array with the elements in reverse
   //   order.
   //
   // Argument:
   //   pa - An input packed array.
   //
   // Returns:
   //   A copy of *pa* with the elements in reverse order.
   //
   // Example:
   // | assert( packed_array#(bit,8)::reverse( 8'h0F ) == 8'hF0 );
   //---------------------------------------------------------------------------

   static function pa_type reverse( pa_type pa );
      foreach ( pa[i] ) reverse[WIDTH-1-i] = pa[i];
   endfunction: reverse

   //---------------------------------------------------------------------------
   // Function: count_ones
   //   Counts the number of bits having value 1.
   //
   // Argument:
   //   pa - A packed array.
   //
   // Returns:
   //   The number of bits having value 1. If the type *T* is not a single-bit
   //   data type, -1 is returned.
   //
   // Example:
   // | bit[15:0] pa = 16'h1234;
   // | assert( packed_array#(bit,16)::count_ones( pa ) == 5 );
   //---------------------------------------------------------------------------

   static function int count_ones( pa_type pa );
      if ( text::is_single_bit_type( $typename( T ) ) ) begin

`ifdef CL_SUPPORT_COUNTONES      
	 return $countones( pa );
`else
	 count_ones = 0;
	 foreach ( pa[i] ) if ( pa[i] === '1 ) count_ones++;
`endif

      end else begin
	 return -1;
      end
   endfunction: count_ones

   //---------------------------------------------------------------------------
   // Function: count_zeros
   //   Counts the number of bits having value 0.
   //
   // Argument:
   //   pa - A packed array.
   //
   // Returns:
   //   The number of bits having value 0. If the type *T* is not a single-bit
   //   data type, -1 is returned.
   //
   // Example:
   // | bit[15:0] pa = 16'h1234;
   // | assert( packed_array#(bit,16)::count_zeros( pa ) == 11 );
   //---------------------------------------------------------------------------

   static function int count_zeros( pa_type pa );
      if ( text::is_single_bit_type( $typename( T ) ) ) begin

`ifdef CL_SUPPORT_COUNTBITS
	 return $countbits( pa, '0 );
`else
	 count_zeros = 0;
	 foreach ( pa[i] ) if ( pa[i] === '0 ) count_zeros++;
`endif

      end else begin
	 return -1;
      end
   endfunction: count_zeros

   //---------------------------------------------------------------------------
   // Function: count_unknowns
   //   Counts the number of bits having value X.
   //
   // Argument:
   //   pa - A packed array.
   //
   // Returns:
   //   The number of bits having value X. If the type *T* is not a single-bit
   //   data type, -1 is returned.
   //
   // Example:
   // | logic[15:0] pa = 16'b0000_1111_xxxx_zzzz;
   // | assert( packed_array#(logic,16)::count_unknowns( pa ) == 4 );
   //---------------------------------------------------------------------------

   static function int count_unknowns( pa_type pa );
      if ( text::is_single_bit_type( $typename( T ) ) ) begin

`ifdef CL_SUPPORT_COUNTBITS
	 return $countbits( pa, 'x );
`else
      count_unknowns = 0;
	 foreach ( pa[i] ) if ( pa[i] === 'x ) count_unknowns++;
`endif

      end else begin
	 return -1;
      end
   endfunction: count_unknowns

   //---------------------------------------------------------------------------
   // Function: count_hizs
   //    Counts the number of bits having value Z.
   //
   // Argument:
   //   pa - A packed array.
   //
   // Returns:
   //   The number of bits having value Z. If the type *T* is not a single-bit
   //   data type, -1 is returned.
   //
   // Example:
   // | logic[15:0] pa = 16'b0000_1111_xxxx_zzzz;
   // | assert( packed_array#(logic,16)::count_hizs( pa ) == 4 );
   //---------------------------------------------------------------------------

   static function int count_hizs( pa_type pa );
      if ( text::is_single_bit_type( $typename( T ) ) ) begin

`ifdef CL_SUPPORT_COUNTBITS
	 return $countbits( pa, 'z );
`else
	 count_hizs = 0;
	 foreach ( pa[i] ) if ( pa[i] === 'z ) count_hizs++;
`endif

      end else begin
	 return -1;
      end
   endfunction: count_hizs

endclass: packed_array

`endif //  `ifndef CL_PACKED_ARRAY_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
