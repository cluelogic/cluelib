//==============================================================================
//
// cl_journal.svh (v0.1.0)
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
//   Provides the logging function of transactions.
//------------------------------------------------------------------------------

virtual class journal;

   local static integer fid = $fopen( `CL_NAME_OF_JOURNAL, "w" );

   //---------------------------------------------------------------------------
   // Function: log
   //   Logs a transaction to the journal file specified by the
   //   <CL_NAME_OF_JOURNAL> macro.
   //
   // Arguments:
   //   desc - The description of the transaction.
   //   from_unit - (OPTIONAL) The name of the unit the transaction comes
   //               from. The default name is "journal".
   //   to_unit - (OPTIONAL) The name of the unit the transaction goes to. The
   //             default name is the value of *from_unit*.
   //---------------------------------------------------------------------------

   static function void log( string desc,
			     string from_unit = "journal",
			     string to_unit = from_unit );
      $fwrite( fid, "%s->%s: @%s %s\n",
	       from_unit, to_unit, com_fmtr.to_string( $time ), desc );
   endfunction: log

endclass: journal

`endif //  `ifndef CL_JOURNAL_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
