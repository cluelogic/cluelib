//==============================================================================
// cl_dynamic_array.svh (v0.6.1)
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

`ifndef CL_DYNAMIC_ARRAY_SVH
`define CL_DYNAMIC_ARRAY_SVH

//------------------------------------------------------------------------------
// Class: dynamic_array
//   A parameterized class that manages a dynamic array. 
//
// Parameters:
//   T - (OPTIONAL) The type of a dynamic array. The default type is *bit*.
//   SIZE - (OPTIONAL) The size of an unpacked array. This parameter is used
//          only if a dynamic array is converted from/to an unpacked array. The
//          default is 1.
//------------------------------------------------------------------------------

virtual class dynamic_array #( type T = bit, int SIZE = 1 );

   //---------------------------------------------------------------------------
   // Group: Common Arguments
   //   from_index - The index of the first element of a dynamic array to be
   //                processed.  If negative, the index counts from the last.
   //                For example, if *from_index* is -9, a function starts at
   //                the ninth element (inclusive) from the last.  The default
   //                is 0 (starts at the first element).
   //   to_index - The index of the last element of a dynamic array to be
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
   // Function: from_unpacked_array
   //   (STATIC) Converts an unpacked array of type *T* to a dynamic array of
   //   the same type.
   //
   // Arguments:
   //   ua      - An unpacked array to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *ua* is
   //             positioned to the index 0 of the dynamic array. If 1, the
   //             elements are positioned in the reverse order. The default is
   //             0.
   //             
   // Returns:
   //   A dynamic array converted from *ua*.
   //
   // Example:
   // | bit ua[8] =         '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // same as ua[0:7]
   // | bit da0[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | bit da1[] = new[8]( '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // |
   // | assert( dynamic_array#(bit,8)::from_unpacked_array( ua                ) == da0 );
   // | assert( dynamic_array#(bit,8)::from_unpacked_array( ua, .reverse( 1 ) ) == da1 );
   //
   // See Also:
   //   <ua_to_da>
   //---------------------------------------------------------------------------

   static function da_type from_unpacked_array( const ref ua_type ua,
						input bit reverse = 0 );
      from_unpacked_array = new[ $size( ua ) ];
      common_array#( T, ua_type, da_type )::a_to_a( ua, from_unpacked_array,
						    reverse );
   endfunction: from_unpacked_array

   //---------------------------------------------------------------------------
   // Function: to_unpacked_array
   //   (STATIC) Converts a dynamic array of type *T* to an unpacked array of
   //   the same type.
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
   // | bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | bit ua0[8] =       '{ 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit ua1[8] =       '{ 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | assert( dynamic_array#(bit,8)::to_unpacked_array( da                ) == ua0 );
   // | assert( dynamic_array#(bit,8)::to_unpacked_array( da, .reverse( 1 ) ) == ua1 );
   // 
   // See Also:
   //   <da_to_ua>
   //---------------------------------------------------------------------------

   static function ua_type to_unpacked_array( const ref da_type da,
					      input bit reverse = 0 );
      common_array#( T, da_type, ua_type )::a_to_a( da, to_unpacked_array, 
						    reverse );
   endfunction: to_unpacked_array

   //---------------------------------------------------------------------------
   // Function: from_queue
   //   (STATIC) Converts a queue of type *T* to a dynamic array of the same
   //   type.
   //
   // Arguments:
   //   q       - A queue to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *q* is
   //             positioned to the index 0 of the dynamic array. If 1, the
   //             elements are positioned in the reverse order. The default is
   //             0.
   //
   // Returns:
   //   A dynamic array converted from *q*.
   //
   // Example:
   // | bit q[$]  =          { 0, 0, 0, 1, 1, 0, 1, 1 }; // q[0] to q[7]
   // | bit da0[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | bit da1[] = new[8]( '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // |
   // | assert( dynamic_array#(bit)::from_queue( q                ) == da0 );
   // | assert( dynamic_array#(bit)::from_queue( q, .reverse( 1 ) ) == da1 );
   //
   // See Also:
   //   <q_to_da>
   //---------------------------------------------------------------------------

   static function da_type from_queue( const ref q_type q,
				       input bit reverse = 0 );
      from_queue = new[ q.size() ];
      common_array#( T, q_type, da_type )::a_to_a( q, from_queue, reverse );
   endfunction: from_queue

   //---------------------------------------------------------------------------
   // Function: to_queue
   //   (STATIC) Converts a dynamic array of type *T* to a queue of the same
   //   type.
   //
   // Arguments:
   //   da      - A dynamic array to be converted.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *da* is
   //             positioned to the index 0 of the queue. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   A queue converted from *da*.
   //
   // Example:
   // | bit da[]  = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | bit q0[$] =          { 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit q1[$] =          { 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | assert( dynamic_array#(bit)::to_queue( da                ) == q0 );
   // | assert( dynamic_array#(bit)::to_queue( da, .reverse( 1 ) ) == q1 );
   //
   // See Also:
   //   <da_to_q>
   //---------------------------------------------------------------------------

   static function q_type to_queue( const ref da_type da,
				    input bit reverse = 0 );
      common_array#( T, da_type, q_type )::a_to_q( da, to_queue, reverse );
   endfunction: to_queue

   //---------------------------------------------------------------------------
   // Function: ua_to_da
   //   (STATIC) Converts an unpacked array of type *T* to a dynamic array of
   //   the same type. Unlike <from_unpacked_array>, this function populates the
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
   // | bit ua[8] =         '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
   // | bit da0[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | bit da1[] = new[8]( '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // | bit da [] = new[8]; // set the size of da[]
   // |
   // | dynamic_array#(bit,8)::ua_to_da( ua, da );
   // | assert( da == da0 );
   // |
   // | dynamic_array#(bit,8)::ua_to_da( ua, da, .reverse( 1 ) );
   // | assert( da == da1 );
   // 
   // See Also:
   //   <from_unpacked_array>
   //---------------------------------------------------------------------------

   static function void ua_to_da( const ref ua_type ua,
				  ref da_type da,
				  input bit reverse = 0 );
      common_array#( T, ua_type, da_type )::a_to_a( ua, da, reverse );
   endfunction: ua_to_da
   
   //---------------------------------------------------------------------------
   // Function: da_to_ua
   //   (STATIC) Converts a dynamic array of type *T* to an unpacked array of
   //   the same type.  Unlike <to_unpacked_array>, this function populates the
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
   // | bit da[]   = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } ); // da[0] to da[7]
   // | bit ua0[8] =         '{ 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit ua1[8] =         '{ 1, 1, 0, 1, 1, 0, 0, 0 };
   // | bit ua [8];
   // |
   // | dynamic_array#(bit,8)::da_to_ua( da, ua );
   // | assert( ua == ua0 );
   // |
   // | dynamic_array#(bit,8)::da_to_ua( da, ua, .reverse( 1 ) );
   // | assert( ua == ua1 );
   //
   // See Also:
   //   <to_unpacked_array>
   //---------------------------------------------------------------------------

   static function void da_to_ua( const ref da_type da,
				  ref ua_type ua,
				  input bit reverse = 0 );
      common_array#( T, da_type, ua_type )::a_to_a( da, ua, reverse );
   endfunction: da_to_ua
   
   //---------------------------------------------------------------------------
   // Function: q_to_da
   //   (STATIC) Converts a queue of type *T* to a dynamic array of the same
   //   type.  Unlike <from_queue>, this function populates the dynamic array
   //   passed by reference, instead of returning a new dynamic array.
   //
   // Arguments:
   //   q - A queue to be converted.
   //   da - A dynamic array to be populated.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *q* is
   //             positioned to the index 0 of *da*. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit q[$]  =          { 0, 0, 0, 1, 1, 0, 1, 1 }; // q[0] to q[7]
   // | bit da0[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | bit da1[] = new[8]( '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // | bit da [] = new[8]; // set the size of da[]
   // |
   // | dynamic_array#(bit)::q_to_da( q, da );
   // | assert( da == da0 );
   // |
   // | dynamic_array#(bit)::q_to_da( q, da, .reverse( 1 ) );
   // | assert( da == da1 );
   //
   // See Also:
   //   <from_queue>
   //---------------------------------------------------------------------------

   static function void q_to_da( const ref q_type q,
				 ref da_type da,
				 input bit reverse = 0 );
      common_array#( T, q_type, da_type )::a_to_a( q, da, reverse );
   endfunction: q_to_da

   //---------------------------------------------------------------------------
   // Function: da_to_q
   //   (STATIC) Converts a dynamic array of type *T* to a queue of the same
   //   type. Unlike <to_queue>, this function populates the queue passed by
   //   reference instead of returning a new queue.
   //
   // Arguments:
   //   da - A dynamic array to be converted.
   //   q - A queue to be populated.  This function does _not_ change the size
   //       of *q*. Make sure that *q* has enough items to accommodate the
   //       elements of *da* before calling this function.
   //   reverse - (OPTIONAL) If 0, the element at the index 0 of *da* is
   //             positioned to the index 0 of *q*. If 1, the elements are
   //             positioned in the reverse order. The default is 0.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit da[]  = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } ); // da[0] to da[7]
   // | bit q0[$] =          { 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit q1[$] =          { 1, 1, 0, 1, 1, 0, 0, 0 };
   // | bit q [$];
   // |
   // | dynamic_array#(bit)::da_to_q( da, q );
   // | assert( q == q0 );
   // |
   // | q.delete();
   // | dynamic_array#(bit)::da_to_q( da, q, .reverse( 1 ) );
   // | assert( q == q1 );
   // 
   // See Also:
   //   <to_queue>
   //---------------------------------------------------------------------------

   static function void da_to_q( const ref da_type da,
				 ref q_type q,
				 input bit reverse = 0 );
      common_array#( T, da_type, q_type )::a_to_q( da, q, reverse );
   endfunction: da_to_q
   
   //---------------------------------------------------------------------------
   // Function: init
   //   (STATIC) Initializes the each element of the given dynamic array to the
   //   specified value.
   //
   // Arguments:
   //   da - A dynamic array to be initialized.
   //   val - A value to initialize the elements of *da*.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit da[]       = new[8];
   // | bit expected[] = new[8]( '{ 1, 1, 1, 1, 1, 1, 1, 1 } );
   // |
   // | dynamic_array#(bit)::init( da, 1'b1 );
   // | assert( da == expected );
   //---------------------------------------------------------------------------

   static function void init( ref da_type da, input T val );
      common_array#( T, da_type )::init( da, val );
   endfunction: init

   //---------------------------------------------------------------------------
   // Function: reverse
   //   (STATIC) Reverses the order of the elements of the given dynamic array.
   //
   // Argument:
   //   da - A dynamic array to be reversed.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit da[]       = new[8]( '{ 0, 0, 0, 0, 1, 1, 1, 1 } ); // da[0] to da[7]
   // | bit expected[] = new[8]( '{ 1, 1, 1, 1, 0, 0, 0, 0 } );
   // |
   // | dynamic_array#(bit)::reverse( da );
   // | assert( da == expected );
   //---------------------------------------------------------------------------

   static function void reverse( ref da_type da );
      common_array#( T, da_type )::reverse( da );
   endfunction: reverse

   //---------------------------------------------------------------------------
   // Function: split
   //   (STATIC) Splits the given dynamic array into two dynamic arrays.
   //
   // Arguments:
   //   da  - A dynamic array to be split.
   //   da0 - A new dynamic array that contains the elements at the even index
   //         of *da*.
   //   da1 - A new dynamic array that contains the elements at the odd index of
   //         *da*.
   //   pad - (OPTIONAL) If the size of *da* is odd and *pad* is 1, the size of
   //         *da1* is expanded to be the same size as *da0*. The padded
   //         element is initialized with the default value of type *T*.  If 0,
   //         no padding element is added. The default is 0.
   //
   // Example:
   // | bit da[] = new[7]( '{ 0, 0, 0, 1, 1, 0, 1 } ); // da[0] to da[6]
   // | bit da0[], da1[], expected_da0[], expected_da1[];
   // |
   // | expected_da0 = new[4]( '{ 0, 0, 1, 1 } ); // da[0], da[2], da[4], da[6]
   // | expected_da1 = new[3]( '{ 0, 1, 0    } ); // da[1], da[3], da[5]
   // | dynamic_array#(bit)::split( da, da0, da1 );
   // | assert( da0 == expected_da0 );
   // | assert( da1 == expected_da1 );
   // |
   // | expected_da0 = new[4]( '{ 0, 0, 1, 1 } ); // da[0], da[2], da[4], da[6]
   // | expected_da1 = new[4]( '{ 0, 1, 0, 0 } ); // the last element is padded with the default value of bit type
   // | dynamic_array#(bit)::split( da, da0, da1, .pad( 1 ) );
   // | assert( da0 == expected_da0 );
   // | assert( da1 == expected_da1 );
   //
   // See Also:
   //   <merge>
   //---------------------------------------------------------------------------

   static function void split( da_type da,
			       ref da_type da0,
			       ref da_type da1,
			       input bit pad = 0 );
      int da_size = da.size();

      if ( da_size % 2 == 0 ) begin // even
	 da0 = new[ da_size / 2 ];
	 da1 = new[ da_size / 2 ];
      end else if ( pad ) begin
	 da0 = new[ ( da_size + 1 ) / 2 ];
	 da1 = new[ ( da_size + 1 ) / 2 ];
      end else begin
	 da0 = new[ ( da_size + 1 ) / 2 ];
	 da1 = new[ da_size / 2 ];
      end
      for ( int i = 0; i < da.size(); i += 2 ) da0[i/2] = da[i];
      for ( int i = 1; i < da.size(); i += 2 ) da1[i/2] = da[i];
   endfunction: split      

   //---------------------------------------------------------------------------
   // Function: merge
   //   (STATIC) Merges two dynamic arrays into one by alternating the elements
   //   from the two arrays.
   //
   // Arguments:
   //   da0 - A dynamic array to be merged. The first element of this dynamic
   //         array becomes the first element of the merged array.
   //   da1 - Another dynamic array to be merged. The first element of this
   //         dynamic array becomes the second element of the merged array.
   //   truncate - (OPTIONAL) If the sizes of *da0* and *da1* are different and
   //              *truncate* is 1, the merging stops when all the elements of
   //              the smaller array are merged. The remaining elements of the
   //              larger array are ignored. If *truncate* is 0, the remaining
   //              elements are appended to the merged array. The default is 0.
   //
   // Returns:
   //   A new merged dynamic array.
   //
   // Example:
   // | int da0[] = new[4]( '{ 0, 0, 0, 0 } );
   // | int da1[] = new[6]( '{ 1, 2, 3, 4, 5, 6 } );
   // | int expected[];
   // |
   // | expected = new[10]( '{ 0, 1, 0, 2, 0, 3, 0, 4, 5, 6 } );
   // | assert( dynamic_array#(int)::merge( da0, da1 ) == expected );
   // |
   // | expected = new[8]( '{ 0, 1, 0, 2, 0, 3, 0, 4 } );
   // | assert( dynamic_array#(int)::merge( da0, da1, .truncate( 1 ) ) == expected );
   //
   // See Also:
   //   <concat>, <split>
   //---------------------------------------------------------------------------

   static function da_type merge( da_type da0,
				  da_type da1,
				  bit truncate = 0 );
      int da0_size = da0.size();
      int da1_size = da1.size();

      if ( da0_size == da1_size ) begin
	 merge = new[ da0_size + da1_size ];
	 for ( int i = 0; i < da0_size; i++ ) begin
	    merge[i*2  ] = da0[i];
	    merge[i*2+1] = da1[i];
	 end
      end else if ( da0_size < da1_size ) begin
	 if ( truncate ) begin
	    merge = new[ da0_size * 2 ];
	    for ( int i = 0; i < da0_size; i++ ) begin
	       merge[i*2  ] = da0[i];
	       merge[i*2+1] = da1[i];
	    end
	 end else begin
	    merge = new[ da0_size + da1_size ];
	    for ( int i = 0; i < da0_size; i++ ) begin
	       merge[i*2  ] = da0[i];
	       merge[i*2+1] = da1[i];
	    end
	    for ( int i = 0; i < ( da1_size - da0_size ); i++ )
	      merge[ da0_size * 2 + i ] = da1[ da0_size + i ];
	 end // else: !if( truncate )
      end else begin // da0_size > da1_size
	 if ( truncate ) begin
	    merge = new[ da1_size * 2 ];
	    for ( int i = 0; i < da1_size; i++ ) begin
	       merge[i*2  ] = da0[i];
	       merge[i*2+1] = da1[i];
	    end
	 end else begin
	    merge = new[ da0_size + da1_size ];
	    for ( int i = 0; i < da1_size; i++ ) begin
	       merge[i*2  ] = da0[i];
	       merge[i*2+1] = da1[i];
	    end
	    for ( int i = 0; i < ( da0_size - da1_size ); i++ )
	      merge[ da1_size * 2 + i ] = da1[ da1_size + i ];
	 end // else: !if( truncate )
      end
   endfunction: merge

   //---------------------------------------------------------------------------
   // Function: concat
   //   (STATIC) Concatenates two dynamic arrays into one.
   //
   // Arguments:
   //   da0 - A dynamic array. This array becomes the first part of the
   //         concatenated array.
   //   da1 - Another dynamic array. The elements of this array are appended to
   //         *da0*.
   //
   // Returns:
   //   A new dynamic array created by concatenating *da0* and *da1*.
   //
   // Example:
   // | int da0[]      = new[4] ( '{ 0, 0, 0, 0                   } );
   // | int da1[]      = new[6] ( '{             1, 2, 3, 4, 5, 6 } );
   // | int expected[] = new[10]( '{ 0, 0, 0, 0, 1, 2, 3, 4, 5, 6 } );
   // |
   // | assert( dynamic_array#(int)::concat( da0, da1 ) == expected );
   //
   // See Also:
   //   <merge>
   //---------------------------------------------------------------------------

   static function da_type concat( da_type da0,
				   da_type da1 );
      int da0_size = da0.size();
      int da1_size = da1.size();
      da_type da = new[ da0_size + da1_size ] ( da0 );

      for ( int i = 0; i < da1_size; i++ )
	da[ da0_size + i ] = da1[i];
      return da;
   endfunction: concat

   //---------------------------------------------------------------------------
   // Function: extract
   //   (STATIC) Returns a new dynamic array by extracting a part of the given
   //   dynamic array.
   //
   // Arguments:
   //   da - A dynamic array to be extracted.
   //   from_index - (OPTIONAL) The index of the first element of *da* to be
   //                extracted. See <Common Arguments>. The default is 0.
   //   to_index - (OPTIONAL) The index of the last element of *da* to be
   //              extracted. See <Common Arguments>. The default is -1.
   //
   // Returns:
   //   A new dynamic array extracted from *da*.
   //
   // Example:
   // | int da[]       = new[10]( '{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 } );
   // | int expected[] = new[5] ( '{          3, 4, 5, 6, 7       } );
   // |
   // | assert( dynamic_array#(int)::extract( da, 3,  7 ) == expected );
   // | assert( dynamic_array#(int)::extract( da, 3, -3 ) == expected );
   //---------------------------------------------------------------------------

   static function da_type extract( da_type da,
				    int from_index = 0,
				    int to_index = -1 );
      util::normalize( da.size(), from_index, to_index );
      extract = new[ to_index - from_index + 1 ];
      for ( int i = from_index; i <= to_index; i++ )
	extract[ i - from_index ] = da[i];
   endfunction: extract

   //---------------------------------------------------------------------------
   // Function: append
   //   (STATIC) Appends the specified element to the given dynamic array.
   //
   // Arguments:
   //   da - A dynamic array to be appended.
   //   e  - An element to append.
   //
   // Returns:
   //   A _copy_ of *da* appended with *e*. The input *da* is not modified.
   //
   // Example:
   // | int da[]       = new[10]( '{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9     } );
   // | int original[] = new[10]( '{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9     } );
   // | int expected[] = new[11]( '{ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 } );
   // |
   // | assert( dynamic_array#(int)::append( da, 10 ) == expected );
   // | assert( da == original ); // da is not modified
   //---------------------------------------------------------------------------

   static function da_type append( da_type da, T e );
      int da_size = da.size();
      
      append = new[ da_size + 1 ]( da );
      append[da_size] = e;
   endfunction: append

   //---------------------------------------------------------------------------
   // Function: compare
   //   (STATIC) Compares two dynamic arrays.
   //
   // Arguments:
   //   da1         - A dynamic array.
   //   da2         - Another dynamic array to compare with *da1*.
   //   from_index1 - (OPTIONAL) The first index of the *da1* to compare. See
   //                 <Common Arguments>. The default is 0.
   //   to_index1 - (OPTIONAL) The last index of the *da1* to compare. See
   //                 <Common Arguments>. The default is -1.
   //   from_index2 - (OPTIONAL) The first index of the *da2* to compare. See
   //                 <Common Arguments>. The default is 0.
   //   to_index2 - (OPTIONAL) The last index of the *da2* to compare. See
   //                 <Common Arguments>. The default is -1.
   //   cmp - (OPTIONAL) A strategy object used to compare two dynamic
   //         arrays. If not specified or null, *comparator#(T)* is used. The
   //         default is null.
   //
   // Returns:
   //   If the numbers of elements to compare (*to_index1-from_index1+1* and
   //   *to_index2-from_index2+1*) are different, 0 is returned.  If the two
   //   dynamic arrays contain the same data in the specified range, 1 is
   //   returned. Otherwise, 0 is returned.
   //
   // Example:
   // | bit da1[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | bit da2[] = new[8]( '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // | //                           |<------>|
   // | //                           2        5
   // | assert( dynamic_array#(bit)::compare( da1, da2 ) == 0 );
   // | assert( dynamic_array#(bit)::compare( da1, da2, 
   // |         .from_index1( 2 ), .to_index1( 5 ), 
   // |         .from_index2( 2 ), .to_index2( 5 ) ) == 1 );
   //---------------------------------------------------------------------------

   static function bit compare( const ref da_type da1,
				const ref da_type da2,
				input int from_index1 = 0, 
				int to_index1   = -1,
				int from_index2 = 0, 
				int to_index2   = -1,
				comparator#(T) cmp = null );
      return common_array#( T, da_type, da_type )::
	compare( da1, da2, from_index1, to_index1, from_index2, to_index2, cmp );
   endfunction: compare

   //---------------------------------------------------------------------------
   // Function: clone
   //   (STATIC) Returns a copy of the given dynamic array.
   //
   // Argument:
   //   da - A dynamic array to be cloned.
   //
   // Returns:
   //   A copy of *da*.
   //
   // Example:
   // | bit da[]       = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | bit expected[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit)::clone( da ) == expected );
   //---------------------------------------------------------------------------

   static function da_type clone( da_type da );
      clone = da; // same as new[ da.size() ]( da ); see LRM7.6
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: to_string
   //   (STATIC) Converts a dynamic array to the form of a string.
   //
   // Arguments:
   //   da - An dynamic array to be converted.
   //   separator - (OPTIONAL) A string to separate each element of *da*. The
   //               default is a space (" ").
   //   from_index - (OPTIONAL) The index of the first element of *da* to
   //                convert. See <Common Arguments>. The default is 0.
   //   to_index - (OPTIONAL) The index of the last element of *da* to convert.
   //              See <Common Arguments>. The default is -1.
   //   fmtr - (OPTIONAL) A strategy object used to format *da*. If not
   //          specified or *null*, <hex_formatter> *#(T)* is used. The default
   //          is *null*.
   //
   // Returns:
   //   A string to represent *da*.
   //
   // Example:
   // | bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit,8)::to_string( da )                    == "0 0 0 1 1 0 1 1" );
   // | assert( dynamic_array#(bit,8)::to_string( da, .separator( "-" ) ) == "0-0-0-1-1-0-1-1" );
   // | assert( dynamic_array#(bit,8)::to_string( da, .from_index( 4 )  ) ==         "1 0 1 1" );
   //---------------------------------------------------------------------------

   static function string to_string( const ref da_type da,
				     input string separator = " ",
				     int from_index = 0,
				     int to_index = -1,
				     formatter#(T) fmtr = null );
      return common_array#(T, da_type )::
	to_string( da, separator, from_index, to_index, fmtr );
   endfunction: to_string

endclass: dynamic_array

`endif //  `ifndef CL_DYNAMIC_ARRAY_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
