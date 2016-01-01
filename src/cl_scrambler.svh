//==============================================================================
//
// cl_scrambler.svh (v0.6.1)
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

// Title: Scramblers

`ifndef CL_SCRAMBLER_SVH
`define CL_SCRAMBLER_SVH

//------------------------------------------------------------------------------
// Class: scrambler
//   Provides a function to scramble an input bit stream using Galois LFSR,
//   which is also known as the internal LFSR. 
//
// Parameters:
//   T - (OPTIONAL) The type of a bit stream. The *T* must be *bit*, *logic*, or
//       *reg*.  The default is *bit*.
//   DEGREE - (OPTIONAL) The degree of an LFSR polynomial. The default is 2.
//------------------------------------------------------------------------------

class scrambler #( type T = bit, int DEGREE = 2 );

   //---------------------------------------------------------------------------
   // Typedef: bs_type
   //   Bit stream type. The shorthand of the dynamic array of type *T*.
   //---------------------------------------------------------------------------

   typedef T bs_type[];

   //---------------------------------------------------------------------------
   // Typedef: lfsr_type
   //   The shorthand of the *DEGREE*-bit packed array of type *T*.
   //---------------------------------------------------------------------------

   typedef T[DEGREE-1:0] lfsr_type;

   local lfsr_type tap;

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //
   // Argument:
   //   tap - (OPTIONAL) The bit vector representation of LFSR polynomial. The
   //   default is 0 (no scramble).
   //---------------------------------------------------------------------------

   function new( lfsr_type tap = 0 );
      this.tap = tap;
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: scramble
   //   Returns a scrambled bit stream.
   //
   // Arguments:
   //   bs   - An input bit stream.
   //   lfsr - The value of an LFSR, which can be used as the seed of the next
   //          call of this function. The initial value should be all ones.
   //
   // Returns:
   //   A scrambled bit stream.
   //---------------------------------------------------------------------------

   virtual function bs_type scramble( bs_type bs,
				      ref lfsr_type lfsr );
      T msb;

      scramble = new[ bs.size() ];

      tap[0] = 0; // force the first tap to be 0
      foreach ( bs[i] ) begin
	 msb = lfsr[ DEGREE - 1 ];
	 scramble[i] = bs[i] ^ msb;
	 lfsr <<= 1;
	 lfsr[0] = msb;
	 if ( msb ) lfsr ^= tap;
      end
   endfunction: scramble

endclass: scrambler

