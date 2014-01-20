//==============================================================================
// cl_dynamic_array.svh (v0.1.0)
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

`ifndef CL_DYNAMIC_ARRAY_SVH
`define CL_DYNAMIC_ARRAY_SVH

//------------------------------------------------------------------------------
// Class: dynamic_array
//   A parameterized class that manages a dynamic array. The default type is
//   *bit*. *WIDTH* is used to specify the size of an unpacked array only if the
//   dynamic array is converted to/from the unpacked array.
//------------------------------------------------------------------------------

virtual class dynamic_array #( type T = bit, int WIDTH = 1 );

   local static formatter#(T) default_fmtr = formatter#(T)::get_instance();

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

   local static comparator#(T) default_cmp = new();

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
   // | assert( dynamic_array#(bit,8)::from_unpacked_array( ua                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit,8)::from_unpacked_array( ua, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   //---------------------------------------------------------------------------

   static function da_type from_unpacked_array( ua_type ua,
						bit reverse = 0 );
      da_type da = new[WIDTH];

      // Bit-stream casting cannot be used as the T may not be an integral type.

      foreach ( ua[i] ) begin
	 if ( reverse ) da[WIDTH-1-i] = ua[i];
	 else           da[i]         = ua[i];
      end
      
      return da;
   endfunction: from_unpacked_array

   //---------------------------------------------------------------------------
   // Function: from_queue
   //   Converts a queue of type *T* to the dynamic array of the same type.
   //
   // Arguments:
   //   q       - An input queue.
   //   reverse - (OPTIONAL) If 1, the item at index 0 of the queue
   //             occupies the index WIDTH-1 of the dynamic array. If 0, the
   //             item at index 0 of the queue occupies the index 0 of
   //             the dynamic array. The default is 0.
   //
   // Returns:
   //   The dynamic array converted from *q*.
   //
   // Examples:
   // | bit q[$] = '{ 0, 0, 0, 1, 1, 0, 1, 1 };
   // | assert( dynamic_array#(bit)::from_queue( ua                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit)::from_queue( ua, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   //---------------------------------------------------------------------------

   static function da_type from_queue( q_type q,
				       bit reverse = 0 );
      int len = q.size();
      da_type da = new[len];

      foreach ( q[i] ) begin
	 if ( reverse ) da[len-1-i] = q[i];
	 else           da[i]       = q[i];
      end
      return da;
   endfunction: from_queue

   //---------------------------------------------------------------------------
   // Function: to_unpacked_array
   //   Converts a dynamic array of type *T* to the unpacked array of the same
   //   type. If the size of the dynamic array is smaller than *WIDTH*, the
   //   remaining elements have the default initial values of type *T*.  If the
   //   size of the dynamic array is larger than *WIDTH*, excess elements are
   //   ignored.
   //
   // Arguments:
   //   da      - An input dynamic array.
   //   reverse - (OPTIONAL) If 1, the item at index 0 of the dynamic array
   //             occupies the index WIDTH-1 of the unpacked array. If 0, the
   //             item at index 0 of the dynamic array occupies the index 0 of
   //             the unpacked array. The default is 0.
   //
   // Returns:
   //   The unpacked array converted from *da*.
   //
   // Examples:
   // | bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit,8)::to_unpacked_array( da                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit,8)::to_unpacked_array( da, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   //---------------------------------------------------------------------------

   static function ua_type to_unpacked_array( da_type da,
					      bit reverse = 0 );
      ua_type ua;
      da_type size_adjusted_da;

      if ( da.size() == WIDTH )	size_adjusted_da = da;
      else                      size_adjusted_da = new[WIDTH]( da );

      for ( int i = 0; i < WIDTH; i++ ) begin
	 if ( reverse ) ua[WIDTH-1-i] = size_adjusted_da[i];
	 else           ua[i]         = size_adjusted_da[i];
      end
      return ua;
   endfunction: to_unpacked_array
   
   //---------------------------------------------------------------------------
   // Function: to_queue
   //   Converts a dynamic array of type *T* to the queue of the same type.
   //
   // Arguments:
   //   da      - An input dynamic array.
   //   reverse - (OPTIONAL) If 1, the item at index 0 of the dynamic array
   //             occupies the index WIDTH-1 of the queue. If 0, the item at
   //             index 0 of the dynamic array occupies the index 0 of the
   //             queue. The default is 0.
   //
   // Returns:
   //   The queue converted from *da*.
   //
   // Examples:
   // | bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit)::to_queue( da                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit)::to_queue( da, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   //---------------------------------------------------------------------------

   static function q_type to_queue( da_type da,
				    bit reverse = 0 );
      q_type q;

      foreach ( da[i] ) begin
	 if ( reverse ) q.push_front( da[i] );
	 else	        q.push_back ( da[i] );
      end
      return q;
   endfunction: to_queue

   //---------------------------------------------------------------------------
   // Function: compare
   //   Compares two dynamic arrays.
   //
   // Arguments:
   //   da1         - A dynamic array.
   //   da2         - Another dynamic array to compare with *da1*.
   //   from_index1 - (OPTIONAL) The first index of the *da1* to compare.
   //                 If negative, count from the last.  For example, if the
   //                 *from_index1* is -9, compare from the ninth element
   //                 (inclusive) from the last.  The default value is 0.
   //   to_index1   - (OPTIONAL) The last index of the *da1* to compare.
   //                 If negative, count from the last.  For example, if the
   //                 *from_index1* is -3, compare to the third element
   //                 (inclusive) from the last.  The default value is -1
   //                 (compare to the last element).
   //   from_index2 - (OPTIONAL) The first index of the *da2* to compare.
   //                 If negative, count from the last.  For example, if the
   //                 *from_index2* is -9, compare from the ninth element
   //                 (inclusive) from the last.  The default value is 0.
   //   to_index2   - (OPTIONAL) The last index of the *da2* to compare.
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
   // | bit da1[];
   // | bit da2[];
   // | da1 = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | da2 = new[8]( '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   // | assert( dynamic_array#(bit)::compare( da1, da2 ) == 0 );
   // | assert( dynamic_array#(bit)::compare( da1, da2, .from_index1( 2 ), .to_index1( 5 ), 
   // |                                                 .from_index2( 2 ), .to_index2( 5 ) ) == 1 );
   //---------------------------------------------------------------------------

   static function bit compare( da_type da1,
				da_type da2,
				int from_index1 = 0, 
				int to_index1   = -1,
				int from_index2 = 0, 
				int to_index2   = -1,
				comparator#(T) cmp = null );
      int j;
      
      if ( from_index1 < 0 ) from_index1 += da1.size();
      if ( from_index2 < 0 ) from_index2 += da2.size();
      if ( to_index1   < 0 ) to_index1   += da1.size();
      if ( to_index2   < 0 ) to_index2   += da2.size();

      if ( da1.size() <= from_index1 ) return 0;
      if ( da2.size() <= from_index2 ) return 0;
      if ( da1.size() <= to_index1   ) return 0;
      if ( da2.size() <= to_index2   ) return 0;

      if ( from_index1 > to_index1 ) return 0;
      if ( from_index2 > to_index2 ) return 0;
      
      if ( to_index1 - from_index1 != to_index2 - from_index2 ) return 0;

      j = from_index2;
      for ( int i = from_index1; i <= to_index1; i++ ) begin
	 if ( cmp ) begin
	    if ( cmp.ne( da1[i], da2[j++] ) ) return 0;
	 end else begin
	    if ( default_cmp.ne( da1[i], da2[j++] ) ) return 0;
	 end
      end
      return 1;
   endfunction: compare

   //---------------------------------------------------------------------------
   // Function: clone
   //   Returns a copy of the given dynamic array.
   //
   // Argument:
   //   da - A dynamic array to be cloned.
   //
   // Returns:
   //   A copy of *da*.
   //
   // Example:
   // | bit da[];
   // | da = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit)::clone( da ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   //---------------------------------------------------------------------------

   static function da_type clone( da_type da );
      clone = new[ da.size() ]( da );
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: reverse
   //   Returns a copy of the given dynamic array with the elements in reverse
   //   order.
   //
   // Argument:
   //   da - An input dynamic array.
   //
   // Returns:
   //   A copy of *da* with the elements in reverse order.
   //
   // Example:
   // | bit da[];
   // | da = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
   // | assert( dynamic_array#(bit)::reverse( da ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
   //---------------------------------------------------------------------------

   static function da_type reverse( da_type da );
      int len = da.size();

      reverse = new[len];
      foreach ( da[i] ) reverse[len-1-i] = da[i];
   endfunction: reverse

   //---------------------------------------------------------------------------
   // Function to_string
   //   Returns a string representation of this dynamic array.
   //
   // Argument:
   //   da   - An input dynamic array.
   //   fmtr - (OPTIONAL) An object that provides a function to convert the
   //          element of type *T* to a string.
   //
   // Returns:
   //   A string that represents this dynamic array.
   //---------------------------------------------------------------------------

   static function string to_string( da_type da,
				     formatter#(T) fmtr = null );
      string s;

      s = "[ ";
      foreach ( da[i] ) 
	if ( fmtr )
	  s = { s, fmtr.to_string( da[i] ), " " };
	else
	  s = { s, default_fmtr.to_string( da[i] ), " " };
      s = { s, "]" };
      return s;
   endfunction: to_string

endclass: dynamic_array

`endif //  `ifndef CL_DYNAMIC_ARRAY_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
