//==============================================================================
// cl_data_stream.svh (v0.6.1)
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
  
`ifndef CL_DATA_STREAM_SVH
`define CL_DATA_STREAM_SVH

//------------------------------------------------------------------------------
// Class: data_stream
//   A parameterized class that manages a stream of packed arrays.
//
// Parameters:
//   T - (OPTIONAL) The type of the packed array of a data stream. The *T* must
//       be the single bit data types (*bit*, *logic*, or *reg*).  The default
//       type is *bit*.
//   WIDTH - (OPTIONAL) The width of the packed array. The default is 1.
//   DEGREE - (OPTIONAL) The degree of an LFSR polynomial. This parameter is
//            used only if *scramble* function is used. The default is 2.
//------------------------------------------------------------------------------

virtual class data_stream #( type T = bit, int WIDTH = 1, int DEGREE = 2 ) 
   extends dynamic_array #( T[WIDTH-1:0] );

   //---------------------------------------------------------------------------
   // Group: Common Arguments
   //   from_index - The index of the first element of a data stream to be
   //                processed.  If negative, the index counts from the last.
   //                For example, if *from_index* is -9, a function starts at
   //                the ninth element (inclusive) from the last.  The default
   //                is 0 (starts at the first element).
   //   to_index - The index of the last element of a data stream to be
   //              processed.  If negative, the index counts from the last.  For
   //              example, if *to_index* is -3, a function ends at the third
   //              element (inclusive) from the last.  The default is -1 (ends
   //              at the last element).
   //---------------------------------------------------------------------------

   // Group: Types

   //---------------------------------------------------------------------------
   // Typedef: pa_type
   //   The shorthand of the packed array of type *T*.
   //---------------------------------------------------------------------------

   typedef T [WIDTH-1:0] pa_type;

   //---------------------------------------------------------------------------
   // Typedef: ds_type
   //   The data stream type. The shorthand of the dynamic array of <pa_type>.
   //---------------------------------------------------------------------------

   typedef pa_type ds_type[];

   //---------------------------------------------------------------------------
   // Typedef: bs_type
   //   The bit stream type. The shorthand of the dynamic array of type *T*.
   //---------------------------------------------------------------------------

   typedef T bs_type[];

   //---------------------------------------------------------------------------
   // Typedef: lfsr_type
   //   The linear feedback shift register (LFSR) type. The shorthand of the
   //   *lfsr_type* defined in the <scrambler> class.
   //---------------------------------------------------------------------------

   typedef scrambler#(T,DEGREE)::lfsr_type lfsr_type;

   // Group: Functions

   //---------------------------------------------------------------------------
   // Function: to_bit_stream
   //   (STATIC) Serializes a data stream of type *T* to a bit stream of the
   //   same type.
   //
   // Arguments:
   //   ds - An input data stream.
   //   msb_first - (OPTIONAL) If 1, converts *ds* from the most significant bit
   //               to the least significant bit. If 0, converts *ds* from the
   //               least significant bit to the most signicant bit. The default
   //               is 1.
   //   from_index - (OPTIONAL) The index of the first element of *ds* to
   //                convert. See <Common Arguments>. The default is 0.
   //   to_index - (OPTIONAL) The index of the last element of *ds* to
   //              convert. See <Common Arguments>. The default is -1.
   //
   // Returns:
   //   A _new_ bit stream serialized from *ds*.
   //
   // Example:
   // | bit[7:0] ds[] = new[2]( '{ 8'h0F, 8'hAA } );
   // | bit bs0[] = new[16]( '{ 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0 } );
   // | bit bs1[] = new[16]( '{ 1, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1 } );
   // |
   // | assert( data_stream#(bit,8)::to_bit_stream( ds                  ) == bs0 );
   // | assert( data_stream#(bit,8)::to_bit_stream( ds, .msb_first( 0 ) ) == bs1 );
   //---------------------------------------------------------------------------

   static function bs_type to_bit_stream( ds_type ds,
					  bit msb_first = 1,
					  int from_index = 0,
					  int to_index = -1 );
      bs_type bs;
      
      util::normalize( ds.size(), from_index, to_index );
      bs = new[ ( to_index - from_index + 1 ) * WIDTH ];

      for ( int i = from_index; i <= to_index; i++ ) begin
	 if ( msb_first ) begin
	    for ( int j = 0; j < WIDTH; j++ )
	      bs[ i * WIDTH + j ] = ds[i][ WIDTH - 1 - j ];
	 end else begin
	    for ( int j = 0; j < WIDTH; j++ )
	      bs[ i * WIDTH + j ] = ds[i][j];
	 end
      end
      return bs;
   endfunction: to_bit_stream

   //---------------------------------------------------------------------------
   // Function: make_divisible
   //   (STATIC) Makes the data stream divisible by the specified number by
   //   padding data.
   //
   // Arguments:
   //   ds - An input data stream.
   //   divisible_by - (OPTIONAL) The output data stream is divisible by this
   //                  number. The default is 1.
   //   padding - (OPTIONAL) Padding data. The default is 0.
   //
   // Returns:
   //   A _new_ data stream made divisible by *divisible_by*.
   //
   // Example:
   // | bit[7:0] ds[]       = new[4]( '{ 8'h00, 8'h01, 8'h02, 8'h03               } );
   // | bit[7:0] expected[] = new[6]( '{ 8'h00, 8'h01, 8'h02, 8'h03, 8'hFF, 8'hFF } );
   // |
   // | assert( data_stream#(bit,8)::make_divisible( ds, .divisible_by( 3 ), .padding( 8'hFF ) ) == expected );
   //---------------------------------------------------------------------------

   static function ds_type make_divisible( ds_type ds,
					   int divisible_by = 1,
					   pa_type padding = 0 );
      assert( divisible_by > 0 ) begin
	 if ( ds.size() % divisible_by == 0 ) begin // already divisible
	    return ds;
	 end else begin
	    int ds_size = ds.size();
	    int num_padding = divisible_by - ( ds_size % divisible_by );
	    ds_type padded_ds = new[ ds_size + num_padding ]( ds );

	    for ( int i = 0; i < num_padding; i++ )
	      padded_ds[ ds_size + i ] = padding;
	    return padded_ds;
	 end
      end else begin
	 $fatal( 2, "divisible_by=%0d is not positive", divisible_by );
	 return ds;
      end
   endfunction: make_divisible

   //---------------------------------------------------------------------------
   // Function: sequential
   //   (STATIC) Returns a new data stream with the elements whose values are
   //   initialized with sequential values.
   //
   // Arguments:
   //   length     - The length of the output data stream.
   //   init_value - (OPTIONAL) The value of the first element. The default is
   //                0.
   //   step - (OPTIONAL) The value difference between two adjacent
   //          elements. The default is 1.
   //   randomize_init_value - (OPTIONAL) If 1, the value of the first element
   //                          is randomized (the *init_value* argument is
   //                          ignored). The default is 0.
   //
   // Returns:
   //   A _new_ data stream with the elements whose values are initialized with
   //   sequential values.
   //
   // Example:
   // | bit[7:0] ds0[] = new[8]( '{ 8'hFE, 8'hFF, 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05 } );
   // | bit[7:0] ds1[] = new[8]( '{ 8'hFE, 8'h00, 8'h02, 8'h04, 8'h06, 8'h08, 8'h0A, 8'h0C } );
   // | bit[7:0] ds2[] = new[8]( '{ 8'hFE, 8'hFD, 8'hFC, 8'hFB, 8'hFA, 8'hF9, 8'hF8, 8'hF7 } );
   // |
   // | assert( data_stream#(bit,8)::sequential( .length( 8 ), .init_value( 8'hFE )              ) == ds0 );
   // | assert( data_stream#(bit,8)::sequential( .length( 8 ), .init_value( 8'hFE ), .step(  2 ) ) == ds1 );
   // | assert( data_stream#(bit,8)::sequential( .length( 8 ), .init_value( 8'hFE ), .step( -1 ) ) == ds2 );
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
	next_value = { ( ( WIDTH - 1 ) / 32 + 1 ) { $random } } % ( 1 << WIDTH );
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
   //   (STATIC) Returns a new data stream with the elements whose values are
   //   initiazlized with the specified constant.
   //
   // Arguments:
   //   length - The length of the output data stream.
   //   value  - (OPTIONAL) The value of the elements. The default is 0.
   //   randomize_value - (OPTIONAL) If 1, the value of the elements is
   //                     randomized (the *value* argument is ignored). The
   //                     default is 0.
   //
   // Returns:
   //   A _new_ data stream with the elements whose values are initialized with *value*.
   //
   // Example:
   // | bit[7:0] expected[] = new[8]( '{ 8'hAB, 8'hAB, 8'hAB, 8'hAB, 8'hAB, 8'hAB, 8'hAB, 8'hAB } );
   // | assert( data_stream#(bit,8)::constant( .length( 8 ), .value( 8'hAB ) ) == expected );
   //---------------------------------------------------------------------------

   static function ds_type constant( int unsigned length,
				     pa_type value = 0,
				     bit randomize_value = 0 );
      return data_stream::sequential( length, value, .step( 0 ), 
				      .randomize_init_value( randomize_value ) );
   endfunction: constant

   //---------------------------------------------------------------------------
   // Function: random
   //   (STATIC) Returns a new data stream with the elements whose values are
   //   randomized.
   //
   // Arguments:
   //   length - The length of the output data stream.
   //
   // Returns:
   //   A _new_ data stream with the elements whose values are randomized.
   //
   // Example:
   // | bit[7:0] ds[];
   // | ds = data_stream#(bit,8)::random( .length( 16 ) );
   // | $display( data_stream#(bit,8)::to_string( ds, .group( 1 ) ) );
   //---------------------------------------------------------------------------

   static function ds_type random( int unsigned length );
      ds_type ds = new[ length ];
      foreach ( ds[i] )
	ds[i] = { ( ( WIDTH - 1 ) / 32 + 1 ) { $random } } % ( 1 << WIDTH );
      return ds;
   endfunction: random

   //---------------------------------------------------------------------------
   // Function: scramble
   //   (STATIC) Returns a scrambled data stream.
   //
   // Arguments:
   //   ds - An input data stream.
   //   scrblr - A scrambler to use.
   //   lfsr - The value of a linear feedback shift register (LFSR), which can
   //          be used as the seed of the next call of this function. The
   //          initial value should be all ones.
   //   msb_first - If 1, scrambles *ds* from the most significant bit.  If 0,
   //               scrambles *ds* from the least significant bit to the most
   //               signicant bit. The default is 1.
   //   little_endian - (OPTIONAL) If 1, each data-stream item is scrambled from
   //                   LSBs. If 0, each data stream item is scrambled from
   //                   MSBs. The default is 0.
   //
   // Returns:
   //   A _new_ data stream scrambled by *scrblr*.
   //
   // Example:
   // | bit[7:0] ds[] = new[8]( '{ 8'h00, 8'h01, 8'h02, 8'h03, 8'h04, 8'h05, 8'h06, 8'h07 } );
   // | bit[7:0] scrambled[];
   // | scrambler_16#(bit) scrblr = new;
   // | bit[15:0] lfsr = '1;
   // |
   // | scrambled = data_stream#(bit,8,16)::scramble( ds, scrblr, lfsr ); // DEGREE=16
   // | $display( data_stream#(bit,8)::to_string( scrambled, .group( 1 ) ) );
   //---------------------------------------------------------------------------

   static function ds_type scramble( ds_type ds,
				     scrambler#(T,DEGREE) scrblr,
				     ref lfsr_type lfsr,
				     input bit msb_first = 1 );
      scramble = new[ ds.size() ];
      foreach ( ds[i] ) begin
	 pa_type pa = ds[i];
	 T bitstream[];
	 T scrambled[];

	 bitstream = packed_array#(T,WIDTH)::to_dynamic_array( pa, msb_first );
	 scrambled = scrblr.scramble( bitstream, lfsr );
	 scramble[i] = packed_array#(T,WIDTH)::from_dynamic_array( scrambled,
								   msb_first );
      end
   endfunction: scramble

   //---------------------------------------------------------------------------
   // Function: to_string
   //    (STATIC) Converts a data stream to the form of a string.
   // 
   // Arguments:
   //   ds              - An input data stream.
   //   left_to_right   - (OPTIONAL) If 1, the item at index 0 of the data
   //                     stream is placed on the left of the output string. If
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
   //                     only if all items are not converted to a string. The
   //                     default is three periods followed by a space ("... ").
   //
   // Returns:
   //   A string representing *ds*.
   //
   // Example:
   // 
   // | bit[15:0] ds16[] = new[7]( '{ 16'h0123, 16'h4567, 16'h89ab, 16'hcdef, 16'h0000, 16'h0001, 16'h1000 } );
   // | assert( data_stream#(bit,16)::to_string( ds16 ) 
   // |   == "0123456789abcdef000000011000" );
   // | assert( data_stream#(bit,16)::to_string( ds16, .left_to_right( 0 ) ) 
   // |   == "100000010000cdef89ab45670123" );
   // | assert( data_stream#(bit,16)::to_string( ds16, .group( 1 ) ) 
   // |   == "0123 4567 89ab cdef 0000 0001 1000" );
   // | assert( data_stream#(bit,16)::to_string( ds16, .group( 2 ) ) 
   // |   == "01234567 89abcdef 00000001 1000" );
   // | assert( data_stream#(bit,16)::to_string( ds16, .group( 1 ), .left_to_right( 0 ) ) 
   // |   == "1000 0001 0000 cdef 89ab 4567 0123" );
   // | assert( data_stream#(bit,16)::to_string( ds16, .group( 2 ), .left_to_right( 0 ) ) 
   // |   == "10000001 0000cdef 89ab4567 0123" );
   // | assert( data_stream#(bit,16)::to_string( ds16, .group( 1 ), .num_head( 2 ), .num_tail( 0 ) ) 
   // |   == "0123 4567 ... " );
   // | assert( data_stream#(bit,16)::to_string( ds16, .group( 1 ), .num_head( 0 ), .num_tail( 2 ) ) 
   // |   == "... 0001 1000" );
   // | assert( data_stream#(bit,16)::to_string( ds16, .group( 1 ), .num_head( 2 ), .num_tail( 2 ) ) 
   // |   == "0123 4567 ... 0001 1000" );
   //---------------------------------------------------------------------------

   static function string to_string( ds_type ds,
				     bit left_to_right = 1,
				     int unsigned group = 0,
				     string group_separator = " ",
				     int num_head = -1,
				     int num_tail = -1,
				     string abbrev = "... " );
      bit enables[];
      int len = ds.size();

      enables = new[ len ];
      for ( int i = 0; i < len; i++ ) enables[i] = 1'b1; // enables all
      return to_string_with_en( ds, enables, "-", left_to_right,
				group, group_separator, num_head, 
				num_tail, abbrev );
   endfunction: to_string

   //---------------------------------------------------------------------------
   // Function: to_string_with_en
   //   (STATIC) Converts a data stream with corresponding data enables to the
   //   form of a string.
   //
   // Arguments:
   //   ds      - An input data stream.
   //   enables - The dynamic array of data enables corresponding to the data in
   //             *ds*. The size of *enables* should be the same as the size of
   //             *ds*. If the size of *enables* is larger than the size of
   //             *ds*, the excess data enables are ignored. If the size of
   //             *enables* is smaller than the size of *ds*, the data without
   //             enables are treated as disabled.
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
   //   abbrev - (OPTIONAL) A string to indicate the abbreviation of the items
   //            in the data stream. The *abbrev* is used only if all items are
   //            not converted to a string. The default is three periods
   //            followed by a space ("... ").
   //
   // Returns:
   //   A string representing *ds* qualified with *enables*.
   //
   // Example:
   // | bit[7:0] ds8[] = new[10]( '{ 8'h10, 8'h11, 8'h12, 8'h13, 8'h14, 8'h15, 8'h16, 8'h17, 8'h18, 8'h19 } );
   // | bit      en[]  = new[10]( '{ 1'b1,  1'b0,  1'b1,  1'b0,  1'b1,  1'b0,  1'b1,  1'b0,  1'b1,  1'b0  } );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en ) 
   // |   == "10--12--14--16--18--" );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en, .group(1) ) 
   // |   == "10 -- 12 -- 14 -- 16 -- 18 --" );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en, .group(2) ) 
   // |   == "10-- 12-- 14-- 16-- 18--" );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en, .group(8) ) 
   // |   == "10--12--14--16-- 18--" );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en, .group(1), .group_separator("|") ) 
   // |   == "10|--|12|--|14|--|16|--|18|--" );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en, .group(1), .num_head(2), .num_tail(2) ) 
   // |   == "10 -- ...18 --" );
   // | assert( data_stream#(bit,8)::to_string_with_en( ds8, en, .group(1), .disabled_char("*") ) 
   // |   == "10 ** 12 ** 14 ** 16 ** 18 **" );
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
	 num_head  = num_data;
	 num_tail  = 0;
	 is_abbrev = 0;
      end else begin
	 is_abbrev = 1;
      end

      // match the size of enables to the size of ds
      
      en = new[ num_data ]( enables ); 

      if ( left_to_right ) begin // position ds[0] at the left
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
      end else begin // position ds[0] at the right
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

	 repeat ( util::num_hex_digits( WIDTH ) )
	   s = { s, string'( disabled_char ) };
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
      int loc_from_left;

      if ( left_to_right ) loc_from_left = index;
      else                 loc_from_left = last_index - index;

      return ( group != 0 && loc_from_left != last_index && 
	       loc_from_left % group == ( group - 1 ) );
   endfunction: separated

endclass: data_stream

`endif //  `ifndef CL_DATA_STREAM_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
