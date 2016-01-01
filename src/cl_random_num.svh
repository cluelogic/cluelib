//==============================================================================
//
// cl_random_num.svh (v0.6.1)
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

// Title: Random Number Generators

`ifndef CL_RANDOM_NUM_SVH
`define CL_RANDOM_NUM_SVH

//------------------------------------------------------------------------------
// Typedef: dist_bin
//   Defines the structure of a random distribution bin.
//
//   min_val - The minimum value of a bin.
//   max_val - The maximum value of a bin.
//   wt      - The distribution weight of a bin.
//------------------------------------------------------------------------------

typedef struct { 
   int 	         min_val;
   int           max_val;
   byte unsigned wt /*= 0*/;
} dist_bin;

//------------------------------------------------------------------------------
// Class: random_util
//   Provides a utility function to generate random numbers.
//------------------------------------------------------------------------------

class random_util;

   //---------------------------------------------------------------------------
   // Function: random_bool
   //   (STATIC) Returns a randomized Boolean value based on the specified
   //   percentage.
   //
   // Argument:
   //   true_pct - (OPTIONAL) The probability of the returned value to be
   //              randomized to 1 (true). The unit is a percent. The default is
   //              50 (50% true).
   //
   // Returns:
   //   The randomized Boolean value (1 or 0).
   //
   // Example:
   // | bit rb = random_util::random_bool( .true_pct( 70 ) ); // 70% true
   //---------------------------------------------------------------------------

   static function bit random_bool( int unsigned true_pct = 50 );
      return $urandom_range( 99 ) < true_pct;
   endfunction: random_bool

endclass: random_util

//------------------------------------------------------------------------------
// Class: random_2_bin_num
//   Provides a random number using two distribution bins.
//
// Example:
//   The value of variable *n.val* is randomzed to between 0 and 9, or 10 and 19
//   with a weighted ratio of 1-2.
// | random_2_bin_num n = new();
// |
// | //          min max wt
// | n.db[0] = '{  0,  9, 1 }; // bin 0
// | n.db[1] = '{ 10, 19, 2 }; // bin 1
// |
// | assert( n.randomize() );
// | $display( n.val );
//------------------------------------------------------------------------------

class random_2_bin_num;

   //---------------------------------------------------------------------------
   // Property: db
   //   Random distribution bins. The distribution weight of unused bins are set
   //   to be 0.
   //---------------------------------------------------------------------------

   dist_bin db[2];

   //---------------------------------------------------------------------------
   // Property: val
   //   (RAND) The randomized value.
   //---------------------------------------------------------------------------

   rand int val;

   constraint val_con {
      val dist {
	 [db[0].min_val:db[0].max_val] :/ db[0].wt,
	 [db[1].min_val:db[1].max_val] :/ db[1].wt };
   } // val_con

   //---------------------------------------------------------------------------
   // Function: new
   //   Create a random number object.
   //
   // Argument:
   //   default_val - (OPTIONAL) The value of *val* before randomization. The
   //                 default is 0.
   //---------------------------------------------------------------------------

   function new( int default_val = 0 );
      this.val = default_val;
   endfunction: new

endclass: random_2_bin_num

//------------------------------------------------------------------------------
// Class: random_4_bin_num
//   Provides a random number using four distribution bins.
//
// Example:
//   The value of variable *n.val* is randomzed to between 0 and 9, 10 and 19,
//   20 and 29, or 30 and 39 with a weighted ratio of 1-2-3-4.
// | random_4_bin_num n = new();
// |
// | //          min max wt
// | n.db[0] = '{  0,  9, 1 }; // bin 0
// | n.db[1] = '{ 10, 19, 2 }; // bin 1
// | n.db[2] = '{ 20, 29, 3 }; // bin 2
// | n.db[3] = '{ 30, 39, 4 }; // bin 3
// |
// | assert( n.randomize() );
// | $display( n.val );
//------------------------------------------------------------------------------

class random_4_bin_num;

   //---------------------------------------------------------------------------
   // Property: db
   //   Random distribution bins. The distribution weight of unused bins are set
   //   to be 0.
   //---------------------------------------------------------------------------

   dist_bin db[4];

   //---------------------------------------------------------------------------
   // Property: val
   //   (RAND) The randomized value.
   //---------------------------------------------------------------------------

   rand int val;

   constraint val_con {
      val dist {
	 [db[0].min_val:db[0].max_val] :/ db[0].wt,
	 [db[1].min_val:db[1].max_val] :/ db[1].wt,
	 [db[2].min_val:db[2].max_val] :/ db[2].wt,
	 [db[3].min_val:db[3].max_val] :/ db[3].wt };
   } // val_con

   //---------------------------------------------------------------------------
   // Function: new
   //   Create a random number object.
   //
   // Argument:
   //   default_val - (OPTIONAL) The value of *val* before randomization. The
   //                 default is 0.
   //---------------------------------------------------------------------------

   function new( int default_val = 0 );
      this.val = default_val;
   endfunction: new

