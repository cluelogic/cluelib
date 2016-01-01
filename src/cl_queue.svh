//==============================================================================
// cl_queue.svh (v0.6.1)
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

`ifndef CL_QUEUE_SVH
`define CL_QUEUE_SVH

//------------------------------------------------------------------------------
// Class: queue
//   A parameterized class that manages a queue. 
//
//
// Parameters:
//   T - (OPTIONAL) The type of a queue. The default type is *bit*.
//   SIZE - (OPTIONAL) The size of an unpacked array. This parameter is used
//          only if a queue is converted from/to an unpacked array. The default
//          is 1.
//------------------------------------------------------------------------------

virtual class queue #( type T = bit, int SIZE = 1 );

   //---------------------------------------------------------------------------
   // Group: Common Arguments
   //   from_index - The index of the first element of a queue to be processed.
   //                If negative, the index counts from the last.  For example,
   //                if *from_index* is -9, a function starts at the ninth
   //                element (inclusive) from the last.  The default is 0
   //                (starts at the first element).
   //   to_index - The index of the last element of a queue to be processed.  If
   //              negative, the index counts from the last.  For example, if
   //              *to_index* is -3, a function ends at the third element
   //              (inclusive) from the last.  The default is -1 (ends at the
   //              last element).
   //---------------------------------------------------------------------------

   // Group: Types

   //---------------------------------------------------------------------------
   // Typedef: ua_type
   //   The shorthand of the unpacked array of type *T*.
   //---------------------------------------------------------------------------

   typedef T ua_type[SIZE];

   //---------------------------------------------------------------------------
   // Typedef: da_type
   //   The shorthand of the dynamic array of type *T*.
   //---------------------------------------------------------------------------

   typedef T da_type[];

   //---------------------------------------------------------------------------
   // Typedef: q_type
   //   The shorthand of the queue of type *T*.
   //---------------------------------------------------------------------------

   typedef T q_type[$];

   // Group: Functions

   //---------------------------------------------------------------------------
   // Function: from_unpacked_array
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
   // | bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // same as ua[0:7]
   // | bit q0[$] =  { 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit q1[$] =  { 1, 1, 0, 1, 1, 0, 0, 0 };
   // |
   // | assert( queue#(bit,8)::from_unpacked_array( ua                ) == q0 );
   // | assert( queue#(bit,8)::from_unpacked_array( ua, .reverse( 1 ) ) == q1 );
   //
   // See Also:
   //   <ua_to_q>
   //---------------------------------------------------------------------------

   static function q_type from_unpacked_array( const ref ua_type ua,
					       input bit reverse = 0 );
      common_array#( T, ua_type, q_type )::a_to_q( ua, from_unpacked_array,
						   reverse );
   endfunction: from_unpacked_array

   //---------------------------------------------------------------------------
   // Function: to_unpacked_array
   //   (STATIC) Converts a queue of type *T* to an unpacked array of the same
   //   type.
   //
   // Arguments:
   //   q      - A queue to be converted.
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
   // | assert( queue#(bit,8)::to_unpacked_array( q                ) == ua0 );
   // | assert( queue#(bit,8)::to_unpacked_array( q, .reverse( 1 ) ) == ua1 );
   // 
   // See Also:
   //   <q_to_ua>
   //---------------------------------------------------------------------------

   static function ua_type to_unpacked_array( const ref q_type q,
					      input bit reverse = 0 );
      common_array#( T, q_type, ua_type )::a_to_a( q, to_unpacked_array, 
						   reverse );
   endfunction: to_unpacked_array

   //---------------------------------------------------------------------------
   // Function: from_dynamic_array
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
   // | assert( queue#(bit)::from_dynamic_array( da                ) == q0 );
   // | assert( queue#(bit)::from_dynamic_array( da, .reverse( 1 ) ) == q1 );
   //
   // See Also:
   //   <da_to_q>
   //---------------------------------------------------------------------------

   static function q_type from_dynamic_array( const ref da_type da,
					      input bit reverse = 0 );
      common_array#( T, da_type, q_type )::a_to_q( da, from_dynamic_array, 
						   reverse );
   endfunction: from_dynamic_array
   
   //---------------------------------------------------------------------------
   // Function: to_dynamic_array
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
   // | assert( queue#(bit)::to_dynamic_array( q                ) == da0 );
   // | assert( queue#(bit)::to_dynamic_array( q, .reverse( 1 ) ) == da1 );
   //
   // See Also:
   //   <q_to_da>
   //---------------------------------------------------------------------------

   static function da_type to_dynamic_array( const ref q_type q,
					     input bit reverse = 0 );
      to_dynamic_array = new[ q.size() ];
      common_array#( T, q_type, da_type )::a_to_a( q, to_dynamic_array, 
						   reverse );
   endfunction: to_dynamic_array
   
   //---------------------------------------------------------------------------
   // Function: ua_to_q
   //   (STATIC) Converts an unpacked array of type *T* to a queue of the same
   //   type. Unlike <from_unpacked_array>, this function populates the queue
   //   passed by reference instead of returning a new queue.
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
   // | bit q0[$] =  { 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit q1[$] =  { 1, 1, 0, 1, 1, 0, 0, 0 };
   // | bit q[$];
   // |
   // | queue#(bit,8)::ua_to_q( ua, q );
   // | assert( q == q0 );
   // |
   // | q.delete();
   // | queue#(bit,8)::ua_to_q( ua, q, .reverse( 1 ) );
   // | assert( q == q1 );
   // 
   // See Also:
   //   <from_unpacked_array>
   //---------------------------------------------------------------------------

   static function void ua_to_q( const ref ua_type ua,
				 ref q_type q,
				 input bit reverse = 0 );
      common_array#( T, ua_type, q_type )::a_to_q( ua, q, reverse );
   endfunction: ua_to_q

   //---------------------------------------------------------------------------
   // Function: q_to_ua
   //   (STATIC) Converts a queue of type *T* to an unpacked array of the same
   //   type.  Unlike <to_unpacked_array>, this function populates the unpacked
   //   array passed by reference, instead of returning a new unpacked array. If
   //   the size of the queue is larger than *SIZE*, the excess elements are
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
   // | bit q[$]   =  { 0, 0, 0, 1, 1, 0, 1, 1 }; // q[0] to q[7]
   // | bit ua0[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit ua1[8] = '{ 1, 1, 0, 1, 1, 0, 0, 0 };
   // | bit ua[8];
   // |
   // | queue#(bit,8)::q_to_ua( q, ua );
   // | assert( ua == ua0 );
   // |
   // | queue#(bit,8)::q_to_ua( q, ua, .reverse( 1 ) );
   // | assert( ua == ua1 );
   //
   // See Also:
   //   <to_unpacked_array>
   //---------------------------------------------------------------------------

   static function void q_to_ua( const ref q_type q,
				 ref ua_type ua,
				 input bit reverse = 0 );
      common_array#( T, q_type, ua_type )::a_to_a( q, ua, reverse );
   endfunction: q_to_ua
   
   //---------------------------------------------------------------------------
   // Function: da_to_q
   //   (STATIC) Converts a dynamic array of type *T* to a queue of the same
   //   type. Unlike <from_dynamic_array>, this function populates the queue
   //   passed by reference instead of returning a new queue.
   //
   // Arguments:
   //   da - A dynamic array to be converted.
   //   q - A queue to be populated.
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
   // | bit q[$];
   // |
   // | queue#(bit)::da_to_q( da, q );
   // | assert( q == q0 );
   // |
   // | q.delete();
   // | queue#(bit)::da_to_q( da, q, .reverse( 1 ) );
   // | assert( q == q1 );
   // 
   // See Also:
   //   <from_dynamic_array>
   //---------------------------------------------------------------------------

   static function void da_to_q( const ref da_type da,
				 ref q_type q,
				 input bit reverse = 0 );
      common_array#( T, da_type, q_type )::a_to_q( da, q, reverse );
   endfunction: da_to_q
   
   //---------------------------------------------------------------------------
   // Function: q_to_da
   //   (STATIC) Converts a queue of type *T* to a dynamic array of the same
   //   type.  Unlike <to_dynamic_array>, this function populates the dynamic
   //   array passed by reference, instead of returning a new dynamic array.
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
   // | queue#(bit)::q_to_da( q, da );
   // | assert( da == da0 );
   // |
   // | queue#(bit)::q_to_da( q, da, .reverse( 1 ) );
   // | assert( da == da1 );
   //
   // See Also:
   //   <to_dynamic_array>
   //---------------------------------------------------------------------------

   static function void q_to_da( const ref q_type q,
				 ref da_type da,
				 input bit reverse = 0 );
      common_array#( T, q_type, da_type )::a_to_a( q, da, reverse );
   endfunction: q_to_da

   //---------------------------------------------------------------------------
   // Function: init
   //   (STATIC) Initializes the each element of the given queue to the
   //   specified value.
   //
   // Arguments:
   //   q - A queue to be initialized.  All the elements of *q* are initialized,
   //       but this function does _not_ change the size of *q*.
   //   val - A value to initialize the elements of *q*.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit q[$] = { 0, 0, 0, 0, 0, 0, 0, 0 };
   // | bit expected[$] = { 1, 1, 1, 1, 1, 1, 1, 1 };
   // |
   // | queue#(bit)::init( q, 1'b1 );
   // | assert( q == expected );
   //---------------------------------------------------------------------------

   static function void init( ref q_type q, input T val );
      common_array#( T, q_type )::init( q, val );
   endfunction: init

   //---------------------------------------------------------------------------
   // Function: reverse
   //   (STATIC) Reverses the order of the elements of the given queue.
   //
   // Argument:
   //   q - A queue to be reversed.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | bit q[$] = { 0, 0, 0, 0, 1, 1, 1, 1 };
   // | bit expected[$] = { 1, 1, 1, 1, 0, 0, 0, 0 };
   // |
   // | queue#(bit)::reverse( q );
   // | assert( q == expected );
   //---------------------------------------------------------------------------

   static function void reverse( ref q_type q );
      common_array#( T, q_type )::reverse( q );
   endfunction: reverse

   //---------------------------------------------------------------------------
   // Function: split
   //   (STATIC) Splits the given queue into two queues.
   //
   // Arguments:
   //   q  - A queue to be split.
   //   q0 - A new queue that contains the elements at the even index of *q*.
   //   q1 - A new queue that contains the elements at the odd index of *q*.
   //   pad - (OPTIONAL) If the size of *q* is odd and *pad* is 1, the size of
   //         *q1* is expanded to be the same size as *q0*. The padded element
   //         is initialized with the default value of type *T*.  If 0, no
   //         padding element is added. The default is 0.
   //
   // Example:
   // | bit q[$] = { 0, 0, 0, 1, 1, 0, 1 }; // q[0] to q[6]
   // | bit q0[$], q1[$], expected_q0[$], expected_q1[$];
   // |
   // | expected_q0 = { 0, 0, 1, 1 }; // q[0], q[2], q[4], q[6]
   // | expected_q1 = { 0, 1, 0    }; // q[1], q[3], q[5]
   // | queue#(bit)::split( q, q0, q1 );
   // | assert( q0 == expected_q0 );
   // | assert( q1 == expected_q1 );
   // |
   // | q0.delete();
   // | q1.delete();
   // | expected_q0 = { 0, 0, 1, 1 }; // q[0], q[2], q[4], q[6]
   // | expected_q1 = { 0, 1, 0, 0 }; // q[1], q[3], q[5], 0 (padded with the default value of bit type)
   // | queue#(bit)::split( q, q0, q1, .pad( 1 ) );
   // | assert( q0 == expected_q0 );
   // | assert( q1 == expected_q1 );
   //
   // See Also:
   //   <merge>
   //---------------------------------------------------------------------------

   static function void split( q_type q,
			       ref q_type q0,
			       ref q_type q1,
			       input bit pad = 0 );
      T dummy;
      int q_size = q.size();

      for ( int i = 0; i < q.size(); i += 2 ) q0.push_back( q[i] );
      for ( int i = 1; i < q.size(); i += 2 ) q1.push_back( q[i] );
      if ( q_size % 2 == 1 && pad ) q1.push_back( dummy );
   endfunction: split      

   //---------------------------------------------------------------------------
   // Function: merge
   //   (STATIC) Merges two queues into one by alternating the elements from the
   //   two queues.
   //
   // Arguments:
   //   q0 - A queue to be merged. The first element of this queue becomes the
   //        first element of the merged queue.
   //   q1 - Another queue to be merged. The first element of this queue becomes
   //        the second element of the merged queue.
   //   truncate - (OPTIONAL) If the sizes of *q0* and *q1* are different and
   //              *truncate* is 1, the merging stops when all the elements of
   //              the smaller queue are merged. The remaining elements of the
   //              larger queue are ignored. If *truncate* is 0, the remaining
   //              elements are appended to the merged queue. The default is 0.
   //
   // Returns:
   //   A new merged queue.
   //
   // Example:
   // | int q0[$] = { 0, 0, 0, 0 };
   // | int q1[$] = { 1, 2, 3, 4, 5, 6 };
   // | int expected[$];
   // |
   // | expected = { 0, 1, 0, 2, 0, 3, 0, 4, 5, 6 };
   // | assert( queue#(int)::merge( q0, q1 ) == expected );
   // |
   // | expected = { 0, 1, 0, 2, 0, 3, 0, 4 };
   // | assert( queue#(int)::merge( q0, q1, .truncate( 1 ) ) == expected );
   //
   // See Also:
   //   <concat>, <split>
   //---------------------------------------------------------------------------

   static function q_type merge( q_type q0,
				 q_type q1,
				 bit truncate = 0 );
      int q0_size = q0.size();
      int q1_size = q1.size();
      q_type q;

      if ( q0_size == q1_size ) begin
	 for ( int i = 0; i < q0_size; i++ ) begin
	    q.push_back( q0[i] );
	    q.push_back( q1[i] );
	 end
      end else if ( q0_size < q1_size ) begin
	 for ( int i = 0; i < q0_size; i++ ) begin
	    q.push_back( q0[i] );
	    q.push_back( q1[i] );
	 end
	 if ( ! truncate ) begin
	    for ( int i = q0_size; i < q1_size; i++ )
	      q.push_back( q1[i] );
	 end
      end else begin // q0_size > q1_size
	 for ( int i = 0; i < q1_size; i++ ) begin
	    q.push_back( q0[i] );
	    q.push_back( q1[i] );
	 end
	 if ( ! truncate ) begin
	    for ( int i = q1_size; i < q0_size; i++ )
	      q.push_back( q0[i] );
	 end
      end // else: !if( q0_size < q1_size )
      return q;
   endfunction: merge

   //---------------------------------------------------------------------------
   // Function: concat
   //   (STATIC) Concatenates two queues into one.
   //
   // Arguments:
   //   q0 - A queue. This queue becomes the first part of the concatenated
   //        queue.
   //   q1 - Another queue. The elements of this queue are appended to *q0*.
   //
   // Returns:
   //   A new queue created by concatenating *q0* and *q1*.
   //
   // Example:
   // | int q0[$]       = { 0, 0, 0, 0                   };
   // | int q1[$]       = {             1, 2, 3, 4, 5, 6 };
   // | int expected[$] = { 0, 0, 0, 0, 1, 2, 3, 4, 5, 6 };
   // |
   // | assert( queue#(int)::concat( q0, q1 ) == expected );
   //
   // See Also:
   //   <merge>
   //---------------------------------------------------------------------------

   static function q_type concat( q_type q0,
				  q_type q1 );
      q_type q = q0; // assign element by element
      for ( int i = 0; i < q1.size(); i++ ) q.push_back( q1[i] );
      return q;
   endfunction: concat

   //---------------------------------------------------------------------------
   // Function: extract
   //   (STATIC) Returns a new queue by extracting a part of the given queue.
   //
   // Arguments:
   //   q - A queue to be extracted.
   //   from_index - (OPTIONAL) The index of the first element of *q* to be
   //                extracted. See <Common Arguments>. The default is 0.
   //   to_index - (OPTIONAL) The index of the last element of *q* to be
   //              extracted. See <Common Arguments>. The default is -1.
   //
   // Returns:
   //   A new queue extracted from *q*.
   //
   // Example:
   // | int q[$]        = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 };
   // | int expected[$] = {          3, 4, 5, 6, 7       };
   // |
   // | assert( queue#(int)::extract( q, 3,  7 ) == expected );
   // | assert( queue#(int)::extract( q, 3, -3 ) == expected );
   //---------------------------------------------------------------------------

   static function q_type extract( q_type q,
				   int from_index = 0,
				   int to_index   = -1 );
      util::normalize( q.size(), from_index, to_index );
      extract = q[ from_index : to_index ];
   endfunction: extract

   //---------------------------------------------------------------------------
   // Function: append
   //   (STATIC) Appends the specified element to the given queue.
   //
   // Arguments:
   //   q - A queue to be appended.
   //   e  - An element to append.
   //
   // Returns:
   //   A _copy_ of *q* appended with *e*. The input *q* is not modified.
   //
   // Example:
   // | int q[$]        = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9     };
   // | int original[$] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9     };
   // | int expected[$] = { 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 };
   // |
   // | assert( queue#(int)::append( q, 10 ) == expected );
   // | assert( q == original ); // not modified
   //---------------------------------------------------------------------------

   static function q_type append( q_type q, T e );
      append = q; // assign element by element
      append.push_back( e );
   endfunction: append

   //---------------------------------------------------------------------------
   // Function: compare
   //   (STATIC) Compares two queues.
   //
   // Arguments:
   //   q1         - A queue.
   //   q2         - Another queue to compare with *q1*.
   //   from_index1 - (OPTIONAL) The first index of the *q1* to compare. See
   //                 <Common Arguments>. The default is 0.
   //   to_index1 - (OPTIONAL) The last index of the *q1* to compare. See
   //               <Common Arguments>. The default is -1.
   //   from_index2 - (OPTIONAL) The first index of the *q2* to compare. See
   //                 <Common Arguments>. The default is 0.
   //   to_index2 - (OPTIONAL) The last index of the *q2* to compare. See
   //               <Common Arguments>. The default is -1.
   //   cmp - (OPTIONAL) A strategy object used to compare two queues.  If not
   //         specified or null, *comparator#(T)* is used. The default is null.
   //
   // Returns:
   //   If the numbers of elements to compare (*to_index1-from_index1+1* and
   //   *to_index2-from_index2+1*) are different, 0 is returned.  If the two
   //   queues contain the same data in the specified range, 1 is
   //   returned. Otherwise, 0 is returned.
   //
   // Example:
   // | bit q1[$] = { 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit q2[$] = { 1, 1, 0, 1, 1, 0, 0, 0 };
   // | //                  |<------>|
   // | //                  2        5
   // | assert( queue#(bit)::compare( q1, q2 ) == 0 );
   // | assert( queue#(bit)::compare( q1, q2, 
   // |         .from_index1( 2 ), .to_index1( 5 ), 
   // |         .from_index2( 2 ), .to_index2( 5 ) ) == 1 );
   //---------------------------------------------------------------------------

   static function bit compare( const ref q_type q1,
				const ref q_type q2,
				input int from_index1 = 0, 
				int to_index1   = -1,
				int from_index2 = 0, 
				int to_index2   = -1,
				comparator#(T) cmp = null );
      return common_array#( T, q_type, q_type )::
	compare( q1, q2, from_index1, to_index1, from_index2, to_index2, cmp );
   endfunction: compare

   //---------------------------------------------------------------------------
   // Function: clone
   //   (STATIC) Returns a copy of the given queue.
   //
   // Argument:
   //   q - A queue to be cloned.
   //
   // Returns:
   //   A copy of *q*.
   //
   // Example:
   // | bit q[$]        = { 0, 0, 0, 1, 1, 0, 1, 1 };
   // | bit expected[$] = { 0, 0, 0, 1, 1, 0, 1, 1 };
   // | assert( queue#(bit)::clone( q ) == expected );
   //---------------------------------------------------------------------------

   static function q_type clone( q_type q );
      clone = q; // assign element by element
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: to_string
   //   (STATIC) Converts a queue to the form of a string.
   //
   // Arguments:
   //   q - An queue to be converted.
   //   separator - (OPTIONAL) A string to separate each element of *q*. The
   //               default is a space (" ").
   //   from_index - (OPTIONAL) The index of the first element of *q* to
   //                convert. See <Common Arguments>. The default is 0.
   //   to_index - (OPTIONAL) The index of the last element of *q* to convert.
   //              See <Common Arguments>. The default is -1.
   //   fmtr - (OPTIONAL) A strategy object used to format *q*. If not
   //          specified or *null*, <hex_formatter> *#(T)* is used. The default
   //          is *null*.
   //
   // Returns:
   //   A string to represent *q*.
   //
   // Example:
   // | bit q[$] = { 0, 0, 0, 1, 1, 0, 1, 1 };
   // | assert( queue#(bit,8)::to_string( q )                    == "0 0 0 1 1 0 1 1" );
   // | assert( queue#(bit,8)::to_string( q, .separator( "-" ) ) == "0-0-0-1-1-0-1-1" );
   // | assert( queue#(bit,8)::to_string( q, .from_index( 4 )  ) ==         "1 0 1 1" );
   //---------------------------------------------------------------------------

   static function string to_string( const ref q_type q,
				     input string separator = " ",
				     int from_index = 0,
				     int to_index = -1,
				     formatter#(T) fmtr = null );
      return common_array#(T, q_type )::
	to_string( q, separator, from_index, to_index, fmtr );
   endfunction: to_string

endclass: queue

`endif //  `ifndef CL_QUEUE_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
