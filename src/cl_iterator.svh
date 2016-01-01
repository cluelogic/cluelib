//==============================================================================
//
// cl_iterator.svh (v0.6.1)
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

`ifndef CL_ITERATOR_SVH
`define CL_ITERATOR_SVH

//------------------------------------------------------------------------------
// Class: iterator
//   (VIRTUAL) Defines a uniform way of accessing collection elements
//   sequentially.
//------------------------------------------------------------------------------

virtual class iterator #( type T = int );

   //---------------------------------------------------------------------------
   // Function: has_next
   //   (PURE) (VIRTUAL) Returns 1 if the iteration has more elements.
   //---------------------------------------------------------------------------

   pure virtual function bit has_next();

   //---------------------------------------------------------------------------
   // Function: next
   //   (PURE) (VIRTUAL) Returns the next element in the iteration.
   //---------------------------------------------------------------------------

   pure virtual function T next();

   //---------------------------------------------------------------------------
   // Function: remove
   //   (PURE) (VIRTUAL) Removes the last element returned by the iterator.
   //---------------------------------------------------------------------------

   pure virtual function void remove();

endclass: iterator

`endif //  `ifndef CL_ITERATOR_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
