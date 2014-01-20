//==============================================================================
//
// cl_bidir_iterator.svh (v0.1.0)
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
// ==============================================================================

`ifndef CL_BIDIR_ITERATOR_SVH
`define CL_BIDIR_ITERATOR_SVH

//------------------------------------------------------------------------------
// Class: bidir_iterator
//   Defines a uniform way of accessing collection elements sequentially in both
//   directions.
//------------------------------------------------------------------------------

virtual class bidir_iterator #( type T = int ) extends iterator#( T );

   //---------------------------------------------------------------------------
   // Function: add
   //   Adds the given element to the collection.
   //---------------------------------------------------------------------------

   pure virtual function void add( T e );

   //---------------------------------------------------------------------------
   // Function: has_previous
   //   Returns 1 if the iteration has more elements in the reverse direction.
   //---------------------------------------------------------------------------

   pure virtual function bit has_previous();

   //---------------------------------------------------------------------------
   // Function: next_index
   //   Returns the index of the element that would be returned by a subsequence
   //   call to *next()*.
   //---------------------------------------------------------------------------

   pure virtual function int next_index();

   //---------------------------------------------------------------------------
   // Function: previous
   //   Returns the previous element in the iteration.
   //---------------------------------------------------------------------------

   pure virtual function T previous();

   //---------------------------------------------------------------------------
   // Function: previous_index
   //   Returns the index of the element that would be returned by a subsequence
   //   call to *previous()*.
   //---------------------------------------------------------------------------

   pure virtual function int previous_index();

   //---------------------------------------------------------------------------
   // Function: set
   //   Replaces the last element returned by *next()* or *previous()* with the
   //   given element.
   //---------------------------------------------------------------------------

   pure virtual function void set( T e );

endclass: bidir_iterator

`endif //  `ifndef CL_BIDIR_ITERATOR_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
