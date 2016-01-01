//==============================================================================
// cl_pair.svh (v0.6.1)
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

`ifndef CL_PAIR_SVH
`define CL_PAIR_SVH

//------------------------------------------------------------------------------
// Class: pair
//   Provides a pair that carries two values, which can be different types.
//
// Parameters:
//   T1 - (OPTIONAL) The type of the first value of a pair. The default is
//        *int*.
//   T2 - (OPTIONAL) The type of the second value of a pair. The default is the
//        same type as *T1*.
//------------------------------------------------------------------------------

class pair#( type T1 = int, type T2 = T1 );

   //---------------------------------------------------------------------------
   // Typedef: this_type
   //   The shorthand of *pair#(T1,T2)*.
   //---------------------------------------------------------------------------

   typedef pair#(T1,T2) this_type;

   local comparator#(this_type) cmp;

   //---------------------------------------------------------------------------
   // Property: first
   //   The first value inside the pair.
   //
   // Example:
   // | pair#(int, string) p = new( 1, "apple" );
   // | assert( p.first == 1 );
   //---------------------------------------------------------------------------

   T1 first;

   //---------------------------------------------------------------------------
   // Property: second
   //   The second value inside the pair.
   //
   // Example:
   // | pair#(int, string) p = new( 1, "apple" );
   // | assert( p.second == "apple" );
   //---------------------------------------------------------------------------

   T2 second;

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a pair of values of types T1 and T2.
   //
   // Arguments:
   //   first  - The first value of a pair.
   //   second - The second value of a pair.
   //   cmp - (OPTIONAL) A strategy object used to compare two pairs. If not
   //         specified or *null*, <pair_comparator> *#(this_type)* is used. The
   //         default is *null*.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | pair#(int, string) p = new( 1, "apple" );
   //---------------------------------------------------------------------------

   function new( T1 first, T2 second, comparator#(this_type) cmp = null );
      this.first  = first;
      this.second = second;
      if ( cmp ) this.cmp = cmp;
      else       this.cmp = pair_comparator#(this_type)::get_instance();
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: eq
   //   Returns 1 if this object is equal to the specified pair. The comparison
   //   is done by the strategy object specified at the object construction.
   //
   // Argument:
   //   p - A pair to compare with.
   //
   // Returns:
   //   If this object is equal to *p*, then returns 1. Otherwise, returns 0.
   //
   // Example:
   // | pair#(int, string) p = new( 1, "apple" );
   // | pair#(int, string) q = new( 1, "apple" );
   // | assert( p.eq( q ) == 1 ); // 1 == 1 && "apple" == "apple"
   //---------------------------------------------------------------------------

   function bit eq( const ref this_type p );
      return cmp.eq( this, p );
   endfunction: eq

   // Operator overloading is not supported?
   // bind == function bit eq( this_type );

   //---------------------------------------------------------------------------
   // Function: ne
   //   Returns 1 if this object is not equal to the specified pair. The
   //   comparison is done by the strategy object specified at the object
   //   construction.
   //
   // Argument:
   //   p - A pair to compare with.
   //
   // Returns:
   //   If this object is not equal to *p*, then returns 1. Otherwise, returns
   //   0.
   //
   // Example:
   // | pair#(int, string) p = new( 1, "apple" );
   // | pair#(int, string) q = new( 1, "orange" );
   // | assert( p.ne( q ) == 1 ); // "apple" != "orange"
   //---------------------------------------------------------------------------

   function bit ne( const ref this_type p );
      return cmp.ne( this, p );
   endfunction: ne

   //---------------------------------------------------------------------------
   // Function: lt
   //   Returns 1 if this object is less than the specified pair. The comparison
   //   is done by the strategy object specified at the object construction.
   //
   // Argument:
   //   p - A pair to compare with.
   //
   // Returns:
   //   If this object is less than *p*, then returns 1. Otherwise, returns 0.
   //
   // Example:
   // | pair#(int, string) p = new( 1, "apple" );
   // | pair#(int, string) q = new( 2, "apple" );
   // | assert( p.lt( q ) == 1 ); // 1 < 2
   //---------------------------------------------------------------------------

   function bit lt( const ref this_type p );
      return cmp.lt( this, p );
   endfunction: lt

   //---------------------------------------------------------------------------
   // Function: gt
   //   Returns 1 if this object is greater than the specified pair. The
   //   comparison is done by the strategy object specified at the object
   //   construction.
   //
   // Argument:
   //   p - A pair to compare with.
   //
   // Returns:
   //   If this object is greater than *p*, then returns 1. Otherwise, returns
   //   0.
   //
   // Example:
   // | pair#(int, string) p = new( 1, "orange" );
   // | pair#(int, string) q = new( 1, "apple" );
   // | assert( p.gt( q ) == 1 ); // "orange" > "apple" by the lexicographical order
   //---------------------------------------------------------------------------

   function bit gt( const ref this_type p );
      return cmp.gt( this, p );
   endfunction: gt

   //---------------------------------------------------------------------------
   // Function: le
   //   Returns 1 if this object is less than or equal to the specified
   //   pair. The comparison is done by the strategy object specified at the
   //   object construction.
   //
   // Argument:
   //   p - A pair to compare with.
   //
   // Returns:
   //   If this object is less than or equal to *p*, then returns 1. Otherwise,
   //   returns 0.
   //
   // Example:
   // | pair#(int, string) p = new( 1, "apple" );
   // | pair#(int, string) q = new( 1, "orange" );
   // | assert( p.le( q ) == 1 ); // "apple" < "orange" by the lexicographical order
   //---------------------------------------------------------------------------

   function bit le( const ref this_type p );
      return cmp.le( this, p );
   endfunction: le

   //---------------------------------------------------------------------------
   // Function: ge
   //   Returns 1 if this object is greater than or equal to the specified
   //   pair. The comparison is done by the strategy object specified at the
   //   object construction.
   //
   // Argument:
   //   p - A pair to compare with.
   //
   // Returns:
   //   If this object is greater than or equal to *p*, then returns
   //   1. Otherwise, returns 0.
   //
   // Example:
   // | pair#(int, string) p = new( 2, "apple" );
   // | pair#(int, string) q = new( 1, "orange" );
   // | assert( p.ge( q ) == 1 ); // 2 > 1
   //---------------------------------------------------------------------------

   function bit ge( const ref this_type p );
      return cmp.ge( this, p );
   endfunction: ge

   //---------------------------------------------------------------------------
   // Function: clone
   //   Creates a pair by cloning this object.
   //
   // Returns:
   //   A cloned pair.
   //
   // Example:
   // | pair#(int, string) p = new( 1, "apple" );
   // | pair#(int, string) q = p.clone();
   // | assert( p.eq( q ) == 1 );
   //---------------------------------------------------------------------------

   function this_type clone();
      clone = new( first, second, cmp );
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: swap
   //   Swaps the contents of this pair with the ones of the specified pair.
   //
   // Argument:
   //   p - A pair to swap the contents.
   //
   // Example:
   // | pair#(int, string) p = new( 1, "apple" );
   // | pair#(int, string) q = new( 2, "orange" );
   // | p.swap( q );
   // | assert( p.first == 2 );
   // | assert( q.first == 1 );
   // | assert( p.second == "orange" );
   // | assert( q.second == "apple" );
   //---------------------------------------------------------------------------

   function void swap( ref this_type p );
      T1 f;
      T2 s;

      f = p.first;
      p.first = this.first;
      this.first = f;

      s = p.second;
      p.second = this.second;
      this.second = s;
   endfunction: swap

endclass: pair

`endif //  `ifndef CL_PAIR_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
