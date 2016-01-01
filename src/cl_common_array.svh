//==============================================================================
// cl_common_array.svh (v0.6.1)
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

`ifndef CL_COMMON_ARRAY_SVH
`define CL_COMMON_ARRAY_SVH

//------------------------------------------------------------------------------
// Class: common_array
//   The common array class used by the aggregate classes. There is no user
//   accessible function in this class.
//------------------------------------------------------------------------------

virtual class common_array #( type T = bit, type AT1 = bit[0:0], type AT2 = bit[0:0] );

   // The above bit[0:0] is required to make VCS and Incisive happy :)
   //              ^^^^^
   
   //---------------------------------------------------------------------------
   // Typedef q_type
   //   The shorthand of the queue of type *T*.
   //---------------------------------------------------------------------------

   typedef T q_type[$];

   //---------------------------------------------------------------------------
   // Function a_to_a
   //---------------------------------------------------------------------------

   static function void a_to_a( const ref AT1 src,
				ref AT2 dst,
				input bit reverse = 0 );
      T filler;
      integer src_size = $size( src );
      integer dst_size = $size( dst );
      int     min_size = choice#(integer)::min( src_size, dst_size );

      for ( int i = 0; i < min_size; i++ ) begin
	 if ( reverse ) dst[dst_size-1-i] = src[i];
	 else           dst[i]            = src[i];
      end
      for ( int i = min_size; i < dst_size; i++ ) begin
	 if ( reverse ) dst[dst_size-1-i] = filler;
	 else           dst[i]            = filler;
      end
   endfunction: a_to_a
   
   //---------------------------------------------------------------------------
   // Function a_to_q
   //---------------------------------------------------------------------------

   static function void a_to_q( const ref AT1 src,
				ref q_type dst,
				input bit reverse = 0 );
      integer src_size = $size( src );

      for ( int i = 0; i < src_size; i++ ) begin
	 if ( reverse ) dst.push_front( src[i] );
	 else	        dst.push_back ( src[i] );
      end
   endfunction: a_to_q
   
   //---------------------------------------------------------------------------
   // Function reverse
   //---------------------------------------------------------------------------

   static function void reverse( ref AT1 a );
      T tmp;
      integer a_size = $size( a );
      integer half_size = a_size / 2;

      for ( int i = 0; i < half_size; i++ ) begin
	 tmp = a[i];
	 a[i] = a[a_size-i-1];
	 a[a_size-i-1] = tmp;
      end
   endfunction: reverse

   //---------------------------------------------------------------------------
   // Function init
   //---------------------------------------------------------------------------

   static function void init( ref AT1 a, input T val );
      foreach( a[i] ) a[i] = val;
   endfunction: init

   //---------------------------------------------------------------------------
   // Function compare
   //---------------------------------------------------------------------------

   static function bit compare( const ref AT1 a1,
				const ref AT2 a2,
				input int from_index1 = 0, 
				int to_index1   = -1,
				int from_index2 = 0, 
				int to_index2   = -1,
				comparator#(T) cmp = null );
      integer a1_size = $size( a1 );
      integer a2_size = $size( a2 );
      int j;
      
      if ( from_index1 < 0 ) from_index1 += a1_size;
      if ( from_index2 < 0 ) from_index2 += a2_size;
      if ( to_index1   < 0 ) to_index1   += a1_size;
      if ( to_index2   < 0 ) to_index2   += a2_size;

      if ( a1_size <= from_index1 ) return 0;
      if ( a2_size <= from_index2 ) return 0;
      if ( a1_size <= to_index1   ) return 0;
      if ( a2_size <= to_index2   ) return 0;

      if ( from_index1 > to_index1 ) return 0;
      if ( from_index2 > to_index2 ) return 0;
      
      if ( to_index1 - from_index1 != to_index2 - from_index2 ) return 0;

      if ( cmp == null ) cmp = comparator#(T)::get_instance();

      j = from_index2;
      for ( int i = from_index1; i <= to_index1; i++ )
	if ( cmp.ne( a1[i], a2[j++] ) ) return 0;
      return 1;
   endfunction: compare

   //---------------------------------------------------------------------------
   // Function to_string
   //---------------------------------------------------------------------------

   static function string to_string( const ref AT1 a,
				     input string separator = " ",
				     int from_index = 0,
				     int to_index = -1,
				     formatter#(T) fmtr = null );
      string s = "";
      integer a_size = $size( a );

      util::normalize( a_size, from_index, to_index );
      if ( fmtr == null ) fmtr = hex_formatter#(T)::get_instance();

      for ( int i = from_index; i <= to_index; i++ ) begin
	 s = { s, fmtr.to_string( a[i] ) };
	 if ( i != to_index ) s = { s, separator };
      end
      return s;
   endfunction: to_string

endclass: common_array

`endif //  `ifndef CL_COMMON_ARRAY_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
