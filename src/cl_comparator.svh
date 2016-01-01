//==============================================================================
// cl_comparator.svh (v0.6.1)
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

`ifndef CL_COMPARATOR_SVH
`define CL_COMPARATOR_SVH

//------------------------------------------------------------------------------
// Class: comparator
//   (SINGLETON) Provides strategies to compare objects.
//
// Parameter:
//   T - (OPTIONAL) The type of an object to be compared. The default is *int*.
//------------------------------------------------------------------------------

class comparator#( type T = int );

   //---------------------------------------------------------------------------
   // Typedef: this_type
   //   The shorthand of <comparator> *#(T)*.
   //---------------------------------------------------------------------------

   typedef comparator#(T) this_type;

   local static this_type inst = null; // needs to place after the typedef above

   //---------------------------------------------------------------------------
   // Function: new
   //   (PROTECTED) Creates a new comparator.
   //---------------------------------------------------------------------------

   protected function new();
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: get_instance
   //   (STATIC) Returns the singleton instance of this comparator.
   //
   // Returns:
   //   The singleton instance.
   //---------------------------------------------------------------------------

   static function this_type get_instance();
      if ( inst == null ) inst = new();
      return inst;
   endfunction: get_instance

   //---------------------------------------------------------------------------
   // Function: eq
   //   (VIRTUAL) Returns 1 if two inputs are equal. This function uses the
   //   logical equality operator (==) for the object comparison.
   //
   // Arguments:
   //   x - An input of type T.
   //   y - Another input of type T.
   //
   // Returns:
   //   If *x* is equal to *y*, then returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   virtual function bit eq( T x, T y );
      return x == y;
   endfunction: eq

   // Operator overloading is not supported?
   // bind == function bit eq( T x, T y );

   //---------------------------------------------------------------------------
   // Function: ne
   //   (VIRTUAL) Returns 1 if two inputs are not equal.
   //
   // Arguments:
   //   x - An input of type T.
   //   y - Another input of type T.
   //
   // Returns:
   //   This function returns the negated value of <eq> *(x,y)*.
   //---------------------------------------------------------------------------

   virtual function bit ne( T x, T y );
      return ! eq( x, y );
   endfunction: ne

   //---------------------------------------------------------------------------
   // Function: lt
   //   (VIRTUAL) Returns 1 if *x* is less than *y*.
   //
   // Arguments:
   //   x - An input of type T.
   //   y - Another input of type T.
   //
   // Returns:
   //   This function always returns 0. A subclass should implement this
   //   function if necessary.
   //---------------------------------------------------------------------------

   virtual function bit lt( T x, T y );

`ifdef CL_SUPPORT_FATAL_SEVERITY_TASK
      $fatal( 2, "lt() is not defined for %s", $typename( T ) );
`else
      $display( "lt() is not defined for %s", $typename( T ) );
      $finish( 2 );
`endif

      return 0; // dummy
   endfunction: lt

   //---------------------------------------------------------------------------
   // Function: gt
   //   (VIRTUAL) Returns 1 if *x* is greater than *y*.
   //
   // Arguments:
   //   x - An input of type T.
   //   y - Another input of type T.
   //
   // Returns:
   //   This function returns the value of <lt> *(y,x)*.
   //---------------------------------------------------------------------------

   virtual function bit gt( T x, T y );
      return lt( y, x ); // attention (y,x)
   endfunction: gt

   //---------------------------------------------------------------------------
   // Function: le
   //   (VIRTUAL) Returns 1 if *x* is less than or equal to *y*.
   //
   // Arguments:
   //   x - An input of type T.
   //   y - Another input of type T.
   //
   // Returns:
   //   This function returns the negated value of <gt> *(x,y)*.
   //---------------------------------------------------------------------------

   virtual function bit le( T x, T y );
      return ! gt( x, y );
   endfunction: le

   //---------------------------------------------------------------------------
   // Function: ge
   //   (VIRTUAL) Returns 1 if *x* is greater than or equal to *y*.
   //
   // Arguments:
   //   x - An input of type T.
   //   y - Another input of type T.
   //
   // Returns:
   //   This function returns the negated value of <lt> *(x,y)*.
   //---------------------------------------------------------------------------

   virtual function bit ge( T x, T y );
      return ! lt( x, y );
   endfunction: ge

endclass: comparator

`endif //  `ifndef CL_COMPARATOR_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