//------------------------------------------------------------------------------
// Class: scrambler_2
//   Provides a function to scramble an input bit stream using the following
//   2-bit LFSR polynomial:
//   (see scrambler_2.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_2 #( type T = bit ) extends scrambler#(T, 2);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^2 + x + 1
      // 111
      //  ^^
      super.new( 2'h3 );
   endfunction: new

endclass: scrambler_2

//------------------------------------------------------------------------------
// Class: scrambler_3
//   Provides a function to scramble an input bit stream using the following
//   3-bit LFSR polynomial:
//   (see scrambler_3.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_3 #( type T = bit ) extends scrambler#(T, 3);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^3 + x^2 + 1
      // 1101
      //  ^^^
      super.new( 3'h5 );
   endfunction: new

endclass: scrambler_3

//------------------------------------------------------------------------------
// Class: scrambler_4
//   Provides a function to scramble an input bit stream using the following
//   4-bit LFSR polynomial:
//   (see scrambler_4.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_4 #( type T = bit ) extends scrambler#(T, 4);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^4 + x^3 + 1
      // 1_1001
      //   ^^^^
      super.new( 4'h9 );
   endfunction: new

endclass: scrambler_4

//------------------------------------------------------------------------------
// Class: scrambler_5
//   Provides a function to scramble an input bit stream using the following
//   5-bit LFSR polynomial:
//   (see scrambler_5.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_5 #( type T = bit ) extends scrambler#(T, 5);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^5 + x^3 + 1
      // 10_1001
      //  ^ ^^^^
      super.new( 5'h9 );
   endfunction: new

endclass: scrambler_5

//------------------------------------------------------------------------------
// Class: scrambler_6
//   Provides a function to scramble an input bit stream using the following
//   6-bit LFSR polynomial:
//   (see scrambler_6.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_6 #( type T = bit ) extends scrambler#(T, 6);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^6 + x^5 + 1
      // 110_0001
      //  ^^ ^^^^
      super.new( 6'h21 );
   endfunction: new

endclass: scrambler_6

//------------------------------------------------------------------------------
// Class: scrambler_7
//   Provides a function to scramble an input bit stream using the following
//   7-bit LFSR polynomial:
//   (see scrambler_7.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_7 #( type T = bit ) extends scrambler#(T, 7);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^7 + x^6 + 1
      // 1100_0001
      //  ^^^ ^^^^
      super.new( 7'h41 );
   endfunction: new

endclass: scrambler_7

//------------------------------------------------------------------------------
// Class: scrambler_8
//   Provides a function to scramble an input bit stream using the following
//   8-bit LFSR polynomial:
//   (see scrambler_8.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_8 #( type T = bit ) extends scrambler#(T, 8);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^8 + x^6 + x^5 + x^4 + 1
      // 1_0111_0001
      //   ^^^^ ^^^^
      super.new( 8'h71 );
   endfunction: new

endclass: scrambler_8

//------------------------------------------------------------------------------
// Class: scrambler_9
//   Provides a function to scramble an input bit stream using the following
//   9-bit LFSR polynomial:
//   (see scrambler_9.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_9 #( type T = bit ) extends scrambler#(T, 9);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^9 + x^5 + 1
      // 10_0010_0001
      //  ^ ^^^^ ^^^^
      super.new( 9'h021 );
   endfunction: new

endclass: scrambler_9

//------------------------------------------------------------------------------
// Class: scrambler_10
//   Provides a function to scramble an input bit stream using the following
//   10-bit LFSR polynomial:
//   (see scrambler_10.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_10 #( type T = bit ) extends scrambler#(T, 10);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^10 + x^7 + 1
      // 100_1000_0001
      //  ^^ ^^^^ ^^^^
      super.new( 10'h081 );
   endfunction: new

endclass: scrambler_10

//------------------------------------------------------------------------------
// Class: scrambler_11
//   Provides a function to scramble an input bit stream using the following
//   11-bit LFSR polynomial:
//   (see scrambler_11.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_11 #( type T = bit ) extends scrambler#(T, 11);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^11 + x^9 + 1
      // 1010_0000_0001
      //  ^^^ ^^^^ ^^^^
      super.new( 11'h201 );
   endfunction: new

endclass: scrambler_11

//------------------------------------------------------------------------------
// Class: scrambler_12
//   Provides a function to scramble an input bit stream using the following
//   12-bit LFSR polynomial:
//   (see scrambler_12.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_12 #( type T = bit ) extends scrambler#(T, 12);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^12 + x^11 + x^10 + x^4 + 1
      // 1_1100_0001_0001
      //   ^^^^ ^^^^ ^^^^
      super.new( 12'hC11 );
   endfunction: new

endclass: scrambler_12

//------------------------------------------------------------------------------
// Class: scrambler_13
//   Provides a function to scramble an input bit stream using the following
//   13-bit LFSR polynomial:
//   (see scrambler_13.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_13 #( type T = bit ) extends scrambler#(T, 13);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^13 + x^12 + x^11 + x^8 + 1
      // 11_1001_0000_0001
      //  ^ ^^^^ ^^^^ ^^^^
      super.new( 13'h1901 );
   endfunction: new

endclass: scrambler_13

//------------------------------------------------------------------------------
// Class: scrambler_14
//   Provides a function to scramble an input bit stream using the following
//   14-bit LFSR polynomial:
//   (see scrambler_14.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_14 #( type T = bit ) extends scrambler#(T, 14);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^14 + x^13 + x^12 + x^2 + 1
      // 111_0000_0000_0101
      //  ^^ ^^^^ ^^^^ ^^^^
      super.new( 14'h3005 );
   endfunction: new

endclass: scrambler_14

//------------------------------------------------------------------------------
// Class: scrambler_15
//   Provides a function to scramble an input bit stream using the following
//   15-bit LFSR polynomial:
//   (see scrambler_15.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_15 #( type T = bit ) extends scrambler#(T, 15);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^15 + x^14 + 1
      // 1100_0000_0000_0001
      //  ^^^ ^^^^ ^^^^ ^^^^
      super.new( 15'h4001 );
   endfunction: new

endclass: scrambler_15

//------------------------------------------------------------------------------
// Class: scrambler_16
//   Provides a function to scramble an input bit stream using the following
//   16-bit LFSR polynomial:
//   (see scrambler_16.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_16 #( type T = bit ) extends scrambler#(T, 16);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^16 + x^14 + x^13 + x^11 + 1
      // 1_0110_1000_0000_0001
      //   ^^^^ ^^^^ ^^^^ ^^^^
      super.new( 16'h6801 );
   endfunction: new

endclass: scrambler_16

//------------------------------------------------------------------------------
// Class: scrambler_17
//   Provides a function to scramble an input bit stream using the following
//   17-bit LFSR polynomial:
//   (see scrambler_17.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_17 #( type T = bit ) extends scrambler#(T, 17);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^17 + x^14 + 1
      // 10_0100_0000_0000_0001
      //  ^ ^^^^ ^^^^ ^^^^ ^^^^
      super.new( 17'h0_4001 );
   endfunction: new

endclass: scrambler_17

//------------------------------------------------------------------------------
// Class: scrambler_18
//   Provides a function to scramble an input bit stream using the following
//   18-bit LFSR polynomial:
//   (see scrambler_18.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_18 #( type T = bit ) extends scrambler#(T, 18);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^18 + x^11 + 1
      // 100_0000_1000_0000_0001
      //  ^^ ^^^^ ^^^^ ^^^^ ^^^^
      super.new( 18'h0_0801 );
   endfunction: new

endclass: scrambler_18

//------------------------------------------------------------------------------
// Class: scrambler_19
//   Provides a function to scramble an input bit stream using the following
//   19-bit LFSR polynomial:
//   (see scrambler_19.png)
//
// Parameter:
//   T - The type of bit stream. The *T* must be *bit*, *logic*, or *reg*.
//       The default is *bit*.
//------------------------------------------------------------------------------

class scrambler_19 #( type T = bit ) extends scrambler#(T, 19);

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new scrambler.
   //---------------------------------------------------------------------------

   function new();
      // x^19 + x^18 + x^17 + x^14 + 1
      // 1110_0100_0000_0000_0001
      //  ^^^ ^^^^ ^^^^ ^^^^ ^^^^
      super.new( 19'h6_4001 );
   endfunction: new

endclass: scrambler_19

`endif //  `ifndef CL_SCRAMBLE_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
