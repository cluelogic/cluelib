//==============================================================================
//
// cl_tree_node.svh (v0.6.1)
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

`ifndef CL_TREE_NODE_SVH
`define CL_TREE_NODE_SVH

//------------------------------------------------------------------------------
// Class: tree_node
//   Implements a node of a <tree>.
//
// Parameter:
//   T - (OPTIONAL) The type of data collected in a tree_node. The
//       default is *int*.
//------------------------------------------------------------------------------

class tree_node #( type T = int );

   // Group: Types

   //---------------------------------------------------------------------------
   // Typedef: tree_node_type
   //   The shorthand of the tree node type specialized with type *T*.
   //---------------------------------------------------------------------------

   typedef tree_node#(T) tree_node_type;
   
   // Group: Properties

   //---------------------------------------------------------------------------
   // PropertyX: id
   //   The unique ID of a node within a tree.
   //---------------------------------------------------------------------------

   int id;

   //---------------------------------------------------------------------------
   // Property: elem
   //   The element stored at this tree node.
   //---------------------------------------------------------------------------

   T elem;

   //---------------------------------------------------------------------------
   // Property: parent
   //   The parent node of this tree node.
   //---------------------------------------------------------------------------

   tree_node_type parent;
   
   //---------------------------------------------------------------------------
   // Property: children
   //   The child nodes this tree node has.
   //---------------------------------------------------------------------------

   tree_node_type children[$];
   
   //---------------------------------------------------------------------------
   // Property: relatives
   //   The tree nodes this tree node is related to. Usage of this property is
   //   up to the user.
   //---------------------------------------------------------------------------

   tree_node_type relatives[$];
   
   //---------------------------------------------------------------------------
   // Property: location
   //   The queue indicating the location of this tree node in a <tree>. Every
   //   child appends its index to the queue. _The <new>, <add>, <graft>, and
   //   <prune> functions do not update the location automatically. You must
   //   call <tree::update_locations> to update the entire tree-node locations._
   //   To get a human-readable location string, use <tree::get_location_name>.
   //
   //   Example:
   //   (start example)
   //   [0] -+-- [0,0] -+-- [0,0,0] ---- [0,0,0,0]
   //   root |          |
   //   node |          +-- [0,0,1]
   //        |
   //        +-- [0,1] -+-- [0,1,0] ---- [0,1,0,0]
   //        |          |
   //        |          +-- [0,1,1] -+-- [0,1,1,0]
   //        |                       |
   //        |                       +-- [0,1,1,1]
   //        |                       |
   //        |                       +-- [0,1,1,2]
   //        +-- [0,2]                   
   //   (end example)
   //
   // See Also:
   //   <tree::get_location_name>
   //---------------------------------------------------------------------------

   int location[$];

   // Group: Functions

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new tree node.
   //
   // Argument:
   //   elem - Data element stored at the tree node.
   //
   // Example:
   // | int i = 123;
   // | tree_node#(int) tn = new( i );
   //---------------------------------------------------------------------------

   function new( T elem );
      this.elem = elem;
