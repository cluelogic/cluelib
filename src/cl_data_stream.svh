//==============================================================================
// cl_data_stream.svh (v0.1.0)
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
  
`ifndef CL_DATA_STREAM_SVH
`define CL_DATA_STREAM_SVH

//------------------------------------------------------------------------------
// Class: data_stream
//   A parameterized class that manages a stream of a packed array. 
//
// Parameters:
//   T - (OPTIONAL) The type of the packed array. The *T* must be the single bit
//       data types (*bit*, *logic*, *reg*), enumerated types, or other packed
//       arrays or packed structures. The default is *bit*.
//   WIDTH - (OPTIONAL) The width of the packed array. The default is 1.
//   DEGREE - (OPTIONAL) The degree of LFSR polynomial if *scramble* function is
//            used. The default is 2.
//------------------------------------------------------------------------------

virtual class data_stream #( type T = bit, int WIDTH = 1, int DEGREE = 2 ) extends dynamic_array #( T [WIDTH-1:0] );

   //---------------------------------------------------------------------------
   // Typedef: pa_type
   //   The shorthand of the packed array of type *T*.
   //---------------------------------------------------------------------------

   typedef T [WIDTH-1:0] pa_type;

   //---------------------------------------------------------------------------
   // Typedef: ds_type
   //   Data stream type. The shorthand of the dynamic array of *pa_type*.
   //---------------------------------------------------------------------------

   typedef pa_type ds_type[];

