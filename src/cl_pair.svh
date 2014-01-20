//==============================================================================
// cl_pair.svh (v0.1.0)
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

`ifndef CL_PAIR_SVH
`define CL_PAIR_SVH

//------------------------------------------------------------------------------
// Class: pair
//   Provides a pair that carries two values, which can be different types.
//------------------------------------------------------------------------------

class pair#( type T1 = int, type T2 = T1 );

   //---------------------------------------------------------------------------
   // Typedef: this_type
   //   The shorthand of pair#(T1,T2).
   //---------------------------------------------------------------------------

   typedef pair#(T1,T2) this_type;

   local comparator#(this_type) cmp;
   local static pair_comparator#(this_type) default_cmp = new();

   //---------------------------------------------------------------------------
   // Property: first
   //   The first value inside the pair.
   //---------------------------------------------------------------------------

   T1 first;

   //---------------------------------------------------------------------------
   // Property: second
   //   The second value inside the pair.
   //---------------------------------------------------------------------------

   T2 second;

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a pair of values of types T1 and T2.
   //
   // Arguments:
   //   first  - The first value of the pair.
   //   second - The second value of the pair.
   //   cmp    - (OPTIONAL) Compare strategy. If not specified or null, 
   //            pair_comparator#(this_type) is used. The default is null.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | pair#(int, string) p = new( 1, "second" );
   //---------------------------------------------------------------------------

   function new( T1 first, T2 second, comparator#(this_type) cmp = null );
      this.first  = first;
      this.second = second;
      this.cmp    = cmp;
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: eq
   //   Returns 1 if this object is equal to the specified pair. The comparison
   //   is done by the compare strategy object.
   //
   // Argument:
   //   p - A pair to compare with.
   //
   // Returns:
   //   If this object is equal to *p*, then returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   function bit eq( this_type p );
      if ( cmp ) return cmp.eq( this, p );
      else       return default_cmp.eq( this, p );
   endfunction: eq

   // Operator overloading is not supported?
   // bind == function bit eq( this_type );

   //---------------------------------------------------------------------------
   // Function: ne
   //   Returns 1 if this object is not equal to the specified pair. The
   //   comparison is done by the compare strategy object.
   //
   // Argument:
   //   p - A pair to compare with.
   //
   // Returns:
   //   If this object is not equal to *p*, then returns 1. Otherwise, returns
   //   0.
   //---------------------------------------------------------------------------

   function bit ne( this_type p );
      if ( cmp ) return cmp.ne( this, p );
      else       return default_cmp.ne( this, p );
   endfunction: ne

   //---------------------------------------------------------------------------
   // Function: lt
   //   Returns 1 if this object is less than the specified pair. The comparison
   //   is done by the compare strategy object.
   //
   // Argument:
   //   p - A pair to compare with.
   //
   // Returns:
   //   If this object is less than *p*, then returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   function bit lt( this_type p );
      if ( cmp ) return cmp.lt( this, p );
      else       return default_cmp.lt( this, p );
   endfunction: lt

   //---------------------------------------------------------------------------
   // Function: gt
   //   Returns 1 if this object is greater than the specified pair. The
   //   comparison is done by the compare strategy object.
   //
   // Argument:
   //   p - A pair to compare with.
   //
   // Returns:
   //   If this object is greater than *p*, then returns 1. Otherwise, returns
   //   0.
   //---------------------------------------------------------------------------

   function bit gt( this_type p );
      if ( cmp ) return cmp.gt( this, p );
      else       return default_cmp.gt( this, p );
   endfunction: gt

   //---------------------------------------------------------------------------
   // Function: le
   //   Returns 1 if this object is less than or equal to the specified
   //   pair. The comparison is done by the compare strategy object.
   //
   // Argument:
   //   p - A pair to compare with.
   //
   // Returns:
   //   If this object is less than or equal to *p*, then returns 1. Otherwise,
   //   returns 0.
   //---------------------------------------------------------------------------

   function bit le( this_type p );
      if ( cmp ) return cmp.le( this, p );
      else       return default_cmp.le( this, p );
   endfunction: le

   //---------------------------------------------------------------------------
   // Function: ge
   //   Returns 1 if this object is greater than or equal to the specified
   //   pair. The comparison is done by the compare strategy object.
   //
   // Argument:
   //   p - A pair to compare with.
   //
   // Returns:
   //   If this object is greater than or equal to *p*, then returns
   //   1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   function bit ge( this_type p );
      if ( cmp ) return cmp.ge( this, p );
      else       return default_cmp.ge( this, p );
   endfunction: ge

   //---------------------------------------------------------------------------
   // Function: clone
   //   Creates a pair by cloning this object.
   //
   // Returns:
   //   A cloned pair.
   //---------------------------------------------------------------------------

   function this_type clone();
      clone = new( first, second, cmp );
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: swap
   //   Swaps the data of this object and the specified pair.
   //
   // Argument:
   //   p - A pair to swap.
   //---------------------------------------------------------------------------

   function void swap( this_type p );
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
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
