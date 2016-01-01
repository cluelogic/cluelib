//==============================================================================
// cl_pair_comparator.svh (v0.6.1)
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

`ifndef CL_PAIR_COMPARATOR_SVH
`define CL_PAIR_COMPARATOR_SVH

typedef class pair;

//------------------------------------------------------------------------------
// Class: pair_comparator
//   (SINGLETON) Provides strategies to compare <pairs>.
//
// Parameter:
//   T - (OPTIONAL) The type of a pair object to be compared. The default is
//       *pair* (with its default parameters).
//------------------------------------------------------------------------------

class pair_comparator#( type T = pair ) extends comparator#(T);

   //---------------------------------------------------------------------------
   // Typedef: this_type
   //   The shorthand of <pair_comparator> *#(T)*.
   //---------------------------------------------------------------------------

   typedef pair_comparator#(T) this_type;

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
   //   (VIRTUAL) Returns 1 if two pairs are equal.
   //
   // Arguments:
   //   x - A pair.
   //   y - Another pair.
   //
   // Returns:
   //   If *x.first* is equal to *y.first* and *x.second* is equal to
   //   *y.second*, then returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   virtual function bit eq( T x, T y );
      return x.first == y.first && x.second == y.second;
   endfunction: eq

   //---------------------------------------------------------------------------
   // Function: lt
   //   (VIRTUAL) Returns 1 if *x* is less than *y*. Compares *x.first* and
   //   *y.first*. If equal, then compares *x.second* and *y.second*.
   //
   // Arguments:
   //   x - A pair.
   //   y - Another pair.
   //
   // Returns:
   //   Returns 1 if *x* is less than *y*. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   virtual function bit lt( T x, T y );
      if ( x.first < y.first ) return 1;
      else if ( x.first > y.first ) return 0;
      else return x.second < y.second;
   endfunction: lt

endclass: pair_comparator

`endif //  `ifndef CL_PAIR_COMPARATOR_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