endclass: random_4_bin_num

//------------------------------------------------------------------------------
// Class: random_8_bin_num
//   Provides a random number using eight distribution bins.
//
// Example:
//   The value of variable *n.val* is randomzed to between 0 and 9, 10 and 19,
//   20 and 29, 30 and 39, 40 and 49, 50 and 59, 60 and 69, or 70 and 79 with a
//   weighted ratio of 1-2-3-4-5-6-7-8.
// | random_8_bin_num n = new();
// |
// | //          min max wt
// | n.db[0] = '{  0,  9, 1 }; // bin 0
// | n.db[1] = '{ 10, 19, 2 }; // bin 1
// | n.db[2] = '{ 20, 29, 3 }; // bin 2
// | n.db[3] = '{ 30, 39, 4 }; // bin 3
// | n.db[4] = '{ 40, 49, 5 }; // bin 4
// | n.db[5] = '{ 50, 59, 6 }; // bin 5
// | n.db[6] = '{ 60, 69, 7 }; // bin 6
// | n.db[7] = '{ 70, 79, 8 }; // bin 7
// |
// | assert( n.randomize() );
// | $display( n.val );
//------------------------------------------------------------------------------

class random_8_bin_num;

   //---------------------------------------------------------------------------
   // Property: db
   //   Random distribution bins. The distribution weight of unused bins are set
   //   to be 0.
   //---------------------------------------------------------------------------

   dist_bin db[8];

   //---------------------------------------------------------------------------
   // Property: val
   //   (RAND) The randomized value.
   //---------------------------------------------------------------------------

   rand int val;

   constraint val_con {
      val dist {
	 [db[0].min_val:db[0].max_val] :/ db[0].wt,
	 [db[1].min_val:db[1].max_val] :/ db[1].wt,
	 [db[2].min_val:db[2].max_val] :/ db[2].wt,
	 [db[3].min_val:db[3].max_val] :/ db[3].wt,
	 [db[4].min_val:db[4].max_val] :/ db[4].wt,
	 [db[5].min_val:db[5].max_val] :/ db[5].wt,
	 [db[6].min_val:db[6].max_val] :/ db[6].wt,
	 [db[7].min_val:db[7].max_val] :/ db[7].wt };
   } // val_con

   //---------------------------------------------------------------------------
   // Function: new
   //   Create a random number object.
   //
   // Argument:
   //   default_val - (OPTIONAL) The value of *val* before randomization. The
   //                 default is 0.
   //---------------------------------------------------------------------------

   function new( int default_val = 0 );
      this.val = default_val;
   endfunction: new

endclass: random_8_bin_num

//------------------------------------------------------------------------------
// Class: random_16_bin_num
//   Provides a random number using sixteen distribution bins. See
//   <random_8_bin_num> for how to use this class.
//------------------------------------------------------------------------------

class random_16_bin_num;

   //---------------------------------------------------------------------------
   // Property: db
   //   Random distribution bins. The distribution weight of unused bins are set
   //   to be 0.
   //---------------------------------------------------------------------------

   dist_bin db[16];

   //---------------------------------------------------------------------------
   // Property: val
   //   (RAND) The randomized value.
   //---------------------------------------------------------------------------

   rand int val;

   constraint val_con {
      val dist {
	 [db[ 0].min_val:db[ 0].max_val] :/ db[ 0].wt,
	 [db[ 1].min_val:db[ 1].max_val] :/ db[ 1].wt,
	 [db[ 2].min_val:db[ 2].max_val] :/ db[ 2].wt,
	 [db[ 3].min_val:db[ 3].max_val] :/ db[ 3].wt,
	 [db[ 4].min_val:db[ 4].max_val] :/ db[ 4].wt,
	 [db[ 5].min_val:db[ 5].max_val] :/ db[ 5].wt,
	 [db[ 6].min_val:db[ 6].max_val] :/ db[ 6].wt,
	 [db[ 7].min_val:db[ 7].max_val] :/ db[ 7].wt,
	 [db[ 8].min_val:db[ 8].max_val] :/ db[ 8].wt,
	 [db[ 9].min_val:db[ 9].max_val] :/ db[ 9].wt,
	 [db[10].min_val:db[10].max_val] :/ db[10].wt,
	 [db[11].min_val:db[11].max_val] :/ db[11].wt,
	 [db[12].min_val:db[12].max_val] :/ db[12].wt,
	 [db[13].min_val:db[13].max_val] :/ db[13].wt,
	 [db[14].min_val:db[14].max_val] :/ db[14].wt,
	 [db[15].min_val:db[15].max_val] :/ db[15].wt };
   } // val_con

   //---------------------------------------------------------------------------
   // Function: new
   //   Create a random number object.
   //
   // Argument:
   //   default_val - (OPTIONAL) The value of *val* before randomization. The
   //                 default is 0.
   //---------------------------------------------------------------------------

   function new( int default_val = 0 );
      this.val = default_val;
   endfunction: new

