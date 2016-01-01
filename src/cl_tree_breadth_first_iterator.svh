//==============================================================================
//
// cl_tree_breadth_first_iterator.svh (v0.6.1)
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

`ifndef CL_TREE_BREADTH_FIRST_ITERATOR_SVH
`define CL_TREE_BREADTH_FIRST_ITERATOR_SVH
`ifndef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS

typedef class tree;
typedef class tree_node;

//-----------------------------------------------------------------------------
// Class: tree_breadth_first_iterator
//   Provides a breadth-first iterator to a <tree>.
//
// Parameter:
//   T - (OPTIONAL) The type of data collected in a <tree>. The default is
//       *int*.
//-----------------------------------------------------------------------------

class tree_breadth_first_iterator #( type T = int ) extends iterator#( T );

   // Group: Types

   //---------------------------------------------------------------------------
   // Typedef: tree_node_type
   //   The shorthand of the <tree_node> type specialized with type *T*.
   //---------------------------------------------------------------------------

   typedef tree_node#(T) tree_node_type;

   //--------------------------------------------------------------------------
   // Typedef: tree_type
   //   The shorthand of the <tree> type specialized with type *T*.
   //--------------------------------------------------------------------------

   typedef tree#( T ) tree_type;

   local tree_node_type q[$];
   local int cur_index;

   //--------------------------------------------------------------------------
   // Function: new
   //   Creates a tree iterator.
   //
   // Argument:
   //   t - A tree to be iterated.
   //--------------------------------------------------------------------------

   function new( tree_type t );
      if ( t.root ) q.push_back( t.root );
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
      return cur_index < q.size();
   endfunction: has_next

   //--------------------------------------------------------------------------
   // Function: next
   //   (VIRTUAL) Returns the next element.
   //
   // Returns:
   //   The next element in the iterator.
   //--------------------------------------------------------------------------

   virtual function T next();
      tree_node_type tn = next_node();

      return tn.elem;
   endfunction: next

   //--------------------------------------------------------------------------
   // Function: next_node
   //   (VIRTUAL) Returns the next <tree_node>.
   //
   // Returns:
   //   The next tree node in the tree.
   //--------------------------------------------------------------------------

   virtual function tree_node_type next_node();
      tree_node_type tn = q[cur_index];

      if ( cur_index == 0 ) begin
	 tn.location.delete();
	 tn.location.push_back( 0 );
      end
      foreach ( tn.children[i] ) begin
	 tn.children[i].location = { tn.location, i }; // append the child ID
	 q.push_back( tn.children[i] );
      end
      cur_index++;

      return tn;
   endfunction: next_node

   //--------------------------------------------------------------------------
   // Function: remove
   //   (VIRTUAL) Removes the last element returned by the iterator. This
   //   function can be called once per call to <next> or <next_node>.
   //
   // Returns:
   //   None.
   //--------------------------------------------------------------------------

   virtual function void remove();
      q.delete( --cur_index ); // delete at the previous index
   endfunction: remove

endclass: tree_breadth_first_iterator

`endif //  `ifndef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
`endif //  `ifndef CL_TREE_BREADTH_FIRST_ITERATOR_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
