//==============================================================================
// cl_text.svh (v0.6.1)
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
// ==============================================================================

`ifndef CL_TEXT_SVH
`define CL_TEXT_SVH

//------------------------------------------------------------------------------
// Class: text
//   Provides utility functions for text processing.  All functions are defined
//   as static.
//------------------------------------------------------------------------------

virtual class text;

   //---------------------------------------------------------------------------
   // Group: Common Arguments
   //   start_pos - Specifies the start position in a string.  The position of
   //               the first character is 0, the position of the second
   //               character is 1, and so on. The position can be specified as
   //               a negative number. The position of the last character can be
   //               specified as -1, the position of the second to the last
   //               character can be specified as -2, and so on. The default is
   //               0 (the first character).
   //   end_pos - Specifies the end position in a string using the same rule as
   //             the *start_pos*. The default is -1 (the last character).
   //
   // Example:
   // (begin example)
   //       ____ position 0 or -26
   //      /    ____ position 5 or -21
   //     /    /         ____ position 15 or -11
   //    /    /         /         ____ position 25 or -1
   //   /    /         /         /
   //  V    V         V         V
   // "How common arguments work."
   //  |----------------------->| start_pos =   0, end_pos =  25 \
   //  |----------------------->| start_pos =   0, end_pos =  -1  \ these specify the same range of the string
   //  |----------------------->| start_pos = -26, end_pos =  25  /
   //  |----------------------->| start_pos = -26, end_pos =  -1 /
   //       |-------->|           start_pos =   5, end_pos =  15 \
   //       |-------->|           start_pos =   5, end_pos = -11  \ these specify the same range of the string
   //       |-------->|           start_pos = -21, end_pos =  15  /
   //       |-------->|           start_pos = -21, end_pos = -11 /
   // (end example)
   //---------------------------------------------------------------------------

   // Group: Functions

   //---------------------------------------------------------------------------
   // Function: capitalize
   //   (STATIC) Returns a copy of the given string with the first character
   //   uppercased and the remainder lowercased.
   //
   // Argument:
   //   s - A string to be capitalized.
   //
   // Returns: 
   //   A copy of *s* with the first character uppercased and the remainder
   //   lowercased.
   //
   // Example:
   // | assert( text::capitalize( "capitalize me!" ) == "Capitalize me!" );
   //
   // See Also:
   //   <lc_first>, <swap_case>, <title_case>, <uc_first>
   //---------------------------------------------------------------------------

   static function string capitalize( string s );
      string head = string'( s[0] );
      string tail = trim( s, .left( 1 ) );

      return { head.toupper(), tail.tolower() };
   endfunction: capitalize

   //---------------------------------------------------------------------------
   // Function: center
   //   (STATIC) Returns a string of the specified width with the given string
   //   centerted and padded with the specified character.
   //
   // Arguments:
   //   s - A string to be centered.
   //   width - The width of the returned string.
   //   fill_char - (OPTIONAL) The character used for padding if *width* is
   //               wider than the length of *s*.  The default is a space
   //               character (" ").
   //   trim_ends - (OPTIONAL) If *width* is narrower than the length of *s* and
   //               *trim_ends* is 1, then the head and the tail of *s* are
   //               trimmed to fit within *width*. If *trim_ends* is 0, then
   //               *width* is widened to the length of *s*.  If *width* is
   //               wider than or equal to the length of *s*, *trim_ends* is
   //               ignored.  The default is 0.
   //
   // Returns:
   //   A string with *s* placed at the center and padded with *fill_char*.
   //
   // Example:
   // | assert( text::center( "center me", 15 )                 == "   center me   " );
   // | assert( text::center( "center me", 15, "-" )            == "---center me---" );
   // | assert( text::center( "center me", 7 )                  ==    "center me"    ); // widened to fit
   // | assert( text::center( "center me", 7, .trim_ends( 1 ) ) ==     "enter m"     ); // trimmed
   //
   // See Also:
   //   <ljust>, <rjust>
   //---------------------------------------------------------------------------

   static function string center( string s, 
				  int  width,
				  byte fill_char = " ",
				  bit  trim_ends = 0 );
      int slen = s.len();
      int left_padding;
      int right_padding;
      
      if ( width < slen && trim_ends == 0 ) width = slen; // extend the width
      left_padding  = ( width - slen ) / 2;
      right_padding = width - left_padding - slen;

      center = s;
      if ( left_padding >= 0 ) 
	repeat( left_padding ) center = { string'( fill_char ), center };
      else
	center = trim( center, .left( -left_padding ) );
	
      if ( right_padding >= 0 )
	repeat( right_padding ) center = { center, string'( fill_char ) };
      else
	center = trim( center, .right( -right_padding ) );
   endfunction: center

   //---------------------------------------------------------------------------
   // Function: change
   //   (STATIC) Returns a copy of the given string with the characters in the
   //   specified range replaced with the specified substring.
   //
   // Arguments:
   //   s         - A string to be changed.
   //   sub       - A substring. 
   //   start_pos - (OPTIONAL) Specifies the left-most position in *s* to be 
   //               replaced. See <Common Arguments>.
   //   end_pos   - (OPTIONAL) Specifies the right-most position in *s* to be
   //               replaced. See <Common Arguments>.
   //
   // Returns:
   //   A copy of *s* with the characters in the specified range replaced with
   //   *sub*. If the specified range is invalid, *s* is returned without a
   //   change. If *s* is an empty string (""), no change is made.
   //
   // Example:
   // | assert( text::change( "a primary library", "function", .start_pos( 10 ) ) == "a primary function" );
   // | //                               |---->|
   // | //                              10
   //
   // See Also:
   //   <replace>
   //---------------------------------------------------------------------------

   static function string change( string s, 
				  string sub,
				  int 	 start_pos = 0,
				  int 	 end_pos = -1 );
      string old_str = slice( s, start_pos, end_pos );

      if ( old_str == "" ) return s;
      else                 return replace( s, old_str, sub, .count( 1 ) );
   endfunction: change

   //---------------------------------------------------------------------------
   // Function: chomp
   //   (STATIC) Returns a copy of the given string with the last newline
   //   character removed (if present). Returns the given string as is if the
   //   given string does not end in a newline character.
   //
   // Argument:
   //   s - A string to be chomped
   //
   // Returns:
   //   Returns a copy of *s* with the last newline character removed (if
   //   present). Returns *s* as is if the given string does not end in a
   //   newline character.
   //
   // Example:
   // | assert( text::chomp( "abc"     ) == "abc" );
   // | assert( text::chomp( "abc\n"   ) == "abc" );
   // | assert( text::chomp( "abc\n\n" ) == "abc\n" );
   //
   // See Also:
   //   <chop>, <delete>, <lstrip>, <rstrip>, <strip>, <trim>
   //---------------------------------------------------------------------------

   static function string chomp( string s );
      if ( ends_with( s, { "\n" } ) ) 
	return s.substr( 0, s.len() - 2 );
      else
	return s;
   endfunction: chomp

   //---------------------------------------------------------------------------
   // Function: chop
   //   (STATIC) Returns the last character of the given string. 
   //
   // Arguments:
   //   s - An input string.
   //
   // Returns:
   //   Returns the last character of *s*. If *s* is empty, 0 is returned.
   //
   // Example:
   // | assert( text::chop( "abc" ) == "c" );
   // | assert( text::chop( "abc\n" ) == "\n" );
   //
   // See Also:
   //   <chomp>, <delete>, <lstrip>, <rstrip>, <strip>, <trim>
   //---------------------------------------------------------------------------

   static function byte chop( string s );
      return s[ s.len() - 1 ];
   endfunction: chop

   //---------------------------------------------------------------------------
   // Function: colorize
   //   (STATIC) Returns a copy of the given string with ANSI escape codes.
   //
   // Arguments:
   //   s  - A string to be colorized.
   //   fg - (OPTIONAL) The foreground color of *s*. See <fg_color_e> for available
   //        colors. The default is black.
   //   bg - (OPTIONAL) The background color of *s*. See <bg_color_e> for
   //        available colors. The default is white.
   //   bold      - (OPTIONAL) If 1, *s* is boldfaced. The default is 0.
   //   underline - (OPTIONAL) If 1, *s* is underlined. The default is 0.
   //   blink     - (OPTIONAL) If 1, *s* is blinked. The default is 0.
   //   reverse - (OPTIONAL) If 1, the foreground and the background colors of
   //             *s* are reversed. The default is 0.
   //
   // Returns:
   //   A copy of *s* with ANSI escape codes.
   //
   // Example:
   // | $display( text::colorize( "display me in red", FG_RED ) );
   //---------------------------------------------------------------------------

   static function string colorize( string s,
				    fg_color_e fg = FG_BLACK,
				    bg_color_e bg = BG_WHITE,
				    bit bold = 0,
				    bit underline = 0,
				    bit blink = 0,
				    bit reverse = 0 );
      string       color = "\033[";
      string reset_color = "\033[0m";

      if ( bold      ) color = { color, "1;" };
      if ( underline ) color = { color, "4;" };
      if ( blink     ) color = { color, "5;" };
      if ( reverse   ) color = { color, "7;" };
      color = { color, $sformatf( "%0d;%0dm", fg, bg ) };
      return { color, s, reset_color };
   endfunction: colorize

   //---------------------------------------------------------------------------
   // Function: contains
   //   (STATIC) Returns 1 if the given string contains the specified substring.
   //
   // Arguments:
   //   s   - An input string.
   //   sub - A substring to search. An empty substring ("") matches no input
   //         string.
   //   start_pos - (OPTIONAL) Specifies the position in *s* to begin the
   //               search. See <Common Arguments>.
   //   end_pos   - (OPTIONAL) Specifies the position in *s* to end the search.
   //               See <Common Arguments>.
   //
   // Returns:
   //   If *s* contains *sub*, 1 is returned. Otherwise, 0 is returned.
   //
   // Example:
   // | assert( text::contains( "a primary library", "primary" )                  == 1 );
   // | assert( text::contains( "a primary library", "primary", .start_pos( 3 ) ) == 0 );
   // | //                          |----------->|
   // | //                          3
   // | assert( text::contains( "a primary library", "primary", .end_pos(  7 ) )  == 0 );
   // | //                       |----->|
   // | //                              7
   // | assert( text::contains( "a primary library", "primary", .end_pos( -9 ) )  == 1 );
   // | //                       |------>|
   // | //                              -9
   //
   // See Also:
   //   <contains_str>, <count>, <ends_with>, <find_any>, <index>, <only>, 
   //   <rfind_any>, <rindex>, <starts_with>
   //---------------------------------------------------------------------------

   static function bit contains( string s, 
				 string sub,
				 int start_pos = 0,
				 int end_pos   = -1 );
      return index( s, sub, start_pos, end_pos ) != -1;
   endfunction: contains

   //---------------------------------------------------------------------------
   // Function: contains_str
   //   (STATIC) If the given string contains the specified substring, returns
   //   that substring.
   //
   // Arguments:
   //   s   - An input string.
   //   sub - A substring to search.  An empty substring ("") matches no input
   //         string.
   //   start_pos - (OPTIONAL) Specifies the position in *s* to begin the
   //               search. See <Common Arguments>.
   //   end_pos   - (OPTIONAL) Specifies the position in *s* to end the search.
   //               See <Common Arguments>.
   //
   // Returns:
   //   If *s* contains *sub*, *sub* is returned. Otherwise, an empty string
   //   ("") is returned.
   //
   // Example:
   // | assert( text::contains_str( "a primary library", "primary" )                  == "primary" );
   // | assert( text::contains_str( "a primary library", "primary", .start_pos( 3 ) ) == "" );
   // | //                              |----------->|
   // | //                              3
   // | assert( text::contains_str( "a primary library", "primary", .end_pos(  7 ) )  == "" );
   // | //                           |----->|
   // | //                                  7
   // | assert( text::contains_str( "a primary library", "primary", .end_pos( -9 ) )  == "primary" );
   // | //                           |------>|
   // | //                                  -9
   //
   // See Also:
   //   <contains>, <count>, <ends_with>, <find_any>, <index>, <only>, 
   //   <rfind_any>, <rindex>, <starts_with>
   //---------------------------------------------------------------------------

   static function string contains_str( string s, 
					string sub,
					int    start_pos = 0,
					int    end_pos = -1 );
      if ( contains( s, sub, start_pos, end_pos ) ) return sub;
      else return "";
   endfunction: contains_str

   //---------------------------------------------------------------------------
   // Function: count
   //   (STATIC) Returns the number of non-overlapping occurrences of the
   //   specified substring in the given string.
   //
   // Arguments:
   //   s   - An input string.
   //   sub - A substring to search.  An empty substring ("") matches no input
   //         string.
   //   start_pos - (OPTIONAL) Specifies the position in *s* to begin the
   //               search.  See <Common Arguments>.
   //   end_pos   - (OPTIONAL) Specifies the position in *s* to end the search.
   //               See <Common Arguments>.
   //
   // Returns:
   //   The number of non-overlapping occurrences of *sub* in *s*.
   //
   // Example:
   // | assert( text::count( "a primary library", "ary" )                  == 2 );
   // | assert( text::count( "a primary library", "ary", .start_pos( 3 ) ) == 2 );
   // | //                       |----------->|
   // | //                       3
   // | assert( text::count( "a primary library", "ary", .end_pos(  7 ) )  == 0 );
   // | //                    |----->|
   // | //                           7
   // | assert( text::count( "a primary library", "ary", .end_pos( -9 ) )  == 1 );
   // | //                    |------>|
   // | //                           -9
   //
   // See Also:
   //   <contains>, <contains_str>, <ends_with>, <find_any>, <index>, <only>, 
   //   <rfind_any>, <rindex>, <starts_with>
   //---------------------------------------------------------------------------

   static function int unsigned count( string s,
				       string sub,
				       int    start_pos = 0,
				       int    end_pos   = -1 );
      int pos;
      
      count = 0;
      pos = index( s, sub, start_pos, end_pos );
      while( pos != -1 ) begin
	 count++;
	 start_pos = pos + sub.len();
	 pos = index( s, sub, start_pos, end_pos );
      end
   endfunction: count

   //---------------------------------------------------------------------------
   // Function: delete
   //   (STATIC) Returns a copy of the given string with the specified string
   //   removed.
   //
   // Arguments:
   //   s     - An input string.
   //   sub   - A substring to remove. An empty substring ("") matches no input
   //           string.
   //   count - (OPTIONAL) The number of substrings to remove. If specified,
   //           only the first *count* occurrences are removed. By default, all
   //           occurrences are removed.
   //
   // Returns:
   //   A copy of *s* with the first *count* occurrences of *sub* removed.
   //
   // Example:
   // | assert( text::delete( "abcabc", "abc"    ) == "" );
   // | assert( text::delete( "abcabc", "abc", 1 ) == "abc" );
   //
   // See Also:
   //   <chop>, <chomp>, <insert>, <lstrip>, <rstrip>, <strip>, <trim>
   //---------------------------------------------------------------------------

   static function string delete( string s,
				  string sub,
				  int 	 count = -1 );
      return replace( s, sub, "", count );
   endfunction: delete

   //---------------------------------------------------------------------------
   // Function: ends_with
   //   (STATIC) Returns 1 if the given string ends with one of the specified suffixes.
   //
   // Arguments:
   //   s         - An input string.
   //   suffixes  - A queue of suffix strings. The suffixes can be specified
   //               using an array literal.  An empty string ("") matches no
   //               input string.
   //   start_pos - (OPTIONAL) Specifies the position in *s* to begin the
   //               search. See <Common Arguments>.
   //   end_pos   - (OPTIONAL) Specifies the position in *s* to end the search.
   //               See <Common Arguments>.
   //
   // Returns:
   //   If *s* ends with one of the specified *suffixes*, 1 is returned. 
   //   Otherwise, 0 is returned.
   //
   // Example:
   // | assert( text::ends_with( "a primary library", { "primary", "library" } )                  == 1 );
   // | assert( text::ends_with( "a primary library", { "primary", "library" }, .start_pos( 3 ) ) == 1 );
   // | //                           |----------->|
   // | //                           3
   // | assert( text::ends_with( "a primary library", { "primary", "library" }, .end_pos(  7 ) )  == 0 );
   // | //                        |----->|
   // | //                               7
   // | assert( text::ends_with( "a primary library", { "primary", "library" }, .end_pos( -9 ) )  == 1 );
   // | //                        |------>|
   // | //                               -9
   //
   // See Also:
   //   <contains>, <contains_str>, <count>, <find_any>, <index>, <only>, 
   //   <rfind_any>, <rindex>, <starts_with>
   //---------------------------------------------------------------------------

   static function bit ends_with( string s,
				  string_q suffixes,
				  int start_pos = 0,
				  int end_pos = -1 );
      int slen = s.len();

      if ( slen == 0 ) return 0;
      util::normalize( slen, start_pos, end_pos );

      foreach ( suffixes[i] ) begin
	 int blen = suffixes[i].len();
	 int begin_pos = end_pos - blen + 1;

	 if ( blen == 0 ) continue;
	 if ( begin_pos < start_pos ) continue;
	 if ( s.substr( begin_pos, end_pos ) == suffixes[i] ) return 1;
      end
      return 0;
   endfunction: ends_with

   //---------------------------------------------------------------------------
   // Function: find_any
   //   (STATIC) Returns the lowest index in the given string where each
   //   specified substring is found.
   //
   // Arguments:
   //   s         - An input string.
   //   subs      - A queue of substrings. The substrings can be specified using
   //               an array literal.
   //               An empty substring ("") matches no input string.
   //   start_pos - (OPTIONAL) Specifies the position in *s* to begin the
   //               search. See <Common Arguments>.
   //   end_pos   - (OPTIONAL) Specifies the position in *s* to end the search.
   //               See <Common Arguments>.
   //
   // Returns:
   //   The lowest index in *s* where each substring in *subs* is found. If no
   //   substring is found, -1 is returned.
   //
   // Example:
   // | assert( text::find_any( "a primary library", { "primary", "library" } ) ==  2 );
   // | assert( text::find_any( "a primary library", { "primary", "library" }, .start_pos( 3 ) ) == 10 );
   // | //                          |----------->|
   // | //                          3
   // | assert( text::find_any( "a primary library", { "primary", "library" }, .end_pos(  7 ) ) == -1 );
   // | //                       |----->|
   // | //                              7
   // | assert( text::find_any( "a primary library", { "primary", "library" }, .end_pos( -9 ) ) ==  2 );
   // | //                       |------>|
   // | //                              -9
   //
   // See Also:
   //   <contains>, <contains_str>, <count>, <ends_with>, <index>, <only>, 
   //   <rfind_any>, <rindex>, <starts_with>
   //-----------------------------------------------------------------------

   static function int find_any( string s,
				 string_q subs,
				 int start_pos = 0,
				 int end_pos = -1 );
      int found_pos[$];
      
      foreach ( subs[i] ) begin
	 int pos = index( s, subs[i], start_pos, end_pos );
	 
	 if ( pos != -1 ) found_pos.push_back( pos );
      end

      if ( found_pos.size() == 0 ) begin
	 return -1;
      end else begin
	 int q[$] = found_pos.min;

	 return q[0];
      end
   endfunction: find_any

   //---------------------------------------------------------------------------
   // Function: hash
   //   (STATIC) Returns the hash value of the given string. The hash value is
   //   calculated by:
   //   (see hash.png) 
   //   where N is the length of the given string.
   //
   // Argument:
   //   s - An input string.
   //
   // Returns:
   //   The hash value of *s*.
   //
   // Example:
   // | assert( text::hash( "my hash value is" ) == 32'he4260597 );
   //---------------------------------------------------------------------------

   static function int hash( string s );
      hash = 0;
      for ( int i = 0; i < s.len(); i++ ) hash = hash * 31 + s[i];
   endfunction: hash
   
   //---------------------------------------------------------------------------
   // Function: index
   //   (STATIC) Returns the index of the first occurrence of the specified
   //   substring in the given string within the optionally specified range.
   //
   // Arguments:
   //   s         - An input string.
   //   sub       - A substring to search. 
   //               An empty substring ("") matches no input string.
   //   start_pos - (OPTIONAL) Specifies the position in *s* to begin the
   //               search. See <Common Arguments>.
   //   end_pos   - (OPTIONAL) Specifies the position in *s* to end the search.
   //               See <Common Arguments>.
   //
   // Returns:
   //   The index of the first occurrence of *sub* in *s*. If *sub* is not
   //   found, -1 is returned.
   //
   // Example:
   // | assert( text::index( "a primary library", "ary" )                  ==  6 );
   // | assert( text::index( "a primary library", "ary", .start_pos( 3 ) ) ==  6 );
   // | //                       |----------->|
   // | //                       3  
   // | assert( text::index( "a primary library", "ary", .end_pos(  7 ) )  == -1 );
   // | //                    |----->|
   // | //                           7
   // | assert( text::index( "a primary library", "ary", .end_pos( -9 ) )  ==  6 );
   // | //                    |------>|
   // | //                           -9
   //
   // See Also:
   //   <contains>, <contains_str>, <count>, <ends_with>, <find_any>, <only>, 
   //   <rfind_any>, <rindex>, <starts_with>
   //---------------------------------------------------------------------------

   static function int index( string s,
			      string sub,
			      int    start_pos = 0,
			      int    end_pos = -1 );
      int slen = s.len();
      int blen = sub.len();

      if ( slen == 0 || blen == 0 ) return -1;
      util::normalize( slen, start_pos, end_pos );

`ifdef CL_USE_DPI_C
      begin
	 int i = c_find( s, sub, start_pos );
	 if ( i >= 0 && i + blen - 1 <= end_pos ) return i;
      end
`else
      for ( int i = start_pos; i <= end_pos - blen + 1; i++ ) begin
	 if ( s.substr( i, i + blen - 1 ) == sub )
	   return i;
      end
`endif
      
      return -1;
   endfunction: index

   //---------------------------------------------------------------------------
   // Function: insert
   //   (STATIC) Returns a copy of the given string with the specified substring
   //   inserted at the specified position.
   //
   // Arguments:
   //   s         - An input string.
   //   sub       - A substring to insert.
   //   start_pos - (OPTIONAL) Specifies the position where *sub* is inserted.
   //               See <Common Arguments>. The default is 0 (inserting *sub*
   //               before *s*).
   //
   // Returns:
   //   A copy of *s* with *sub* inserted at *start_pos*.
   //
   // Example:
   // | assert( text::insert( "abc", "XYZ"     ) == "XYZabc" ); // insert "XYZ" before the first character ("a")
   // | assert( text::insert( "abc", "XYZ",  1 ) == "aXYZbc" ); // insert "XYZ" before the character index 1 ("b")
   // | assert( text::insert( "abc", "XYZ", -1 ) == "abXYZc" ); // insert "XYZ" before the last character ("c")
   //
   // See Also:
   //   <chop>, <chomp>, <delete>, <lstrip>, <rstrip>, <strip>, <trim>
   //---------------------------------------------------------------------------

   static function string insert( string s,
				  string sub,
				  int 	 start_pos = 0 );
      int end_pos = -1;
      
      util::normalize( s.len(), start_pos, end_pos );
      return { s.substr( 0, start_pos - 1 ), 
	       sub, 
	       s.substr( start_pos, end_pos ) };
   endfunction: insert

   //---------------------------------------------------------------------------
   // Function: is_alpha
   //   (STATIC) Returns 1 if all characters in the given string are alphabetic.
   //   Alphabetic characters are *[a-zA-Z]*.
   //
   // Argument:
   //   s - An input string.
   //
   // Returns:
   //   If all characters in *s* are alphabetic, 1 is returned. Otherwise, 0 is
   //   returned. If *s* is an empty string, 0 is returned.
   //
   // Example:
   // | assert( text::is_alpha( "abc"  ) == 1 );
   // | assert( text::is_alpha( "abc_" ) == 0 );
   //
   // See Also:
   //   <is_digit>, <is_lower>, <is_printable>, <is_space>, <is_upper>
   //---------------------------------------------------------------------------

   static function bit is_alpha( string s );
      if ( s.len() == 0 ) return 0;
      foreach ( s[i] ) begin
	 if ( ! ( s[i] >= "a" && s[i] <= "z" ||
		  s[i] >= "A" && s[i] <= "Z" ) )
	   return 0;
      end
      return 1;
   endfunction: is_alpha

   //---------------------------------------------------------------------------
   // Function: is_digit
   //   (STATIC) Returns 1 if all characters in the given string are digits.
   //   Digits are *[0-9]*.
   //
   // Argument:
   //   s - An input string.
   //
   // Returns:
   //   If all characters in *s* are digits, 1 is returned. Otherwise, 0 is
   //   returned.  If *s* is an empty string, 0 is returned.
   //
   // Example:
   // | assert( text::is_digit( "123"  ) == 1 );
   // | assert( text::is_digit( "123X" ) == 0 );
   //
   // See Also:
   //   <is_alpha>, <is_lower>, <is_printable>, <is_space>, <is_upper>
   //---------------------------------------------------------------------------

   static function bit is_digit( string s );
      if ( s.len() == 0 ) return 0;
      foreach ( s[i] ) begin
	 if ( ! ( s[i] >= "0" && s[i] <= "9" ) )
	   return 0;
      end
      return 1;
   endfunction: is_digit

   //---------------------------------------------------------------------------
   // Function: is_lower
   //   (STATIC) Returns 1 if all _cased_ characters in the given string are
   //   lowercase.  Lowercase characters are *[a-z]*.
   //
   // Argument:
   //   s - An input string.
   //
   // Returns:
   //   If all cased characters in *s* are lowercase, 1 is returned. Otherwise,
   //   0 is returned. If *s* is an empty string, 0 is returned.
   //
   // Example:
   // | assert( text::is_lower( "abc"   ) == 1 );
   // | assert( text::is_lower( "abcX"  ) == 0 );
   // | assert( text::is_lower( "abc!?" ) == 1 ); // all cased characters are lowercase
   //
   // See Also:
   //   <is_alpha>, <is_digit>, <is_printable>, <is_space>, <is_upper>
   //---------------------------------------------------------------------------

   static function bit is_lower( string s );
      if ( s.len() == 0 ) return 0;
      foreach ( s[i] ) begin
	 if ( s[i] >= "A" && s[i] <= "Z" ) return 0; // uppercase is found
      end
      return 1;
   endfunction: is_lower

   //---------------------------------------------------------------------------
   // Function: is_printable
   //   (STATIC) Returns 1 if all characters in the given string are printable.
   //   Printable characters are the ones whose ASCII code are between 'h20 
   //   (" ") and 'h7F ("~").
   //
   // Argument:
   //   s - An input string.
   //
   // Returns:
   //   If all characters in *s* are printable, 1 is returned. Otherwise, 0 is
   //   returned.  If *s* is an empty string, 0 is returned.
   //
   // Example:
   // | assert( text::is_printable( "!@#$" ) == 1 );
   // | assert( text::is_printable( "\200" ) == 0 ); // ASCII 'h80 is not printable
   //
   // See Also:
   //   <is_alpha>, <is_digit>, <is_lower>, <is_space>, <is_upper>
   //---------------------------------------------------------------------------

   static function bit is_printable( string s );
      if ( s.len() == 0 ) return 1; // unlike other is_* functions, returns 1
      foreach ( s[i] ) begin
	 if ( ! ( s[i] >= 'h20 && s[i] <= 'h7E ) ) // <space> to ~
	   return 0;
      end
      return 1;
   endfunction: is_printable

   //---------------------------------------------------------------------------
   // Function: is_single_bit_type
   //   (STATIC) Returns 1 if the given string is *bit*, *logic*, or *reg*.
   //
   // Argument:
   //   s - An input string.
   //
   // Returns:
   //   If *s* is *bit*, *logic*, or *reg*, 1 is returned. Othewise, 0 is
   //   returned.
   //
   // Example:
   // | assert( text::is_single_bit_type( "bit" ) == 1 );
   // | assert( text::is_single_bit_type( "int" ) == 0 );
   //---------------------------------------------------------------------------

   static function bit is_single_bit_type( string s );
      return ( s == "bit" || s == "logic" || s == "reg" );
   endfunction: is_single_bit_type

   //---------------------------------------------------------------------------
   // Function: is_space
   //   (STATIC) Returns 1 if all characters in the given string are whitespace
   //   characters: a space (" "), a tab (*\t*), or a newline (*\n*).
   //
   // Argument:
   //   s - An input string.
   //
   // Returns:
   //   If all characters in *s* are whitespace characters, 1 is
   //   returned. Otherwise, 0 is returned. If *s* is an empty string, 0 is
   //   returned.
   //
   // Example:
   // | assert( text::is_space( " \t\n" ) == 1 );
   // | assert( text::is_space( "X\t\n" ) == 0 );
   //
   // See Also:
   //   <is_alpha>, <is_digit>, <is_lower>, <is_printable>, <is_upper>
   //---------------------------------------------------------------------------

   static function bit is_space( string s );
      if ( s.len() == 0 ) return 0;
      foreach ( s[i] ) begin
	 if ( ! ( s[i] == " " || s[i] == "\t" || s[i] == "\n" ) )
	   return 0;
      end
      return 1;
   endfunction: is_space

   //---------------------------------------------------------------------------
   // Function: is_upper
   //   (STATIC) Returns 1 if all _cased_ characters in the given string are
   //   uppercase.  Uppercase characters are *[A-Z]*.
   //
   // Argument:
   //   s - An input string.
   //
   // Returns:
   //   If all cased characters in *s* are uppercase, 1 is returned. Otherwise,
   //   0 is returned.  If *s* is an empty string, 0 is returned.
   //
   // Example:
   // | assert( text::is_upper( "ABC"   ) == 1 );
   // | assert( text::is_upper( "ABCx"  ) == 0 );
   // | assert( text::is_upper( "ABC!?" ) == 1 ); // all cased characters are uppercase
   //
   // See Also:
   //   <is_alpha>, <is_digit>, <is_lower>, <is_printable>, <is_space>
   //---------------------------------------------------------------------------

   static function bit is_upper( string s );
      if ( s.len() == 0 ) return 0;
      foreach ( s[i] ) begin
//	 if ( ! ( s[i] >= "A" && s[i] <= "Z" ) ) return 0;
	 if ( s[i] >= "a" && s[i] <= "z" ) return 0;
      end
      return 1;
   endfunction: is_upper

   //---------------------------------------------------------------------------
   // Function: join_str
   //   (STATIC) Returns a string by concatenating the strings in the given
   //   string queue, separated by the specified separator.
   //
   // Arguments:
   //   strings   - A queue of strings. The *strings* can be specified using an
   //               array literal.
   //   separator - (OPTIONAL) A separator between strings. The default is an
   //               empty string ("").
   //
   // Returns:
   //   A string by concatenating the strings in *strings*, separated by 
   //   *separator*.
   //
   // Example:
   // | assert( text::join_str( { "abc", "XYZ" }        ) == "abcXYZ"    );
   // | assert( text::join_str( { "abc", "XYZ" }, "---" ) == "abc---XYZ" );
   //---------------------------------------------------------------------------

   static function string join_str( string_q strings,
				    string   separator = "" );
      int last_i = strings.size() - 1;
      
      join_str = "";
      foreach ( strings[i] ) begin
	 join_str = { join_str, strings[i] };
	 if ( i < last_i ) join_str = { join_str, separator };
      end
   endfunction: join_str

   //---------------------------------------------------------------------------
   // Function: lc_first
   //   (STATIC) Returns a copy of the given string with the first character
   //   lowercased and the remainder unchanged.
   //
   // Argument:
   //   s - An input string.
   //
   // Returns: 
   //   A copy of *s* with the first character lowercased and the remainder
   //   unchanged.
   //
   // Example:
   // | assert( text::lc_first( "Lower CASE first" ) == "lower CASE first" );
   //
   // See Also:
   //   <capitalize>, <swap_case>, <title_case>, <uc_first>
   //---------------------------------------------------------------------------

   static function string lc_first( string s );
      string head = string'( s[0] );
      string tail = s.substr( 1, s.len() - 1 );

      return { head.tolower(), tail };
   endfunction: lc_first

   //---------------------------------------------------------------------------
   // Function: ljust
   //   (STATIC) Returns a string of the specified width with the given string
   //   left justified and padded with the specified character.
   //
   // Arguments:
   //   s          - A string to left-justify.
   //   width      - The width of the returned string.
   //   fill_char - (OPTIONAL) A character used for padding if *width* is wider
   //               than the length of *s*.  The default is a space character ("
   //               ").
   //   trim_right - (OPTIONAL) If *width* is narrower than the length of *s*
   //                and *trim_right* is 1, then the tail of *s* is trimmed to
   //                fit within *width*. If *trim_right* is 0, then *width* is
   //                widened to the length of *s*.  If *width* is wider than or
   //                equal to the length of *s*, *trim_right* is ignored.  The
   //                default is 0.
   //
   // Returns:
   //   A string with *s* left-justified and padded with *fill_char*.
   //
   // Example:
   // | assert( text::ljust( "ljust me", 15 )                  == "ljust me       " );
   // | assert( text::ljust( "ljust me", 15, "-" )             == "ljust me-------" );
   // | assert( text::ljust( "ljust me", 7 )                   == "ljust me"        ); // widened to fit
   // | assert( text::ljust( "ljust me", 7, .trim_right( 1 ) ) == "ljust m"         ); // trimmed
   //
   // See Also:
   //   <center>, <rjust>
   //---------------------------------------------------------------------------

   static function string ljust( string s, 
				 int  width,
				 byte fill_char = " ",
				 bit  trim_right = 0 );
      int slen = s.len();
      int padding;
      
      if ( width < slen && trim_right == 0 ) width = slen; // extend the width
      padding = width - slen;

      ljust = s;
      if ( padding >= 0 )
	repeat( padding ) ljust = { ljust, string'( fill_char ) };
      else
	ljust = trim( ljust, .right( -padding ) );
   endfunction: ljust

   //---------------------------------------------------------------------------
   // Function: lstrip
   //   (STATIC) Returns a copy of the given string with leading characters
   //   removed.
   //
   // Arguments:
   //   s     - A string to be stripped.
   //   chars - (OPTIONAL) A string specifying the set of characters to be
   //           removed. The default is whitespace characters: a space (" "), a
   //           tab (*\t*), or a newline (*\n*). Note that the *chars* string is
   //           not a prefix. All combinations of its characters are stripped.
   //
   // Returns:
   //   A copy of *s* with leading characters removed.
   //
   // Example:
   // | assert( text::lstrip( "      abc" ) == "abc" );
   // | assert( text::lstrip( "  \t\nabc" ) == "abc" );
   // | assert( text::lstrip( "aabbcc", "a"  ) == "bbcc" );
   // | assert( text::lstrip( "aabbcc", "ab" ) == "cc"   );
   // | assert( text::lstrip( "aabbcc", "ba" ) == "cc"   ); // "b"s and "a"s are stripped
   //
   // See Also:
   //   <chop>, <chomp>, <delete>, <rstrip>, <strip>, <trim>
   //---------------------------------------------------------------------------

   static function string lstrip( string s,
				  string chars = " \t\n" );
      int slen = s.len();

      foreach ( s[i] ) begin
	 if ( ! text::contains( chars, string'( s[i] ) ) ) 
	   return s.substr( i, slen - 1 );
      end
      return "";
   endfunction: lstrip

   //---------------------------------------------------------------------------
   // Function: only
   //   (STATIC) Returns 1 if the given string consists of only the specified
   //   set of characters.
   //
   // Arguments:
   //   s     - An input string.
   //   chars - A string specifying the set of characters to be checked. An
   //           empty string ("") matches no input string.
   //
   // Returns:
   //   If *s* consists of only the characters in *chars*, 1 is returned.
   //   Othewise, 0 is returned.
   //
   // Example:
   // | assert( text::only( "abc", "abcXYZ" ) == 1 );
   // | assert( text::only( "abcXYZ", "abc" ) == 0 );
   //
   // See Also:
   //   <contains>, <contains_str>, <count>, <ends_with>, <find_any>, <index>,
   //   <rfind_any>, <rindex>, <starts_with>
   //---------------------------------------------------------------------------

   static function bit only( string s,
			     string chars );
      if ( s == "" ) return 0;
      foreach ( s[i] ) begin
	 only = 0;
	 foreach ( chars[j] ) begin
	    if ( s[i] == chars[j] ) begin
	       only = 1;
	       break;
	    end
	 end
	 if ( only == 0 ) return only;
      end
      only = 1;
   endfunction: only

   //---------------------------------------------------------------------------
   // Function: partition 
   //   (STATIC) Searches the first occurrence of the specified separator in the
   //   given string and returns an array of three strings. The returned array
   //   consists of: the string before the separator, the separator itself, and
   //   the string after the separator. If the separator is not found, the given
   //   string and two empty strings are returned.
   //
   // Arguments:
   //   s   - An input string.
   //   sep - A separator.
   //
   // Returns:
   //   An array that consists of the part before *sep*, the *sep*, and the part
   //   after *sep*. If *sep* is not found, returns *s* and two empty strings.
   //
   // Example:
   // | three_strings s, t1, t2, t3, t4;
   // |
   // | s = '{ "abc", "-", "XYZ" };
   // | assert( text::partition( "abc-XYZ", "-" ) == s );
   // | 
   // | t1 = '{ "", "a", "bcabc" };
   // | t2 = '{ "a", "b", "cabc" };
   // | t3 = '{ "ab", "c", "abc" };
   // | t4 = '{ "abcabc", "", "" };
   // | assert( text::partition( "abcabc", "a" ) == t1 );
   // | assert( text::partition( "abcabc", "b" ) == t2 );
   // | assert( text::partition( "abcabc", "c" ) == t3 );
   // | assert( text::partition( "abcabc", "X" ) == t4 );
   //
   // See Also:
   //   <rpartition>, <rsplit>, <split>
   //---------------------------------------------------------------------------

   static function three_strings partition( string s,
					    string sep );
      int i = text::index( s, sep );
      int j = i + sep.len();
	  
      if ( i == -1 )
	partition = '{ s, "", "" };
      else
	partition = '{ s.substr( 0, i - 1 ), // if i == 0, returns ""
		       sep, 
		       s.substr( j, s.len() - 1 ) };
   endfunction: partition

   //---------------------------------------------------------------------------
   // Function: replace
   //   (STATIC) Returns a copy of the given string with the specified string
   //   replaced with a new string.
   //
   // Arguments:
   //   s       - An input string.
   //   old_str - An old string. An empty string ("") matches no input string.
   //   new_str - A new string.
   //   count - (OPTIONAL) The number of strings to replace. If specified, only
   //           the first *count* occurrences are replaced. By default, all
   //           occurrences are replaced.
   //
   // Returns:
   //   A copy of *s* with the first *count* occurrences of *old_str* replaced
   //   with *new_str*.
   //
   // Example:
   // | assert( text::replace( "abcabc", "abc", "XYZ"    ) == "XYZXYZ" );
   // | assert( text::replace( "abcabc", "abc", "XYZ", 1 ) == "XYZabc" );
   //
   // See Also:
   //   <change>
   //---------------------------------------------------------------------------

   static function string replace( string s,
				   string old_str,
				   string new_str,
				   int 	  count = -1 );
      three_strings t;
      
      if ( count == 0 ) return s;      

      t = text::partition( s, old_str );
      if ( t[1] == "" ) // no more match
	return t[0];
      else
	return { t[0], new_str, 
		 replace( t[2], old_str, new_str, count - 1 ) };
   endfunction: replace

   //---------------------------------------------------------------------------
   // Function: reverse
   //   (STATIC) Returns a copy of the given string with the characters in
   //   reverse order.
   //
   // Argument:
   //   s - An input string.
   //
   // Returns:
   //   A copy of *s* with the characters in reverse order.
   //
   // Example:
   // | assert( text::reverse( "reverse me!" ) == "!em esrever" );
   // | assert( text::reverse( "wonton? not now" ) == "won ton ?notnow" );
   //---------------------------------------------------------------------------

   static function string reverse( string s );
      int last_pos = s.len() - 1;
      
      reverse = s;
      foreach ( s[i] ) 
	reverse[ last_pos - i ] = s[i];
   endfunction: reverse

   //---------------------------------------------------------------------------
   // Function: rfind_any
   //   (STATIC) Returns the highest index in the given string where each
   //   specified substring is found.
   //
   // Arguments:
   //   s         - An input string.
   //   subs      - A queue of substrings. The substrings can be specified using
   //               an array literal.
   //               An empty substring ("") matches no input string.
   //   start_pos - (OPTIONAL) Specifies the position in *s* to begin the
   //               search. See <Common Arguments>.
   //   end_pos   - (OPTIONAL) Specifies the position in *s* to end the search.
   //               See <Common Arguments>.
   //
   // Returns:
   //   The highest index in *s* where each substring in *subs* is found. If no
   //   substring is found, -1 is returned.
   //
   // Example:
   // | assert( text::rfind_any( "a primary library", { "primary", "library" } )                  == 10 );
   // | assert( text::rfind_any( "a primary library", { "primary", "library" }, .start_pos( 3 ) ) == 10 );
   // | //                           |----------->|
   // | //                           3
   // | assert( text::rfind_any( "a primary library", { "primary", "library" }, .end_pos(  7 ) )  == -1 );
   // | //                        |----->|
   // | //                               7
   // | assert( text::rfind_any( "a primary library", { "primary", "library" }, .end_pos( -9 ) )  ==  2 );
   // | //                        |------>|
   // | //                               -9
   //
   // See Also:
   //   <contains>, <contains_str>, <count>, <ends_with>, <find_any>, <index>, 
   //   <only>, <rindex>, <starts_with>
   //---------------------------------------------------------------------------

   static function int rfind_any( string s,
				  string_q subs,
				  int start_pos = 0,
				  int end_pos = -1 );
      int found_pos[$];
      
      foreach ( subs[i] ) begin
	 int pos = rindex( s, subs[i], start_pos, end_pos );
	 
	 if ( pos != -1 ) found_pos.push_back( pos );
      end

      if ( found_pos.size() == 0 ) begin
	 return -1;
      end else begin
	 int q[$] = found_pos.max;

	 return q[0];
      end
   endfunction: rfind_any

   //---------------------------------------------------------------------------
   // Function: rindex
   //   (STATIC) Returns the index of the last occurrence of the specified
   //   substring in the given string within the optionally specified range.
   //
   // Arguments:
   //   s         - An input string.
   //   sub       - A substring to search.
   //               An empty substring ("") matches no input string.
   //   start_pos - (OPTIONAL) Specifies the position in *s* to begin the
   //               search. See <Common Arguments>.
   //   end_pos   - (OPTIONAL) Specifies the position in *s* to end the search.
   //               See <Common Arguments>.
   //
   // Returns:
   //   The index of the last occurrence of *sub* in *s*. If *sub* is not found,
   //   -1 is returned.
   //
   // Example:
   // | assert( text::rindex( "a primary library", "ary" )                  == 14 );
   // | assert( text::rindex( "a primary library", "ary", .start_pos( 3 ) ) == 14 );
   // | //                        |----------->|
   // | //                        3
   // | assert( text::rindex( "a primary library", "ary", .end_pos(  7 ) )  == -1 );
   // | //                     |----->|
   // | //                            7
   // | assert( text::rindex( "a primary library", "ary", .end_pos( -9 ) )  ==  6 );
   // | //                     |------>|
   // | //                            -9
   //
   // See Also:
   //   <contains>, <contains_str>, <count>, <ends_with>, <find_any>, <index>, 
   //   <only>, <rfind_any>, <starts_with>
   //---------------------------------------------------------------------------

   static function int rindex( string s,
			       string sub,
			       int    start_pos = 0,
			       int    end_pos = -1 );
      int slen = s.len();
      int blen = sub.len();
      
      if ( slen == 0 || blen == 0 ) return -1;
      util::normalize( slen, start_pos, end_pos );
      for ( int i = end_pos - blen + 1; i >= start_pos; i-- ) begin
	 if ( s.substr( i, i + blen - 1 ) == sub )
	   return i;
      end
      return -1;
   endfunction: rindex

   //---------------------------------------------------------------------------
   // Function: rjust
   //   (STATIC) Returns a string of the specified width with the given string
   //   right justified and padded with the specified character.
   //
   // Arguments:
   //   s         - A string to right-justify.
   //   width     - The width of the returned string.
   //   fill_char - (OPTIONAL) A character used for padding if *width* is wider
   //               than the length of *s*.  The default is a space character ("
   //               ").
   //   trim_left - (OPTIONAL) If *width* is narrower than the length of *s*
   //               and *trim_left* is 1, then the head of *s* is trimmed to fit
   //               within *width*. If *trim_left* is 0, then *width* is widened
   //               to the length of *s*.  If *width* is wider than or equal to
   //               the length of *s*, *trim_left* is ignored.  The default is
   //               0.
   //
   // Returns:
   //   A string with *s* right justified and padded with *fill_char*.
   //
   // Example:
   // | assert( text::rjust( "rjust me", 15 )                 == "       rjust me" );
   // | assert( text::rjust( "rjust me", 15, "-" )            == "-------rjust me" );
   // | assert( text::rjust( "rjust me", 7 )                  ==        "rjust me" ); // widened to fit
   // | assert( text::rjust( "rjust me", 7, .trim_left( 1 ) ) ==         "just me" ); // trimmed
   //
   // See Also:
   //   <center>, <ljust>
   //---------------------------------------------------------------------------

   static function string rjust( string s, 
				 int  width,
				 byte fill_char = " ",
				 bit  trim_left = 0 );
      int slen = s.len();
      int padding;
      
      if ( width < slen && trim_left == 0 ) width = slen; // extend the width
      padding = width - slen;

      rjust = s;
      if ( padding >= 0 ) 
	repeat( padding ) rjust = { string'( fill_char ), rjust };
      else
	rjust = trim( rjust, .left( -padding ) );
   endfunction: rjust

   //---------------------------------------------------------------------------
   // Function: rpartition
   //   (STATIC) Searches the last occurrence of the specified separator in the
   //   given string and returns an array of three strings. The returned array
   //   consists of: the string before the separator, the separator itself, and
   //   the string after the separator. If the separator is not found, the given
   //   string and two empty strings are returned.
   //
   // Arguments:
   //   s   - An input string.
   //   sep - A separator.
   //
   // Returns:
   //   An array that consists of the part before *sep*, the *sep*, and the part
   //   after *sep*. If *sep* is not found, returns *s* and two empty strings.
   //
   // Example:
   // | three_strings s, t1, t2, t3, t4;
   // |
   // | s = '{ "abc", "-", "XYZ" };
   // | assert( text::rpartition( "abc-XYZ", "-" ) == s );
   // |
   // | t1 = '{ "abc", "a", "bc" };
   // | t2 = '{ "abca", "b", "c" };
   // | t3 = '{ "abcab", "c", "" };
   // | t4 = '{ "abcabc", "", "" };
   // | assert( text::rpartition( "abcabc", "a" ) == t1 );
   // | assert( text::rpartition( "abcabc", "b" ) == t2 );
   // | assert( text::rpartition( "abcabc", "c" ) == t3 );
   // | assert( text::rpartition( "abcabc", "X" ) == t4 );
   //
   // See Also:
   //   <partition>, <rsplit>, <split>
   //---------------------------------------------------------------------------

   static function three_strings rpartition( string s,
					     string sep );
      int i = text::rindex( s, sep );
      int j = i + sep.len();
	  
      if ( i == -1 )
	rpartition = '{ s, "", "" };
      else
	rpartition = '{ s.substr( 0, i - 1 ), // if i == 0, returns ""
			sep, 
			s.substr( j, s.len() - 1 ) };
   endfunction: rpartition

   //---------------------------------------------------------------------------
   // Function: rsplit
   //   (STATIC) Returns a queue of substrings by dividing the given string by
   //   the specified separator from the right.
   //
   // Arguments:
   //   s         - An input string. If *s* is empty, an empty queue is 
   //               returned.
   //   sep - (OPTIONAL) A separator. If specified, *sep* is used as the
   //         delimiter. The *sep* itself is not returned as an element of the
   //         queue. If not specified, whitespace characters (a space (" "), a
   //         tab (*\t*), or a newline (*\n*)) are used. If *sep* is not
   //         specified, the contiguous whitespaces and the trailing whitespaces
   //         are ignored.
   //   max_split - (OPTIONAL) If specified, at most *max_split* splits are 
   //               done from the right and the remaining substring is returned
   //               as the first element of the queue.  If not specified or -1,
   //               there is no limit to the number of splits.
   //
   // Returns:
   //   A queue of substrings (<string_q>).
   //
   // Example:
   // | string_q s1, s2, s3, s4, t1, t2, t3, t4, t5;
   // |
   // | s1 = '{ "abc", "pqr", "xyz" };
   // | s2 = '{ "  abc  pqr", "xyz" };
   // | s3 = '{ "  abc", "pqr", "xyz" };
   // | s4 = '{ "abc", "pqr", "xyz" };
   // | assert( text::rsplit( "  abc  pqr  xyz  "                  ) == s1 );
   // | assert( text::rsplit( "  abc  pqr  xyz  ", .max_split( 1 ) ) == s2 );
   // | assert( text::rsplit( "  abc  pqr  xyz  ", .max_split( 2 ) ) == s3 );
   // | assert( text::rsplit( "  abc  pqr  xyz  ", .max_split( 3 ) ) == s4 );
   // |
   // | t1 = '{ "", "abc", "pqr", "xyz", "" };
   // | t2 = '{ "--abc--pqr--xyz", "" };
   // | t3 = '{ "--abc--pqr", "xyz", "" };
   // | t4 = '{ "--abc", "pqr", "xyz", "" };
   // | t5 = '{ "", "abc", "pqr", "xyz", "" };
   // | assert( text::rsplit( "--abc--pqr--xyz--", "--"                  ) == t1 );
   // | assert( text::rsplit( "--abc--pqr--xyz--", "--", .max_split( 1 ) ) == t2 );
   // | assert( text::rsplit( "--abc--pqr--xyz--", "--", .max_split( 2 ) ) == t3 );
   // | assert( text::rsplit( "--abc--pqr--xyz--", "--", .max_split( 3 ) ) == t4 );
   // | assert( text::rsplit( "--abc--pqr--xyz--", "--", .max_split( 4 ) ) == t5 );
   //
   // See Also:
   //   <partition>, <rpartition>, <split>
   //---------------------------------------------------------------------------

   static function string_q rsplit( string s,
				    string sep = "",
				    int    max_split = -1 );
      if ( sep == "" ) begin // use whitespace as a separator
	 int pos;
	    
	 s = rstrip( s );
	 if ( s == "" ) return {};
	 if ( max_split == 0 ) return { s };

	 pos = rfind_any( s, { " ", "\t", "\n" } );
	 if ( pos == -1 ) begin // no more match
	    return { s };
	 end else begin // found whitespace
	    string head = s.substr( 0, pos );
	    string tail = s.substr( pos + 1, s.len() - 1 );
	    string_q  q = rsplit( rstrip( head ), sep, max_split - 1 );
	    
	    q.push_back( tail );
	    return q;
	 end
      end else begin
	 three_strings t = rpartition( s, sep );

	 if ( max_split == 0 ) return { s };
	 if ( t[1] == "" ) begin // no more match
	    return { t[0] };
	 end else begin // found match
	    string_q q = rsplit( t[0], sep, max_split - 1 ); // recursive call

	    q.push_back( t[2] );
	    return q;
	 end
      end
   endfunction: rsplit

   //---------------------------------------------------------------------------
   // Function: rstrip
   //   (STATIC) Returns a copy of the given string with trailing characters
   //   removed.
   //
   // Arguments:
   //   s     - A string to be stripped.
   //   chars - (OPTIONAL) A string specifying the set of characters to be
   //           removed. The default is whitespace characters: a space (" "), a
   //           tab (*\t*), or a newline (*\n*). Note that the *chars* string is
   //           not a suffix. All combinations of its characters are stripped.
   //
   // Returns:
   //   A copy of *s* with trailing characters removed.
   //
   // Example:
   // | assert( text::rstrip( "abc      " ) == "abc" );
   // | assert( text::rstrip( "abc  \t\n" ) == "abc" );
   // | assert( text::rstrip( "aabbcc", "c"  ) == "aabb" );
   // | assert( text::rstrip( "aabbcc", "bc" ) == "aa"   );
   // | assert( text::rstrip( "aabbcc", "cb" ) == "aa"   ); // "c"s and "b"s are stripped
   //
   // See Also:
   //   <chop>, <chomp>, <delete>, <lstrip>, <strip>, <trim>
   //---------------------------------------------------------------------------

   static function string rstrip( string s,
				  string chars = " \t\n" );
      int slen = s.len();

      for ( int i = slen - 1; i >= 0; i-- ) begin
	 if ( ! text::contains( chars, string'( s[i] ) ) ) 
	   return s.substr( 0, i );
      end
      return "";
   endfunction: rstrip

   //---------------------------------------------------------------------------
   // Function: slice
   //   (STATIC) Returns a substring in the specified range. This function is
   //   similar to the *substr* function in native SystemVerilog, but one can
   //   specify negative numbers to specify the range with this function.
   //
   // Arguments:
   //   s - An input string.
   //   start_pos - (OPTIONAL) Specifies the position in *s* to begin the
   //               substring. See <Common Arguments>.
   //   end_pos   - (OPTIONAL) Specifies the position in *s* to end the 
   //               substring. See <Common Arguments>.
   // 
   // Returns:
   //   Returns a substring in the specified range.
   //
   // Example:
   // | assert( text::slice( "slice me",  2,  6 ) == "ice m" );
   // | assert( text::slice( "slice me", -6, -2 ) == "ice m" );
   //
   // See Also:
   //   <slice_len>
   //---------------------------------------------------------------------------

   static function string slice( string s,
				 int start_pos = 0,
				 int end_pos = - 1 );
      util::normalize( s.len(), start_pos, end_pos );
      return s.substr( start_pos, end_pos );
   endfunction: slice

   //---------------------------------------------------------------------------
   // Function: slice_len
   //   (STATIC) Returns a substring in the specified range. Unlike <slice>,
   //   this function takes the length to extract instead of the end position.
   //
   // Arguments:
   //   s         - An input string.
   //   start_pos - (OPTIONAL) Specifies the position in *s* to begin the
   //               substring. See <Common Arguments>.
   //   length    - (OPTIONAL) The number of characters to extract. The default
   //               is the length of *s*.
   // 
   // Returns:
   //   Returns a substring in the specified range.
   //
   // Example:
   // | assert( text::slice_len( "slice me",  2, 5 ) == "ice m" );
   // | assert( text::slice_len( "slice me", -6, 5 ) == "ice m" );
   //
   // See Also:
   //   <slice>
   //---------------------------------------------------------------------------

   static function string slice_len( string s,
				     int start_pos = 0,
				     int unsigned length = s.len() );
      int end_pos = -1; // dummy for normalize()

      if ( length == 0 ) return "";
      util::normalize( s.len(), start_pos, end_pos ); // make start_pos positive
      return slice( s, start_pos, start_pos + length - 1 );
   endfunction: slice_len

   //---------------------------------------------------------------------------
   // Function: split
   //   (STATIC) Returns a queue of substrings by dividing the given string by
   //   the specified separator.
   //
   // Arguments:
   //   s         - An input string. If *s* is empty, an empty queue is
   //               returned.
   //   sep - (OPTIONAL) A separator. If specified, *sep* is used as the
   //         delimiter. The *sep* itself is not returned as an element of the
   //         queue. If not specified, whitespace characters (a space (" "), a
   //         tab (*\t*), or a newline (*\n*)) are used. If *sep* is not
   //         specified, the leading whitespaces and the contiguous whitespaces
   //         are ignored.
   //   max_split - (OPTIONAL) If specified, at most *max_split* splits are 
   //               done and the remaining substring is returned as the last
   //               element of the queue.  If not specified or -1, there is no
   //               limit to the number of splits.
   //
   // Returns:
   //   A queue of substrings (<string_q>).
   //
   // Example:
   // | string_q s1, s2, s3, s4, t1, t2, t3, t4, t5;
   // |
   // | s1 = '{ "abc", "pqr", "xyz" };
   // | s2 = '{ "abc", "pqr  xyz  " };
   // | s3 = '{ "abc", "pqr", "xyz  " };
   // | s4 = '{ "abc", "pqr", "xyz" };
   // | assert( text::split( "  abc  pqr  xyz  "                  ) == s1 );
   // | assert( text::split( "  abc  pqr  xyz  ", .max_split( 1 ) ) == s2 );
   // | assert( text::split( "  abc  pqr  xyz  ", .max_split( 2 ) ) == s3 );
   // | assert( text::split( "  abc  pqr  xyz  ", .max_split( 3 ) ) == s4 );
   // | 
   // | t1 = '{ "", "abc", "pqr", "xyz", "" };
   // | t2 = '{ "", "abc--pqr--xyz--" };
   // | t3 = '{ "", "abc", "pqr--xyz--" };
   // | t4 = '{ "", "abc", "pqr", "xyz--" };
   // | t5 = '{ "", "abc", "pqr", "xyz", "" };
   // | assert( text::split( "--abc--pqr--xyz--", "--"                  ) == t1 );
   // | assert( text::split( "--abc--pqr--xyz--", "--", .max_split( 1 ) ) == t2 );
   // | assert( text::split( "--abc--pqr--xyz--", "--", .max_split( 2 ) ) == t3 );
   // | assert( text::split( "--abc--pqr--xyz--", "--", .max_split( 3 ) ) == t4 );
   // | assert( text::split( "--abc--pqr--xyz--", "--", .max_split( 4 ) ) == t5 );
   //
   // See Also:
   //   <partition>, <rpartition>, <rsplit>
   //---------------------------------------------------------------------------

   static function string_q split( string s,
				   string sep = "",
				   int 	  max_split = -1 );
      if ( sep == "" ) begin // use whitespace as a separator
	 int pos;
	    
	 s = lstrip( s );
	 if ( s == "" ) return {};
	 if ( max_split == 0 ) return { s };

	 pos = find_any( s, { " ", "\t", "\n" } );
	 if ( pos == -1 ) begin // no more match
	    return { s };
	 end else begin // found whitespace
	    string head = s.substr( 0, pos - 1 );
	    string tail = s.substr( pos, s.len() - 1 );
	    string_q  q = split( lstrip( tail ), sep, max_split - 1 );

	    q.push_front( head );
	    return q;
	 end
      end else begin
	 three_strings t = partition( s, sep );

	 if ( max_split == 0 ) return { s };
	 if ( t[1] == "" ) begin // no more match
	    return { t[0] };
	 end else begin // found match
	    string_q q = split( t[2], sep, max_split - 1 ); // recursive call

	    q.push_front( t[0] );
	    return q;
	 end
      end
   endfunction: split

   //---------------------------------------------------------------------------
   // FunctionX: split_lines
   //   (STATIC) Returns a queue of strings by dividing a multi-line string at
   //   newline characters.
   //
   // ArgumentsX:
   //   s         - An input string. If *s* is empty, an empty queue is
   //               returned.
   //   keep_ends - (OPTIONAL) If 1, newline characters are included in the
   //               resulting queue. If 0, newline characters are not included
   //               in the resulting queue. The default is 0.
   //
   // Returns:
   //   A queue of strings.
   //
   // ExamplesX:
   // : assert( text::split_lines( ""   ) == '{} );
   // : assert( text::split_lines( "\n" ) == '{} ); // trailing newline characters are dropped
   // : assert( text::split_lines( "\n", .keep_ends( 1 ) ) == '{ "\n" } );
   // : 
   // : assert( text::split_lines( "abc\nXYZ"                  ) == '{ "abc",     "XYZ" } );
   // : assert( text::split_lines( "abc\n\nXYZ"                ) == '{ "abc", "", "XYZ" } );
   // : assert( text::split_lines( "abc\nXYZ", .keep_ends( 1 ) ) == '{ "abc\n",   "XYZ" } );
   //
   // See AlsoX:
   //   <partition>, <rpartition>, <rsplit>, <split>
   //---------------------------------------------------------------------------
/*
   static function string_q split_lines( string s,
					 bit keep_ends = 0 );
      int pos;

      if ( s == "" ) return {};
      if ( only( s, "\n" ) ) begin
      	 if ( keep_ends ) return { s };
      	 else             return {};
      end

      pos = find_any( s, { "\n" } );
      if ( pos == -1 ) begin // no more newlines
	 return { s };
      end else begin // found a newline
	 string head;
	 int 	slen = s.len();

	 if ( keep_ends ) head = s.substr( 0, pos ); // keep newline
	 else             head = s.substr( 0, pos - 1 );

	 if ( pos + 1 <= slen - 1 ) begin // tail exists
	    string tail = s.substr( pos + 1, slen - 1 );

	    if ( only( tail, "\n" ) ) begin
	       if ( keep_ends )
		 head = { head, tail }; // concatenate the last newlines
	       return { head }; // if not keep_ends, drop the last newlines
	    end else begin
	       string_q q = split_lines( tail, keep_ends );

	       q.push_front( head );
	       return q;
	    end
	 end else begin // no tail
	    return { head };
	 end
      end
   endfunction: split_lines
*/
   //---------------------------------------------------------------------------
   // Function: starts_with
   //   (STATIC) Returns 1 if the given string starts with one of the specified
   //   prefixes.
   //
   // Arguments:
   //   s         - An input string.
   //   prefixes  - A queue of prefix strings. The prefixes can be specified
   //               using an array literal.  An empty string ("") matches no
   //               input string.
   //   start_pos - (OPTIONAL) Specifies the position in *s* to begin the
   //               search. See <Common Arguments>.
   //   end_pos   - (OPTIONAL) Specifies the position in *s* to end the search.
   //               See <Common Arguments>.
   //
   // Returns:
   //   If *s* starts with one of the specified *prefixes*, 1 is returned. 
   //   Otherwise, 0 is returned.
   //
   // Example:
   // | assert( text::starts_with( "a primary library", { "a primary", "library" } )                   == 1 );
   // | assert( text::starts_with( "a primary library", { "a primary", "library" }, .start_pos( 10 ) ) == 1 );
   // | //                                    |---->|
   // | //                                   10
   // | assert( text::starts_with( "a primary library", { "a primary", "library" }, .end_pos(  7 ) )  == 0 );
   // | //                          |----->|
   // | //                                 7
   // | assert( text::starts_with( "a primary library", { "a primary", "library" }, .end_pos( -9 ) )  == 1 );
   // | //                          |------>|
   // | //                                 -9
   //
   // See Also:
   //   <contains>, <contains_str>, <count>, <ends_with>, <find_any>, <index>, 
   //   <only>, <rfind_any>, <rindex>
   //---------------------------------------------------------------------------

   static function bit starts_with( string s,
				   string_q prefixes,
				   int start_pos = 0,
				   int end_pos = -1 );
      int slen = s.len();

      if ( slen == 0 ) return 0;
      util::normalize( slen, start_pos, end_pos );

      foreach ( prefixes[i] ) begin
	 int blen = prefixes[i].len();
	 int stop_pos = start_pos + blen - 1;

	 if ( blen == 0 ) continue;
	 if ( end_pos < stop_pos ) continue;
	 if ( s.substr( start_pos, stop_pos ) == prefixes[i] ) return 1;
      end
      return 0;
   endfunction: starts_with

   //---------------------------------------------------------------------------
   // Function: strip
   //   (STATIC) Returns a copy of the given string with leading and trailing
   //   characters removed.
   //
   // Arguments:
   //   s     - A string to be stripped.
   //   chars - (OPTIONAL) A string specifying the set of characters to be
   //           removed. The default is whitespace characters: a space (" "), a
   //           tab (*\t*), or a newline (*\n*). Note that the *chars* string is
   //           not a prefix or suffix. All combinations of its characters are
   //           stripped.
   //
   // Returns:
   //   A copy of *s* with leading and trailing characters removed.
   //
   // Example:
   // | assert( text::strip( "   abc    " ) == "abc" );
   // | assert( text::strip( " \t\nabc\n" ) == "abc" );
   // | assert( text::strip( "aabbcc", "a"  ) == "bbcc" );
   // | assert( text::strip( "aabbcc", "ab" ) == "cc"   );
   // | assert( text::strip( "aabbcc", "ac" ) == "bb"   );
   //
   // See Also:
   //   <chop>, <chomp>, <delete>, <lstrip>, <rstrip>, <trim>
   //---------------------------------------------------------------------------

   static function string strip( string s,
				 string chars = " \t\n" );
      return rstrip( lstrip( s, chars ), chars );
   endfunction: strip

   //---------------------------------------------------------------------------
   // Function: swap_case
   //   (STATIC) Returns a copy of the given string with uppercase characters
   //   converted to lowercase, and lowercase characters converted to uppercase.
   //
   // Argument:
   //   s - A string to be swap-cased.
   //
   // Returns:
   //   A copy of *s* with uppercase characters converted to lowercase, and
   //   lowercase characters converted to uppercase.
   //
   // Example:
   // | assert( text::swap_case( "Swap Case Me!" ) == "sWAP cASE mE!" );
   //
   // See Also:
   //   <capitalize>, <lc_first>, <title_case>, <uc_first>
   //---------------------------------------------------------------------------

   static function string swap_case( string s );
      swap_case = "";
      foreach ( s[i] ) begin
	 string t = string'( s[i] );

	 if ( is_lower( t ) )      swap_case = { swap_case, t.toupper() };
	 else if ( is_upper( t ) ) swap_case = { swap_case, t.tolower() };
	 else	                   swap_case = { swap_case, t };
      end
   endfunction: swap_case

   //---------------------------------------------------------------------------
   // Function: title_case
   //   (STATIC) Returns a copy of the given string with the first character of
   //   words uppercased and the remainder lowercased.
   //
   // Argument:
   //   s - A string to be title-cased.
   //
   // Returns:
   //   A copy of *s* with the first character of words uppercased and the
   //   remainder lowercased.
   //
   // Example:
   // | assert( text::title_case( "title case me!" ) == "Title Case Me!" );
   //
   // See Also:
   //   <capitalize>, <lc_first>, <swap_case>, <uc_first>
   //---------------------------------------------------------------------------

   static function string title_case( string s );
      bit start = 1;

      title_case = "";
      foreach ( s[i] ) begin
	 string t = string'( s[i] );

	 if ( is_alpha( t ) ) begin
	    if ( start ) begin
	       title_case = { title_case, t.toupper() };
	       start = 0;
	    end else begin
	       title_case = { title_case, t.tolower() };
	    end
	 end else begin
	    title_case = { title_case, t };
	    start = 1;
	 end
      end
   endfunction: title_case
   
   //---------------------------------------------------------------------------
   // Function: trim
   //   (STATIC) Returns a copy of the given string with the specified numbers
   //   of leading and trailing characters removed.
   //
   // Arguments:
   //   s     - A string to be trimmed.
   //   left  - (OPTIONAL) The number of leading characters to remove. The
   //           default is 0.
   //   right - (OPTIONAL) The number of trailing characters to remove. The 
   //           default is 0.
   //
   // Returns:
   //   A copy of *s* with leading *left* characters and trailing *right* 
   //   characters removed.
   //
   // Example:
   // | assert( text::trim( "trim me!"       ) == "trim me!" );
   // | assert( text::trim( "trim me!", 1, 2 ) ==  "rim m"   );
   // | assert( text::trim( "trim me!", 3, 4 ) ==    "m"     );
   //
   // See Also:
   //   <chop>, <chomp>, <delete>, <lstrip>, <rstrip>, <strip>
   //---------------------------------------------------------------------------

   static function string trim( string s,
				int unsigned left = 0,
				int unsigned right = 0 );
      return s.substr( left, s.len() - right - 1 );
   endfunction: trim

   //---------------------------------------------------------------------------
   // Function: uc_first
   //   (STATIC) Returns a copy of the given string with the first character
   //   uppercased and the remainder unchanged.
   //
   // Argument:
   //   s - An input string.
   //
   // Returns: 
   //   A copy of *s* with the first character uppercased and the remainder
   //   unchanged.
   //
   // Example:
   // | assert( text::uc_first( "upper CASE first" ) == "Upper CASE first" );
   //
   // See Also:
   //   <capitalize>, <lc_first>, <swap_case>, <title_case>
   //---------------------------------------------------------------------------

   static function string uc_first( string s );
      string head = string'( s[0] );
      string tail = s.substr( 1, s.len() - 1 );

      return { head.toupper(), tail };
   endfunction: uc_first

   //---------------------------------------------------------------------------
   // Function: untabify
   //   (STATIC) Returns a copy of the given string where all tab characters
   //   (*\t*) are replaced by one or more spaces, depending on the tab
   //   positions. If a newline (*\n*) is found, it is copied and the tab
   //   position is reset.
   //
   // Arguments:
   //   s        - A string to untabify.
   //   tab_size - (OPTIONAL) Tab positions occur every *tab_size* characters.
   //              The default is 8.
   //
   // Returns:
   //   A copy of *s* where all tab characters are replaced by one or more 
   //   spaces, depending on the tab positions.
   //   
   // Example:
   // | assert( text::untabify( "AB\tCDE\tFGHI\tJKLMN" ) == "AB      CDE     FGHI    JKLMN" );
   // |                                    // tab positions: ^       ^       ^       ^
   // | assert( text::untabify( "AB\tCDE\tFGHI\tJKLMN", 4 ) == "AB  CDE FGHI    JKLMN" );
   // |                                    // tab positions:    ^   ^   ^   ^   ^   ^
   // | assert( text::untabify( "AB\nCDE\tFGHI\tJKLMN", 4 ) == "AB\nCDE FGHI    JKLMN" );
   // |                                    // tab positions:    ^   ^   ^   ^   ^   ^
   //---------------------------------------------------------------------------

   static function string untabify( string s,
				    int unsigned tab_size = 8 );
      int unsigned column = 0;
      int unsigned spaces;

      untabify = "";
      foreach ( s[i] ) begin
	 if ( s[i] == "\t" ) begin
	    if ( tab_size > 0 ) begin
	       spaces = ( ( column / tab_size ) + 1 ) * tab_size - column;
	       repeat ( spaces ) begin
		  untabify = { untabify, " " };
		  column++;
	       end
	    end // if tab_size == 0, then simply drop the "\t"
	 end else if ( s[i] == "\n" /*|| s[i] == "\r"*/ ) begin
	    untabify = { untabify, s[i] };
	    column = 0;
	 end else begin
	    untabify = { untabify, s[i] };
	    column++;
	 end
      end // foreach ( s[i] )
   endfunction: untabify

endclass: text

`endif //  `ifndef CL_TEXT_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
