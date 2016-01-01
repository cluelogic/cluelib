//==============================================================================
//
// cl_route_breadth_first_iterator.svh (v0.6.1)
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

`ifndef CL_ROUTE_BREADTH_FIRST_ITERATOR_SVH
`define CL_ROUTE_BREADTH_FIRST_ITERATOR_SVH
`ifndef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS

typedef class route;
typedef class route_node;

//-----------------------------------------------------------------------------
// Class: route_breadth_first_iterator
//   Provides a breadth-first iterator to a <route>.
//
// Parameter:
//   T - (OPTIONAL) The type of data collected in a <route>. The default is
//       *int*.
//-----------------------------------------------------------------------------

class route_breadth_first_iterator #( type T = int ) extends iterator#( T );

   // Group: Types

   //---------------------------------------------------------------------------
   // Typedef: route_node_type
   //   The shorthand of the <route_node> type specialized with type *T*.
   //---------------------------------------------------------------------------

   typedef route_node#(T) route_node_type;

   //--------------------------------------------------------------------------
   // Typedef: route_type
   //   The shorthand of the <route> type specialized with type *T*.
   //--------------------------------------------------------------------------

   typedef route#( T ) route_type;

   local route_node_type q[$];
   local int cur_index;
   local bit visited[ route_node_type ];

   //--------------------------------------------------------------------------
   // Function: new
   //   Creates a route iterator.
   //
   // Argument:
   //   r - A route to be iterated.
   //--------------------------------------------------------------------------

   function new( route_type r );
      if ( r.start ) q.push_back( r.start );
      cur_index = 0;
      visited.delete();
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
      route_node_type rn = next_node();

      return rn.elem;
   endfunction: next

   //--------------------------------------------------------------------------
   // Function: next_node
   //   (VIRTUAL) Returns the next <route_node>.
   //
   // Returns:
   //   The next route node in the route.
   //--------------------------------------------------------------------------

   virtual function route_node_type next_node();
      route_node_type rn = q[cur_index];

      foreach ( rn.to_nodes[i] ) begin
	 if ( ! visited.exists( rn.to_nodes[i] ) ) begin
	    q.push_back( rn.to_nodes[i] );
	    visited[ rn.to_nodes[i] ] = 1;
	 end
      end
      cur_index++;

      return rn;
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

endclass: route_breadth_first_iterator

`endif //  `ifndef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
`endif //  `ifndef CL_ROUTE_BREADTH_FIRST_ITERATOR_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