//    location.push_back( 0 );
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: add
   //   (VIRTUAL) Creates a tree node of the given element and adds it
   //   as a new child.
   //
   // Argument:
   //   e - An element to be added.
   //
   // Returns:
   //   Newly added tree node.
   //
   // Example:
   // | tree_node#(int) tn;
   // | tree_node#(int) tn_123 = new( 123 );
   // |
   // | tn = tn_123.add( 234 );
   // | // (123) ---- (234) <~~ tn
   // |
   // | tn = tn_123.add( 345 );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345) <~~ tn
   // |
   // | tn = tn_123.add( 456 ).add( 567 ); // chain
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345)
   // | //        |
   // | //        +-- (456) ---- (567) <~~ tn
   //---------------------------------------------------------------------------

   virtual function tree_node_type add( T e );
      tree_node_type tn = new( e );
      return graft( tn );
   endfunction: add
   
   //---------------------------------------------------------------------------
   // Function: graft
   //   (VIRTUAL) Grafts the given tree node (and its children) as a new child.
   //
   // Argument:
   //   tn - A tree node to be grafted.
   //
   // Returns:
   //   A tree node to be grafted (*tn*).
   //
   // Example:
   // | tree_node#(int) tn_123;
   // | tree_node#(int) tn_234;
   // | tree_node#(int) tn_345;
   // | tree_node#(int) tn_456;
   // | tree_node#(int) tn;
   // |
   // | tn_123 = new( 123 );
   // | tn_234 = tn_123.add( 234 );
   // | // (123) --- (234)
   // | //             \__ tn_234
   // |
   // | tn_345 = new( 345 );
   // | tn_456 = tn_345.add( 456 );
   // | // (345) ---- (456)
   // | //   \__ tn_345
   // |
   // | tn = tn_234.graft( tn_345 );
   // | // (123) ---- (234) --- (345) ---- (456)
   // | //                        \__ tn
   //---------------------------------------------------------------------------

   virtual function tree_node_type graft( tree_node_type tn );
      children.push_back( tn );
      tn.parent = this;
//    tn.location = { location, get_num_children() - 1 };
      return tn;
   endfunction: graft
   
   //---------------------------------------------------------------------------
   // Function: prune
   //   (VIRTUAL) Removes the specified child (and its descendants).
   //
   // Argument:
   //   index - (OPTIONAL) The index of the child. The default is *0*. If the
   //           specified child does not exist, this function does nothing.
   //
   // Returns:
   //   This tree node.
   //
   // Example:
   // | tree_node#(int) tn;
   // | tree_node#(int) tn_123 = new( 123 );
   // |
   // | tn = tn_123.add( 234 );
   // | tn = tn_123.add( 456 ).add( 567 );
   // | tn = tn_123.add( 345 );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (456) ---- (567)
   // | //        |
   // | //        +-- (345)
   // |
   // | tn = tn_123.prune( .index( 1 ) );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345)
   //---------------------------------------------------------------------------

   virtual function tree_node_type prune( int index = 0 );
      if ( index >= children.size() ) return this;

      children.delete( index );
      return this;
   endfunction: prune
   
   //---------------------------------------------------------------------------
   // Function: get_num_children
   //   (VIRTUAL) Returns the number of (immediate) children of this tree node.
   //   This function _does not_ count the number of descendants recursively.
   //
   // Returns:
   //   The number of children.
   //
   // Example:
   // | tree_node#(int) tn;
   // | tree_node#(int) tn_123 = new( 123 );
   // |
   // | tn = tn_123.add( 234 );
   // | tn = tn_123.add( 345 );
   // | tn = tn_123.add( 456 ).add( 567 );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345)
   // | //        |
   // | //        +-- (456) ---- (567)
   // |
   // | assert( tn_123.get_num_children() == 3 ); // not 4
   //---------------------------------------------------------------------------

   virtual function int get_num_children();
      return children.size();
   endfunction: get_num_children

   //---------------------------------------------------------------------------
   // Function: has_child
   //   (VIRTUAL) Returns if this tree node has at least one child.
   //
   // Returns:
   //   If this tree node has a child (or children), returns 1. Otherwise,
   //   returns 0.
   //
   // Example:
   // | tree_node#(int) tn;
   // | tree_node#(int) tn_123 = new( 123 );
   // |
   // | tn = tn_123.add( 234 );
   // | tn = tn_123.add( 345 );
   // | tn = tn_123.add( 456 ).add( 567 );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345)
   // | //        |
   // | //        +-- (456) ---- (567)
   // |
   // | assert( tn_123.has_child() == 1 );
   //---------------------------------------------------------------------------

   virtual function bit has_child();
      return get_num_children() > 0;
   endfunction: has_child

   // TBD...
   // is_leaf()
   // is_root()
   
endclass: tree_node

`endif //  `ifndef CL_TREE_NODE_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
