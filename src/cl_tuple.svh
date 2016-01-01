//==============================================================================
// cl_tuple.svh (v0.6.1)
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

`ifndef CL_TUPLE_SVH
`define CL_TUPLE_SVH

//------------------------------------------------------------------------------
// Class: tuple
//   Provides a tuple that carries up to ten values, which can be different
//   types.
//
// Parameters:
//   T1 - (OPTIONAL) The type of the first value of a tuple. The default is
//        *int*.
//   T2 - (OPTIONAL) The type of the second value of a tuple. The default is
//        *int*.
//   T3 - (OPTIONAL) The type of the third value of a tuple. The default is
//        *int*.
//   T4 - (OPTIONAL) The type of the fourth value of a tuple. The default is
//        *int*.
//   T5 - (OPTIONAL) The type of the fifth value of a tuple. The default is
//        *int*.
//   T6 - (OPTIONAL) The type of the sixth value of a tuple. The default is 
//        *int*.
//   T7 - (OPTIONAL) The type of the seventh value of a tuple. The default is
//        *int*.
//   T8 - (OPTIONAL) The type of the eighth value of a tuple. The default is
//        *int*.
//   T9 - (OPTIONAL) The type of the ninth value of a tuple. The default is
//        *int*.
//   T10 - (OPTIONAL) The type of the tenth value of a tuple. The default is
//         *int*.
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

   // In order to assign the default values to the "fourth" to the "tenth" of
   // the new(), "int" is used for T4 to T10, instead of using T1 as their
   // default types.

   //---------------------------------------------------------------------------
   // Typedef: this_type
   //   The shorthand of *tuple#(T1,T2,T3,T4,T5,T6,T7,T8,T9,T10)*
   //---------------------------------------------------------------------------

   typedef tuple#(T1,T2,T3,T4,T5,T6,T7,T8,T9,T10) this_type;

   local comparator#(this_type) cmp;

   //---------------------------------------------------------------------------
   // Property: first
   //   The first value inside the tuple.
   //
   // Example:
   // | tuple#(int,string,bit[7:0]) t = new( 1, "apple", 8'hFF );
   // | assert( t.first == 1 );
   //---------------------------------------------------------------------------

   T1 first;

   //---------------------------------------------------------------------------
   // Property: second
   //   The second value inside the tuple.
   //
   // Example:
   // | tuple#(int,string,bit[7:0]) t = new( 1, "apple", 8'hFF );
   // | assert( t.second == "apple" );
   //---------------------------------------------------------------------------

   T2 second;

   //---------------------------------------------------------------------------
   // Property: third
   //   The third value inside the tuple.
   //
   // Example:
   // | tuple#(int,string,bit[7:0]) t = new( 1, "apple", 8'hFF );
   // | assert( t.third == 8'hFF );
   //---------------------------------------------------------------------------

   T3 third;

   //---------------------------------------------------------------------------
   // Property: fourth
   //   The fourth value inside the tuple.
   //
   // Example:
   // | tuple#() t = new( 1, 2, 3, 4 );
   // | assert( t.fourth == 4 );
   //---------------------------------------------------------------------------

   T4 fourth;

   //---------------------------------------------------------------------------
   // Property: fifth
   //   The fifth value inside the tuple.
   //
   // Example:
   // | tuple#() t = new( 1, 2, 3, 4, 5 );
   // | assert( t.fifth == 5 );
   //---------------------------------------------------------------------------

   T5 fifth;

   //---------------------------------------------------------------------------
   // Property: sixth
   //   The sixth value inside the tuple.
   //
   // Example:
   // | tuple#() t = new( 1, 2, 3, 4, 5, 6 );
   // | assert( t.sixth == 6 );
   //---------------------------------------------------------------------------

   T6 sixth;

   //---------------------------------------------------------------------------
   // Property: seventh
   //   The seventh value inside the tuple.
   //
   // Example:
   // | tuple#() t = new( 1, 2, 3, 4, 5, 6, 7 );
   // | assert( t.seventh == 7 );
   //---------------------------------------------------------------------------

   T7 seventh;

   //---------------------------------------------------------------------------
   // Property: eighth
   //   The eighth value inside the tuple.
   //
   // Example:
   // | tuple#() t = new( 1, 2, 3, 4, 5, 6, 7, 8 );
   // | assert( t.eighth == 8 );
   //---------------------------------------------------------------------------

   T8 eighth;

   //---------------------------------------------------------------------------
   // Property: ninth
   //   The ninth value inside the tuple.
   //
   // Example:
   // | tuple#() t = new( 1, 2, 3, 4, 5, 6, 7, 8, 9 );
   // | assert( t.ninth == 9 );
   //---------------------------------------------------------------------------

   T9 ninth;

   //---------------------------------------------------------------------------
   // Property: tenth
   //   The tenth value inside the tuple.
   //
   // Example:
   // | tuple#() t = new( 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 );
   // | assert( t.tenth == 10 );
   //---------------------------------------------------------------------------

   T10 tenth;

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a tuple of values of types T1, T2, and T3. Optionally, a tuple
   //   can have up to ten values of different types.
   //
   // Arguments:
   //   first   - The first  value of a tuple.
   //   second  - The second value of a tuple.
   //   third   - The third  value of a tuple.
   //   fourth  - (OPTIONAL) The fourth  value of a tuple.
   //   fifth   - (OPTIONAL) The fifth   value of a tuple.
   //   sixth   - (OPTIONAL) The sixth   value of a tuple.
   //   seventh - (OPTIONAL) The seventh value of a tuple.
   //   eighth  - (OPTIONAL) The eighth  value of a tuple.
   //   ninth   - (OPTIONAL) The ninth   value of a tuple.
   //   tenth   - (OPTIONAL) The tenth   value of a tuple.
   //   cmp - (OPTIONAL) A strategy object used to compare two tuples. If not
   //         specified or *null*, <tuple_comparator> *#(this_type)* is
   //         used. The default is *null*.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | tuple#(int, string, bit[7:0]) t = new( 1, "apple", 8'hFF );
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
      if ( cmp ) this.cmp = cmp;
      else       this.cmp = tuple_comparator#(this_type)::get_instance();
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: eq
   //   Returns 1 if this object is equal to the specified tuple. The comparison
   //   is done by the strategy object specified at the object construction.
   //
   // Argument:
   //   t - A tuple to compare with.
   //
   // Returns:
   //   If this object is equal to *t*, then returns 1. Otherwise, returns 0.
   //
   // Example:
   // | tuple#(int, string, bit[7:0]) t = new( 1, "apple", 8'hFF );
   // | tuple#(int, string, bit[7:0]) u = new( 1, "apple", 8'hFF );
   // | assert( t.eq( u ) == 1 ); // 1 == 1 && "apple" == "apple" && 8'hFF == 8'hFF
   //---------------------------------------------------------------------------

   function bit eq( const ref this_type t );
      return cmp.eq( this, t );
   endfunction: eq

   // Operator overloading is not supported?
   // bind == function bit eq( this_type );

   //---------------------------------------------------------------------------
   // Function: ne
   //   Returns 1 if this object is not equal to the specified tuple. The
   //   comparison is done by the strategy object specified at the object
   //   construction.
   //
   // Argument:
   //   t - A tuple to compare with.
   //
   // Returns:
   //   If this object is not equal to *t*, then returns 1. Otherwise, returns
   //   0.
   //
   // Example:
   // | tuple#(int, string, bit[7:0]) t = new( 1, "apple",  8'hFF );
   // | tuple#(int, string, bit[7:0]) u = new( 1, "orange", 8'hFF );
   // | assert( t.ne( u ) == 1 ); // "apple" != "orange"
   //---------------------------------------------------------------------------

   function bit ne( const ref this_type t );
      return cmp.ne( this, t );
   endfunction: ne

   //---------------------------------------------------------------------------
   // Function: lt
   //   Returns 1 if this object is less than the specified tuple. The
   //   comparison is done by the strategy object specified at the object
   //   construction.
   //
   // Argument:
   //   t - A tuple to compare with.
   //
   // Returns:
   //   If this object is less than *t*, then returns 1. Otherwise, returns 0.
   //
   // Example:
   // | tuple#(int, string, bit[7:0]) t = new( 1, "apple", 8'hFF );
   // | tuple#(int, string, bit[7:0]) u = new( 2, "apple", 8'hFF );
   // | assert( t.lt( u ) == 1 ); // 1 < 2
   //---------------------------------------------------------------------------

   function bit lt( const ref this_type t );
      return cmp.lt( this, t );
   endfunction: lt

   //---------------------------------------------------------------------------
   // Function: gt
   //   Returns 1 if this object is greater than the specified tuple. The
   //   comparison is done by the strategy object specified at the object
   //   construction.
   //
   // Argument:
   //   t - A tuple to compare with.
   //
   // Returns:
   //   If this object is greater than *t*, then returns 1. Otherwise, returns
   //   0.
   //
   // Example:
   // | tuple#(int, string, bit[7:0]) t = new( 1, "orange", 8'hFF );
   // | tuple#(int, string, bit[7:0]) u = new( 1, "apple",  8'hFF );
   // | assert( t.gt( u ) == 1 ); // "orange" > "apple" by the lexicographical order
   //---------------------------------------------------------------------------

   function bit gt( const ref this_type t );
      return cmp.gt( this, t );
   endfunction: gt

   //---------------------------------------------------------------------------
   // Function: le
   //   Returns 1 if this object is less than or equal to the specified
   //   tuple. The comparison is done by the strategy object specified at the
   //   object construction.
   //
   // Argument:
   //   t - A tuple to compare with.
   //
   // Returns:
   //   If this object is less than or equal to *t*, then returns 1. Otherwise,
   //   returns 0.
   //
   // Example:
   // | tuple#(int, string, bit[7:0]) t = new( 1, "apple",  8'hFF );
   // | tuple#(int, string, bit[7:0]) u = new( 1, "orange", 8'hFF );
   // | assert( t.le( u ) == 1 ); // "apple" < "orange" by the lexicographical order
   //---------------------------------------------------------------------------

   function bit le( const ref this_type t );
      return cmp.le( this, t );
   endfunction: le

   //---------------------------------------------------------------------------
   // Function: ge
   //   Returns 1 if this object is greater than or equal to the specified
   //   tuple. The comparison is done by the strategy object specified at the
   //   object construction.
   //
   // Argument:
   //   t - A tuple to compare with.
   //
   // Returns:
   //   If this object is greater than or equal to *t*, then returns
   //   1. Otherwise, returns 0.
   //
   // Example:
   // | tuple#(int, string, bit[7:0]) t = new( 2, "apple",  8'hFF );
   // | tuple#(int, string, bit[7:0]) u = new( 1, "orange", 8'hFF );
   // | assert( t.ge( u ) == 1 ); // 2 > 1
   //---------------------------------------------------------------------------

   function bit ge( const ref this_type t );
      return cmp.ge( this, t );
   endfunction: ge

   //---------------------------------------------------------------------------
   // Function: clone
   //   Creates a tuple by cloning this object.
   //
   // Returns:
   //   A cloned tuple.
   //
   // Example:
   // | tuple#(int, string, bit[7:0]) t = new( 1, "apple",  8'hFF );
   // | tuple#(int, string, bit[7:0]) u = t.clone();
   // | assert( t.eq( u ) == 1 );
   //---------------------------------------------------------------------------

   function this_type clone();
      clone = new( first, second, third, fourth, fifth, sixth, seventh, eighth, 
		   ninth, tenth, cmp );
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: swap
   //   Swaps the contents of this tuple with the ones of the specified tuple.
   //
   // Argument:
   //   t - A tuple to swap the contents.
   //
   // Example:
   // | tuple#(int, string, bit[7:0]) t = new( 1, "apple",  8'hFF );
   // | tuple#(int, string, bit[7:0]) u = new( 2, "orange", 8'hAA );
   // | t.swap( u );
   // | assert( t.first == 2 );
   // | assert( u.first == 1 );
   // | assert( t.second == "orange" );
   // | assert( u.second == "apple" );
   // | assert( t.third == 8'hAA );
   // | assert( u.third == 8'hFF );
   //---------------------------------------------------------------------------

   function void swap( ref this_type t );
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
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
