//==============================================================================
//
// cl_set_iterator.svh (v0.1.0)
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

`ifndef CL_SET_ITERATOR_SVH
`define CL_SET_ITERATOR_SVH
`ifndef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS

typedef class set;

//-----------------------------------------------------------------------------
// Class: set_iterator
//   Provides an iterator to a *set*.
//-----------------------------------------------------------------------------

class set_iterator #( type T = int ) extends iterator#( T );

   typedef bit aa_type[T];
   typedef set#( T ) set_type;

   local set_type s;
   local T cur_key;
   local int cnt;
   local int aa_size;

   //--------------------------------------------------------------------------
   // Function: new
   //   Creates a set iterator.
   //
   // Argument:
   //   s - A set to be iterated.
   //--------------------------------------------------------------------------

   function new( set_type s );
      this.s = s;
      aa_size = s.aa.size();
      cnt = 0;
   endfunction: new

   //--------------------------------------------------------------------------
   // Function: has_next
   //   Returns 1 if the iterator has more elements.
   //
   // Returns:
   //   If the iterator has more elements, returns 1. Otherwise, returns 0.
   //--------------------------------------------------------------------------

   virtual function bit has_next();
      return cnt < aa_size;
   endfunction: has_next

   //--------------------------------------------------------------------------
   // Function: next
   //   Returns the next element.
   //
   // Returns:
   //   The next element in the iterator.
   //--------------------------------------------------------------------------

   virtual function T next();
      if ( cnt == 0 ) begin
	 assert( s.aa.first( cur_key ) == 1 ); // first() returns 0, 1, or -1
      end else begin
	 assert( s.aa.next( cur_key ) == 1 ); // next() returns 0, 1, or -1
      end
      cnt++;
      return cur_key;
   endfunction: next

   //--------------------------------------------------------------------------
   // Function: remove
   //   Removes the last element returned by the iterator. This function can be
   //   called once per call to *next()*.
   //--------------------------------------------------------------------------

   virtual function void remove();
      void'( s.aa.delete( cur_key ) );
   endfunction: remove

endclass: set_iterator

`endif //  `ifndef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
`endif //  `ifndef CL_SET_ITERATOR_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
