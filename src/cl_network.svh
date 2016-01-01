//==============================================================================
//
// cl_network.svh (v0.6.1)
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

`ifndef CL_NETWORK_SVH
`define CL_NETWORK_SVH

//------------------------------------------------------------------------------
// Class: network
//   (VIRTUAL) Provides a logging function to store network transactions in the
//   Wireshark hex format.
//------------------------------------------------------------------------------

virtual class network;

   //---------------------------------------------------------------------------
   // Property: fds
   //   The dynamic array of file descriptors. It is user's responsibility to
   //   open the file(s).
   //
   // Example:
   // | network::fds    = new[2];
   // | network::fds[0] = $fopen( "file0.hex", "w" );
   // | network::fds[1] = $fopen( "file1.hex", "w" );
   //---------------------------------------------------------------------------

   static integer fds[];

   //---------------------------------------------------------------------------
   // Function: dump
   //
   //   (STATIC) Stores a network transaction to the file specified by the *idx*
   //   using the Wireshark hex format. It is user's responsibility to open the
   //   file before calling this function.
   //
   // Arguments:
   //   desc - The description of a transaction.
   //   idx - (OPTIONAL) The index of the file descriptor array. The default
   //   index is 0.
   //
   // Example:
   // | network::fds    = new[2];
   // | network::fds[0] = $fopen( "file0.hex", "w" );
   // | network::fds[1] = $fopen( "file1.hex", "w" );
   // | network::dump( "000000 01 02 03 04" ); // dump to fds[0] (file0.hex)
   // | #100;
   // | network::dump( "000000 11 12 13 14", .idx( 1 ) ); // dump to fds[1] (file1.hex)
   // |
   // | /* file0.hex */
   // | // 0.
   // | // 000000 01 02 03 04
   // |
   // | /* file1.hex */
   // | // 100.
   // | // 000000 11 12 13 14
   //---------------------------------------------------------------------------

   static function void dump( string desc, int idx = 0 );
      time t = $time;
      $fwrite( fds[idx], "%0d.\n%s\n", t, desc );
   endfunction: dump

endclass: network

`endif //  `ifndef CL_NETWORK_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
