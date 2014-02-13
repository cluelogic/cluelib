//==============================================================================
// cl_common_packed_array.svh (v0.1.0)
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

`ifndef CL_COMMON_PACKED_ARRAY_SVH
`define CL_COMMON_PACKED_ARRAY_SVH

//------------------------------------------------------------------------------
// Class: common_packed_array
//------------------------------------------------------------------------------

virtual class common_packed_array #( type T = bit, int WIDTH = 1, type AT = T[WIDTH-1:0] );

   //---------------------------------------------------------------------------
   // Typedef: pa_type
   //   The shorthand of the packed array of type *T*.
   //---------------------------------------------------------------------------

   typedef T [WIDTH-1:0] pa_type;

   //---------------------------------------------------------------------------
   // Function: pa_to_a
   //---------------------------------------------------------------------------

   static function void pa_to_a( const ref pa_type src,
				 ref AT dst,
				 input bit reverse = 0 );
      T filler;
      integer src_size = $size( src );
      integer dst_size = $size( dst );
      int     min_size = choice#(integer)::min( src_size, dst_size );

      for ( int i = 0; i < min_size; i++ ) begin
	 if ( reverse ) dst[WIDTH-1-i] = src[i];
	 else           dst[i]         = src[i];
      end
      for ( int i = min_size; i < dst_size; i++ ) begin
	 if ( reverse ) dst[WIDTH-1-i] = filler;
	 else           dst[i]         = filler;
      end
   endfunction: pa_to_a
   
endclass: common_packed_array

`endif //  `ifndef CL_COMMON_PACKED_ARRAY_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