endclass: random_16_bin_num

//------------------------------------------------------------------------------
// Class: random_32_bin_num
//   Provides a random number using thirty-two distribution bins. See
//   <random_8_bin_num> for how to use this class.
//------------------------------------------------------------------------------

class random_32_bin_num;

   //---------------------------------------------------------------------------
   // Property: db
   //   Random distribution bins. The distribution weight of unused bins are set
   //   to be 0.
   //---------------------------------------------------------------------------

   dist_bin db[32];

   //---------------------------------------------------------------------------
   // Property: val
   //   (RAND) The randomized value.
   //---------------------------------------------------------------------------

   rand int val;

   constraint val_con {
      val dist {
	 [db[ 0].min_val:db[ 0].max_val] :/ db[ 0].wt,
	 [db[ 1].min_val:db[ 1].max_val] :/ db[ 1].wt,
	 [db[ 2].min_val:db[ 2].max_val] :/ db[ 2].wt,
	 [db[ 3].min_val:db[ 3].max_val] :/ db[ 3].wt,
	 [db[ 4].min_val:db[ 4].max_val] :/ db[ 4].wt,
	 [db[ 5].min_val:db[ 5].max_val] :/ db[ 5].wt,
	 [db[ 6].min_val:db[ 6].max_val] :/ db[ 6].wt,
	 [db[ 7].min_val:db[ 7].max_val] :/ db[ 7].wt,
	 [db[ 8].min_val:db[ 8].max_val] :/ db[ 8].wt,
	 [db[ 9].min_val:db[ 9].max_val] :/ db[ 9].wt,
	 [db[10].min_val:db[10].max_val] :/ db[10].wt,
	 [db[11].min_val:db[11].max_val] :/ db[11].wt,
	 [db[12].min_val:db[12].max_val] :/ db[12].wt,
	 [db[13].min_val:db[13].max_val] :/ db[13].wt,
	 [db[14].min_val:db[14].max_val] :/ db[14].wt,
	 [db[15].min_val:db[15].max_val] :/ db[15].wt,
	 [db[16].min_val:db[16].max_val] :/ db[16].wt,
	 [db[17].min_val:db[17].max_val] :/ db[17].wt,
	 [db[18].min_val:db[18].max_val] :/ db[18].wt,
	 [db[19].min_val:db[19].max_val] :/ db[19].wt,
	 [db[20].min_val:db[20].max_val] :/ db[20].wt,
	 [db[21].min_val:db[21].max_val] :/ db[21].wt,
	 [db[22].min_val:db[22].max_val] :/ db[22].wt,
	 [db[23].min_val:db[23].max_val] :/ db[23].wt,
	 [db[24].min_val:db[24].max_val] :/ db[24].wt,
	 [db[25].min_val:db[25].max_val] :/ db[25].wt,
	 [db[26].min_val:db[26].max_val] :/ db[26].wt,
	 [db[27].min_val:db[27].max_val] :/ db[27].wt,
	 [db[28].min_val:db[28].max_val] :/ db[28].wt,
	 [db[29].min_val:db[29].max_val] :/ db[29].wt,
	 [db[30].min_val:db[30].max_val] :/ db[30].wt,
	 [db[31].min_val:db[31].max_val] :/ db[31].wt };
   } // val_con

   //---------------------------------------------------------------------------
   // Function: new
   //   Create a random number object.
   //
   // Argument:
   //   default_val - (OPTIONAL) The value of *val* before randomization. The
   //                 default is 0.
   //---------------------------------------------------------------------------

   function new( int default_val = 0 );
      this.val = default_val;
   endfunction: new

