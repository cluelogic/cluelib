//
// test_from_examples.sv - a test generated from code examples
//

import cl::*;

module test_from_examples;
  function automatic void test;
    $display( "==========starting test_from_examples==========" );
    // test ./src/cl_text.svh
    begin
      assert( text::capitalize( "capitalize me!" ) == "Capitalize me!" );
    end
    begin
      assert( text::center( "center me", 15 )                 == "   center me   " );
      assert( text::center( "center me", 15, "-" )            == "---center me---" );
      assert( text::center( "center me", 7 )                  ==    "center me"    ); // widened to fit
      assert( text::center( "center me", 7, .trim_ends( 1 ) ) ==     "enter m"     ); // trimmed
    end
    begin
      assert( text::change( "a primary library", "function", .start_pos( 10 ) ) == "a primary function" );
      //                               |---->|
      //                              10
    end
    begin
      assert( text::chomp( "abc"     ) == "abc" );
      assert( text::chomp( "abc\n"   ) == "abc" );
      assert( text::chomp( "abc\n\n" ) == "abc\n" );
    end
    begin
      assert( text::chop( "abc" ) == "c" );
      assert( text::chop( "abc\n" ) == "\n" );
    end
    begin
      $display( text::colorize( "display me in red", FG_RED ) );
    end
    begin
      assert( text::contains( "a primary library", "primary" )                  == 1 );
      assert( text::contains( "a primary library", "primary", .start_pos( 3 ) ) == 0 );
      //                          |----------->|
      //                          3
      assert( text::contains( "a primary library", "primary", .end_pos(  7 ) )  == 0 );
      //                       |----->|
      //                              7
      assert( text::contains( "a primary library", "primary", .end_pos( -9 ) )  == 1 );
      //                       |------>|
      //                              -9
    end
    begin
      assert( text::contains_str( "a primary library", "primary" )                  == "primary" );
      assert( text::contains_str( "a primary library", "primary", .start_pos( 3 ) ) == "" );
      //                              |----------->|
      //                              3
      assert( text::contains_str( "a primary library", "primary", .end_pos(  7 ) )  == "" );
      //                           |----->|
      //                                  7
      assert( text::contains_str( "a primary library", "primary", .end_pos( -9 ) )  == "primary" );
      //                           |------>|
      //                                  -9
    end
    begin
      assert( text::count( "a primary library", "ary" )                  == 2 );
      assert( text::count( "a primary library", "ary", .start_pos( 3 ) ) == 2 );
      //                       |----------->|
      //                       3
      assert( text::count( "a primary library", "ary", .end_pos(  7 ) )  == 0 );
      //                    |----->|
      //                           7
      assert( text::count( "a primary library", "ary", .end_pos( -9 ) )  == 1 );
      //                    |------>|
      //                           -9
    end
    begin
      assert( text::delete( "abcabc", "abc"    ) == "" );
      assert( text::delete( "abcabc", "abc", 1 ) == "abc" );
    end
    begin
      assert( text::ends_with( "a primary library", { "primary", "library" } )                  == 1 );
      assert( text::ends_with( "a primary library", { "primary", "library" }, .start_pos( 3 ) ) == 1 );
      //                           |----------->|
      //                           3
      assert( text::ends_with( "a primary library", { "primary", "library" }, .end_pos(  7 ) )  == 0 );
      //                        |----->|
      //                               7
      assert( text::ends_with( "a primary library", { "primary", "library" }, .end_pos( -9 ) )  == 1 );
      //                        |------>|
      //                               -9
    end
    begin
      assert( text::find_any( "a primary library", { "primary", "library" } )                  ==  2 ); // found "primary" at index 2
      assert( text::find_any( "a primary library", { "primary", "library" }, .start_pos( 3 ) ) == 10 ); // found "library" at index 10
      //                          |----------->|
      //                          3
      assert( text::find_any( "a primary library", { "primary", "library" }, .end_pos(  7 ) )  == -1 ); // no substring was found
      //                       |----->|
      //                              7
      assert( text::find_any( "a primary library", { "primary", "library" }, .end_pos( -9 ) )  ==  2 ); // found "primary" at index 2
      //                       |------>|
      //                              -9
    end
    begin
      assert( text::hash( "my hash value is" ) == 32'he4260597 );
    end
    begin
      assert( text::index( "a primary library", "ary" )                  ==  6 );
      assert( text::index( "a primary library", "ary", .start_pos( 3 ) ) ==  6 );
      //                       |----------->|
      //                       3  
      assert( text::index( "a primary library", "ary", .end_pos(  7 ) )  == -1 );
      //                    |----->|
      //                           7
      assert( text::index( "a primary library", "ary", .end_pos( -9 ) )  ==  6 );
      //                    |------>|
      //                           -9
    end
    begin
      assert( text::insert( "abc", "XYZ"     ) == "XYZabc" ); // insert "XYZ" before the first character ("a")
      assert( text::insert( "abc", "XYZ",  1 ) == "aXYZbc" ); // insert "XYZ" before the character index 1 ("b")
      assert( text::insert( "abc", "XYZ", -1 ) == "abXYZc" ); // insert "XYZ" before the last character ("c")
    end
    begin
      assert( text::is_alpha( "abc"  ) == 1 );
      assert( text::is_alpha( "abc_" ) == 0 );
    end
    begin
      assert( text::is_digit( "123"  ) == 1 );
      assert( text::is_digit( "123X" ) == 0 );
    end
    begin
      assert( text::is_lower( "abc"   ) == 1 );
      assert( text::is_lower( "abcX"  ) == 0 );
      assert( text::is_lower( "abc!?" ) == 1 ); // all cased characters are lowercase
    end
    begin
      assert( text::is_printable( "!@#$" ) == 1 );
      assert( text::is_printable( "\200" ) == 0 ); // ASCII 'h80 is not printable
    end
    begin
      assert( text::is_single_bit_type( "bit" ) == 1 );
      assert( text::is_single_bit_type( "int" ) == 0 );
    end
    begin
      assert( text::is_space( " \t\n" ) == 1 );
      assert( text::is_space( "X\t\n" ) == 0 );
    end
    begin
      assert( text::is_upper( "ABC"   ) == 1 );
      assert( text::is_upper( "ABCx"  ) == 0 );
      assert( text::is_upper( "ABC!?" ) == 1 ); // all cased characters are uppercase
    end
    begin
      assert( text::join_str( { "abc", "XYZ" }        ) == "abcXYZ"    );
      assert( text::join_str( { "abc", "XYZ" }, "---" ) == "abc---XYZ" );
    end
    begin
      assert( text::lc_first( "Lower CASE first" ) == "lower CASE first" );
    end
    begin
      assert( text::ljust( "ljust me", 15 )                  == "ljust me       " );
      assert( text::ljust( "ljust me", 15, "-" )             == "ljust me-------" );
      assert( text::ljust( "ljust me", 7 )                   == "ljust me"        ); // widened to fit
      assert( text::ljust( "ljust me", 7, .trim_right( 1 ) ) == "ljust m"         ); // trimmed
    end
    begin
      assert( text::lstrip( "      abc" ) == "abc" );
      assert( text::lstrip( "  \t\nabc" ) == "abc" );
      assert( text::lstrip( "aabbcc", "a"  ) == "bbcc" );
      assert( text::lstrip( "aabbcc", "ab" ) == "cc"   );
      assert( text::lstrip( "aabbcc", "ba" ) == "cc"   ); // "b"s and "a"s are stripped
    end
    begin
      assert( text::only( "abc", "abcXYZ" ) == 1 );
      assert( text::only( "abcXYZ", "abc" ) == 0 );
    end
    begin
      assert( text::partition( "abc-XYZ", "-" ) == '{ "abc", "-", "XYZ" } );
      assert( text::partition( "abcabc",  "a" ) == '{ "", "a", "bcabc" } );
      assert( text::partition( "abcabc",  "b" ) == '{ "a", "b", "cabc" } );
      assert( text::partition( "abcabc",  "c" ) == '{ "ab", "c", "abc" } );
      assert( text::partition( "abcabc",  "X" ) == '{ "abcabc", "", "" } );
    end
    begin
      assert( text::replace( "abcabc", "abc", "XYZ"    ) == "XYZXYZ" );
      assert( text::replace( "abcabc", "abc", "XYZ", 1 ) == "XYZabc" );
    end
    begin
      assert( text::reverse( "reverse me!" ) == "!em esrever" );
      assert( text::reverse( "wonton? not now" ) == "won ton ?notnow" );
    end
    begin
      assert( text::rfind_any( "a primary library", { "primary", "library" } )                  == 10 ); // found "library" at index 10
      assert( text::rfind_any( "a primary library", { "primary", "library" }, .start_pos( 3 ) ) == 10 ); // found "library" at index 10
      //                           |----------->|
      //                           3
      assert( text::rfind_any( "a primary library", { "primary", "library" }, .end_pos(  7 ) )  == -1 ); // no substring was found
      //                        |----->|
      //                               7
      assert( text::rfind_any( "a primary library", { "primary", "library" }, .end_pos( -9 ) )  ==  2 ); // found "primary" at index 2
      //                        |------>|
      //                               -9
    end
    begin
      assert( text::rindex( "a primary library", "ary" )                  == 14 );
      assert( text::rindex( "a primary library", "ary", .start_pos( 3 ) ) == 14 );
      //                        |----------->|
      //                        3
      assert( text::rindex( "a primary library", "ary", .end_pos(  7 ) )  == -1 );
      //                     |----->|
      //                            7
      assert( text::rindex( "a primary library", "ary", .end_pos( -9 ) )  ==  6 );
      //                     |------>|
      //                            -9
    end
    begin
      assert( text::rjust( "rjust me", 15 )                 == "       rjust me" );
      assert( text::rjust( "rjust me", 15, "-" )            == "-------rjust me" );
      assert( text::rjust( "rjust me", 7 )                  ==        "rjust me" ); // widened to fit
      assert( text::rjust( "rjust me", 7, .trim_left( 1 ) ) ==         "just me" ); // trimmed
    end
    begin
      assert( text::rpartition( "abc-XYZ", "-" ) == '{ "abc", "-", "XYZ" } );
      assert( text::rpartition( "abcabc",  "a" ) == '{ "abc", "a", "bc" } );
      assert( text::rpartition( "abcabc",  "b" ) == '{ "abca", "b", "c" } );
      assert( text::rpartition( "abcabc",  "c" ) == '{ "abcab", "c", "" } );
      assert( text::rpartition( "abcabc",  "X" ) == '{ "abcabc", "", "" } );
    end
    begin
      assert( text::rsplit( "  abc  pqr  xyz  "                  ) == '{ "abc", "pqr", "xyz" } );
      assert( text::rsplit( "  abc  pqr  xyz  ", .max_split( 1 ) ) == '{ "  abc  pqr", "xyz" } );
      assert( text::rsplit( "  abc  pqr  xyz  ", .max_split( 2 ) ) == '{ "  abc", "pqr", "xyz" } );
      assert( text::rsplit( "  abc  pqr  xyz  ", .max_split( 3 ) ) == '{ "abc", "pqr", "xyz" } );
      
      assert( text::rsplit( "--abc--pqr--xyz--", "--"                  ) == '{ "", "abc", "pqr", "xyz", "" } );
      assert( text::rsplit( "--abc--pqr--xyz--", "--", .max_split( 1 ) ) == '{ "--abc--pqr--xyz", "" } );
      assert( text::rsplit( "--abc--pqr--xyz--", "--", .max_split( 2 ) ) == '{ "--abc--pqr", "xyz", "" } );
      assert( text::rsplit( "--abc--pqr--xyz--", "--", .max_split( 3 ) ) == '{ "--abc", "pqr", "xyz", "" } );
      assert( text::rsplit( "--abc--pqr--xyz--", "--", .max_split( 4 ) ) == '{ "", "abc", "pqr", "xyz", "" } );
    end
    begin
      assert( text::rstrip( "abc      " ) == "abc" );
      assert( text::rstrip( "abc  \t\n" ) == "abc" );
      assert( text::rstrip( "aabbcc", "c"  ) == "aabb" );
      assert( text::rstrip( "aabbcc", "bc" ) == "aa"   );
      assert( text::rstrip( "aabbcc", "cb" ) == "aa"   ); // "c"s and "b"s are stripped
    end
    begin
      assert( text::slice( "slice me",  2,  6 ) == "ice m" );
      assert( text::slice( "slice me", -6, -2 ) == "ice m" );
    end
    begin
      assert( text::slice_len( "slice me",  2, 5 ) == "ice m" );
      assert( text::slice_len( "slice me", -6, 5 ) == "ice m" );
    end
    begin
      assert( text::split( "  abc  pqr  xyz  "                  ) == '{ "abc", "pqr", "xyz" } );
      assert( text::split( "  abc  pqr  xyz  ", .max_split( 1 ) ) == '{ "abc", "pqr  xyz  " } );
      assert( text::split( "  abc  pqr  xyz  ", .max_split( 2 ) ) == '{ "abc", "pqr", "xyz  " } );
      assert( text::split( "  abc  pqr  xyz  ", .max_split( 3 ) ) == '{ "abc", "pqr", "xyz" } );
      
      assert( text::split( "--abc--pqr--xyz--", "--"                  ) == '{ "", "abc", "pqr", "xyz", "" } );
      assert( text::split( "--abc--pqr--xyz--", "--", .max_split( 1 ) ) == '{ "", "abc--pqr--xyz--" } );
      assert( text::split( "--abc--pqr--xyz--", "--", .max_split( 2 ) ) == '{ "", "abc", "pqr--xyz--" } );
      assert( text::split( "--abc--pqr--xyz--", "--", .max_split( 3 ) ) == '{ "", "abc", "pqr", "xyz--" } );
      assert( text::split( "--abc--pqr--xyz--", "--", .max_split( 4 ) ) == '{ "", "abc", "pqr", "xyz", "" } );
    end
    begin
      assert( text::starts_with( "a primary library", { "a primary", "library" } )                   == 1 );
      assert( text::starts_with( "a primary library", { "a primary", "library" }, .start_pos( 10 ) ) == 1 );
      //                                    |---->|
      //                                   10
      assert( text::starts_with( "a primary library", { "a primary", "library" }, .end_pos(  7 ) )  == 0 );
      //                          |----->|
      //                                 7
      assert( text::starts_with( "a primary library", { "a primary", "library" }, .end_pos( -9 ) )  == 1 );
      //                          |------>|
      //                                 -9
    end
    begin
      assert( text::strip( "   abc    " ) == "abc" );
      assert( text::strip( " \t\nabc\n" ) == "abc" );
      assert( text::strip( "aabbcc", "a"  ) == "bbcc" );
      assert( text::strip( "aabbcc", "ab" ) == "cc"   );
      assert( text::strip( "aabbcc", "ac" ) == "bb"   );
    end
    begin
      assert( text::swap_case( "Swap Case Me!" ) == "sWAP cASE mE!" );
    end
    begin
      assert( text::title_case( "title case me!" ) == "Title Case Me!" );
    end
    begin
      assert( text::trim( "trim me!"       ) == "trim me!" );
      assert( text::trim( "trim me!", 1, 2 ) ==  "rim m"   );
      assert( text::trim( "trim me!", 3, 4 ) ==    "m"     );
    end
    begin
      assert( text::uc_first( "upper CASE first" ) == "Upper CASE first" );
    end
    begin
      assert( text::untabify( "AB\tCDE\tFGHI\tJKLMN" ) == "AB      CDE     FGHI    JKLMN" );
      // tab positions: ^       ^       ^       ^
      assert( text::untabify( "AB\tCDE\tFGHI\tJKLMN", 4 ) == "AB  CDE FGHI    JKLMN" );
      // tab positions:    ^   ^   ^   ^   ^   ^
      assert( text::untabify( "AB\nCDE\tFGHI\tJKLMN", 4 ) == "AB\nCDE FGHI    JKLMN" );
      // tab positions:    ^   ^   ^   ^   ^   ^
    end
    // test ./src/cl_pair.svh
    begin
      pair#(int, string) p = new( 1, "apple" );
      assert( p.first == 1 );
    end
    begin
      pair#(int, string) p = new( 1, "apple" );
      assert( p.second == "apple" );
    end
    begin
      pair#(int, string) p = new( 1, "apple" );
    end
    begin
      pair#(int, string) p = new( 1, "apple" );
      pair#(int, string) q = new( 1, "apple" );
      assert( p.eq( q ) == 1 ); // 1 == 1 && "apple" == "apple"
    end
    begin
      pair#(int, string) p = new( 1, "apple" );
      pair#(int, string) q = new( 1, "orange" );
      assert( p.ne( q ) == 1 ); // "apple" != "orange"
    end
    begin
      pair#(int, string) p = new( 1, "apple" );
      pair#(int, string) q = new( 2, "apple" );
      assert( p.lt( q ) == 1 ); // 1 < 2
    end
    begin
      pair#(int, string) p = new( 1, "orange" );
      pair#(int, string) q = new( 1, "apple" );
      assert( p.gt( q ) == 1 ); // "orange" > "apple" by the lexicographical order
    end
    begin
      pair#(int, string) p = new( 1, "apple" );
      pair#(int, string) q = new( 1, "orange" );
      assert( p.le( q ) == 1 ); // "apple" < "orange" by the lexicographical order
    end
    begin
      pair#(int, string) p = new( 2, "apple" );
      pair#(int, string) q = new( 1, "orange" );
      assert( p.ge( q ) == 1 ); // 2 > 1
    end
    begin
      pair#(int, string) p = new( 1, "apple" );
      pair#(int, string) q = p.clone();
      assert( p.eq( q ) == 1 );
    end
    begin
      pair#(int, string) p = new( 1, "apple" );
      pair#(int, string) q = new( 2, "orange" );
      p.swap( q );
      assert( p.first == 2 );
      assert( q.first == 1 );
      assert( p.second == "orange" );
      assert( q.second == "apple" );
    end
    // test ./src/cl_tuple.svh
    begin
      tuple#(int,string,bit[7:0]) t = new( 1, "apple", 8'hFF );
      assert( t.first == 1 );
    end
    begin
      tuple#(int,string,bit[7:0]) t = new( 1, "apple", 8'hFF );
      assert( t.second == "apple" );
    end
    begin
      tuple#(int,string,bit[7:0]) t = new( 1, "apple", 8'hFF );
      assert( t.third == 8'hFF );
    end
    begin
      tuple#() t = new( 1, 2, 3, 4 );
      assert( t.fourth == 4 );
    end
    begin
      tuple#() t = new( 1, 2, 3, 4, 5 );
      assert( t.fifth == 5 );
    end
    begin
      tuple#() t = new( 1, 2, 3, 4, 5, 6 );
      assert( t.sixth == 6 );
    end
    begin
      tuple#() t = new( 1, 2, 3, 4, 5, 6, 7 );
      assert( t.seventh == 7 );
    end
    begin
      tuple#() t = new( 1, 2, 3, 4, 5, 6, 7, 8 );
      assert( t.eighth == 8 );
    end
    begin
      tuple#() t = new( 1, 2, 3, 4, 5, 6, 7, 8, 9 );
      assert( t.ninth == 9 );
    end
    begin
      tuple#() t = new( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 );
      assert( t.tenth == 10 );
    end
    begin
      tuple#(int, string, bit[7:0]) t = new( 1, "apple", 8'hFF );
    end
    begin
      tuple#(int, string, bit[7:0]) t = new( 1, "apple", 8'hFF );
      tuple#(int, string, bit[7:0]) u = new( 1, "apple", 8'hFF );
      assert( t.eq( u ) == 1 ); // 1 == 1 && "apple" == "apple" && 8'hFF == 8'hFF
    end
    begin
      tuple#(int, string, bit[7:0]) t = new( 1, "apple",  8'hFF );
      tuple#(int, string, bit[7:0]) u = new( 1, "orange", 8'hFF );
      assert( t.ne( u ) == 1 ); // "apple" != "orange"
    end
    begin
      tuple#(int, string, bit[7:0]) t = new( 1, "apple", 8'hFF );
      tuple#(int, string, bit[7:0]) u = new( 2, "apple", 8'hFF );
      assert( t.lt( u ) == 1 ); // 1 < 2
    end
    begin
      tuple#(int, string, bit[7:0]) t = new( 1, "orange", 8'hFF );
      tuple#(int, string, bit[7:0]) u = new( 1, "apple",  8'hFF );
      assert( t.gt( u ) == 1 ); // "orange" > "apple" by the lexicographical order
    end
    begin
      tuple#(int, string, bit[7:0]) t = new( 1, "apple",  8'hFF );
      tuple#(int, string, bit[7:0]) u = new( 1, "orange", 8'hFF );
      assert( t.le( u ) == 1 ); // "apple" < "orange" by the lexicographical order
    end
    begin
      tuple#(int, string, bit[7:0]) t = new( 2, "apple",  8'hFF );
      tuple#(int, string, bit[7:0]) u = new( 1, "orange", 8'hFF );
      assert( t.ge( u ) == 1 ); // 2 > 1
    end
    begin
      tuple#(int, string, bit[7:0]) t = new( 1, "apple",  8'hFF );
      tuple#(int, string, bit[7:0]) u = t.clone();
      assert( t.eq( u ) == 1 );
    end
    begin
      tuple#(int, string, bit[7:0]) t = new( 1, "apple",  8'hFF );
      tuple#(int, string, bit[7:0]) u = new( 2, "orange", 8'hAA );
      t.swap( u );
      assert( t.first == 2 );
      assert( u.first == 1 );
      assert( t.second == "orange" );
      assert( u.second == "apple" );
      assert( t.third == 8'hAA );
      assert( u.third == 8'hFF );
    end
    // test ./src/cl_packed_array.svh
    begin
      bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
      assert( packed_array#(bit,8)::from_unpacked_array( ua                ) == 8'hD8 ); // bit[7:0]
      assert( packed_array#(bit,8)::from_unpacked_array( ua, .reverse( 1 ) ) == 8'h1B );
    end
    begin
      bit[7:0] pa = 8'hD8;
      assert( packed_array#(bit,8)::to_unpacked_array( pa                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      assert( packed_array#(bit,8)::to_unpacked_array( pa, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } ); // da[0] to da[7]
      assert( packed_array#(bit,8)::from_dynamic_array( da                ) == 8'hD8 ); // bit[7:0]
      assert( packed_array#(bit,8)::from_dynamic_array( da, .reverse( 1 ) ) == 8'h1B );
    end
    begin
      bit[7:0] pa = 8'hD8;
      assert( packed_array#(bit,8)::to_dynamic_array( pa                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      assert( packed_array#(bit,8)::to_dynamic_array( pa, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit q[$] = { 0, 0, 0, 1, 1, 0, 1, 1 }; // q[0] to q[7]
      assert( packed_array#(bit,8)::from_queue( q                ) == 8'hD8 ); // bit[7:0]
      assert( packed_array#(bit,8)::from_queue( q, .reverse( 1 ) ) == 8'h1B );
    end
    begin
      bit[7:0] pa = 8'hD8;
      assert( packed_array#(bit,8)::to_queue( pa                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      assert( packed_array#(bit,8)::to_queue( pa, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
      bit[7:0] pa;
      
      packed_array#(bit,8)::ua_to_pa( ua, pa );
      assert( pa == 8'hD8 ); // bit[7:0]
      
      packed_array#(bit,8)::ua_to_pa( ua, pa, .reverse( 1 ) );
      assert( pa == 8'h1B );
    end
    begin
      bit[7:0] pa = 8'hD8;
      bit ua[8];
      
      packed_array#(bit,8)::pa_to_ua( pa, ua );
      assert( ua == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      
      packed_array#(bit,8)::pa_to_ua( pa, ua, .reverse( 1 ) );
      assert( ua == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } ); // da[0] to da[7]
      bit[7:0] pa;
      
      packed_array#(bit,8)::da_to_pa( da, pa );
      assert( pa == 8'hD8 ); // bit[7:0]
      
      packed_array#(bit,8)::da_to_pa( da, pa, .reverse( 1 ) );
      assert( pa == 8'h1B );
    end
    begin
      bit[7:0] pa = 8'hD8;
      bit da[] = new[8]; // set the size of da[]
      
      packed_array#(bit,8)::pa_to_da( pa, da );
      assert( da == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      
      packed_array#(bit,8)::pa_to_da( pa, da, .reverse( 1 ) );
      assert( da == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit q[$] = { 0, 0, 0, 1, 1, 0, 1, 1 }; // q[0] to q[7]
      bit[7:0] pa;
      
      packed_array#(bit,8)::q_to_pa( q, pa );
      assert( pa == 8'hD8 ); // bit[7:0]
      
      packed_array#(bit,8)::q_to_pa( q, pa, .reverse( 1 ) );
      assert( pa == 8'h1B );
    end
    begin
      bit[7:0] pa = 8'hD8;
      bit q[$] = { 0, 0, 0, 0, 0, 0, 0, 0 }; // with 8 items
      
      packed_array#(bit,8)::pa_to_q( pa, q );
      assert( q == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      
      packed_array#(bit,8)::pa_to_q( pa, q, .reverse( 1 ) );
      assert( q == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit[7:0] pa;
      packed_array#(bit,8)::init( pa, 1'b1 );
      assert( pa == 8'hFF );
    end
    begin
      bit[7:0] pa = 8'h0F;
      packed_array#(bit,8)::reverse( pa );
      assert( pa == 8'hF0 );
    end
    begin
      bit[15:0] pa = 16'h1234; // 16'b0001_0010_0011_0100
      assert( packed_array#(bit,16)::count_ones( pa ) == 5 );
    end
    begin
      bit[15:0] pa = 16'h1234; // 16'b0001_0010_0011_0100
      assert( packed_array#(bit,16)::count_zeros( pa ) == 11 );
    end
    begin
      logic[15:0] pa = 16'b0000_1111_xxxx_zzzz;
      assert( packed_array#(logic,16)::count_unknowns( pa ) == 4 );
    end
    begin
      logic[15:0] pa = 16'b0000_1111_xxxx_zzzz;
      assert( packed_array#(logic,16)::count_hizs( pa ) == 4 );
    end
    // test ./src/cl_unpacked_array.svh
    begin
      bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } ); // da[0] to da[7]
      assert( unpacked_array#(bit,8)::from_dynamic_array( da                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      assert( unpacked_array#(bit,8)::from_dynamic_array( da, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
      assert( unpacked_array#(bit,8)::to_dynamic_array( ua                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      assert( unpacked_array#(bit,8)::to_dynamic_array( ua, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit q[$] = { 0, 0, 0, 1, 1, 0, 1, 1 }; // q[0] to q[7]
      assert( unpacked_array#(bit,8)::from_queue( q                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      assert( unpacked_array#(bit,8)::from_queue( q, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
      assert( unpacked_array#(bit,8)::to_queue( ua                ) == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      assert( unpacked_array#(bit,8)::to_queue( ua, .reverse( 1 ) ) == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit da[] = new[8]( '{ 0, 0, 0, 1, 1, 0, 1, 1 } ); // da[0] to da[7]
      bit ua[8];
      
      unpacked_array#(bit,8)::da_to_ua( da, ua );
      assert( ua == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      
      unpacked_array#(bit,8)::da_to_ua( da, ua, .reverse( 1 ) );
      assert( ua == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
      bit da[] = new[8]; // set the size of da[]
      
      unpacked_array#(bit,8)::ua_to_da( ua, da );
      assert( da == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      
      unpacked_array#(bit,8)::ua_to_da( ua, da, .reverse( 1 ) );
      assert( da == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit q[$] = { 0, 0, 0, 1, 1, 0, 1, 1 }; // q[0] to q[7]
      bit ua[8];
      
      unpacked_array#(bit,8)::q_to_ua( q, ua );
      assert( ua == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      
      unpacked_array#(bit,8)::q_to_ua( q, ua, .reverse( 1 ) );
      assert( ua == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit ua[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 }; // assigned to ua[0:7]
      bit q[$]  =  { 0, 0, 0, 0, 0, 0, 0, 0 }; // with 8 items
      
      unpacked_array#(bit,8)::ua_to_q( ua, q );
      assert( q == '{ 0, 0, 0, 1, 1, 0, 1, 1 } );
      
      unpacked_array#(bit,8)::ua_to_q( ua, q, .reverse( 1 ) );
      assert( q == '{ 1, 1, 0, 1, 1, 0, 0, 0 } );
    end
    begin
      bit ua[8];
      unpacked_array#(bit,8)::init( ua, 1'b1 );
      assert( ua == '{ 1, 1, 1, 1, 1, 1, 1, 1 } );
    end
    begin
      bit ua[8] = '{ 0, 0, 0, 0, 1, 1, 1, 1 };
      unpacked_array#(bit,8)::reverse( ua );
      assert( ua == '{ 1, 1, 1, 1, 0, 0, 0, 0 } );
    end
    begin
      bit ua1[8] = '{ 0, 0, 0, 1, 1, 0, 1, 1 };
      bit ua2[8] = '{ 1, 1, 0, 1, 1, 0, 0, 0 };
      //                    |<------>|
      //                    2        5
      assert( unpacked_array#(bit,8)::compare( ua1, ua2 ) == 0 );
      assert( unpacked_array#(bit,8)::compare( ua1, ua2, 
      .from_index1( 2 ), .to_index1( 5 ), 
      .from_index2( 2 ), .to_index2( 5 ) ) == 1 );
    end
    $display( "==========finished test_from_examples==========" );
  endfunction: test

  initial test();
endmodule: test_from_examples
