/*
 * 
 *///==============================================================================
//
// cl_list_iterator.svh (v0.1.0)
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

`ifndef CL_LIST_ITERATOR_SVH
`define CL_LIST_ITERATOR_SVH
`ifndef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS

typedef class list;

//------------------------------------------------------------------------------
// Class: list_iterator
//   Provides an iterator to a *list*.
//------------------------------------------------------------------------------

class list_iterator #( type T = int ) extends iterator#( T );

   typedef list#( T ) list_type;

   local list_type l;
   local int cur_index;
   local int q_size;

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a list iterator.
   //
   // Argument:
   //   l - A list to be iterated.
   //---------------------------------------------------------------------------

   function new( list_type l );
      this.l = l;
      q_size = l.q.size();
      cur_index = 0;
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: has_next
   //   Returns 1 if the iterator has more elements.
   //
   // Returns:
   //   If the iterator has more elements, returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   virtual function bit has_next();
      return cur_index < q_size;
   endfunction: has_next

   //---------------------------------------------------------------------------
   // Function: next
   //   Returns the next element.
   //
   // Returns:
   //   The next element in the iterator.
   //---------------------------------------------------------------------------

   virtual function T next();
      return l.q[cur_index++];
   endfunction: next

   //---------------------------------------------------------------------------
   // Function: remove
   //   Removes the last element returned by the iterator. This function can be
   //   called once per call to *next()*.
   //---------------------------------------------------------------------------

   virtual function void remove();
      l.q.delete( --cur_index ); // delete at the previous index
      q_size--;
   endfunction: remove

endclass: list_iterator

`endif //  `ifndef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
`endif //  `ifndef CL_LIST_ITERATOR_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