endclass: random_32_bin_num

//------------------------------------------------------------------------------
// Class: random_power_of_2_num
//   Provides a random number with power-of-two distributions. This class uses
//   the following pre-populated distribution bins.
//
//   (begin table)
//   //           min    max  wt       bin
//   db = '{ '{     0,     0, 1 },   //  0
//           '{     1,     1, 1 },   //  1
//           '{     2,     2, 1 },   //  2
//           '{     3,     3, 1 },   //  3
//           '{     4,     4, 1 },   //  4
//           '{     5,     7, 1 },   //  5
//           '{     8,     8, 1 },   //  6
//           '{     9,    15, 1 },   //  7
//           '{    16,    16, 1 },   //  8
//           '{    17,    31, 1 },   //  9
//           '{    32,    32, 1 },   // 10
//           '{    33,    63, 1 },   // 11
//           '{    64,    64, 1 },   // 12
//           '{    65,   127, 1 },   // 13
//           '{   128,   128, 1 },   // 14
//           '{   129,   255, 1 },   // 15
//           '{   256,   256, 1 },   // 16
//           '{   257,   511, 1 },   // 17
//           '{   512,   512, 1 },   // 18
//           '{   513,  1023, 1 },   // 19
//           '{  1024,  1024, 1 },   // 20
//           '{  1025,  2047, 1 },   // 21
//           '{  2048,  2048, 1 },   // 22
//           '{  2049,  4095, 1 },   // 23
//           '{  4096,  4096, 1 },   // 24
//           '{  4097,  8191, 1 },   // 25
//           '{  8192,  8192, 1 },   // 26
//           '{  8193, 16383, 1 },   // 27
//           '{ 16384, 16384, 1 },   // 28
//           '{ 16385, 32767, 1 },   // 29
//           '{ 32768, 32768, 1 },   // 30
//           '{ 32769, 65535, 1 } }; // 31
//   (end)
//
// Example:
// | random_power_of_2_num n = new();
// | assert( n.randomize() );
// | $display( n.val );
//------------------------------------------------------------------------------

class random_power_of_2_num extends random_32_bin_num;

   //---------------------------------------------------------------------------
   // Property: min_val
   //   The minimum limit of *val*. The *val* is randomized to be at least this
   //   value.
   //---------------------------------------------------------------------------

   int min_val;

   //---------------------------------------------------------------------------
   // Property: max_val
   //   The maximum limit of *val*. The *val* is randomized to be at most this 
   //   value.
   //---------------------------------------------------------------------------

   int max_val;

   constraint min_max_con {
      val >= min_val;
      val <= max_val;
   }
   
   //---------------------------------------------------------------------------
   // Function: new
   //   Create a random number object.
   //
   // Argument:
   //   default_val - (OPTIONAL) The value of *val* before randomization. The
   //                 default is 0.
   //   min_val     - (OPTIONAL) The minimum limit of *val*. The *val* is 
   //                 randomized to be at least this value. The default is 0.
   //   max_val     - (OPTIONAL) The maximum limit of *val*. The *val* is 
   //                 randomized to be at most this value. The default is
   //                 65,535.
   //---------------------------------------------------------------------------

   function new( int default_val = 0,
		 int min_val = 0, 
		 int max_val = 65535 );
      super.new( default_val );
      this.min_val = min_val;
      this.max_val = max_val;

      //           min    max  wt       bin
      db = '{ '{     0,     0, 1 },   //  0
	      '{     1,     1, 1 },   //  1
	      '{     2,     2, 1 },   //  2
	      '{     3,     3, 1 },   //  3
	      '{     4,     4, 1 },   //  4
	      '{     5,     7, 1 },   //  5
	      '{     8,     8, 1 },   //  6
	      '{     9,    15, 1 },   //  7
	      '{    16,    16, 1 },   //  8
	      '{    17,    31, 1 },   //  9
	      '{    32,    32, 1 },   // 10
	      '{    33,    63, 1 },   // 11
	      '{    64,    64, 1 },   // 12
	      '{    65,   127, 1 },   // 13
	      '{   128,   128, 1 },   // 14
	      '{   129,   255, 1 },   // 15
	      '{   256,   256, 1 },   // 16
	      '{   257,   511, 1 },   // 17
	      '{   512,   512, 1 },   // 18
	      '{   513,  1023, 1 },   // 19
	      '{  1024,  1024, 1 },   // 20
	      '{  1025,  2047, 1 },   // 21
	      '{  2048,  2048, 1 },   // 22
	      '{  2049,  4095, 1 },   // 23
	      '{  4096,  4096, 1 },   // 24
	      '{  4097,  8191, 1 },   // 25
	      '{  8192,  8192, 1 },   // 26
	      '{  8193, 16383, 1 },   // 27
	      '{ 16384, 16384, 1 },   // 28
	      '{ 16385, 32767, 1 },   // 29
	      '{ 32768, 32768, 1 },   // 30
	      '{ 32769, 65535, 1 } }; // 31
   endfunction: new
