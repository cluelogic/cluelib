//==============================================================================
// cl_unpacked_array.svh (v0.6.1)
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

`ifndef CL_UNPACKED_ARRAY_SVH
`define CL_UNPACKED_ARRAY_SVH

//------------------------------------------------------------------------------
// Class: unpacked_array
//   A parameterized class that manages an unpacked array.
//
// Parameters:
//   T - (OPTIONAL) The type of an unpacked array. The default type is *bit*.
//   SIZE - (OPTIONAL) The size of an unpacked array. The default is 1.
//------------------------------------------------------------------------------

virtual class unpacked_array #( type T = bit, int SIZE = 1 );

   //---------------------------------------------------------------------------
   // Group: Common Arguments
   //   from_index - The index of the first element of an unpacked array to be
   //                processed.  If negative, the index counts from the last.
   //                For example, if *from_index* is -9, a function starts at
   //                the ninth element (inclusive) from the last.  The default
   //                is 0 (starts at the first element).
   //   to_index - The index of the last element of an unpacked array to be
   //              processed.  If negative, the index counts from the last.  For
   //              example, if *to_index* is -3, a function ends at the third
   //              element (inclusive) from the last.  The default is -1 (ends
   //              at the last element).
   //---------------------------------------------------------------------------

   // Group: Types

   //---------------------------------------------------------------------------
   // Typedef: ua_type
   //   The shorthand of the unpacked array type of type *T*.
   //---------------------------------------------------------------------------

   typedef T ua_type[SIZE];

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

   // Group: Functions

   //---------------------------------------------------------------------------
   // Function: from_dynamic_array
   //   (STATIC) Converts a dynamic array of type *T* to un unpacked array of
   //   the same type.  If the size of the dynamic array is larger than *SIZE*,
   //   the excess elements are ignored. If the size of the dynamic array is
   //   smaller than *SIZE*, the default value of type *T* is used for the
   //   missing elements.
   //
   // Arguments:
   //   da      - A dynamic array to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *da* is
   //             positioned to the index 0 of the unpacked array. If 1, the
   //             elements are positioned in the reverse order. The default is
   //             0.
   //
   // Returns:
   //   An unpacked array converted from *da*.
   //
   // Example:
   // | bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } ); // da[0] to da[7]
   // | bit ua0[8] =       '{ 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit ua1[8] =       '{ 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | assert( unpacked_array#(bit,8)::from_dynamic_array( da                ) == ua0 );
   // | assert( unpacked_array#(bit,8)::from_dynamic_array( da, .reverse( 1 ) ) == ua1 );
   //
   // See Also:
   //   <da_to_ua>
   //---------------------------------------------------------------------------

   static function ua_type from_dynamic_array( const ref da_type da,
					       input bit reverse = 0 );
      common_array#( T, da_type, ua_type )::a_to_a( da, from_dynamic_array, 
						    reverse );
   endfunction: from_dynamic_array
   
   //---------------------------------------------------------------------------
   // Function: to_dynamic_array
   //   (STATIC) Converts an unpacked array of type *T* to a dynamic array of
   //   the same type.
   //
   // Arguments:
   //   ua      - A unpacked array to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *ua* is
   //             positioned to the index 0 of the dynamic array. If 1, the
   //             elements are positioned in the reverse order. The default is
   //             0.
   //
   // Returns:
   //   A dynamic array converted from *ua*.
   //
   // Example:
   // | bit ua[8] =         '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
   // | bit da0[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | bit da1[] = new[8]( '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // |
   // | assert( unpacked_array#(bit,8)::to_dynamic_array( ua                ) == da0 );
   // | assert( unpacked_array#(bit,8)::to_dynamic_array( ua, .reverse( 1 ) ) == da1 );
   // 
   // See Also:
   //   <ua_to_da>
   //---------------------------------------------------------------------------

   static function da_type to_dynamic_array( const ref ua_type ua,
					     input bit reverse = 0 );
      to_dynamic_array = new[ $size( ua ) ];
      common_array#( T, ua_type, da_type )::a_to_a( ua, to_dynamic_array, 
						    reverse );
   endfunction: to_dynamic_array
   
   //---------------------------------------------------------------------------
   // Function: from_queue
   //   (STATIC) Converts a queue of type *T* to an unpacked array of the same
   //   type.  If the size of the queue is larger than *SIZE*, the excess
   //   elements are ignored. If the size of the queue is smaller than *SIZE*,
   //   the default valus of type *T* is used for the missing elements.
   //
   // Arguments:
   //   q - A queue to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *q* is
   //             positioned to the index 0 of the unpacked array. If 1, the
   //             elements are positioned in the reverse order. The default is
   //             0.
   //
   // Returns:
   //   An unpacked array converted from *q*.
   //
   // Example:
   // | bit q[$]   =  { 0, 0, 0, 1, 1, 0, 1, 1 }; // q[0] to q[7]
   // | bit ua0[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit ua1[8] = '{ 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | assert( unpacked_array#(bit,8)::from_queue( q                ) == ua0 );
   // | assert( unpacked_array#(bit,8)::from_queue( q, .reverse( 1 ) ) == ua1 );
   //
   // See Also:
   //   <q_to_ua>
   //---------------------------------------------------------------------------

   static function ua_type from_queue( const ref q_type q,
				       input bit reverse = 0 );
      common_array#( T, q_type, ua_type )::a_to_a( q, from_queue, reverse );
   endfunction: from_queue
   
   //---------------------------------------------------------------------------
   // Function: to_queue
   //   (STATIC) Converts an unpacked array of type *T* to a queue of the same
   //   type.
   //
   // Arguments:
   //   ua      - An unpacked array to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *ua* is
   //             positioned to the index 0 of the queue. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   A queue converted from *ua*.
   //
   // Example:
   // | bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
   // | bit q0[$] =  { 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit q1[$] =  { 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | assert( unpacked_array#(bit,8)::to_queue( ua                ) == q0 );
   // | assert( unpacked_array#(bit,8)::to_queue( ua, .reverse( 1 ) ) == q1 );
   // 
   // See Also:
   //   <ua_to_q>
   //---------------------------------------------------------------------------

   static function q_type to_queue( const ref ua_type ua,
				    input bit reverse = 0 );
      common_array#( T, ua_type, q_type )::a_to_q( ua, to_queue, reverse );
   endfunction: to_queue
   
   //---------------------------------------------------------------------------
   // Function: da_to_ua
   //   (STATIC) Converts a dynamic array of type *T* to an unpacked array of
   //   the same type.  Unlike <from_dynamic_array>, this function populates the
   //   unpacked array passed by reference, instead of returning a new unpacked
   //   array. If the size of the dynamic array is larger than *SIZE*, the
   //   excess elements are ignored. If the size of the dynamic array is smaller
   //   than *SIZE*, the default value of type *T* is used for the missing
   //   elements.
   //
   // Arguments:
   //   da      - A dynamic array to be converted.
   //   ua      - An unpacked array to be populated.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *da* is
   //             positioned to the index 0 of *ua*. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } ); // da[0] to da[7]
   // | bit ua[8];
   // | bit ua0[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit ua1[8] = '{ 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | unpacked_array#(bit,8)::da_to_ua( da, ua );
   // | assert( ua == ua0 );
   // |
   // | unpacked_array#(bit,8)::da_to_ua( da, ua, .reverse( 1 ) );
   // | assert( ua == ua1 );
   //
   // See Also:
   //   <from_dynamic_array>
   //---------------------------------------------------------------------------

   static function void da_to_ua( const ref da_type da,
				  ref ua_type ua,
				  input bit reverse = 0 );
      common_array#( T, da_type, ua_type )::a_to_a( da, ua, reverse );
   endfunction: da_to_ua
   
   //---------------------------------------------------------------------------
   // Function: ua_to_da
   //   (STATIC) Converts an unpacked array of type *T* to a dynamic array of
   //   the same type. Unlike <to_dynamic_array>, this function populates the
   //   dynamic array passed by reference, instead of returning a new dynamic
   //   array.
   //
   // Arguments:
   //   ua - An unpacked array to be converted.
   //   da - A dynamic array to be populated. This function does _not_ resize
   //        *da*. Make sure to set the size of the dynamic array to accommodate
   //        the elements of *ua* before calling this function.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *ua* is
   //             positioned to the index 0 of *da*. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
   // | bit da [] = new[8]; // set the size of da[]
   // | bit da0[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | bit da1[] = new[8]( '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // |
   // | unpacked_array#(bit,8)::ua_to_da( ua, da );
   // | assert( da == da0 );
   // |
   // | unpacked_array#(bit,8)::ua_to_da( ua, da, .reverse( 1 ) );
   // | assert( da == da1 );
   // 
   // See Also:
   //   <to_dynamic_array>
   //---------------------------------------------------------------------------

   static function void ua_to_da( const ref ua_type ua,
				  ref da_type da,
				  input bit reverse = 0 );
      common_array#( T, ua_type, da_type )::a_to_a( ua, da, reverse );
   endfunction: ua_to_da
   
   //---------------------------------------------------------------------------
   // Function: q_to_ua
   //   (STATIC) Converts a queue of type *T* to an unpacked array of the same
   //   type.  Unlike <from_queue>, this function populates the unpacked array
   //   passed by reference, instead of returning a new unpacked array. If the
   //   size of the queue is larger than *SIZE*, the excess elements are
   //   ignored. If the size of the queue is smaller than *SIZE*, the default
   //   valus of type *T* is used for the missing elements.
   //
   // Arguments:
   //   q - A queue to be converted.
   //   ua - An unpacked array to be populated.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *q* is
   //             positioned to the index 0 of *ua*. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit q[$] = { 0, 0, 0, 1, 1, 0, 1, 1 }; // q[0] to q[7]
   // | bit ua [8];
   // | bit ua0[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit ua1[8] = '{ 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | unpacked_array#(bit,8)::q_to_ua( q, ua );
   // | assert( ua == ua0 );
   // |
   // | unpacked_array#(bit,8)::q_to_ua( q, ua, .reverse( 1 ) );
   // | assert( ua == ua1 );
   //
   // See Also:
   //   <from_queue>
   //---------------------------------------------------------------------------

   static function void q_to_ua( const ref q_type q,
				 ref ua_type ua,
				 input bit reverse = 0 );
      common_array#( T, q_type, ua_type )::a_to_a( q, ua, reverse );
   endfunction: q_to_ua
   
   //---------------------------------------------------------------------------
   // Function: ua_to_q
   //   (STATIC) Converts an unpacked array of type *T* to a queue of the same
   //   type. Unlike <to_queue>, this function populates the queue passed by
   //   reference instead of returning a new queue.
   //
   // Arguments:
   //   ua - An unpacked array to be converted.
   //   q - A queue to be populated.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *ua* is
   //             positioned to the index 0 of *q*. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
   // | bit q [$];
   // | bit q0[$] = { 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit q1[$] = { 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | unpacked_array#(bit,8)::ua_to_q( ua, q );
   // | assert( q == q0 );
   // |
   // | q.delete();
   // | unpacked_array#(bit,8)::ua_to_q( ua, q, .reverse( 1 ) );
   // | assert( q == q1 );
   // 
   // See Also:
   //   <to_queue>
   //---------------------------------------------------------------------------

   static function void ua_to_q( const ref ua_type ua,
				 ref q_type q,
				 input bit reverse = 0 );
      common_array#( T, ua_type, q_type )::a_to_q( ua, q, reverse );
   endfunction: ua_to_q
   
   //---------------------------------------------------------------------------
   // Function: init
   //   (STATIC) Initializes the each element of the given unpacked array to the
   //   specified value.
   //
   // Arguments:
   //   ua - An unpacked array to be initialized.
   //   val - A value to initialize the elements of *ua*.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit ua[8];
   // | bit expected[8] = '{ 1, 1, 1, 1, 1, 1, 1, 1 };
   // |
   // | unpacked_array#(bit,8)::init( ua, 1'b1 );
   // | assert( ua == expected );
   //---------------------------------------------------------------------------

   static function void init( ref ua_type ua, input T val );
      common_array#( T, ua_type )::init( ua, val );
   endfunction: init

   //---------------------------------------------------------------------------
   // Function: reverse
   //   (STATIC) Reverses the order of the elements of the given unpacked array.
   //
   // Argument:
   //   ua - An unpacked array to be reversed.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit ua[8] = '{ 0, 0, 0, 0, 1, 1, 1, 1 };
   // | bit expected[8] = '{ 1, 1, 1, 1, 0, 0, 0, 0 };
   // |
   // | unpacked_array#(bit,8)::reverse( ua );
   // | assert( ua == expected );
   //---------------------------------------------------------------------------

   static function void reverse( ref ua_type ua );
      common_array#( T, ua_type )::reverse( ua );
   endfunction: reverse

   //---------------------------------------------------------------------------
   // Function: compare
   //   (STATIC) Compares two unpacked arrays.
   //
   // Arguments:
   //   ua1         - An unpacked array.
   //   ua2         - Another unpacked array to compare with *ua1*.
   //   from_index1 - (OPTIONAL) The index of the first element of *ua1* to
   //                 compare. See <Common Arguments>. The default is 0.
   //   to_index1 - (OPTIONAL) The index of the last element of *ua1* to
   //               compare. See <Common Arguments>. The default is -1.
   //   from_index2 - (OPTIONAL) The index of the first element of *ua2* to
   //                 compare. See <Common Arguments>. The default is 0.
   //   to_index2 - (OPTIONAL) The index of the last element of *ua2* to
   //               compare. See <Common Arguments>. The default is -1.
   //   cmp - (OPTIONAL) A strategy object used to compare two unpacked
   //         arrays. If not specified or *null*, <comparator> *#(T)* is
   //         used. The default is *null*.
   //
   // Returns:
   //   If the numbers of elements to compare (*to_index1-from_index1+1* and
   //   *to_index2-from_index2+1*) are different, 0 is returned.  If the two
   //   unpacked arrays contain the same data in the specified range, 1 is
   //   returned. Otherwise, 0 is returned.
   //
   // Example:
   // | bit ua1[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit ua2[8] = '{ 1, 1, 0, 1, 1, 0, 0, 0 };
   // | //                    |<------>|
   // | //                    2        5
   // | assert( unpacked_array#(bit,8)::compare( ua1, ua2 ) == 0 );
   // | assert( unpacked_array#(bit,8)::compare( ua1, ua2, 
   // |         .from_index1( 2 ), .to_index1( 5 ), 
   // |         .from_index2( 2 ), .to_index2( 5 ) ) == 1 );
   //---------------------------------------------------------------------------

   static function bit compare( const ref ua_type ua1,
				const ref ua_type ua2,
				input int from_index1 = 0, 
				      int to_index1   = -1,
				      int from_index2 = 0, 
				      int to_index2   = -1,
				comparator#(T) cmp = null );
      return common_array#( T, ua_type, ua_type )::
	compare( ua1, ua2, from_index1, to_index1, from_index2, to_index2, cmp );
   endfunction: compare

   //---------------------------------------------------------------------------
   // Function: to_string
   //   (STATIC) Converts an unpacked array to the form of a string.
   //
   // Arguments:
   //   ua - An unpacked array to be converted.
   //   separator - (OPTIONAL) A string to separate each element of *ua*. The
   //               default is a space (" ").
   //   from_index - (OPTIONAL) The index of the first element of *ua* to
   //                convert. See <Common Arguments>. The default is 0.
   //   to_index - (OPTIONAL) The index of the last element of *ua* to convert.
   //              See <Common Arguments>. The default is -1.
   //   fmtr - (OPTIONAL) A strategy object used to format *ua*. If not
   //          specified or *null*, <hex_formatter> *#(T)* is used. The default
   //          is *null*.
   //
   // Returns:
   //   A string to represent *ua*.
   //
   // Example:
   // | bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
   // | assert( unpacked_array#(bit,8)::to_string( ua )                    == "0 0 0 1 1 0 1 1" );
   // | assert( unpacked_array#(bit,8)::to_string( ua, .separator( "-" ) ) == "0-0-0-1-1-0-1-1" );
   // | assert( unpacked_array#(bit,8)::to_string( ua, .from_index( 4 )  ) ==         "1 0 1 1" );
   //---------------------------------------------------------------------------

   static function string to_string( const ref ua_type ua,
				     input string separator = " ",
				     int from_index = 0,
				     int to_index = -1,
				     formatter#(T) fmtr = null );
      return common_array#(T, ua_type )::
	to_string( ua, separator, from_index, to_index, fmtr );
   endfunction: to_string
endclass: unpacked_array

`endif //  `ifndef CL_UNPACKED_ARRAY_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
