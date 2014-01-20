//==============================================================================
//
// cl_formatter.svh (v0.1.0)
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

`ifndef CL_FORMATTER_SVH
`define CL_FORMATTER_SVH

//------------------------------------------------------------------------------
// Class: formatter
//   Provides a strategy to convert an object of type *T* into a string.
//------------------------------------------------------------------------------

class formatter #( type T = int );

   //---------------------------------------------------------------------------
   // Typedef: this_type
   //   The shorthand of formatter#(T).
   //---------------------------------------------------------------------------

   typedef formatter#(T) this_type;

   local static this_type inst = null;

   protected function new();
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: get_instance
   //   Returns a singleton instance of this formatter.
   //
   // Returns:
   //   A singleton instance.
   //---------------------------------------------------------------------------

   static function this_type get_instance();
      if ( inst == null ) inst = new();
      return inst;
   endfunction: get_instance

   //---------------------------------------------------------------------------
   // Function: to_string
   //   Returns a string representation of the given object of type *T*. This
   //   function should be overridden by extended classes.
   //
   // Argument:
   //   o - An object to convert to a string.
   //
   // Returns:
   //   *"<obj>"* is returned as a placeholder.
   //---------------------------------------------------------------------------

   virtual function string to_string( T o );
      return "<obj>";
   endfunction: to_string

endclass: formatter

`endif //  `ifndef CL_FORMATTER_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
