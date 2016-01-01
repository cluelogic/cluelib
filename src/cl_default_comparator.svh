//==============================================================================
// cl_default_comparator.svh (v0.6.1)
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

`ifndef CL_DEFAULT_COMPARATOR_SVH
`define CL_DEFAULT_COMPARATOR_SVH

//------------------------------------------------------------------------------
// Class: default_comparator
//   (SINGLETON) Provides the default strategies to compare objects.
//
// Parameter:
//   T - (OPTIONAL) The type of an object to be compared. The default is *int*.
//------------------------------------------------------------------------------

class default_comparator#( type T = int ) extends comparator#(T);

   //---------------------------------------------------------------------------
   // Function: lt
   //   (VIRTUAL) Returns 1 if *x* is less than *y*. Uses the binary relational
   //   operator (*<*) to compare the objects.
   //
   // Arguments:
   //   x - An input of type T.
   //   y - Another input of type T.
   //
   // Returns:
   //   The value of *x < y*.
   //---------------------------------------------------------------------------

   virtual function bit lt( T x, T y );
      return x < y;
   endfunction: lt

   //---------------------------------------------------------------------------
   // Function: gt
   //   (VIRTUAL) Returns 1 if *x* is greater than *y*. Uses the binary
   //   relational operator (*>*) to compare the objects.
   //
   // Arguments:
   //   x - An input of type T.
   //   y - Another input of type T.
   //
   // Returns:
   //   The value of *x > y*.
   //---------------------------------------------------------------------------

   virtual function bit gt( T x, T y );
      return x > y;
   endfunction: gt

endclass: default_comparator

`endif //  `ifndef CL_DEFAULT_COMPARATOR_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
