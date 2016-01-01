//==============================================================================
//
// cl_comma_formatter.svh (v0.6.1)
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

`ifndef CL_COMMA_FORMATTER_SVH
`define CL_COMMA_FORMATTER_SVH

//------------------------------------------------------------------------------
// Class: comma_formatter
//   (SINGLETON) Provides a strategy to convert an object of integral data types
//   such as *int* and *time* into a string using a decimal format that has
//   commas as thousands separators for better readability.
//
// Parameter:
//   T - (OPTIONAL) The type of an object to be converted. The default is *int*.
//------------------------------------------------------------------------------

class comma_formatter #( type T = int ) extends formatter#( T );

   //---------------------------------------------------------------------------
   // Typedef: this_type
   //   The shorthand of <comma_formatter> *#(T)*.
   //---------------------------------------------------------------------------

   typedef comma_formatter#(T) this_type;

   local static this_type inst = null;

   //---------------------------------------------------------------------------
   // Function: new
   //   (PROTECTED) Creates a new formatter.
   //---------------------------------------------------------------------------

   protected function new();
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: get_instance
   //   (STATIC) Returns the singleton instance of this formatter.
   //
   // Returns:
   //   The singleton instance.
   //---------------------------------------------------------------------------

   static function this_type get_instance();
      if ( inst == null ) inst = new();
      return inst;
   endfunction: get_instance

   //---------------------------------------------------------------------------
   // Function: to_string
   //   (VIRTUAL) Returns a string representation of the given object of type *T*.
   //
   // Argument:
   //   o - An object to convert to a string.
   //
   // Returns:
   //   A string representing *o*.
   //---------------------------------------------------------------------------

   virtual function string to_string( T o );
      int r;
      string s = "";
      
      if ( o < 0 ) return { "-", to_string( - o ) };
      while ( o >= 1000 ) begin
	 r = o % 1000;
	 o /= 1000;
	 s = { $sformatf( ",%03d", r ), s };
      end
      return { $sformatf( "%0d", o ), s };
   endfunction: to_string

endclass: comma_formatter

`endif //  `ifndef CL_COMMA_FORMATTER_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