/*
   //---------------------------------------------------------------------------
   // Function: from_bit_stream
   // *TBD*
   //---------------------------------------------------------------------------

   static function void from_bit_stream( T bitstream[],
					 ref pa_type datastream[],
					 input bit msb_first = 1,
					 int 	   from_index = 0,
					 int 	   to_index = -1 );
   endfunction: from_bit_stream

   //---------------------------------------------------------------------------
   // Function: to_bit_stream
   // *TBD*
   //---------------------------------------------------------------------------

   static function void to_bit_stream( pa_type datastream[],
				       ref T bitstream[],
				       input bit msb_first = 1,
				       int 	 from_index = 0,
				       int 	 to_index = -1 );
   endfunction: to_bit_stream
*/
   //---------------------------------------------------------------------------
   // Function: sequential
   //   Returns a data stream with the elements whose values are sequential.
   //
   // Arguments:
   //   length               - The length of output data stream.
   //   init_value           - (OPTIONAL) The value of the first element. The 
   //                          default is 0.
   //   step                 - (OPTIONAL) The value difference between two 
   //                          adjacent elements. The default is 1.
   //   randomize_init_value - (OPTIONAL) If 1, the value of the first element
   //                          is randomized and the *init_value* argument is
   //                          ignored. The default is 0.
   //
   // Returns:
   //   A data stream with the elements whose values are sequential.
   //
   // Examples:
   // | assert( data_stream#(bit,8)::sequential( .length( 8 ), .init_value( 8'hFE )              ) == '{ 8'hFE, 8'hFF, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05 } );
   // | assert( data_stream#(bit,8)::sequential( .length( 8 ), .init_value( 8'hFE ), .step(  2 ) ) == '{ 8'hFE, 8'h00, 8'h02, 8'h04, 8'h06, 8'h08, 8'h0A, 8'h0C } );
   // | assert( data_stream#(bit,8)::sequential( .length( 8 ), .init_value( 8'hFE ), .step( -1 ) ) == '{ 8'hFE, 8'hFD, 8'hFC, 8'hFB, 8'hFA, 8'hF9, 8'hF8, 8'hF7 } );
   //
   // Limitation:
   //   The *randomize_init_value* can generate up to 32-bit initial value.
   //---------------------------------------------------------------------------

   static function ds_type sequential( int unsigned length,
				       pa_type init_value = 0,
				       pa_type step = 1,
				       bit randomize_init_value = 0 );
      pa_type next_value;
      ds_type ds;

      // { $random } gives a positive value.
      // See IEEE 1800-2012 Section 20.15.1 for more info.

      if ( randomize_init_value )
	next_value = { $random } % ( 1 << WIDTH );
      else
	next_value = init_value;

      ds = new[ length ];
      foreach ( ds[i] ) begin
	 ds[i] = next_value;
	 next_value += step;
      end
      return ds;
   endfunction: sequential

   //---------------------------------------------------------------------------
   // Function: constant
   //   Returns a data stream with the elements whose values are the same.
   //
   // Arguments:
   //   length          - The length of output data stream.
   //   value           - (OPTIONAL) The value of the elements. The default is 
   //                     0.
   //   randomize_value - (OPTIONAL) If 1, the value of the elements is
   //                     randomized and the *value* argument is ignored. The
   //                     default is 0.
   //
   // Returns:
   //   A data stream with the elements whose values are the same.
   //
   // Example:
   // | assert( data_stream#(bit,8)::constant( .length( 8 ), .value( 8'hFE ) ) == '{ 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE, 8'hFE } );
   //
   // Limitation:
   //   The *randomize_init_value* can generate up to 32-bit value.
   //---------------------------------------------------------------------------

   static function ds_type constant( int unsigned length,
				     pa_type value = 0,
				     bit randomize_value = 0 );
      return data_stream::sequential( length, value, .step( 0 ), 
				      .randomize_init_value( randomize_value ) );
   endfunction: constant

   //---------------------------------------------------------------------------
   // Function: random
   //   Returns a data stream with the elements whose values are randomized.
   //
   // Arguments:
   //   length - The length of output data stream.
   //
   // Returns:
   //   A data stream with the elements whose values are randomized.
   //
   // Limitation:
   //   This function can generate up to 32-bit value.
   //---------------------------------------------------------------------------

   static function ds_type random( int unsigned length );
      ds_type ds = new[ length ];
      foreach ( ds[i] ) ds[i] = { $random } % ( 1 << WIDTH );
      return ds;
   endfunction: random

   typedef scrambler#(T,DEGREE)::lfsr_type lfsr_type;

   //---------------------------------------------------------------------------
   // Function: scramble
   //   Returns a scrambled data stream.
   //
   // Arguments:
   //   ds - The input data stream.
   //   scrblr - The scrambler to use.
   //   lfsr - The value of the LFSR, which can be used as the seed of the next
   //          call of this function. The initial value should be all ones.
   //   little_endian - (OPTIONAL) If 1, each data stream item is scrambled from
   //                   LSBs. If 0, each data stream item is scrambled from
   //                   MSBs. The default is 0.
   //
   // Returns:
   //   The scrambled data stream.
   //---------------------------------------------------------------------------

   static function ds_type scramble( ds_type ds,
				     scrambler#(T,DEGREE) scrblr,
				     ref lfsr_type lfsr,
				     input bit little_endian = 0 );
      scramble = new[ ds.size() ];
      foreach ( ds[i] ) begin
	 T bitstream[];

	 bitstream = packed_array#(T,WIDTH)::to_dynamic_array( ds[i], 
							       little_endian );
	 scramble[i] = packed_array#(T,WIDTH)::from_dynamic_array
		       ( scrblr.scramble( bitstream, lfsr ), little_endian );
      end
   endfunction: scramble

   //---------------------------------------------------------------------------
   // Function: to_string
   //    Converts a data stream to the form of a string.
   // 
   // Arguments:
   //   ds              - An input data stream.
   //   left_to_right   - (OPTIONAL) If 1, the item at index 0 of the dynamic
   //                     array is placed on the left of the output string. If
   //                     0, the item at index 0 of the data stream is placed
   //                     on the right of the output string. The default is 1.
   //   group           - (OPTIONAL) The number of items put together in a
   //                     group. If 0, no groups are created. The default is 0.
   //   group_separator - (OPTIONAL) A string to separate two groups if 
   //                     *group* is not 0. The default is a single space
   //                     (" ").
   //   num_head        - (OPTIONAL) The number of first items in the data 
   //                     stream converted to a string. If specified, *ds[0]* to
   //                     *ds[num_head-1]* are converted. If not specified (or
   //                     -1), all items in the data stream are converted.
   //   num_tail        - (OPTIONAL) The number of last items in the data 
   //                     stream converted to a string. If specified,
   //                     *ds[ds.size()-num_tail]* to *ds[ds.size()-1]* are
   //                     converted. If not specified (or -1), all items in the
   //                     data stream are converted.
   //   abbrev          - (OPTIONAL) A string to indicate the abbreviation of 
   //                     the items in the data stream. The *abbrev* is used
   //                     only if not all items are converted to a string. The
   //                     default is three periods ("...").
   //
   // Returns:
   //   A string representing *ds*.
   //
   // Examples:
   // 
   // | ds16 = new[7]( '{ 16'h0123, 16'h4567, 16'h89ab, 16'hcdef, 16'h0000, 16'h0001, 16'h1000 } );
   // | assert( data_stream#(bit,16)::to_string( ds16 ) == "0123456789abcdef000000011000" );
   // | assert( data_stream#(bit,16)::to_string( ds16, .group( 1 ) ) == "0123 4567 89ab cdef 0000 0001 1000" );
   // | assert( data_stream#(bit,16)::to_string( ds16, .group( 1 ), .num_head( 2 ), .num_tail( 0 ) ) == "0123 4567 ..." );
   // | assert( data_stream#(bit,16)::to_string( ds16, .group( 1 ), .num_head( 0 ), .num_tail( 2 ) ) == "...0001 1000" );
   // | assert( data_stream#(bit,16)::to_string( ds16, .group( 1 ), .num_head( 2 ), .num_tail( 2 ) ) == "0123 4567 ...0001 1000" );
   //---------------------------------------------------------------------------

   static function string to_string( ds_type ds,
				     bit left_to_right = 1,
				     int unsigned group = 0,
				     string group_separator = " ",
				     int num_head = -1,
				     int num_tail = -1,
				     string abbrev = "..." );
      bit enables[];
      int len = ds.size();

      enables = new[ len ];
      for ( int i = 0; i < len; i++ ) enables[i] = 1'b1;
      return to_string_with_en( ds, enables, "-", left_to_right,
				group, group_separator, num_head, 
				num_tail, abbrev );
   endfunction: to_string

   //---------------------------------------------------------------------------
   // Function: to_string_with_en
   //   Converts a data stream with corresponding data enables to the form of a
   //   string.
   //
   // Arguments:
   //   ds              - An input data stream.
   //   enables         - The dynamic array of data enables corresponding to 
   //                     the data in the *ds*. The size of *enables* should be
   //                     the same as the size of *ds*. If the size of *enables*
   //                     is larger than the size of *ds*, excess data enables
   //                     are ignored. If the size of *enables* is smaller than
   //                     the size of *ds*, the remaining data are treated as
   //                     disabled.
   //   disabled_char   - (OPTIONAL) The character representing disabled data. 
   //                     The default character is a dash ("-").
   //   left_to_right   - (OPTIONAL) If 1, the item at index 0 of the dynamic
   //                     array is placed on the left of the output string. If
   //                     0, the item at index 0 of the data stream is placed
   //                     on the right of the output string. The default is 1.
   //   group           - (OPTIONAL) The number of items put together in a
   //                     group. If 0, no groups are created. The default is 0.
   //   group_separator - (OPTIONAL) A string to separate two groups if 
   //                     *group* is not 0. The default is a single space
   //                     (" ").
   //   num_head        - (OPTIONAL) The number of first items in the data 
   //                     stream converted to a string. If specified, *ds[0]* to
   //                     *ds[num_head-1]* are converted. If not specified (or
   //                     -1), all items in the data stream are converted.
   //   num_tail        - (OPTIONAL) The number of last items in the data 
   //                     stream converted to a string. If specified,
   //                     *ds[ds.size()-num_tail]* to *ds[ds.size()-1]* are
   //                     converted. If not specified (or -1), all items in the
   //                     data stream are converted.
   //   abbrev          - (OPTIONAL) A string to indicate the abbreviation of 
   //                     the items in the data stream. The *abbrev* is used
   //                     only if not all items are converted to a string. The
   //                     default is three periods ("...").
   //
   // Returns:
   //   A string representing *ds* qualified with *enables*.
   //
   // Examples:
   // | bit[7:0] ds8 = new[10]( '{ 8'h10, 8'h11, 8'h12, 8'h13, 8'h14, 8'h15, 8'h16, 8'h17, 8'h18, 8'h19 } );
   // | bit      en  = new[10]( '{ 1'b1,  1'b0,  1'b1,  1'b0,  1'b1,  1'b0,  1'b1,  1'b0,  1'b1,  1'b0  } );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en ) == "10--12--14--16--18--" );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en, .group( 1 ) ) == "10 -- 12 -- 14 -- 16 -- 18 --" );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en, .group( 2 ) ) == "10-- 12-- 14-- 16-- 18--" );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en, .group( 1 ), .group_separator( "|" ) ) == "10|--|12|--|14|--|16|--|18|--" );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en, .group( 1 ), .num_head( 2 ), .num_tail( 2 ) ) == "10 -- ...18 --" );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en, .group( 1 ), .disabled_char( "*" ) ) == "10 ** 12 ** 14 ** 16 ** 18 **" );
   //---------------------------------------------------------------------------

   static function string to_string_with_en( ds_type ds,
					     bit enables[],
					     byte disabled_char = "-",
					     bit left_to_right = 1,
					     int unsigned group = 0,
					     string group_separator = " ",
					     int num_head = -1,
					     int num_tail = -1,
					     string abbrev = "..." );
      string s = "";
      int    num_data = ds.size();
      int    max_index = num_data - 1;
      bit    is_abbrev;
      bit    en[];

      if ( num_head == -1 || 
	   num_tail == -1 || 
	   num_head + num_tail >= num_data ) begin
	 num_head = num_data;
	 num_tail = 0;
	 is_abbrev = 0;
      end else begin
	 is_abbrev = 1;
      end

      // match the size of enables to the size of ds
      
      en = new[ num_data ]( enables ); 

      if ( left_to_right ) begin // ds[0] at the left
	 for ( int i = 0; i < num_head; i++ ) begin
	    s = { s, format_data( ds[i], en[i], disabled_char ) };
	    if ( separated(  group, i, max_index, left_to_right ) )
	      s = { s, group_separator };
	 end
	 if ( is_abbrev ) s = { s, abbrev };
	 for ( int i = num_data - num_tail; i < num_data; i++ ) begin
	    s = { s, format_data( ds[i], en[i], disabled_char ) };
	    if ( separated( group, i, max_index, left_to_right ) )
	      s = { s, group_separator };
	 end
      end else begin // ds[0] at the right
	 for ( int i = max_index; i >= num_data - num_tail; i-- ) begin
	    s = { s, format_data( ds[i], en[i], disabled_char ) };
	    if ( separated( group, i, max_index, left_to_right ) )
	      s = { s, group_separator };
	 end
	 if ( is_abbrev ) s = { s, abbrev };
	 for ( int i = num_head - 1; i >= 0; i-- ) begin
	    s = { s, format_data( ds[i], en[i], disabled_char ) };
	    if ( separated( group, i, max_index, left_to_right ) )
	      s = { s, group_separator };
	 end
      end
      return s;
   endfunction: to_string_with_en

   //---------------------------------------------------------------------------
   // format_data
   //---------------------------------------------------------------------------

   protected static function string format_data( pa_type data,
						 bit enabled,
						 byte disabled_char );
      if ( enabled ) begin
	 return $sformatf( "%h", data );
      end else begin
	 string s = "";

	 repeat ( util::num_hex_digits( WIDTH ) ) s = { s, disabled_char };
	 return s;
      end
   endfunction: format_data

   //---------------------------------------------------------------------------
   // separated
   //---------------------------------------------------------------------------

   protected static function bit separated( int unsigned group,
					    int index,
					    int last_index,
					    bit left_to_right );
      int loc_from_right;

      if ( left_to_right ) loc_from_right = last_index - index;
      else                 loc_from_right = index;

      return ( group != 0 && index != last_index && 
	       loc_from_right % group == 0 );
   endfunction: separated

endclass: data_stream

`endif //  `ifndef CL_DATA_STREAM_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
