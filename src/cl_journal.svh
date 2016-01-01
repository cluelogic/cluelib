//==============================================================================
//
// cl_journal.svh (v0.6.1)
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

`ifndef CL_JOURNAL_SVH
`define CL_JOURNAL_SVH

//------------------------------------------------------------------------------
// Class: journal
//   (VIRTUAL) Provides logging functions to store transactions to a log or a
//   CSV file.
//------------------------------------------------------------------------------

virtual class journal;

   //---------------------------------------------------------------------------
   // Property: log_fd
   //   The file descriptor for the log. It is user's responsibility to open the
   //   file before calling *log*.
   //---------------------------------------------------------------------------

   static integer log_fd;

   //---------------------------------------------------------------------------
   // Property: csv_fd
   //   The file descriptor for the CSV file. It is user's responsibility to
   //   open the file before calling *csv*.
   //---------------------------------------------------------------------------

   static integer csv_fd;

   //---------------------------------------------------------------------------
   // Function: log
   //   (STATIC) Stores a transaction to the file specified by the *log_fd*
   //   using the format shown in the Example below. It is user's responsibility
   //   to open the log file before calling this function.
   //
   // Arguments:
   //   desc - The description of a transaction.
   //   from_unit - (OPTIONAL) The name of the unit the transaction comes
   //               from. The default name is "*journal*".
   //   to_unit - (OPTIONAL) The name of the unit the transaction goes to. The
   //             default name is the value of *from_unit*.
   //
   // Example:
   // | journal::log_fd = $fopen( "journal.log", "w" );
   // | journal::log( "request", "master", "slave" );
   // | #100;
   // | journal::log( "response", "slave", "master" );
   // |
   // | /* journal.log */
   // | // master->slave: @0 request
   // | // slave->master: @100 response
   //---------------------------------------------------------------------------

   static function void log( string desc,
			     string from_unit = "journal",
			     string to_unit = from_unit );
      $fwrite( log_fd, "%s->%s: @%s %s\n",
	       from_unit, to_unit, com_fmtr.to_string( $time ), desc );
   endfunction: log

   //---------------------------------------------------------------------------
   // Function: csv
   //   (STATIC) Stores a transaction to the file specified by the *csv_fd*
   //   using the CSV (comma separated value) format shown in the Example
   //   below. It is user's responsibility to open the CSV file before calling
   //   this function.
   //
   // Arguments:
   //   desc - The description of a transaction.
   //   from_unit - (OPTIONAL) The name of the unit the transaction comes
   //               from. The default name is "*journal*".
   //   to_unit - (OPTIONAL) The name of the unit the transaction goes to. The
   //             default name is the value of *from_unit*.
   //
   // Example:
   // | journal::csv_fd = $fopen( "journal.csv", "w" );
   // | journal::csv( "request", "master", "slave" );
   // | #100;
   // | journal::csv( "response", "slave", "master" );
   // |
   // | /* journal.csv */
   // | // "master","slave","@0 request"
   // | // "slave","master","@100 response"
   //---------------------------------------------------------------------------

   static function void csv( string desc,
			     string from_unit = "journal",
			     string to_unit = from_unit );
      $fwrite( csv_fd, "\"%s\",\"%s\",\"@%s %s\"\n",
	       from_unit, to_unit, com_fmtr.to_string( $time ), desc );
   endfunction: csv

endclass: journal

`endif //  `ifndef CL_JOURNAL_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
