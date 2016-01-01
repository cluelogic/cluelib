//==============================================================================
// cl_tuple_comparator.svh (v0.6.1)
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

`ifndef CL_TUPLE_COMPARATOR_SVH
`define CL_TUPLE_COMPARATOR_SVH

typedef class tuple;

//------------------------------------------------------------------------------
// Class: tuple_comparator
//   (SINGLETON) Provides strategies to compare <tuples>.
//
// Parameter:
//   T - (OPTIONAL) The type of a tuple object to be compared. The default is
//       *tuple* (with its default parameters).
//------------------------------------------------------------------------------

class tuple_comparator#( type T = tuple ) extends comparator#(T);

   //---------------------------------------------------------------------------
   // Typedef: this_type
   //   The shorthand of <pair_comparator> *#(T)*.
   //---------------------------------------------------------------------------

   typedef tuple_comparator#(T) this_type;

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
   //   (VIRTUAL) Returns 1 if two tuples are equal.
   //
   // Arguments:
   //   x - A tuple.
   //   y - Another tuple.
   //
   // Returns:
   //   If *x.first* to *x.tenth* are equal to *y.first* to *y.tenth*
   //   respectively, then returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   virtual function bit eq( T x, T y );
      eq = x.first   == y.first   && 
	   x.second  == y.second  &&
	   x.third   == y.third   &&
	   x.fourth  == y.fourth  &&
	   x.fifth   == y.fifth   &&
	   x.sixth   == y.sixth   &&
	   x.seventh == y.seventh &&
	   x.eighth  == y.eighth  &&
	   x.ninth   == y.ninth   &&
	   x.tenth   == y.tenth;
   endfunction: eq

   //---------------------------------------------------------------------------
   // Function: lt
   //   (VIRTUAL) Returns 1 if *x* is less than *y*. Compares *x.first* and
   //   *y.first*. If equal, then compares *x.second* and *y.second*, and so on.
   //
   // Arguments:
   //   x - A tuple.
   //   y - Another tuple.
   //
   // Returns:
   //   Returns 1 if *x* is less than *y*. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   virtual function bit lt( T x, T y );
      if      ( x.first   < y.first   ) return 1;
      else if ( x.first   > y.first   ) return 0;
      else if ( x.second  < y.second  ) return 1; // x.first   == y.first
      else if ( x.second  > y.second  ) return 0;
      else if ( x.third   < y.third   ) return 1; // x.second  == y.second
      else if ( x.third   > y.third   ) return 0; 
      else if ( x.fourth  < y.fourth  ) return 1; // x.third   == y.third
      else if ( x.fourth  > y.fourth  ) return 0;
      else if ( x.fifth   < y.fifth   ) return 1; // x.fourth  == y.fourth
      else if ( x.fifth   > y.fifth   ) return 0;
      else if ( x.sixth   < y.sixth   ) return 1; // x.fifth   == y.fifth
      else if ( x.sixth   > y.sixth   ) return 0;
      else if ( x.seventh < y.seventh ) return 1; // x.sixth   == y.sixth
      else if ( x.seventh > y.seventh ) return 0;
      else if ( x.eighth  < y.eighth  ) return 1; // x.seventh == y.seventh
      else if ( x.eighth  > y.eighth  ) return 0;
      else if ( x.ninth   < y.ninth   ) return 1; // x.eighth  == y.eighth
      else if ( x.ninth   > y.ninth   ) return 0;
      else return x.tenth < y.tenth;              // x.ninth   == y.ninth
   endfunction: lt

endclass: tuple_comparator

`endif //  `ifndef CL_TUPLE_COMPARATOR_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
