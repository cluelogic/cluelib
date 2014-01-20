//==============================================================================
// cl_tuple.svh (v0.1.0)
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

`ifndef CL_TUPLE_SVH
`define CL_TUPLE_SVH

//------------------------------------------------------------------------------
// Class: tuple
//   Provides a tuple that carries up to ten values, which can be different
//   types. The default types are *int*.
//------------------------------------------------------------------------------

class tuple#( type T1 = int, 
	      type T2 = int,
	      type T3 = int,
	      type T4 = int,
	      type T5 = int,
	      type T6 = int,
	      type T7 = int,
	      type T8 = int,
	      type T9 = int,
	      type T10 = int );

   //---------------------------------------------------------------------------
   // Typedef: this_type
   //   The shorthand of tuple#(T1,T2,T3,T4,T5,T6,T7,T8,T9,T10)
   //---------------------------------------------------------------------------

   typedef tuple#(T1,T2,T3,T4,T5,T6,T7,T8,T9,T10) this_type;

   local comparator#(this_type) cmp;
   local static tuple_comparator#(this_type) default_cmp = new();

   //---------------------------------------------------------------------------
   // Property: first
   //   The first value inside the tuple.
   //---------------------------------------------------------------------------

   T1 first;

   //---------------------------------------------------------------------------
   // Property: second
   //   The second value inside the tuple.
   //---------------------------------------------------------------------------

   T2 second;

   //---------------------------------------------------------------------------
   // Property: third
   //   The third value inside the tuple.
   //---------------------------------------------------------------------------

   T3 third;

   //---------------------------------------------------------------------------
   // Property: fourth
   //   The fourth value inside the tuple.
   //---------------------------------------------------------------------------

   T4 fourth;

   //---------------------------------------------------------------------------
   // Property: fifth
   //   The fifth value inside the tuple.
   //---------------------------------------------------------------------------

   T5 fifth;

   //---------------------------------------------------------------------------
   // Property: sixth
   //   The sixth value inside the tuple.
   //---------------------------------------------------------------------------

   T6 sixth;

   //---------------------------------------------------------------------------
   // Property: seventh
   //   The seventh value inside the tuple.
   //---------------------------------------------------------------------------

   T7 seventh;

   //---------------------------------------------------------------------------
   // Property: eighth
   //   The eighth value inside the tuple.
   //---------------------------------------------------------------------------

   T8 eighth;

   //---------------------------------------------------------------------------
   // Property: ninth
   //   The ninth value inside the tuple.
   //---------------------------------------------------------------------------

   T9 ninth;

   //---------------------------------------------------------------------------
   // Property: tenth
   //   The tenth value inside the tuple.
   //---------------------------------------------------------------------------

   T10 tenth;

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a tuple of values of types T1, T2, and T3. Optionally a tuple
   //   can have up to ten values of different types.
   //
   // Arguments:
   //   first   - The first  value of the tuple.
   //   second  - The second value of the tuple.
   //   third   - The third  value of the tuple.
   //   fourth  - (OPTIONAL) The fourth  value of the tuple.
   //   fifth   - (OPTIONAL) The fifth   value of the tuple.
   //   sixth   - (OPTIONAL) The sixth   value of the tuple.
   //   seventh - (OPTIONAL) The seventh value of the tuple.
   //   eighth  - (OPTIONAL) The eighth  value of the tuple.
   //   ninth   - (OPTIONAL) The ninth   value of the tuple.
   //   tenth   - (OPTIONAL) The tenth   value of the tuple.
   //   cmp     - (OPTIONAL) Compare strategy. If not specified or null, 
   //             tuple_comparator#(this_type) is used. The default is null.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | tuple#(int, string, bit[7:0]) t = new( 1, "second", 8'h03 );
   //---------------------------------------------------------------------------

   function new( T1 first,
		 T2 second,
		 T3 third,
		 T4 fourth  = 0, 
		 T5 fifth   = 0, 
		 T6 sixth   = 0, 
		 T7 seventh = 0, 
		 T8 eighth  = 0, 
		 T9 ninth   = 0, 
		 T10 tenth  = 0, 
		 comparator#(this_type) cmp = null );
      this.first   = first;
      this.second  = second;
      this.third   = third;
      this.fourth  = fourth;
      this.fifth   = fifth;
      this.sixth   = sixth;
      this.seventh = seventh;
      this.eighth  = eighth;
      this.ninth   = ninth;
      this.tenth   = tenth;
      this.cmp     = cmp;
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: eq
   //   Returns 1 if this object is equal to the specified tuple. The comparison
   //   is done by the compare strategy object.
   //
   // Argument:
   //   t - A tuple to compare with.
   //
   // Returns:
   //   If this object is equal to *p*, then returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   function bit eq( this_type t );
      if ( cmp ) return cmp.eq( this, t );
      else       return default_cmp.eq( this, t );
   endfunction: eq

   // Operator overloading is not supported?
   // bind == function bit eq( this_type );

   //---------------------------------------------------------------------------
   // Function: ne
   //   Returns 1 if this object is not equal to the specified tuple. The
   //   comparison is done by the compare strategy object.
   //
   // Argument:
   //   t - A tuple to compare with.
   //
   // Returns:
   //   If this object is not equal to *p*, then returns 1. Otherwise, returns
   //   0.
   //---------------------------------------------------------------------------

   function bit ne( this_type t );
      if ( cmp ) return cmp.ne( this, t );
      else       return default_cmp.ne( this, t );
   endfunction: ne

   //---------------------------------------------------------------------------
   // Function: lt
   //   Returns 1 if this object is less than the specified tuple. The comparison
   //   is done by the compare strategy object.
   //
   // Argument:
   //   t - A tuple to compare with.
   //
   // Returns:
   //   If this object is less than *p*, then returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   function bit lt( this_type t );
      if ( cmp ) return cmp.lt( this, t );
      else       return default_cmp.lt( this, t );
   endfunction: lt

   //---------------------------------------------------------------------------
   // Function: gt
   //   Returns 1 if this object is greater than the specified tuple. The
   //   comparison is done by the compare strategy object.
   //
   // Argument:
   //   t - A tuple to compare with.
   //
   // Returns:
   //   If this object is greater than *p*, then returns 1. Otherwise, returns
   //   0.
   //---------------------------------------------------------------------------

   function bit gt( this_type t );
      if ( cmp ) return cmp.gt( this, t );
      else       return default_cmp.gt( this, t );
   endfunction: gt

   //---------------------------------------------------------------------------
   // Function: le
   //   Returns 1 if this object is less than or equal to the specified
   //   tuple. The comparison is done by the compare strategy object.
   //
   // Argument:
   //   t - A tuple to compare with.
   //
   // Returns:
   //   If this object is less than or equal to *p*, then returns 1. Otherwise,
   //   returns 0.
   //---------------------------------------------------------------------------

   function bit le( this_type t );
      if ( cmp ) return cmp.le( this, t );
      else       return default_cmp.le( this, t );
   endfunction: le

   //---------------------------------------------------------------------------
   // Function: ge
   //   Returns 1 if this object is greater than or equal to the specified
   //   tuple. The comparison is done by the compare strategy object.
   //
   // Argument:
   //   t - A tuple to compare with.
   //
   // Returns:
   //   If this object is greater than or equal to *p*, then returns
   //   1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   function bit ge( this_type t );
      if ( cmp ) return cmp.ge( this, t );
      else       return default_cmp.ge( this, t );
   endfunction: ge

   //---------------------------------------------------------------------------
   // Function: clone
   //   Creates a tuple by cloning this object.
   //
   // Returns:
   //   A cloned tuple.
   //---------------------------------------------------------------------------

   function this_type clone();
      clone = new( first, second, third, fourth, fifth, sixth, seventh, eighth, 
		   ninth, tenth, cmp );
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: swap
   //   Swaps the data of this object and the specified tuple.
   //
   // Argument:
   //   t - A tuple to swap.
   //---------------------------------------------------------------------------

   function void swap( this_type t );
      T1 e1;
      T2 e2;
      T3 e3;
      T4 e4;
      T5 e5;
      T6 e6;
      T7 e7;
      T8 e8;
      T9 e9;
      T10 e10;

      e1 = t.first;
      t.first = this.first;
      this.first = e1;

      e2 = t.second;
      t.second = this.second;
      this.second = e2;

      e3 = t.third;
      t.third = this.third;
      this.third = e3;

      e4 = t.fourth;
      t.fourth = this.fourth;
      this.fourth = e4;

      e5 = t.fifth;
      t.fifth = this.fifth;
      this.fifth = e5;

      e6 = t.sixth;
      t.sixth = this.sixth;
      this.sixth = e6;

      e7 = t.seventh;
      t.seventh = this.seventh;
      this.seventh = e7;

      e8 = t.eighth;
      t.eighth = this.eighth;
      this.eighth = e8;

      e9 = t.ninth;
      t.ninth = this.ninth;
      this.ninth = e9;

      e10 = t.tenth;
      t.tenth = this.tenth;
      this.tenth = e10;
   endfunction: swap

endclass: tuple

`endif //  `ifndef CL_TUPLE_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
