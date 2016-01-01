//==============================================================================
//
// cl_tree.svh (v0.6.1)
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

`ifndef CL_TREE_SVH
`define CL_TREE_SVH

//------------------------------------------------------------------------------
// Class: tree
//   Implements a tree structure.
//
// Parameter:
//   T - (OPTIONAL) The type of data collected in a tree. The default is *int*.
//------------------------------------------------------------------------------

class tree #( type T = int ) extends collection#( T );

   //---------------------------------------------------------------------------
   // Typedef: tree_node_type
   //   The shorthand of the <tree_node> type specialized with type *T*.
   //---------------------------------------------------------------------------

   typedef tree_node#(T) tree_node_type;
   
   //--------------------------------------------------------------------------
   // Typedef: tree_type
   //   The shorthand of the <tree> type specialized with type *T*.
   //--------------------------------------------------------------------------

   typedef tree#(T) tree_type;

`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
`else  // !`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
`endif // !`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS

   //---------------------------------------------------------------------------
   // Property: root
   //   The root node of the tree.
   //---------------------------------------------------------------------------

   tree_node_type root;

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new tree.
   //
   // Argument:
   //   c    - (OPTIONAL) A collection whose elements are to be added to this 
   //          tree.
   //   cmp - (OPTIONAL) A strategy object used to compare the elements of type
   //         *T*. If not specified or *null*, <comparator> *#(T)* is used. The
   //         default is *null*.
   //   fmtr - (OPTIONAL) A strategy object that provides a function to convert
   //          the element of type *T* to a string. If not specified or *null*,
   //          <hex_formatter> *#(T)* is used. The default is *null*.
   //
   // Example:
   // | tree#(int) int_tree = new();
   //---------------------------------------------------------------------------

   function new( collection#(T)   c = null,
		 comparator#(T) cmp = null,
		 formatter#(T) fmtr = null );
      if ( cmp == null ) this.cmp = comparator#(T)::get_instance();
      else               this.cmp = cmp;
      if ( fmtr == null ) this.fmtr = hex_formatter#(T)::get_instance();
      else                this.fmtr = fmtr;
      if ( c ) void'( this.add_all( c ) );
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: add
   //   (VIRTUAL) Creates a new <tree_node> of the given element and adds it to
   //   the <root>.  If the <root> is empty, make the newly created <tree_node>
   //   as the root.
   //
   // Argument:
   //   e - An element to be added to the <root>.
   //
   // Returns:
   //   If this tree changed as a result of the call, 1 is returned.
   //   Otherwise, 0 is returned.
   //
   // Example:
   // | tree#(int) int_tree = new();
   // |
   // | assert( int_tree.add( 123 ) );
   // | // (123)
   // | //   \__ root node
   // |
   // | assert( int_tree.add( 234 ) );
   // | // (123) ---- (234)
   // |
   // | assert( int_tree.add( 345 ) );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345)
   //---------------------------------------------------------------------------

   virtual function bit add( T e );
      return add_to_node( e ) != null;
   endfunction: add

   //---------------------------------------------------------------------------
   // Function: add_to_node
   //   (VIRTUAL) Creates a new <tree_node> of the given element and adds it to
   //   the tree as the child of the specified parent.
   //
   // Argument:
   //   e - An element to be added to the tree.
   //   parent - (OPTIONAL) The parent <tree_node>. If the *parent* is *null*,
   //            add the node to the <root>. If the <root> is empty, make the
   //            newly created <tree_node> as the root. Default is *null*.
   //
   // Returns:
   //   Newly added <tree_node>.
   //   
   // Example:
   // | tree#(int)      int_tree = new();
   // | tree_node#(int) tn_123;
   // | tree_node#(int) tn_234;
   // | tree_node#(int) tn_345;
   // |
   // | tn_123 = int_tree.add_to_node( 123 );
   // | // (123)
   // | //   \__ root node
   // |
   // | tn_234 = int_tree.add_to_node( 234, .parent( tn_123 ) );
   // | // (123) ---- (234)
   // |
   // | tn_345 = int_tree.add_to_node( 345, .parent( tn_234 ) );
   // | // (123) ---- (234) ---- (345)
   //---------------------------------------------------------------------------

   virtual function tree_node_type add_to_node( T e, tree_node_type parent = null );
      if ( parent ) begin
	 return parent.add( e );
      end else if ( root ) begin
	 return root.add( e );
      end else begin
	 root = new( e );
	 return root;
      end
   endfunction: add_to_node

   //---------------------------------------------------------------------------
   // Function: graft
   //   (VIRTUAL) Grafts the given <tree_node> (and its children) to the tree as
   //   the child of the specified parent.
   //
   // Argument:
   //   tn - A tree node to be grafted.
   //   parent - (OPTIONAL) The parent <tree_node>. If the *parent* is *null*,
   //            add the node to the <root>. If the <root> is empty, make the
   //            *tn* as the root. Default is *null*.
   //
   // Returns:
   //   A tree node to be grafted (*tn*).
   //
   // Example:
   // | tree#(int)      int_tree = new();
   // | tree_node#(int) tn;
   // | tree_node#(int) tn_123;
   // | tree_node#(int) tn_234;
   // | tree_node#(int) tn_345;
   // | tree_node#(int) tn_456;
   // |
   // | tn_123 = int_tree.add_to_node( 123 );
   // | tn_234 = int_tree.add_to_node( 234, .parent( tn_123 ) );
   // | // (123) ---- (234)
   // | //              \__ tn_234
   // |
   // | tn_345 = new( 345 );
   // | tn_456 = tn_345.add( 456 );
   // | // (345) ---- (456)
   // | //   \__ tn_345
   // |
   // | tn = int_tree.graft( tn_345, .parent( tn_234 ) );
   // | // (123) ---- (234) ---- (345) --- (456)
   // | //                         \__ tn
   //---------------------------------------------------------------------------

   virtual function tree_node_type graft( tree_node_type tn, 
					  tree_node_type parent = null );
      if ( parent ) begin
	 void'( parent.graft( tn ) );
      end else if ( root ) begin
	 void'( root.graft( tn ) );
      end else begin
	 root = tn;
	 tn.parent = null;
      end
      return tn;
   endfunction: graft

   //---------------------------------------------------------------------------
   // Function: clear
   //   (VIRTUAL) Removes all of the elements from this tree.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | tree#(int) int_tree = new();
   // |
   // | assert( int_tree.add( 123 ) );
   // | assert( int_tree.add( 234 ) );
   // | assert( int_tree.size() == 2 );
   // | int_tree.clear();
   // | assert( int_tree.size() == 0 );
   //---------------------------------------------------------------------------

   virtual function void clear();
      root = null;
   endfunction: clear

   //---------------------------------------------------------------------------
   // Function: clone
   //   (VIRTUAL) Returns a shallow copy of this tree. Only the <root>
   //   is copied. The children are not cloned.
   //
   // Returns:
   //   A copy of this tree.
   //
   // Example:
   // | tree#(int) int_tree = new();
   // | collection#(int) cloned;
   // |
   // | assert( int_tree.add( 123 ) );
   // | assert( int_tree.add( 234 ) );
   // | cloned = int_tree.clone();
   // | assert( cloned.size() == 2 );
   //---------------------------------------------------------------------------

   virtual function collection#( T ) clone();
      tree_type t = new();
      t.root = root;
      return t;
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: is_empty
   //   (VIRTUAL) Returns 1 if this tree contains no elements.
   //
   // Returns:
   //   If this tree contains no elements, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | tree#(int) int_tree = new();
   // |
   // | assert( int_tree.add( 123 ) );
   // | assert( int_tree.add( 234 ) );
   // | assert( int_tree.is_empty() == 0 );
   //---------------------------------------------------------------------------

   virtual function bit is_empty();
      return root == null;
   endfunction: is_empty

   //---------------------------------------------------------------------------
   // Function: get_iterator
   //   (VIRTUAL) Returns an iterator over the elements in this tree. This
   //   function is equivalent to <get_breadth_first_iterator>.
   //
   // Returns:
   //   An iterator.
   //
   // Example:
   // | tree#(int)      int_tree = new();
   // | tree_node#(int) tn_123;
   // | tree_node#(int) tn_234;
   // | tree_node#(int) tn_345;
   // | tree_node#(int) tn_456;
   // | iterator#(int)  it;
   // | string s;
   // |
   // | tn_123 = int_tree.add_to_node( 123 );
   // | tn_234 = int_tree.add_to_node( 234, .parent( tn_123 ) );
   // | tn_345 = int_tree.add_to_node( 345, .parent( tn_123 ) );
   // | tn_456 = int_tree.add_to_node( 456, .parent( tn_234 ) );
   // | // (123) -+-- (234) ---- (456)
   // | //        |
   // | //        +-- (345)
   // |
   // | it = int_tree.get_iterator();
   // | while ( it.has_next() ) s = { s, $sformatf( "%0d ", it.next() ) };
   // | assert( s == "123 234 345 456 " );
   //---------------------------------------------------------------------------

   virtual function iterator#( T ) get_iterator();
      return get_breadth_first_iterator();
   endfunction: get_iterator

   //---------------------------------------------------------------------------
   // Function: get_breadth_first_iterator
   //   (VIRTUAL) Returns a <tree_breadth_first_iterator> over the elements in
   //   this tree.
   //
   // Returns:
   //   An iterator.
   //
   // Example:
   // | tree#(int)      int_tree = new();
   // | tree_node#(int) tn_123;
   // | tree_node#(int) tn_234;
   // | tree_node#(int) tn_345;
   // | tree_node#(int) tn_456;
   // | iterator#(int)  it;
   // | string s;
   // |
   // | tn_123 = int_tree.add_to_node( 123 );
   // | tn_234 = int_tree.add_to_node( 234, .parent( tn_123 ) );
   // | tn_345 = int_tree.add_to_node( 345, .parent( tn_123 ) );
   // | tn_456 = int_tree.add_to_node( 456, .parent( tn_234 ) );
   // | // (123) -+-- (234) ---- (456)
   // | //        |
   // | //        +-- (345)
   // |
   // | it = int_tree.get_breadth_first_iterator();
   // | while ( it.has_next() ) s = { s, $sformatf( "%0d ", it.next() ) };
   // | assert( s == "123 234 345 456 " );
   //---------------------------------------------------------------------------

   virtual function iterator#( T ) get_breadth_first_iterator();

`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
      tree_breadth_first_iterator#( T ) it = new();
`else
      tree_breadth_first_iterator#( T ) it = new( this );
`endif      

      return it;
   endfunction: get_breadth_first_iterator

   //---------------------------------------------------------------------------
   // Function: get_last_node
   //   (VIRTUAL) Returns the last tree node in the breadth-first order.
   //
   // Returns:
   //   The last node. If the last tree node does not exist, returns *null*.
   //
   // Example:
   // | tree#(int) int_tree = new();
   // | assert( int_tree.add( 123 ) );
   // | assert( int_tree.add( 234 ) );
   // |
   // | assert( int_tree.get_last_node().elem == 234 );
   //---------------------------------------------------------------------------

   virtual function tree_node_type get_last_node();
      tree_node_type tn;
      tree_breadth_first_iterator#(T) it = tree_breadth_first_iterator'( get_breadth_first_iterator() );

      while ( it.has_next() ) tn = it.next_node();
      return tn;
   endfunction: get_last_node

   //--------------------------------------------------------------------------
   // Function: update_locations
   //   (VIRTUAL) Updates the <tree_node::location> of the entire tree.
   //
   // Returns:
   //   None.
   //--------------------------------------------------------------------------

   virtual function void update_locations();
      iterator#(T) it = get_iterator();

      while ( it.has_next() ) void'( it.next() ); // iterating updates the locations
   endfunction: update_locations

   //---------------------------------------------------------------------------
   // Function: get_location_name
   //   (VIRTUAL) Returns the human-readable location string of this node from
   //   the root. The user must call <update_locations> prior to this function
   //   if the tree structure has changed since the last call of this function
   //   (this function does not call <update_locations> by itself). See
   //   <tree_node::location> for more detail.
   //
   // Argument:
   //   tn - The <tree_node> to get its location name.
   //
   // Returns:
   //   The location string.
   //
   // Example:
   // | tree#(int)      t = new();
   // | tree_node#(int) tn_234;
   // | tree_node#(int) tn_345;
   // | tree_node#(int) tn_456;
   // | tree_node#(int) tn_567;
   // | tree_node#(int) root;
   // |
   // | root = t.add_to_node( 123 );
   // | tn_234 = t.add_to_node( 234 );
   // | tn_345 = t.add_to_node( 345 );
   // | tn_456 = t.add_to_node( 456 );
   // | tn_567 = t.add_to_node( 567, .parent( tn_456 ) );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345)
   // | //        |
   // | //        +-- (456) ---- (567)
   // |
   // | t.update_locations();
   // | assert( t.get_location_name( tn_567 ) == "[0,2,0]" );
   //
   // See Also:
   //   <tree_node::location>
   //---------------------------------------------------------------------------

   virtual function string get_location_name( tree_node_type tn );
      decimal_min_formatter#(int) fmtr = decimal_min_formatter#(int)::get_instance();

      // update_locations(); // expensive
      return { "[", queue#(int)::to_string( tn.location, .separator( "," ), .fmtr( fmtr ) ), "]" };
   endfunction: get_location_name

endclass: tree

`endif //  `ifndef CL_TREE_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
