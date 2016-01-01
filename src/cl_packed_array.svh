//==============================================================================
// cl_packed_array.svh (v0.6.1)
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

`ifndef CL_PACKED_ARRAY_SVH
`define CL_PACKED_ARRAY_SVH

//------------------------------------------------------------------------------
// Class: packed_array
//   A parameterized class that manages a packed array.  
//
// Parameters:
//   T - (OPTIONAL) The type of a packed array. The type *T* must be the single
//       bit data types (*bit*, *logic*, or *reg*), enumerated types, or other
//       packed arrays or packed structures. The default type is *bit*.
//   WIDTH - (OPTIONAL) The width of a packed array. The default is 1.
//------------------------------------------------------------------------------

virtual class packed_array #( type T = bit, int WIDTH = 1 );

   //---------------------------------------------------------------------------
   // Typedef: pa_type
   //   The shorthand of the packed array type of type *T*.
   //---------------------------------------------------------------------------

   typedef T [WIDTH-1:0] pa_type;

   //---------------------------------------------------------------------------
   // Typedef: ua_type
   //   The shorthand of the unpacked array type of type *T*.
   //---------------------------------------------------------------------------

   typedef T ua_type[WIDTH];

   //---------------------------------------------------------------------------
   // Typedef: da_type
   //   The shorthand of the dynamic array type of type *T*.
   //---------------------------------------------------------------------------

   typedef T da_type[];

   //---------------------------------------------------------------------------
   // Typedef: q_type
   //   The shorthand of the queue type of type *T*.
   //---------------------------------------------------------------------------

   typedef T q_type[$];

   //---------------------------------------------------------------------------
   // Function: from_unpacked_array
   //   (STATIC) Converts an unpacked array of type *T* to a packed array of the
   //   same type.
   //
   // Arguments:
   //   ua      - An unpacked array to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *ua* is
   //             positioned to the index 0 of the packed array. If 1, the
   //             elements are positioned in the reverse order. The default is
   //             0.
   //
   // Returns:
   //   A packed array converted from *ua*.
   //
   // Example:
   // | bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
   // | assert( packed_array#(bit,8)::from_unpacked_array( ua                ) == 8'hD8 ); // bit[7:0]
   // | assert( packed_array#(bit,8)::from_unpacked_array( ua, .reverse( 1 ) ) == 8'h1B );
   //
   // See Also:
   //   <ua_to_pa>
   //---------------------------------------------------------------------------

   static function pa_type from_unpacked_array( const ref ua_type ua,
						input bit reverse = 0 );
      common_array#( T, ua_type, pa_type )::a_to_a( ua, from_unpacked_array,
						    reverse );
   endfunction: from_unpacked_array

   //---------------------------------------------------------------------------
   // Function: to_unpacked_array
   //   (STATIC) Converts a packed array of type *T* to an unpacked array of the
   //   same type.
   //
   // Arguments:
   //   pa      - A packed array to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *pa* is
   //             positioned to the index 0 of the unpacked array. If 1, the
   //             elements are positioned in the reverse order. The default is
   //             0.
   //
   // Returns:
   //   An unpacked array converted from *pa*.
   //
   // Example:
   // | bit[7:0] pa = 8'hD8;
   // | bit ua0[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit ua1[8] = '{ 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | assert( packed_array#(bit,8)::to_unpacked_array( pa                ) == ua0 );
   // | assert( packed_array#(bit,8)::to_unpacked_array( pa, .reverse( 1 ) ) == ua1 );
   // 
   // See Also:
   //   <pa_to_ua>
   //---------------------------------------------------------------------------

   static function ua_type to_unpacked_array( const ref pa_type pa,
					      input bit reverse = 0 );
      common_array#( T, pa_type, ua_type )::a_to_a( pa, to_unpacked_array,
						    reverse );
   endfunction: to_unpacked_array

   //---------------------------------------------------------------------------
   // Function: from_dynamic_array
   //   (STATIC) Converts a dynamic array of type *T* to a packed array of the
   //   same type.  If the size of the dynamic array is larger than *WIDTH*, the
   //   excess elements are ignored. If the size of the dynamic array is smaller
   //   than *WIDTH*, the default value of type *T* is used for the missing
   //   elements.
   //
   // Arguments:
   //   da      - A dynamic array to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *da* is
   //             positioned to the index 0 of the packed array. If 1, the
   //             elements are positioned in the reverse order. The default is
   //             0.
   //
   // Returns:
   //   A packed array converted from *da*.
   //
   // Example:
   // | bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } ); // da[0] to da[7]
   // | assert( packed_array#(bit,8)::from_dynamic_array( da                ) == 8'hD8 ); // bit[7:0]
   // | assert( packed_array#(bit,8)::from_dynamic_array( da, .reverse( 1 ) ) == 8'h1B );
   //
   // See Also:
   //   <da_to_pa>
   //---------------------------------------------------------------------------

   static function pa_type from_dynamic_array( const ref da_type da,
					       input bit reverse = 0 );
      common_array#( T, da_type, pa_type )::a_to_a( da, from_dynamic_array, 
						    reverse );
   endfunction: from_dynamic_array

   //---------------------------------------------------------------------------
   // Function: to_dynamic_array
   //   (STATIC) Converts a packed array of type *T* to a dynamic array of the
   //   same type.
   //
   // Arguments:
   //   pa      - A packed array to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *pa* is
   //             positioned to the index 0 of the dynamic array. If 1, the
   //             elements are positioned in the reverse order. The default is
   //             0.
   //
   // Returns:
   //   A dynamic array converted from *pa*.
   //
   // Example:
   // | bit[7:0] pa = 8'hD8;
   // | bit da0[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | bit da1[] = new[8]( '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // |
   // | assert( packed_array#(bit,8)::to_dynamic_array( pa                ) == da0 );
   // | assert( packed_array#(bit,8)::to_dynamic_array( pa, .reverse( 1 ) ) == da1 );
   // 
   // See Also:
   //   <pa_to_da>
   //---------------------------------------------------------------------------

   static function da_type to_dynamic_array( const ref pa_type pa,
					     input bit reverse = 0 );
      to_dynamic_array = new[WIDTH];
      common_array#( T, pa_type, da_type )::a_to_a( pa, to_dynamic_array,
						    reverse );
   endfunction: to_dynamic_array

   //---------------------------------------------------------------------------
   // Function: from_queue
   //   (STATIC) Converts a queue of type *T* to a packed array of the same
   //   type.  If the size of the queue is larger than *WIDTH*, the excess
   //   elements are ignored. If the size of the queue is smaller than *WIDTH*,
   //   the default valus of type *T* is used for the missing elements.
   //
   // Arguments:
   //   q - A queue to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *q* is
   //             positioned to the index 0 of the packed array. If 1, the
   //             elements are positioned in the reverse order. The default is
   //             0.
   //
   // Returns:
   //   A packed array converted from *q*.
   //
   // Example:
   // | bit q[$] = { 0, 0, 0, 1, 1, 0, 1, 1 }; // q[0] to q[7]
   // | assert( packed_array#(bit,8)::from_queue( q                ) == 8'hD8 ); // bit[7:0]
   // | assert( packed_array#(bit,8)::from_queue( q, .reverse( 1 ) ) == 8'h1B );
   //
   // See Also:
   //   <q_to_pa>
   //---------------------------------------------------------------------------

   static function pa_type from_queue( const ref q_type q,
				       input bit reverse = 0 );
      common_array#( T, q_type, pa_type )::a_to_a( q, from_queue, reverse );
   endfunction: from_queue

   //---------------------------------------------------------------------------
   // Function: to_queue
   //   (STATIC) Converts a packed array of type *T* to a queue of the same
   //   type.
   //
   // Arguments:
   //   pa      - A packed array to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *pa* is
   //             positioned to the index 0 of the queue. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   A queue converted from *pa*.
   //
   // Example:
   // | bit[7:0] pa = 8'hD8;
   // | bit q0[$] = { 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit q1[$] = { 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | assert( packed_array#(bit,8)::to_queue( pa                ) == q0 );
   // | assert( packed_array#(bit,8)::to_queue( pa, .reverse( 1 ) ) == q1 );
   // 
   // See Also:
   //   <pa_to_q>
   //---------------------------------------------------------------------------

   static function q_type to_queue( const ref pa_type pa,
				    input bit reverse = 0 );
      common_array#( T, pa_type, q_type )::a_to_q( pa, to_queue, reverse );
   endfunction: to_queue

   //---------------------------------------------------------------------------
   // Function: ua_to_pa
   //   (STATIC) Converts an unpacked array of type *T* to a packed array of the
   //   same type. Unlike <from_unpacked_array>, this function populates the
   //   packed array passed by reference, instead of returning a new packed
   //   array.
   //
   // Arguments:
   //   ua      - An unpacked array to be converted.
   //   pa      - A packed array reference to be populated.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *ua* is
   //             positioned to the index 0 of *pa*. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
   // | bit[7:0] pa;
   // |
   // | packed_array#(bit,8)::ua_to_pa( ua, pa );
   // | assert( pa == 8'hD8 ); // bit[7:0]
   // |
   // | packed_array#(bit,8)::ua_to_pa( ua, pa, .reverse( 1 ) );
   // | assert( pa == 8'h1B );
   //
   // See Also:
   //   <from_unpacked_array>
   //---------------------------------------------------------------------------

   static function void ua_to_pa( const ref ua_type ua,
				  ref pa_type pa,
				  input bit reverse = 0 );
      common_array#( T, ua_type, pa_type )::a_to_a( ua, pa, reverse );
   endfunction: ua_to_pa

   //---------------------------------------------------------------------------
   // Function: pa_to_ua
   //   (STATIC) Converts a packed array of type *T* to an unpacked array of the
   //   same type. Unlike <to_unpacked_array>, this function populates the
   //   unpacked array passed by reference, instead of returning a new unpacked
   //   array.
   //
   // Arguments:
   //   pa      - A packed array to be converted.
   //   ua      - An unpacked array reference to be populated.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *pa* is
   //             positioned to the index 0 of *ua*. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit[7:0] pa = 8'hD8;
   // | bit ua[8];
   // | bit ua0[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit ua1[8] = '{ 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | packed_array#(bit,8)::pa_to_ua( pa, ua );
   // | assert( ua == ua0 );
   // |
   // | packed_array#(bit,8)::pa_to_ua( pa, ua, .reverse( 1 ) );
   // | assert( ua == ua1 );
   // 
   // See Also:
   //   <to_unpacked_array>
   //---------------------------------------------------------------------------

   static function void pa_to_ua( const ref pa_type pa,
				  ref ua_type ua,
				  input bit reverse = 0 );
      common_array#( T, pa_type, ua_type )::a_to_a( pa, ua, reverse );
   endfunction: pa_to_ua

   //---------------------------------------------------------------------------
   // Function: da_to_pa
   //   (STATIC) Converts a dynamic array of type *T* to a packed array of the
   //   same type.  Unlike <from_dynamic_array>, this function populates the
   //   packed array passed by reference, instead of returning a new packed
   //   array. If the size of the dynamic array is larger than *WIDTH*, the
   //   excess elements are ignored. If the size of the dynamic array is smaller
   //   than *WIDTH*, the default value of type *T* is used for the missing
   //   elements.
   //
   // Arguments:
   //   da      - A dynamic array to be converted.
   //   pa      - A packed array to be populated.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *da* is
   //             positioned to the index 0 of *pa*. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } ); // da[0] to da[7]
   // | bit[7:0] pa;
   // |
   // | packed_array#(bit,8)::da_to_pa( da, pa );
   // | assert( pa == 8'hD8 ); // bit[7:0]
   // |
   // | packed_array#(bit,8)::da_to_pa( da, pa, .reverse( 1 ) );
   // | assert( pa == 8'h1B );
   //
   // See Also:
   //   <from_dynamic_array>
   //---------------------------------------------------------------------------

   static function void da_to_pa( const ref da_type da,
				  ref pa_type pa,
				  input bit reverse = 0 );
      common_array#( T, da_type, pa_type )::a_to_a( da, pa, reverse );
   endfunction: da_to_pa

   //---------------------------------------------------------------------------
   // Function: pa_to_da
   //   (STATIC) Converts a packed array of type *T* to a dynamic array of the
   //   same type. Unlike <to_dynamic_array>, this function populates the
   //   dynamic array passed by reference, instead of returning a new dynamic
   //   array.
   //
   // Arguments:
   //   pa - A packed array to be converted.
   //   da - A dynamic array to be populated. This function does _not_ resize
   //        *da*. Make sure to set the size of the dynamic array to accommodate
   //        the elements of *pa* before calling this function.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *pa* is
   //             positioned to the index 0 of *da*. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit[7:0] pa = 8'hD8;
   // | bit da [] = new[8]; // set the size of da[]
   // | bit da0[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | bit da1[] = new[8]( '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // |
   // | packed_array#(bit,8)::pa_to_da( pa, da );
   // | assert( da == da0 );
   // |
   // | packed_array#(bit,8)::pa_to_da( pa, da, .reverse( 1 ) );
   // | assert( da == da1 );
   // 
   // See Also:
   //   <to_dynamic_array>
   //---------------------------------------------------------------------------

   static function void pa_to_da( const ref pa_type pa,
				  ref da_type da,
				  input bit reverse = 0 );
      common_array#( T, pa_type, da_type )::a_to_a( pa, da, reverse );
   endfunction: pa_to_da

   //---------------------------------------------------------------------------
   // Function: q_to_pa
   //   (STATIC) Converts a queue of type *T* to a packed array of the same
   //   type.  Unlike <from_queue>, this function populates the packed array
   //   passed by reference, instead of returning a new packed array. If the
   //   size of the queue is larger than *WIDTH*, the excess elements are
   //   ignored. If the size of the queue is smaller than *WIDTH*, the default
   //   valus of type *T* is used for the missing elements.
   //
   // Arguments:
   //   q - A queue to be converted.
   //   pa - A packed array to be populated.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *q* is
   //             positioned to the index 0 of *pa*. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit q[$] = { 0, 0, 0, 1, 1, 0, 1, 1 }; // q[0] to q[7]
   // | bit[7:0] pa;
   // |
   // | packed_array#(bit,8)::q_to_pa( q, pa );
   // | assert( pa == 8'hD8 ); // bit[7:0]
   // |
   // | packed_array#(bit,8)::q_to_pa( q, pa, .reverse( 1 ) );
   // | assert( pa == 8'h1B );
   //
   // See Also:
   //   <from_queue>
   //---------------------------------------------------------------------------

   static function void q_to_pa( const ref q_type q,
				 ref pa_type pa,
				 input bit reverse = 0 );
      common_array#( T, q_type, pa_type )::a_to_a( q, pa, reverse );
   endfunction: q_to_pa

   //---------------------------------------------------------------------------
   // Function: pa_to_q
   //   (STATIC) Converts a packed array of type *T* to a queue of the same
   //   type. Unlike <to_queue>, this function populates the queue passed by
   //   reference instead of returning a new queue.
   //
   // Arguments:
   //   pa - A packed array to be converted.
   //   q - A queue to be populated.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *pa* is
   //             positioned to the index 0 of *q*. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit[7:0] pa = 8'hD8;
   // | bit q [$];
   // | bit q0[$] = { 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit q1[$] = { 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | packed_array#(bit,8)::pa_to_q( pa, q );
   // | assert( q == q0 );
   // |
   // | q.delete();
   // | packed_array#(bit,8)::pa_to_q( pa, q, .reverse( 1 ) );
   // | assert( q == q1 );
   // 
   // See Also:
   //   <to_queue>
   //---------------------------------------------------------------------------

   static function void pa_to_q( const ref pa_type pa,
				 ref q_type q,
				 input bit reverse = 0 );
      common_array#( T, pa_type, q_type )::a_to_q( pa, q, reverse );
   endfunction: pa_to_q

   //---------------------------------------------------------------------------
   // Function: init
   //   (STATIC) Initializes the each element of the given packed array to the
   //   specified value.
   //
   // Arguments:
   //   pa - A packed array to be initialized.
   //   val - A value to initialize the elements of *pa*.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit[7:0] pa;
   // | packed_array#(bit,8)::init( pa, 1'b1 );
   // | assert( pa == 8'hFF );
   //---------------------------------------------------------------------------

   static function void init( ref pa_type pa, input T val );
      common_array#( T, pa_type )::init( pa, val );
   endfunction: init

   //---------------------------------------------------------------------------
   // Function: reverse
   //   (STATIC) Reverses the order of the elements of the given packed array.
   //
   // Argument:
   //   pa - A packed array to be reversed.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit[7:0] pa = 8'h0F;
   // | packed_array#(bit,8)::reverse( pa );
   // | assert( pa == 8'hF0 );
   //---------------------------------------------------------------------------

   static function void reverse( ref pa_type pa );
      common_array#( T, pa_type )::reverse( pa );
   endfunction: reverse

   //---------------------------------------------------------------------------
   // Function: count_ones
   //   (STATIC) Counts the number of bits having value 1.
   //
   // Argument:
   //   pa - A packed array.
   //
   // Returns:
   //   The number of bits having value 1. If the type *T* is not a single-bit
   //   data type, -1 is returned.
   //
   // Example:
   // | bit[15:0] pa = 16'h1234; // 16'b0001_0010_0011_0100
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
   //   (STATIC) Counts the number of bits having value 0.
   //
   // Argument:
   //   pa - A packed array.
   //
   // Returns:
   //   The number of bits having value 0. If the type *T* is not a single-bit
   //   data type, -1 is returned.
   //
   // Example:
   // | bit[15:0] pa = 16'h1234; // 16'b0001_0010_0011_0100
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
   //   (STATIC) Counts the number of bits having value X.
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
   //   (STATIC) Counts the number of bits having value Z.
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
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
