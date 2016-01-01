//==============================================================================
//
// cl_crc.svh (v0.6.1)
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

`ifndef CL_CRC_SVH
`define CL_CRC_SVH

//------------------------------------------------------------------------------
// Class: crc
//   (VIRTUAL) Provides functions to calculate a variety of CRC (cyclic
//   redundancy check) values from a bit stream.
//
// Parameters:
//   T - (OPTIONAL) The type of the bit stream to calculate the CRC. The type
//       *T* must be *bit*, *logic*, or *reg*.  The default type is *bit*.
//------------------------------------------------------------------------------

virtual class crc #( type T = bit );

   //---------------------------------------------------------------------------
   // Typedef: bs_type
   //   The bit stream type. The shorthand of the dynamic array of type *T*.
   //---------------------------------------------------------------------------

   typedef T bs_type[];

   //---------------------------------------------------------------------------
   // Function: crc
   //   (STATIC) Returns a CRC value using the specified taps. The function
   //   supports up to 64-bit tap. See <this site at https://ghsi.de/CRC> for
   //   how this function calculates the CRC.
   //
   // Argument:
   //   bs     - An input bit stream.
   //   tap    - The bit vector representaion of a CRC polynomial.
   //   degree - The degree of a CRC polynomial.
   //
   // Returns:
   //   A calculated CRC value.
   //
   // Example:
   // | bit[15:0] crc16_ccitt_tap = 16'h1021;
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc( bs, crc16_ccitt_tap, .degree( 16 ) ) == 16'hFEC5 );
   //---------------------------------------------------------------------------

   static function T[63:0] crc( bs_type bs,
				T[63:0] tap,
				int     degree );
      T[63:0] x = 0;
      T       y;

      foreach ( bs[i] ) begin
	 y = bs[i] ^ x[degree - 1];
	 for ( int j = degree - 1; j > 0; j-- )
	   x[j] = tap[j] ? x[j-1] ^ y : x[j-1];
	 x[0] = y;
      end
      return x;
   endfunction: crc

   //-----------------------------------------------------------------------
   // Function: crc1
   //   (STATIC) Returns a CRC-1 value; also known as a parity bit. 
   //   The CRC polynomial is:
   //   (see crc1.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-1 value. 
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc1( bs ) == 1'h1 );
   //-----------------------------------------------------------------------

   static function T crc1( bs_type bs );

      // x + 1
      // 11
      
      return crc( bs, 1'b1 /*not used*/, .degree( 1 ) );
   endfunction: crc1

   //-----------------------------------------------------------------------
   // Function: crc4_itu
   //   (STATIC) Returns a CRC-4-ITU value. 
   //   The CRC polynomial is:
   //   (see crc4_itu.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-4-ITU value. 
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc4_itu( bs ) == 4'h7 );
   //-----------------------------------------------------------------------

   static function T[3:0] crc4_itu( bs_type bs );

      // x^4 + x + 1
      // 1_0011

      return crc( bs, 4'h3, .degree( 4 ) );
   endfunction: crc4_itu

   //-----------------------------------------------------------------------
   // Function: crc5_epc
   //   (STATIC) Returns a CRC-5-EPC value. 
   //   The CRC polynomial is: 
   //   (see crc5_epc.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-5-EPC value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc5_epc( bs ) == 5'h0 );
   //-----------------------------------------------------------------------

   static function T[4:0] crc5_epc( bs_type bs );

      // x^5 + x^3 + 1
      // 10_1001

      return crc( bs, 5'h09, .degree( 5 ) );
   endfunction: crc5_epc

   //-----------------------------------------------------------------------
   // Function: crc5_itu
   //   (STATIC) Returns a CRC-5-ITU value.
   //   The CRC polynomial is:
   //   (see crc5_itu.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-5-ITU value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc5_itu( bs ) == 5'hE );
   //-----------------------------------------------------------------------

   static function T[4:0] crc5_itu( bs_type bs );

      // x^5 + x^4 + x^2 + 1
      // 11_0101

      return crc( bs, 5'h15, .degree( 5 ) );
   endfunction: crc5_itu

   //-----------------------------------------------------------------------
   // Function: crc5_usb
   //   (STATIC) Returns a CRC-5-USB value.
   //   The CRC polynomial is:
   //   (see crc5_usb.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-5-USB value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc5_usb( bs ) == 5'hF );
   //-----------------------------------------------------------------------

   static function T[4:0] crc5_usb( bs_type bs );

      // x^5 + x^2 + 1
      // 10_0101

      return crc( bs, 5'h05, .degree( 5 ) );
   endfunction: crc5_usb

   //-----------------------------------------------------------------------
   // Function: crc6_cdma2000_a
   //   (STATIC) Returns a CRC-6-CDMA2000-A value.
   //   The CRC polynomial is:
   //   (see crc6_cdma2000_a.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-6-CDMA2000-A value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc6_cdma2000_a( bs ) == 6'h24 );
   //-----------------------------------------------------------------------

   static function T[5:0] crc6_cdma2000_a( bs_type bs );

      // x^6 + x^5 + x^2 + x + 1
      // 110_0111

      return crc( bs, 6'h27, .degree( 6 ) );
   endfunction: crc6_cdma2000_a

   //-----------------------------------------------------------------------
   // Function: crc6_cdma2000_b
   //   (STATIC) Returns a CRC-6-CDMA2000-B value.
   //   The CRC polynomial is:
   //   (see crc6_cdma2000_b.png)
   //
   // Argument:
   //   bs - An input bit stream.
   // 
   // Returns:
   //   A CRC-6-CDMA2000-B value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc6_cdma2000_b( bs ) == 6'h20 );
   //-----------------------------------------------------------------------

   static function T[5:0] crc6_cdma2000_b( bs_type bs );

      // x^6 + x^2 + x + 1
      // 100_0111

      return crc( bs, 6'h07, .degree( 6 ) );
   endfunction: crc6_cdma2000_b

   //-----------------------------------------------------------------------
   // Function: crc6_itu
   //   (STATIC) Returns a CRC-6-ITU value.
   //   The CRC polynomial is:
   //   (see crc6_itu.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-6-ITU value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc6_itu( bs ) == 6'h9 );
   //-----------------------------------------------------------------------

   static function T[5:0] crc6_itu( bs_type bs );

      // x^6 + x + 1
      // 100_0011

      return crc( bs, 6'h03, .degree( 6 ) );
   endfunction: crc6_itu

   //-----------------------------------------------------------------------
   // Function: crc7
   //   (STATIC) Returns a CRC-7 value.
   //   The CRC polynomial is:
   //   (see crc7.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-7 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc7( bs ) == 7'h3F );
   //-----------------------------------------------------------------------

   static function T[6:0] crc7( bs_type bs );

      // x^7 + x^3 + 1
      // 1000_1001

      return crc( bs, 7'h09, .degree( 7 ) );
   endfunction: crc7

   //-----------------------------------------------------------------------
   // Function: crc7_mvb
   //   (STATIC) Returns a CRC-7-MVB value.
   //   The CRC polynomial is:
   //   (see crc7_mvb.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-7-MVB value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc7_mvb( bs ) == 7'h4C );
   //-----------------------------------------------------------------------

   static function T[6:0] crc7_mvb( bs_type bs );

      // x^7 + x^6 + x^5 + x^2 + 1
      // 1110_0101

      return crc( bs, 7'h65, .degree( 7 ) );
   endfunction: crc7_mvb

   //-----------------------------------------------------------------------
   // Function: crc8
   //   (STATIC) Returns a CRC-8 value.
   //   The CRC polynomial is:
   //   (see crc8.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-8 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc8( bs ) == 8'hC7 );
   //-----------------------------------------------------------------------

   static function T[7:0] crc8( bs_type bs );

      // x^8 + x^7 + x^6 + x^4 + x^2 + 1
      // 1_1101_0101

      return crc( bs, 8'hD5, .degree( 8 ) );
   endfunction: crc8

   //-----------------------------------------------------------------------
   // Function: crc8_ccitt
   //   (STATIC) Returns a CRC-8-CCITT value.
   //   The CRC polynomial is:
   //   (see crc8_ccitt.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-8-CCITT value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc8_ccitt( bs ) == 8'hF8 );
   //-----------------------------------------------------------------------

   static function T[7:0] crc8_ccitt( bs_type bs );

      // x^8 + x^2 + x + 1
      // 1_0000_0111

      return crc( bs, 8'h07, .degree( 8 ) );
   endfunction: crc8_ccitt

   //-----------------------------------------------------------------------
   // Function: crc8_dallas_maxim
   //   (STATIC) Returns a CRC-8-Dallas/Maxim value.
   //   The CRC polynomial is:
   //   (see crc8_dallas_maxim.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-8-Dallas/Maxim value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc8_dallas_maxim( bs ) == 8'h85 );
   //-----------------------------------------------------------------------

   static function T[7:0] crc8_dallas_maxim( bs_type bs );

      // x^8 + x^5 + x^4 + 1
      // 1_0011_0001

      return crc( bs, 8'h31, .degree( 8 ) );
   endfunction: crc8_dallas_maxim

   //-----------------------------------------------------------------------
   // Function: crc8_sae_j1850
   //   (STATIC) Returns a CRC-8-SAE-J1850 value.
   //   The CRC polynomial is:
   //   (see crc8_sae_j1850.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-8-SAE-J1850 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc8_sae_j1850( bs ) == 8'h7F );
   //-----------------------------------------------------------------------

   static function T[7:0] crc8_sae_j1850( bs_type bs );

      // x^8 + x^4 + x^3 + x^2 + 1
      // 1_0001_1101

      return crc( bs, 8'h1D, .degree( 8 ) );
   endfunction: crc8_sae_j1850

   //-----------------------------------------------------------------------
   // Function: crc8_wcdma
   //   (STATIC) Returns a CRC-8-WCDMA value.
   //   The CRC polynomial is:
   //   (see crc8_wcdma.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-8-WCDMA value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc8_wcdma( bs ) == 8'hF7 );
   //-----------------------------------------------------------------------

   static function T[7:0] crc8_wcdma( bs_type bs );

      // x^8 + x^7 + x^4 + x^3 + x + 1
      // 1_1001_1011

      return crc( bs, 8'h9B, .degree( 8 ) );
   endfunction: crc8_wcdma

   //-----------------------------------------------------------------------
   // Function: crc10
   //   (STATIC) Returns a CRC-10 value.
   //   The CRC polynomial is:
   //   (see crc10.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-10 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc10( bs ) == 10'hB3 );
   //-----------------------------------------------------------------------

   static function T[9:0] crc10( bs_type bs );

      // x^10 + x^9 + x^5 + x^4 + x + 1
      // 110_0011_0011

      return crc( bs, 10'h233, .degree( 10 ) );
   endfunction: crc10

   //-----------------------------------------------------------------------
   // Function: crc10_cdma2000
   //   (STATIC) Returns a CRC-10-CDMA2000 value.
   //   The CRC polynomial is:
   //   (see crc10_cdma2000.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-10-CDMA2000 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc10_cdma2000( bs ) == 10'h2A );
   //-----------------------------------------------------------------------

   static function T[9:0] crc10_cdma2000( bs_type bs );

      // x^10 + x^9 + x^8 + x^7 + x^6 + x^4 + x^3 + 1
      // 111_1101_1001

      return crc( bs, 10'h3D9, .degree( 10 ) );
   endfunction: crc10_cdma2000

   //-----------------------------------------------------------------------
   // Function: crc11
   //   (STATIC) Returns a CRC-11 value.
   //   The CRC polynomial is:
   //   (see crc11.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-11 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc11( bs ) == 11'h43A );
   //-----------------------------------------------------------------------

   static function T[10:0] crc11( bs_type bs );

      // x^11 + x^9 + x^8 + x^7 + x^2 + 1
      // 1011_1000_0101
      
      return crc( bs, 11'h385, .degree( 11 ) );
   endfunction: crc11

   //-----------------------------------------------------------------------
   // Function: crc12
   //   (STATIC) Returns a CRC-12 value.
   //   The CRC polynomial is:
   //   (see crc12.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-12 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc12( bs ) == 12'hBF9 );
   //-----------------------------------------------------------------------

   static function T[11:0] crc12( bs_type bs );

      // x^12 + x^11 + x^3 + x^2 + x + 1
      // 1_1000_0000_1111

      return crc( bs, 12'h80F, .degree( 12 ) );
   endfunction: crc12

   //-----------------------------------------------------------------------
   // Function: crc12_cdma2000
   //   (STATIC) Returns a CRC-12-CDMA2000 value.
   //   The CRC polynomial is:
   //   (see crc12_cdma2000.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-12-CDMA2000 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc12_cdma2000( bs ) == 12'h7C3 );
   //-----------------------------------------------------------------------

   static function T[11:0] crc12_cdma2000( bs_type bs );

      // x^12 + x^11 + x^10 + x^9 + x^8 + x^4 + x + 1
      // 1_1111_0001_0011

      return crc( bs, 12'hF13, .degree( 12 ) );
   endfunction: crc12_cdma2000

   //-----------------------------------------------------------------------
   // Function: crc13_bbc
   //   (STATIC) Returns a CRC-13-BBC value.
   //   The CRC polynomial is:
   //   (see crc13_bbc.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-13-BBC value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc13_bbc( bs ) == 13'hAEA );
   //-----------------------------------------------------------------------

   static function T[12:0] crc13_bbc( bs_type bs );

      // x^13 + x^12 + x^11 + x^10 + x^7 + x^6 + x^5 + x^4 + x^2 + 1
      // 11_1100_1111_0101

      return crc( bs, 13'h1CF5, .degree( 13 ) );
   endfunction: crc13_bbc

   //-----------------------------------------------------------------------
   // Function: crc15_can
   //   (STATIC) Returns a CRC-15-CAN value.
   //   The CRC polynomial is:
   //   (see crc15_can.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-15-CAN value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc15_can( bs ) == 15'h6DDE );
   //-----------------------------------------------------------------------

   static function T[14:0] crc15_can( bs_type bs );

      // x^15 + x^14 + x^10 + x^8 + x^7 + x^4 + x^3 + 1
      // 1100_0101_1001_1001

      return crc( bs, 15'h4599, .degree( 15 ) );
   endfunction: crc15_can

   //-----------------------------------------------------------------------
   // Function: crc15_mpt1327
   //   (STATIC) Returns a CRC-15-MPT1327 value.
   //   The CRC polynomial is:
   //   (see crc15_mpt1327.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-15-MPT1327 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc15_mpt1327( bs ) == 15'h7E4E );
   //-----------------------------------------------------------------------

   static function T[14:0] crc15_mpt1327( bs_type bs );

      // x^15 + x^14 + x^13 + x^11 + x^4 + x^2 + 1
      // 1110_1000_0001_0101

      return crc( bs, 15'h6815, .degree( 15 ) );
   endfunction: crc15_mpt1327

   //-----------------------------------------------------------------------
   // Function: crc16_arinc
   //   (STATIC) Returns a CRC-16-ARINC value.
   //   The CRC polynomial is:
   //   (see crc16_arinc.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-16-ARINC value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc16_arinc( bs ) == 16'h18FB );
   //-----------------------------------------------------------------------

   static function T[15:0] crc16_arinc( bs_type bs );

      // x^16 + x^15 + x^13 + x^5 + x^3 + x + 1
      // 1_1010_0000_0010_1011

      return crc( bs, 16'hA02B, .degree( 16 ) );
   endfunction: crc16_arinc

   //-----------------------------------------------------------------------
   // Function: crc16_ccitt
   //   (STATIC) Returns a CRC-16-CCITT value.
   //   The CRC polynomial is:
   //   (see crc16_ccitt.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-16-CCITT value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc16_ccitt( bs ) == 16'hFEC5 );
   //-----------------------------------------------------------------------

   static function T[15:0] crc16_ccitt( bs_type bs );

      // x^16 + x^12 + x^5 + 1
      // 1_0001_0000_0010_0001

      return crc( bs, 16'h1021, .degree( 16 ) );
   endfunction: crc16_ccitt

   //-----------------------------------------------------------------------
   // Function: crc16_cdma2000
   //   (STATIC) Returns a CRC-16-CDMA2000 value.
   //   The CRC polynomial is:
   //   (see crc16_cdma2000.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-16-CDMA2000 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc16_cdma2000( bs ) == 16'hCEEA );
   //-----------------------------------------------------------------------

   static function T[15:0] crc16_cdma2000( bs_type bs );

      // x^16 + x^15 + x^14 + x^11 + x^6 + x^5 + x^2 + x + 1
      // 1_1100_1000_0110_0111

      return crc( bs, 16'hC867, .degree( 16 ) );
   endfunction: crc16_cdma2000

   //-----------------------------------------------------------------------
   // Function: crc16_dect
   //   (STATIC) Returns a CRC-16-CECT value.
   //   The CRC polynomial is:
   //   (see crc16_dect.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-16-DECT value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc16_dect( bs ) == 16'h7511 );
   //-----------------------------------------------------------------------

   static function T[15:0] crc16_dect( bs_type bs );

      // x^16 + x^10 + x^8 + x^7 + x^3 + 1
      // 1_0000_0101_1000_1001

      return crc( bs, 16'h0589, .degree( 16 ) );
   endfunction: crc16_dect

   //-----------------------------------------------------------------------
   // Function: crc16_t10_dif
   //   (STATIC) Returns a CRC-16-T10-DIF value.
   //   The CRC polynomial is:
   //   (see crc16_t10_dif.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-16-T10-DIF value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc16_t10_dif( bs ) == 16'h5213 );
   //-----------------------------------------------------------------------

   static function T[15:0] crc16_t10_dif( bs_type bs );

      // x^16 + x^15 + x^11 + x^9 + x^8 + x^7 + x^5 + x^4 + x^2 + x + 1
      // 1_1000_1011_1011_0111

      return crc( bs, 16'h8BB7, .degree( 16 ) );
   endfunction: crc16_t10_dif

   //-----------------------------------------------------------------------
   // Function: crc16_dnp
   //   (STATIC) Returns a CRC-16-DNP value.
   //   The CRC polynomial is:
   //   (see crc16_dnp.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-16-DNP value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc16_dnp( bs ) == 16'hF0AD );
   //-----------------------------------------------------------------------

   static function T[15:0] crc16_dnp( bs_type bs );

      // x^16 + x^13 + x^12 + x^11 + x^10 + x^8 + x^6 + x^5 + x^2 + 1
      // 1_0011_1101_0110_0101

      return crc( bs, 16'h3D65, .degree( 16 ) );
   endfunction: crc16_dnp

   //-----------------------------------------------------------------------
   // Function: crc16_ibm
   //   (STATIC) Returns a CRC-16-IBM value.
   //   The CRC polynomial is:
   //   (see crc16_ibm.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-16-IBM value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc16_ibm( bs ) == 16'hB17F );
   //-----------------------------------------------------------------------

   static function T[15:0] crc16_ibm( bs_type bs );

      // x^16 + x^15 + x^2 + 1
      // 1_1000_0000_0000_0101

      return crc( bs, 16'h8005, .degree( 16 ) );
   endfunction: crc16_ibm

   //-----------------------------------------------------------------------
   // Function: crc17_can
   //   (STATIC) Returns a CRC-17-CAN value.
   //   The CRC polynomial is:
   //   (see crc17_can.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-17-CAN value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc17_can( bs ) == 17'h42B0 );
   //-----------------------------------------------------------------------

   static function T[16:0] crc17_can( bs_type bs );

      // x^17 + x^16 + x^14 + x^13 + x^11 + x^6 + x^4 + x^3 + x + 1
      // 11_0110_1000_0101_1011

      return crc( bs, 17'h1_685B, .degree( 17 ) );
   endfunction: crc17_can

   //-----------------------------------------------------------------------
   // Function: crc21_can
   //   (STATIC) Returns a CRC-21-CAN value.
   //   The CRC polynomial is:
   //   (see crc21_can.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-21-CAN value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc21_can( bs ) == 21'h1A3C3F );
   //-----------------------------------------------------------------------

   static function T[20:0] crc21_can( bs_type bs );

      // x^21 + x^20 + x^13 + x^11 + x^7 + x^4 + x^3 + 1
      //              11_0000
      // _0010_1000_1001_1001

      return crc( bs, 21'h10_2899, .degree( 21 ) );
   endfunction: crc21_can

   //-----------------------------------------------------------------------
   // Function: crc24
   //   (STATIC) Returns a CRC-24 value.
   //   The CRC polynomial is:
   //   (see crc24.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-24 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc24( bs ) == 24'h4FAC88 );
   //-----------------------------------------------------------------------

   static function T[23:0] crc24( bs_type bs );

      // x^24 + x^22 + x^20 + x^19 + x^18 + x^16 + x^14 + x^13 + x^11 + 
      // x^10 + x^8 + x^7 + x^6 + x^3 + x + 1
      //          1_0101_1101
      // _0110_1101_1100_1011

      return crc( bs, 24'h5D_6DCB, .degree( 24 ) );
   endfunction: crc24

   //-----------------------------------------------------------------------
   // Function: crc24_radix_64
   //   (STATIC) Returns a CRC-24-Radix-64 value.
   //   The CRC polynomial is:
   //   (see crc24_radix_64.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-24-Radix-64 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc24_radix_64( bs ) == 24'h5EFC5F );
   //-----------------------------------------------------------------------

   static function T[23:0] crc24_radix_64( bs_type bs );

      // x^24 + x^23 + x^18 + x^17 + x^14 + x^11 + x^10 + x^7 + x^6 + x^5 +
      // x^4 + x^3 + x + 1
      //          1_1000_0110
      // _0100_1100_1111_1011
      
      return crc( bs, 24'h86_4CFB, .degree( 24 ) );
   endfunction: crc24_radix_64

   //-----------------------------------------------------------------------
   // Function: crc30
   //   (STATIC) Returns a CRC-30 value.
   //   The CRC polynomial is:
   //   (see crc30.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-30 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc30( bs ) == 30'h3FA4F577 );
   //-----------------------------------------------------------------------

   static function T[29:0] crc30( bs_type bs );

      // x^30 + x^29 + x^21 + x^20 + x^15 + x^13 + x^12 + x^11 + x^8 + x^7 +
      // x^6 + x^2 + x + 1
      //   110_0000_0011_0000
      // _1011_1001_1100_0111

      return crc( bs, 30'h2030_B9C7, .degree( 30 ) );
   endfunction: crc30

   //-----------------------------------------------------------------------
   // Function: crc32
   //   (STATIC) Returns a CRC-32 value.
   //   The CRC polynomial is:
   //   (see crc32.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-32 value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc32( bs ) == 32'h257491D0 );
   //-----------------------------------------------------------------------

   static function T[31:0] crc32( bs_type bs );

      // x^32 + x^26 + x^23 + x^22 + x^16 + x^12 + x^11 + x^10 + x^8 + x^7 +
      // x^5 + x^4 + x^2 + x + 1
      // 1_0000_0100_1100_0001
      //  _0001_1101_1011_0111

      return crc( bs, 32'h04C1_1DB7, .degree( 32 ) );
   endfunction: crc32

   //-----------------------------------------------------------------------
   // Function: crc32c
   //   (STATIC) Returns a CRC-32C (Castagnoli) value.
   //   The CRC polynomial is:
   //   (see crc32c.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-32C (Castagnoli) value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc32c( bs ) == 32'hC68BEAB1 );
   //-----------------------------------------------------------------------

   static function T[31:0] crc32c( bs_type bs );

      // x^32 + x^28 + x^27 + x^26 + x^25 + x^23 + x^22 + x^20 + x^19 + 
      // x^18 + x^14 + x^13 + x^11 + x^10 + x^9 + x^8 + x^6 + 1
      // 1_0001_1110_1101_1100
      //  _0110_1111_0100_0001

      return crc( bs, 32'h1EDC_6F41, .degree( 32 ) );
   endfunction: crc32c

   //-----------------------------------------------------------------------
   // Function: crc32k
   //   (STATIC) Returns a CRC-32K (Koopman) value.
   //   The CRC polynomial is:
   //   (see crc32k.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-32K (Koopman) value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc32k( bs ) == 32'hE9D7E7E8 );
   //-----------------------------------------------------------------------

   static function T[31:0] crc32k( bs_type bs );

      // x^32 + x^30 + x^29 + x^28 + x^26 + x^20 + x^19 + x^17 + x^16 + 
      // x^15 + x^11 + x^10 + x^7 + x^6 + x^4 + x^2 + x + 1
      // 1_0111_0100_0001_1011
      //  _1000_1100_1101_0111

      return crc( bs, 32'h741B_8CD7, .degree( 32 ) );
   endfunction: crc32k

   //-----------------------------------------------------------------------
   // Function: crc32q
   //   (STATIC) Returns a CRC-32Q value.
   //   The CRC polynomial is:
   //   (see crc32q.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-32Q value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc32q( bs ) == 32'hC604B994 );
   //-----------------------------------------------------------------------

   static function T[31:0] crc32q( bs_type bs );

      // x^32 + x^31 + x^24 + x^22 + x^16 + x^14 + x^8 + x^7 + x^5 + x^3 +
      // x + 1
      // 1_1000_0001_0100_0001
      //  _0100_0001_1010_1011
      
      return crc( bs, 32'h8141_41AB, .degree( 32 ) );
   endfunction: crc32q

   //-----------------------------------------------------------------------
   // Function: crc40_gsm
   //   (STATIC) Returns a CRC-40-GSM value.
   //   The CRC polynomial is:
   //   (see crc40_gsm.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-40-GSM value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc40_gsm( bs ) == 40'hAF3E6E680C );
   //-----------------------------------------------------------------------

   static function T[39:0] crc40_gsm( bs_type bs );

      // x^40 + x^26 + x^23 + x^17 + x^3 + 1
      //           1_0000_0000
      //  _0000_0100_1000_0010
      //  _0000_0000_0000_1001
      
      return crc( bs, 40'h00_0482_0009, .degree( 40 ) );
   endfunction: crc40_gsm

   //-----------------------------------------------------------------------
   // Function: crc64_ecma
   //   (STATIC) Returns a CRC-64-ECMA value.
   //   The CRC polynomial is:
   //   (see crc64_ecma.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-64-ECMA value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc64_ecma( bs ) == 64'h1AD51F768A8B4D1D );
   //-----------------------------------------------------------------------

   static function T[63:0] crc64_ecma( bs_type bs );

      // x^64 + x^62 + x^57 + x^55 + x^54 + x^53 + x^52 + x^47 + x^46 + 
      // x^45 + x^40 + x^39 + x^38 + x^37 + x^35 + x^33 + x^32 + x^31 + 
      // x^29 + x^27 + x^24 + x^23 + x^22 + x^21 + x^19 + x^17 + x^13 + 
      // x^12 + x^10 + x^9 + x^7 + x^4 + x + 1
      // 1_0100_0010_1111_0000
      //  _1110_0001_1110_1011
      //  _1010_1001_1110_1010
      //  _0011_0110_1001_0011
      
      return crc( bs, 64'h42F0_E1EB_A9EA_3693, .degree( 64 ) );
   endfunction: crc64_ecma

   //-----------------------------------------------------------------------
   // Function: crc64_iso
   //   (STATIC) Returns a CRC-64-ISO value.
   //   The CRC polynomial is:
   //   (see crc64_iso.png)
   //
   // Argument:
   //   bs - An input bit stream.
   //
   // Returns:
   //   A CRC-64-ISO value.
   //
   // Example:
   // | bit bs[];     // input order --------------------------------->
   // | bs = new[80]( '{ 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0,
   // |                  1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0 } );
   // | assert( crc#(bit)::crc64_iso( bs ) == 64'h41982B4D80015DEB );
   //-----------------------------------------------------------------------

   static function T[63:0] crc64_iso( bs_type bs );

      // x^64 + x^4 + x^3 + x + 1
      // 1_0000_0000_0000_0000
      //  _0000_0000_0000_0000
      //  _0000_0000_0000_0000
      //  _0000_0000_0001_1011
      
      return crc( bs, 64'h0000_0000_0000_001B, .degree( 64 ) );
   endfunction: crc64_iso

endclass: crc

`endif //  `ifndef CL_CRC_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
