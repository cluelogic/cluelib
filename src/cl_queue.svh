//==============================================================================
// cl_queue.svh (v0.1.0)
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

`ifndef CL_QUEUE_SVH
`define CL_QUEUE_SVH

//------------------------------------------------------------------------------
// Class: queue
//   A parameterized class that manages a dynamic array. The default type is
//   *bit*. *WIDTH* is used to specify the size of an unpacked array only if the
//   dynamic array is converted to/from the unpacked array.
//------------------------------------------------------------------------------

virtual class queue #( type T = bit, int WIDTH = 1 );

   local static formatter#(T) default_fmtr = hex_formatter#(T)::get_instance();
   local static comparator#(T) default_cmp = comparator#(T)::get_instance();

   //---------------------------------------------------------------------------
   // Typedef: ua_type
   //   The shorthand of the unpacked array of type *T*.
   //---------------------------------------------------------------------------

   typedef T ua_type[WIDTH];

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

   //---------------------------------------------------------------------------
   // Function: from_unpacked_array
   //   Converts an unpacked array of type *T* to the dynamic array of the same
   //   type.
   //
   // Arguments:
   //   ua      - An input unpacked array.
   //   reverse - (OPTIONAL) If 1, the item at index 0 of the unpacked array
   //             occupies the index WIDTH-1 of the dynamic array. If 0, the
   //             item at index 0 of the unpacked array occupies the index 0 of
   //             the dynamic array. The default is 0.
   //             
   // Returns:
   //   The dynamic array converted from *ua*.
   //
   // Examples:
   // | bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // same as ua[0:7]
   // | assert( queue#(bit,8)::from_unpacked_array( ua                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( queue#(bit,8)::from_unpacked_array( ua, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   //---------------------------------------------------------------------------

   static function q_type from_unpacked_array( const ref ua_type ua,
					       input bit reverse = 0 );
      common_array#( T, WIDTH, ua_type )::a_to_q( ua, from_unpacked_array,
						  reverse );
   endfunction: from_unpacked_array

   //---------------------------------------------------------------------------
   // Function: to_unpacked_array
   //---------------------------------------------------------------------------

   static function ua_type to_unpacked_array( const ref q_type q,
					      input bit reverse = 0 );
      common_array#( T, WIDTH, ua_type )::q_to_a( q, to_unpacked_array, 
						  reverse );
   endfunction: to_unpacked_array

   //---------------------------------------------------------------------------
   // Function: from_dynamic_array
   //---------------------------------------------------------------------------

   static function q_type from_dynamic_array( const ref da_type da,
					      input bit reverse = 0 );
      common_array#( T, WIDTH, da_type )::a_to_q( da, from_dynamic_array, 
						  reverse );
   endfunction: from_dynamic_array
   
   //---------------------------------------------------------------------------
   // Function: to_dynamic_array
   //---------------------------------------------------------------------------

   static function da_type to_dynamic_array( const ref q_type q,
					     input bit reverse = 0 );
      to_dynamic_array = new[ q.size() ];
      common_array#( T, WIDTH, da_type )::q_to_a( q, to_dynamic_array, 
						  reverse );
   endfunction: to_dynamic_array
   
   //---------------------------------------------------------------------------
   // Function: init
   //---------------------------------------------------------------------------

   static function void init( ref q_type q, input T val );
      common_array#( T, WIDTH, q_type )::init( q, val );
   endfunction: init

   //---------------------------------------------------------------------------
   // Function: reverse
   //   Returns a copy of the given dynamic array with the elements in reverse
   //   order.
   //
   // Argument:
   //   q - An input dynamic array.
   //
   // Returns:
   //   A copy of *q* with the elements in reverse order.
   //
   // Example:
   // | bit q[];
   // | q = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( queue#(bit)::reverse( q ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   //---------------------------------------------------------------------------

   static function void reverse( ref q_type q );
      common_array#( T, WIDTH, q_type )::reverse( q );
   endfunction: reverse

   //---------------------------------------------------------------------------
   // Function: split
   //   Splits the specified queue into two queues.
   //
   // Arguments:
   //   ds  - Input data stream.
   //   ds0 - Output data stream with data elements at even location of the
   //         input data stream.
   //   ds1 - Output data stream with data elements at odd location of the
   //         input data stream.
   //   pad - (OPTIONAL) If the size of input data stream is odd and *pad* is 1,
   //         the size of *ds1* is extended to be the same size as *ds0*. If 0,
   //         no padding element is added. The default is 0.
   //
   // Examples:
   // | ds=[0][1][2][3][4] --> ds0=[0][2][4] ds1=[1][3]    (pad=0)
   // | ds=[0][1][2][3][4] --> ds0=[0][2][4] ds1=[1][3][ ] (pad=1)
   //---------------------------------------------------------------------------
   /*
   static function void split( q_type q,
			       ref q_type q0,
			       ref q_type q1,
			       input bit pad = 0 );
      int q_size = q.size();

      if ( q_size % 2 == 0 ) begin // even
	 q0 = new[ q_size / 2 ];
	 q1 = new[ q_size / 2 ];
      end else if ( pad ) begin
	 q0 = new[ ( q_size + 1 ) / 2 ];
	 q1 = new[ ( q_size + 1 ) / 2 ];
      end else begin
	 q0 = new[ ( q_size + 1 ) / 2 ];
	 q1 = new[ q_size / 2 ];
      end
      for ( int i = 0; i < q.size(); i += 2 ) q0[i/2] = q[i];
      for ( int i = 1; i < q.size(); i += 2 ) q1[i/2] = q[i];
   endfunction: split      

   //---------------------------------------------------------------------------
   // Function: merge
   //---------------------------------------------------------------------------

   static function q_type merge( q_type q0,
				  q_type q1,
				  bit truncate = 0 );
      int q0_size = q0.size();
      int q1_size = q1.size();

      if ( q0_size == q1_size ) begin
	 merge = new[ q0_size + q1_size ];
	 for ( int i = 0; i < q0_size; i++ ) begin
	    merge[i*2  ] = q0[i];
	    merge[i*2+1] = q1[i];
	 end
      end else if ( q0_size < q1_size ) begin
	 if ( truncate ) begin
	    merge = new[ q0_size * 2 ];
	    for ( int i = 0; i < q0_size; i++ ) begin
	       merge[i*2  ] = q0[i];
	       merge[i*2+1] = q1[i];
	    end
	 end else begin
	    merge = new[ q0_size + q1_size ];
	    for ( int i = 0; i < q0_size; i++ ) begin
	       merge[i*2  ] = q0[i];
	       merge[i*2+1] = q1[i];
	    end
	    for ( int i = 0; i < ( q1_size - q0_size ); i++ )
	      merge[ q0_size * 2 + i ] = q1[ q0_size + i ];
	 end // else: !if( truncate )
      end else begin // q0_size > q1_size
	 if ( truncate ) begin
	    merge = new[ q1_size * 2 ];
	    for ( int i = 0; i < q1_size; i++ ) begin
	       merge[i*2  ] = q0[i];
	       merge[i*2+1] = q1[i];
	    end
	 end else begin
	    merge = new[ q0_size + q1_size ];
	    for ( int i = 0; i < q1_size; i++ ) begin
	       merge[i*2  ] = q0[i];
	       merge[i*2+1] = q1[i];
	    end
	    for ( int i = 0; i < ( q0_size - q1_size ); i++ )
	      merge[ q1_size * 2 + i ] = q1[ q1_size + i ];
	 end // else: !if( truncate )
      end
   endfunction: merge

   //---------------------------------------------------------------------------
   // Function: concat
   //   Concatenate the specified two dynamic arrays.
   //
   // Arguments:
   //   q0 - Input dynamic array.
   //   q1 - Another dynamic array.
   //
   // Returns:
   //   A new dynamic array by concatenating *q0* and *q1*.
   //---------------------------------------------------------------------------

   static function q_type concat( q_type q0,
				   q_type q1 );
      int q0_size = q0.size();
      int q1_size = q1.size();
      q_type q = new[ q0_size + q1_size ] ( q0 );

      for ( int i = 0; i < q1_size; i++ )
	q[ q0_size + i ] = q1[i];
      return q;
   endfunction: concat

   //---------------------------------------------------------------------------
   // Function: extract
   //---------------------------------------------------------------------------

   static function q_type extract( q_type q,
				    int from_index = 0,
				    int to_index = -1 );
      util::normalize( q.size(), from_index, to_index );
      extract = new[ to_index - from_index + 1 ];
      for ( int i = from_index; i <= to_index; i++ )
	extract[ i - from_index ] = q[i];
   endfunction: extract

   //---------------------------------------------------------------------------
   // Function: append
   //   Appends the specified element to the specified dynamic array.
   //
   // Arguments:
   //   q - The input dynamic array.
   //   e  - An element to append.
   //
   // Returns:
   //   The copy of *q* appended with *e*.
   //---------------------------------------------------------------------------

   static function q_type append( q_type q, T e );
      int q_size = q.size();
      
      append = new[ q_size + 1 ]( q );
      append[q_size] = e;
   endfunction: append

   //---------------------------------------------------------------------------
   // Function: compare
   //   Compares two dynamic arrays.
   //
   // Arguments:
   //   q1         - A dynamic array.
   //   q2         - Another dynamic array to compare with *q1*.
   //   from_index1 - (OPTIONAL) The first index of the *q1* to compare.
   //                 If negative, count from the last.  For example, if the
   //                 *from_index1* is -9, compare from the ninth element
   //                 (inclusive) from the last.  The default value is 0.
   //   to_index1   - (OPTIONAL) The last index of the *q1* to compare.
   //                 If negative, count from the last.  For example, if the
   //                 *from_index1* is -3, compare to the third element
   //                 (inclusive) from the last.  The default value is -1
   //                 (compare to the last element).
   //   from_index2 - (OPTIONAL) The first index of the *q2* to compare.
   //                 If negative, count from the last.  For example, if the
   //                 *from_index2* is -9, compare from the ninth element
   //                 (inclusive) from the last.  The default value is 0.
   //   to_index2   - (OPTIONAL) The last index of the *q2* to compare.
   //                 If negative, count from the last.  For example, if the
   //                 *from_index2* is -3, compare to the third element
   //                 (inclusive) from the last.  The default value is -1
   //                 (compare to the last element).
   //   cmp         - (OPTIONAL) Compare strategy. If not specified or null, 
   //                 *comparator#(T)* is used. The default is null.
   //
   // Returns:
   //   If two dynamic arrays contain the same data, 1 is returned. Otherwise, 
   //   0 is returned.
   //
   // Examples:
   // | bit q1[];
   // | bit q2[];
   // | q1 = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | q2 = new[8]( '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // | assert( queue#(bit)::compare( q1, q2 ) == 0 );
   // | assert( queue#(bit)::compare( q1, q2, .from_index1( 2 ), .to_index1( 5 ), 
   // |                                                 .from_index2( 2 ), .to_index2( 5 ) ) == 1 );
   //---------------------------------------------------------------------------

   static function bit compare( const ref q_type q1,
				const ref q_type q2,
				input int from_index1 = 0, 
				int to_index1   = -1,
				int from_index2 = 0, 
				int to_index2   = -1,
				comparator#(T) cmp = null );
      return common_array#( T, WIDTH, q_type )::
	compare( q1, q2, from_index1, to_index1, from_index2, to_index2, cmp );
   endfunction: compare

   //---------------------------------------------------------------------------
   // Function: clone
   //   Returns a copy of the given dynamic array.
   //
   // Argument:
   //   q - A dynamic array to be cloned.
   //
   // Returns:
   //   A copy of *q*.
   //
   // Example:
   // | bit q[];
   // | q = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( queue#(bit)::clone( q ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   //---------------------------------------------------------------------------

   static function q_type clone( q_type q );
      clone = q; // same as new[ q.size() ]( q ); see LRM7.6
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: to_string
   //   Returns a string representation of this dynamic array.
   //
   // Argument:
   //   q   - An input dynamic array.
   //   fmtr - (OPTIONAL) An object that provides a function to convert the
   //          element of type *T* to a string.
   //
   // Returns:
   //   A string that represents this dynamic array.
   //---------------------------------------------------------------------------

   static function string to_string( const ref q_type q,
				     input string separator = " ",
				     formatter#(T) fmtr = null );
      return common_array#( T, WIDTH, q_type )::to_string( q, separator, fmtr );
   endfunction: to_string
*/
endclass: queue

`endif //  `ifndef CL_QUEUE_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
