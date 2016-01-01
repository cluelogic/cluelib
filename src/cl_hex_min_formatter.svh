//==============================================================================
//
// cl_hex_min_formatter.svh (v0.6.1)
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

`ifndef CL_HEX_MIN_FORMATTER_SVH
`define CL_HEX_MIN_FORMATTER_SVH

//------------------------------------------------------------------------------
// Class: hex_min_formatter
//   (SINGLETON) Provides a strategy to convert an object of type *T* to a
//   string using a hexadecimal format with the minimum width.
//
// Parameter:
//   T - (OPTIONAL) The type of an object to be converted. The default is *int*.
//------------------------------------------------------------------------------

class hex_min_formatter #( type T = int ) extends formatter#( T );

   //---------------------------------------------------------------------------
   // Typedef: this_type
   //   The shorthand of *hex_min_formatter#(T)*.
   //---------------------------------------------------------------------------

   typedef hex_min_formatter#(T) this_type;

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
   //   (VIRTUAL) Returns a string representation of the given object of type
   //   *T* using the *%0h* format string.
   //
   // Argument:
   //   o - An object to convert to a string.
   //
   // Returns:
   //   A string representing *o*.
   //---------------------------------------------------------------------------

   virtual function string to_string( T o );
      return $sformatf( "%0h", o );
   endfunction: to_string

endclass: hex_min_formatter

`endif //  `ifndef CL_HEX_MIN_FORMATTER_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
