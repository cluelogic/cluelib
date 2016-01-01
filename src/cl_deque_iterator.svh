//==============================================================================
//
// cl_deque_iterator.svh (v0.6.1)
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

`ifndef CL_DEQUE_ITERATOR_SVH
`define CL_DEQUE_ITERATOR_SVH
`ifndef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS

typedef class deque;

//-----------------------------------------------------------------------------
// Class: deque_iterator
//   Provides an iterator to a <deque>.
//
// Parameter:
//   T - (OPTIONAL) The type of data collected in a <deque>. The default is
//       *int*.
//-----------------------------------------------------------------------------

class deque_iterator #( type T = int ) extends iterator#( T );

   local int cur_index;
   local int q_size;

   //--------------------------------------------------------------------------
   // Typedef: deque_type
   //   The shorthand of the <deque> type of type *T*.
   //--------------------------------------------------------------------------

   typedef deque#( T ) deque_type;

   local deque_type dq; // needs to place after the typedef above

   //--------------------------------------------------------------------------
   // Function: new
   //   Creates a deque iterator.
   //
   // Argument:
   //   dq - A deque to be iterated.
   //--------------------------------------------------------------------------

   function new( deque_type dq );
      this.dq = dq;
      q_size = dq.q.size();
      cur_index = 0;
   endfunction: new

   //--------------------------------------------------------------------------
   // Function: has_next
   //   (VIRTUAL) Returns 1 if the iterator has more elements.
   //
   // Returns:
   //   If the iterator has more elements, returns 1. Otherwise, returns 0.
   //--------------------------------------------------------------------------

   virtual function bit has_next();
      return cur_index < q_size;
   endfunction: has_next

   //--------------------------------------------------------------------------
   // Function: next
   //   (VIRTUAL) Returns the next element.
   //
   // Returns:
   //   The next element in the iterator.
   //--------------------------------------------------------------------------

   virtual function T next();
      return dq.q[cur_index++];
   endfunction: next

   //--------------------------------------------------------------------------
   // Function: remove
   //   (VIRTUAL) Removes the last element returned by the iterator. This
   //   function can be called once per call to <next>.
   //
   // Returns:
   //   None.
   //--------------------------------------------------------------------------

   virtual function void remove();
      dq.q.delete( --cur_index ); // delete at the previous index
      q_size--;
   endfunction: remove

endclass: deque_iterator

`endif //  `ifndef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
`endif //  `ifndef CL_DEQUE_ITERATOR_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
