//==============================================================================
//
// cl_journal.svh (v0.2.0)
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

`ifndef CL_JOURNAL_SVH
`define CL_JOURNAL_SVH

//------------------------------------------------------------------------------
// Class: journal
//   (VIRTUAL) Provides a logging function to store transactions to a journal
//   file.
//------------------------------------------------------------------------------

virtual class journal;

   local static integer log_fid = $fopen( `CL_NAME_OF_LOG, "w" );
   local static integer csv_fid = $fopen( `CL_NAME_OF_CSV, "w" );

   //---------------------------------------------------------------------------
   // Function: log
   //   (STATIC) Stores a transaction to the file specified by the
   //   <CL_NAME_OF_LOG> macro using the following sequence format:
   //   *from_unit->to_unit:@timestamp desc*.
   //
   // Arguments:
   //   desc - The description of a transaction.
   //   from_unit - (OPTIONAL) The name of the unit a transaction comes
   //               from. The default name is "*journal*".
   //   to_unit - (OPTIONAL) The name of the unit a transaction goes to. The
   //             default name is the value of *from_unit*.
   //
   // Examples:
   // | journal::log( "request", "master", "slave" );
   // | #100;
   // | journal::log( "response", "slave", "master" );
   // |
   // | /* the log file */
   // | // master->slave: @0 request
   // | // slave->master: @100 response
   //---------------------------------------------------------------------------

   static function void log( string desc,
			     string from_unit = "journal",
			     string to_unit = from_unit );
      $fwrite( log_fid, "%s->%s: @%s %s\n",
	       from_unit, to_unit, com_fmtr.to_string( $time ), desc );
   endfunction: log

   //---------------------------------------------------------------------------
   // Function: csv
   //   (STATIC) Stores a transaction to the file specified by the
   //   <CL_NAME_OF_CSV> macro using the following CSV (comma separated value)
   //   format: *"from_unit","to_unit","@timestamp desc"*.
   //
   // Arguments:
   //   desc - The description of a transaction.
   //   from_unit - (OPTIONAL) The name of the unit a transaction comes
   //               from. The default name is "*journal*".
   //   to_unit - (OPTIONAL) The name of the unit a transaction goes to. The
   //             default name is the value of *from_unit*.
   //
   // Examples:
   // | journal::csv( "request", "master", "slave" );
   // | #100;
   // | journal::csv( "response", "slave", "master" );
   // |
   // | /* the CSV file */
   // | // "master","slave","@0 request"
   // | // "slave","master","@100 response"
   //---------------------------------------------------------------------------

   static function void csv( string desc,
			     string from_unit = "journal",
			     string to_unit = from_unit );
      $fwrite( csv_fid, "\"%s\",\"%s\",\"@%s %s\"\n",
	       from_unit, to_unit, com_fmtr.to_string( $time ), desc );
   endfunction: csv

endclass: journal

`endif //  `ifndef CL_JOURNAL_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
