//==============================================================================
//
// cl_route.svh (v0.6.1)
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

`ifndef CL_ROUTE_SVH
`define CL_ROUTE_SVH

//------------------------------------------------------------------------------
// Class: route
//   Implements a route structure.
//
// Parameter:
//   T - (OPTIONAL) The type of data collected in a route. The default is *int*.
//------------------------------------------------------------------------------

class route #( type T = int ) extends collection#( T );

   //---------------------------------------------------------------------------
   // Typedef: route_node_type
   //   The shorthand of the <route_node> type specialized with type *T*.
   //---------------------------------------------------------------------------

   typedef route_node#(T) route_node_type;
   
   //--------------------------------------------------------------------------
   // Typedef: route_type
   //   The shorthand of the <route> type specialized with type *T*.
   //--------------------------------------------------------------------------

   typedef route#(T) route_type;

`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
`else  // !`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
`endif // !`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS

   //---------------------------------------------------------------------------
   // Property: start
   //   The starting node of the route.
   //---------------------------------------------------------------------------

   route_node_type start;

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new route.
   //
   // Argument:
   //   c    - (OPTIONAL) A collection whose elements are to be added to this 
   //          route.
   //   cmp - (OPTIONAL) A strategy object used to compare the elements of type
   //         *T*. If not specified or *null*, <comparator> *#(T)* is used. The
   //         default is *null*.
   //   fmtr - (OPTIONAL) A strategy object that provides a function to convert
   //          the element of type *T* to a string. If not specified or *null*,
   //          <hex_formatter> *#(T)* is used. The default is *null*.
   //
   // Example:
   // | route#(int) int_route = new();
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
   //   (VIRTUAL) Creates a new <route_node> of the given element and adds it to
   //   the <start>.  If the <start> is empty, make the newly created <route_node>
   //   as the starting node.
   //
   // Argument:
   //   e - An element to be added to the <start>.
   //
   // Returns:
   //   If this route changed as a result of the call, 1 is returned.
   //   Otherwise, 0 is returned.
   //
   // Example:
   // | route#(int) int_route = new();
   // |
   // | assert( int_route.add( 123 ) );
   // | // (123)
   // | //   \__ starting node
   // |
   // | assert( int_route.add( 234 ) );
   // | // (123) ---- (234)
   // |
   // | assert( int_route.add( 345 ) );
   // | // (123) -+-- (234)
   // | //        |
   // | //        +-- (345)
   //---------------------------------------------------------------------------

   virtual function bit add( T e );
      return add_to_node( e ) != null;
   endfunction: add

   //---------------------------------------------------------------------------
   // Function: add_to_node
   //   (VIRTUAL) Creates a new <route_node> of the given element and adds it to
   //   the specified *node*.
   //
   // Argument:
   //   e - An element to be added to the route.
   //   node - (OPTIONAL) The node the newly created <route_node> is connected
   //          to. If the *node* is *null*, add the node to the <start>. If the
   //          <start> is empty, make the newly created <route_node> as the
   //          starting node. Default is *null*.
   //
   // Returns:
   //   Newly added <route_node>.
   //   
   // Example:
   // | route#(int)      int_route = new();
   // | route_node#(int) rn_123;
   // | route_node#(int) rn_234;
   // | route_node#(int) rn_345;
   // |
   // | rn_123 = int_route.add_to_node( 123 );
   // | // (123)
   // | //   \__ starting node
   // |
   // | rn_234 = int_route.add_to_node( 234, .node( rn_123 ) );
   // | // (123) ---- (234)
   // |
   // | rn_345 = int_route.add_to_node( 345, .node( rn_234 ) );
   // | // (123) ---- (234) ---- (345)
   //---------------------------------------------------------------------------

   virtual function route_node_type add_to_node( T e, route_node_type node = null );
      if ( node ) begin
	 return node.add( e );
      end else if ( start ) begin
	 return start.add( e );
      end else begin
	 start = new( e );
	 return start;
      end
   endfunction: add_to_node

   //---------------------------------------------------------------------------
   // Function: connect
   //   (VIRTUAL) Connects the given two <route_node>s.
   //
   // Argument:
   //   from_node - A route node connected from.
   //   to_node - A route node connected to.
   //
   // Returns:
   //   A route node connected to (*to_node*).
   //
   // Example:
   // | route#(int)      int_route = new();
   // | route_node#(int) rn;
   // | route_node#(int) rn_123;
   // | route_node#(int) rn_234;
   // | route_node#(int) rn_345;
   // | route_node#(int) rn_456;
   // |
   // | rn_123 = int_route.add_to_node( 123 );
   // | rn_234 = int_route.add_to_node( 234, .node( rn_123 ) );
   // | // (123) ---- (234)
   // | //              \__ rn_234
   // |
   // | rn_345 = new( 345 );
   // | rn_456 = rn_345.add( 456 );
   // | // (345) ---- (456)
   // | //   \__ rn_345
   // |
   // | rn = int_route.connect( .from_node( rn_234 ), .to_node( rn_345 ) );
   // | // (123) ---- (234) ---- (345) --- (456)
   // | //                         \__ rn
   //---------------------------------------------------------------------------

   virtual function route_node_type connect( route_node_type from_node, 
					     route_node_type to_node );
      return from_node.connect( to_node );
   endfunction: connect

   //---------------------------------------------------------------------------
   // Function: clear
   //   (VIRTUAL) Removes all of the elements from this route.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | route#(int) int_route = new();
   // |
   // | assert( int_route.add( 123 ) );
   // | assert( int_route.add( 234 ) );
   // | assert( int_route.size() == 2 );
   // | int_route.clear();
   // | assert( int_route.size() == 0 );
   //---------------------------------------------------------------------------

   virtual function void clear();
      start = null;
   endfunction: clear

   //---------------------------------------------------------------------------
   // Function: clone
   //   (VIRTUAL) Returns a shallow copy of this route. Only the <start>
   //   is copied. The connected routes are not cloned.
   //
   // Returns:
   //   A copy of this route.
   //
   // Example:
   // | route#(int) int_route = new();
   // | collection#(int) cloned;
   // |
   // | assert( int_route.add( 123 ) );
   // | assert( int_route.add( 234 ) );
   // | cloned = int_route.clone();
   // | assert( cloned.size() == 2 );
   //---------------------------------------------------------------------------

   virtual function collection#( T ) clone();
      route_type t = new();
      t.start = start;
      return t;
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: is_empty
   //   (VIRTUAL) Returns 1 if this route contains no elements.
   //
   // Returns:
   //   If this route contains no elements, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | route#(int) int_route = new();
   // |
   // | assert( int_route.add( 123 ) );
   // | assert( int_route.add( 234 ) );
   // | assert( int_route.is_empty() == 0 );
   //---------------------------------------------------------------------------

   virtual function bit is_empty();
      return start == null;
   endfunction: is_empty

   //---------------------------------------------------------------------------
   // Function: get_iterator
   //   (VIRTUAL) Returns an iterator over the elements in this route. This
   //   function is equivalent to <get_breadth_first_iterator>.
   //
   // Returns:
   //   An iterator.
   //
   // Example:
   // | route#(int)      int_route = new();
   // | route_node#(int) rn_123;
   // | route_node#(int) rn_234;
   // | route_node#(int) rn_345;
   // | route_node#(int) rn_456;
   // | iterator#(int)  it;
   // | string s;
   // |
   // | rn_123 = int_route.add_to_node( 123 );
   // | rn_234 = int_route.add_to_node( 234, .node( rn_123 ) );
   // | rn_345 = int_route.add_to_node( 345, .node( rn_123 ) );
   // | rn_456 = int_route.add_to_node( 456, .node( rn_234 ) );
   // | // (123) -+-- (234) ---- (456)
   // | //        |
   // | //        +-- (345)
   // |
   // | it = int_route.get_iterator();
   // | while ( it.has_next() ) s = { s, $sformatf( "%0d ", it.next() ) };
   // | assert( s == "123 234 345 456 " );
   //---------------------------------------------------------------------------

   virtual function iterator#( T ) get_iterator();
      return get_breadth_first_iterator();
   endfunction: get_iterator

   //---------------------------------------------------------------------------
   // Function: get_breadth_first_iterator
   //   (VIRTUAL) Returns a <route_breadth_first_iterator> over the elements in
   //   this route.
   //
   // Returns:
   //   An iterator.
   //
   // Example:
   // | route#(int)      int_route = new();
   // | route_node#(int) rn_123;
   // | route_node#(int) rn_234;
   // | route_node#(int) rn_345;
   // | route_node#(int) rn_456;
   // | iterator#(int)  it;
   // | string s;
   // |
   // | rn_123 = int_route.add_to_node( 123 );
   // | rn_234 = int_route.add_to_node( 234, .node( rn_123 ) );
   // | rn_345 = int_route.add_to_node( 345, .node( rn_123 ) );
   // | rn_456 = int_route.add_to_node( 456, .node( rn_234 ) );
   // | // (123) -+-- (234) ---- (456)
   // | //        |
   // | //        +-- (345)
   // |
   // | it = int_route.get_breadth_first_iterator();
   // | while ( it.has_next() ) s = { s, $sformatf( "%0d ", it.next() ) };
   // | assert( s == "123 234 345 456 " );
   //---------------------------------------------------------------------------

   virtual function iterator#( T ) get_breadth_first_iterator();

`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
      route_breadth_first_iterator#( T ) it = new();
`else
      route_breadth_first_iterator#( T ) it = new( this );
`endif      

      return it;
   endfunction: get_breadth_first_iterator

   //---------------------------------------------------------------------------
   // Function: get_last_node
   //   (VIRTUAL) Returns the last route node in the breadth-first order.
   //
   // Returns:
   //   The last node. If the last route node does not exist, return *null*.
   //
   // Example:
   // | route#(int) int_route = new();
   // | assert( int_route.add( 123 ) );
   // | assert( int_route.add( 234 ) );
   // |
   // | assert( int_route.get_last_node().elem == 234 );
   //---------------------------------------------------------------------------

   virtual function route_node_type get_last_node();
      route_node_type rn;
      route_breadth_first_iterator#(T) it = route_breadth_first_iterator'( get_breadth_first_iterator() );

      while ( it.has_next() ) rn = it.next_node();
      return rn;
   endfunction: get_last_node

endclass: route

`endif //  `ifndef CL_ROUTE_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