endclass: random_power_of_2_num      

//------------------------------------------------------------------------------
// Class: random_power_of_10_num
//   Provides a random number with power-of-ten distributions. This class uses
//   the following pre-populated distribution bins.
//
//   (begin table)
//   //                min         max  wt       bin
//   db = '{ '{          0,          0, 1 },   //  0
//           '{          1,          1, 1 },   //  1
//   	     '{          2,          9, 1 },   //  2
//   	     '{         10,         10, 1 },   //  3
//   	     '{         11,         99, 1 },   //  4
//   	     '{        100,        100, 1 },   //  5
//   	     '{        101,        999, 1 },   //  6
//   	     '{      1_000,      1_000, 1 },   //  7
//   	     '{      1_001,      9_999, 1 },   //  8
//   	     '{     10_000,     10_000, 1 },   //  9
//   	     '{     10_001,     99_999, 1 },   // 10
//   	     '{    100_000,    100_000, 1 },   // 11
//   	     '{    100_001,    999_999, 1 },   // 12
//   	     '{  1_000_000,  1_000_000, 1 },   // 13
//   	     '{  1_000_001,  9_999_999, 1 },   // 14
//   	     '{ 10_000_000, 10_000_000, 1 } }; // 15
//   (end)
//
// Example:
// | random_power_of_10_num n = new();
// | assert( n.randomize() );
// | $display( n.val );
//------------------------------------------------------------------------------

class random_power_of_10_num extends random_16_bin_num;

   //---------------------------------------------------------------------------
   // Property: min_val
   //   The minimum limit of *val*. The *val* is randomized to be at least this
   //   value.
   //---------------------------------------------------------------------------

   int min_val;

   //---------------------------------------------------------------------------
   // Property: max_val
   //   The maximum limit of *val*. The *val* is randomized to be at most this 
   //   value.
   //---------------------------------------------------------------------------

   int max_val;

   constraint min_max_con {
      val >= min_val;
      val <= max_val;
   }
   
   //---------------------------------------------------------------------------
   // Function: new
   //   Create a random number object.
   //
   // Argument:
   //   default_val - (OPTIONAL) The value of *val* before randomization. The
   //                 default is 0.
   //   min_val     - (OPTIONAL) The minimum limit of *val*. The *val* is 
   //                 randomized to be at least this value. The default is 0.
   //   max_val     - (OPTIONAL) The maximum limit of *val*. The *val* is 
   //                 randomized to be at most this value. The default is 
   //                 10,000,000.
   //---------------------------------------------------------------------------

   function new( int default_val = 0,
		 int min_val = 0, 
		 int max_val = 10_000_000 );
      super.new( default_val );
      this.min_val = min_val;
      this.max_val = max_val;

      //                min         max  wt       bin
      db = '{ '{          0,          0, 1 },   //  0
	      '{          1,          1, 1 },   //  1
	      '{          2,          9, 1 },   //  2
	      '{         10,         10, 1 },   //  3
	      '{         11,         99, 1 },   //  4
	      '{        100,        100, 1 },   //  5
	      '{        101,        999, 1 },   //  6
	      '{      1_000,      1_000, 1 },   //  7
	      '{      1_001,      9_999, 1 },   //  8
	      '{     10_000,     10_000, 1 },   //  9
	      '{     10_001,     99_999, 1 },   // 10
	      '{    100_000,    100_000, 1 },   // 11
	      '{    100_001,    999_999, 1 },   // 12
	      '{  1_000_000,  1_000_000, 1 },   // 13
	      '{  1_000_001,  9_999_999, 1 },   // 14
	      '{ 10_000_000, 10_000_000, 1 } }; // 15
   endfunction: new

endclass: random_power_of_10_num

`endif //  `ifndef CL_RANDOM_NUM_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
