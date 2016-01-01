//==============================================================================
//
// cl_route_node.svh (v0.6.1)
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

`ifndef CL_ROUTE_NODE_SVH
`define CL_ROUTE_NODE_SVH

//------------------------------------------------------------------------------
// Class: route_node
//   Implements a node of a <route>.
//
// Parameter:
//   T - (OPTIONAL) The type of data collected in a route_node. The
//       default is *int*.
//------------------------------------------------------------------------------

class route_node #( type T = int );

   // Group: Types

   //---------------------------------------------------------------------------
   // Typedef: route_node_type
   //   The shorthand of the route node type specialized with type *T*.
   //---------------------------------------------------------------------------

   typedef route_node#(T) route_node_type;
   
   // Group: Properties

   //---------------------------------------------------------------------------
   // Property: id
   //   The globally unique ID of this node.
   //---------------------------------------------------------------------------

   int id;

   local static int serial_num = 0;

   //---------------------------------------------------------------------------
   // Property: elem
   //   The element stored at this route node.
   //---------------------------------------------------------------------------

   T elem;

   //---------------------------------------------------------------------------
   // Property: from_nodes
   //   The nodes this node is connected from.
   //
   //   (start diagram)
   //   +---------------+    +-----------+
   //   | from_nodes[0] |--->|           |
   //   +---------------+    |           |
   //   +---------------+    |           |
   //   | from_nodes[1] |--->| this node |
   //   +---------------+    |           |
   //   +---------------+    |           |
   //   | from_nodes[2] |--->|           |
   //   +---------------+    +-----------+ 
   //   (end diagram)
   //---------------------------------------------------------------------------

   route_node_type from_nodes[$];
   
   //---------------------------------------------------------------------------
   // Property: to_nodes
   //   The nodes this node is connected to.
   //
   //   (start diagram)
   //   +-----------+    +-------------+
   //   |           |--->| to_nodes[0] |
   //   |           |    +-------------+
   //   |           |    +-------------+
   //   | this node |--->| to_nodes[1] |
   //   |           |    +-------------+
   //   |           |    +-------------+
   //   |           |--->| to_nodes[2] |
   //   +-----------+    +-------------+           
   //   (end diagram)
   //---------------------------------------------------------------------------

   route_node_type to_nodes[$];
   
   //---------------------------------------------------------------------------
   // Property: relatives
   //   The route nodes this route node is related to. Usage of this property is
   //   up to the user.
   //---------------------------------------------------------------------------

   route_node_type relatives[$];
   
   // Group: Functions

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new route node.
   //
   // Argument:
   //   elem - Data element stored at the route node.
   //
   // Example:
   // | int i = 123;
   // | route_node#(int) rn = new( i );
   //---------------------------------------------------------------------------

   function new( T elem );
      this.elem = elem;
      id = serial_num++;
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: add
   //   (VIRTUAL) Creates a route node of the given element and adds it
   //   as a new <to_nodes>.
   //
   // Argument:
   //   e - An element to be added.
   //
   // Returns:
   //   Newly added route node.
   //
   // Example:
   // | route_node#(int) rn;
   // | route_node#(int) rn_123 = new( 123 );
   // |
   // | rn = rn_123.add( 234 );
   // | // (123) ---- (234) <~~ rn
   // |
   // | rn = rn_123.add( 345 );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345) <~~ rn
   // |
   // | rn = rn_123.add( 456 ).add( 567 ); // chain
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345)
   // | //        |
   // | //        +-- (456) ---- (567) <~~ rn
   //---------------------------------------------------------------------------

   virtual function route_node_type add( T e );
      route_node_type rn = new( e );
      return connect( rn );
   endfunction: add
   
   //---------------------------------------------------------------------------
   // Function: connect
   //   (VIRTUAL) Connects the given route node (and its connections) as a new
   //   <to_nodes>.
   //
   // Argument:
   //   rn - A route node to be connected.
   //
   // Returns:
   //   A route node to be connected (*rn*).
   //
   // Example:
   // | route_node#(int) rn_123;
   // | route_node#(int) rn_234;
   // | route_node#(int) rn_345;
   // | route_node#(int) rn_456;
   // | route_node#(int) rn;
   // |
   // | rn_123 = new( 123 );
   // | rn_234 = rn_123.add( 234 );
   // | // (123) --- (234)
   // | //             \__ rn_234
   // |
   // | rn_345 = new( 345 );
   // | rn_456 = rn_345.add( 456 );
   // | // (345) ---- (456)
   // | //   \__ rn_345
   // |
   // | rn = rn_234.connect( rn_345 );
   // | // (123) ---- (234) --- (345) ---- (456)
   // | //                        \__ rn
   //---------------------------------------------------------------------------

   virtual function route_node_type connect( route_node_type rn );
      to_nodes.push_back( rn );
      rn.from_nodes.push_back( this );
      return rn;
   endfunction: connect
   
   //---------------------------------------------------------------------------
   // Function: disconnect
   //   (VIRTUAL) Removes the specified route node (and its connections) from
   //   this node.
   //
   // Argument:
   //   index - (OPTIONAL) The index of the <to_nodes>. The default is *0*. If
   //           the specified node does not exist, this function does nothing.
   //
   // Returns:
   //   This route node.
   //
   // Example:
   // | route_node#(int) rn;
   // | route_node#(int) rn_123 = new( 123 );
   // |
   // | rn = rn_123.add( 234 );
   // | rn = rn_123.add( 456 ).add( 567 );
   // | rn = rn_123.add( 345 );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (456) ---- (567)
   // | //        |
   // | //        +-- (345)
   // |
   // | rn = rn_123.disconnect( .index( 1 ) );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345)
   //---------------------------------------------------------------------------

   virtual function route_node_type disconnect( int index = 0 );
      if ( index >= to_nodes.size() ) return this;

      to_nodes.delete( index );
      return this;
   endfunction: disconnect
   
   //---------------------------------------------------------------------------
   // Function: get_num_of_to_nodes
   //   (VIRTUAL) Returns the number of <to_nodes>.  This function _does not_
   //   count the number of connections recursively.
   //
   // Returns:
   //   The number of <to_nodes>.
   //
   // Example:
   // | route_node#(int) rn;
   // | route_node#(int) rn_123 = new( 123 );
   // |
   // | rn = rn_123.add( 234 );
   // | rn = rn_123.add( 345 );
   // | rn = rn_123.add( 456 ).add( 567 );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345)
   // | //        |
   // | //        +-- (456) ---- (567)
   // |
   // | assert( rn_123.get_num_of_to_nodes() == 3 ); // not 4
   //---------------------------------------------------------------------------

   virtual function int get_num_of_to_nodes();
      return to_nodes.size();
   endfunction: get_num_of_to_nodes

   //---------------------------------------------------------------------------
   // Function: has_to_nodes
   //   (VIRTUAL) Returns if this route node has at least one <to_nodes>.
   //
   // Returns:
   //   If this tree node has at least one <to_nodes>, returns 1. Otherwise,
   //   returns 0.
   //
   // Example:
   // | route_node#(int) rn;
   // | route_node#(int) rn_123 = new( 123 );
   // |
   // | rn = rn_123.add( 234 );
   // | rn = rn_123.add( 345 );
   // | rn = rn_123.add( 456 ).add( 567 );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345)
   // | //        |
   // | //        +-- (456) ---- (567)
   // |
   // | assert( rn_123.has_to_nodes() == 1 );
   //---------------------------------------------------------------------------

   virtual function bit has_to_nodes();
      return get_num_of_to_nodes() > 0;
   endfunction: has_to_nodes

   //---------------------------------------------------------------------------
   // Function: get_index
   //   (VIRTUAL) Returns the index of the <to_nodes> this node is connected to,
   //   from the view point of the specified "from node".
   //
   // Returns:
   //   The index of the <to_nodes> of the specified "from node". If the
   //   specified "from node" does not exist, returns -1.
   //
   // Example:
   // | route_node#(int) from_node0 = new( 0 );
   // | route_node#(int) from_node1 = new( 1 );
   // | route_node#(int) to_node0   = new( 2 );
   // | route_node#(int) to_node1   = new( 3 );
   // | route_node#(int) this_node  = new( 4 );
   // | route_node#(int) rn;
   // |
   // | rn = from_node0.connect( this_node );
   // | rn = from_node1.connect( to_node0  );
   // | rn = from_node1.connect( to_node1  );
   // | rn = from_node1.connect( this_node );
   // | 
   // | //  +---------------+                       +------+
   // | //  | from_nodes[0] |------to_nodes[0]----->|      |
   // | //  +---------------+                       |      |
   // | //  +---------------+    +-------------+    |      |
   // | //  | from_nodes[1] |--->| to_nodes[0] |    | this |
   // | //  |               |    +-------------+    |      |
   // | //  |               |    +-------------+    | node |
   // | //  |               |--->| to_nodes[1] |    |      |
   // | //  |               |    +-------------+    |      |
   // | //  |               |------to_nodes[2]----->|      | 
   // | //  +---------------+                       +------+
   // |
   // | assert( this_node.get_index( .from_node_index( 0 ) ) == 0 );
   // | assert( this_node.get_index( .from_node_index( 1 ) ) == 2 );
   //---------------------------------------------------------------------------

   virtual function int get_index( int from_node_index );
      if ( from_node_index < from_nodes.size() ) begin
	 route_node_type from_node = from_nodes[ from_node_index ];

	 foreach ( from_node.to_nodes[i] ) 
	   if ( from_node.to_nodes[i] == this ) return i;
      end
      return -1;
   endfunction: get_index

endclass: route_node

`endif //  `ifndef CL_ROUTE_NODE_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
