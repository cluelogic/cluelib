//==============================================================================
//
// cl_set.svh (v0.6.1)
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

`ifndef CL_SET_SVH
`define CL_SET_SVH

//-----------------------------------------------------------------------------
// Class: set
//   Implements the <set_base> using an associative array.
//
// Parameter:
//   T - (OPTIONAL) The type of data collected in a set. The default is *int*.
//-----------------------------------------------------------------------------

class set #( type T = int ) extends set_base#( T );

`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
   local bit aa[ T ];

   class set_iterator #( T ) extends iterator#( T );
      local int cnt;
      local int aa_size;
      local T cur_key;
      
      function new();
	 aa_size = aa.size();
	 cnt = 0;
      endfunction: new

      virtual function bit has_next();
	 return cnt < aa_size;
      endfunction: has_next
      
      virtual function T next();
	 if ( cnt == 0 ) begin
	    assert( aa.first( cur_key ) == 1 ); // first() returns 0, 1, or -1
	 end else begin
	    assert( aa.next( cur_key ) == 1 ); // next() returns 0, 1, or -1
	 end
	 cnt++;
	 return cur_key;
      endfunction: next
      
      virtual function void remove();
	 void'( aa.delete( cur_key ) );
      endfunction: remove

   endclass: set_iterator

`else // !`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
   bit aa[ T ];
`endif // !`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS

   //--------------------------------------------------------------------------
   // Function: new
   //   Creates a new set.
   //
   // Argument:
   //   c    - (OPTIONAL) A collection whose elements are to be added to this 
   //          set.
   //   cmp - (OPTIONAL) A strategy object used to compare the elements of type
   //         *T*. If not specified or *null*, <comparator> *#(T)* is used. The
   //         default is *null*.
   //   fmtr - (OPTIONAL) A strategy object that provides a function to convert
   //          the element of type *T* to a string. If not specified or *null*,
   //          <hex_formatter> *#(T)* is used. The default is *null*.
   //
   // Example:
   // | set#(int) int_set = new();
   //--------------------------------------------------------------------------

   function new( collection#(T) c = null,
		 comparator#(T) cmp = null,
		 formatter#(T) fmtr = null );
      if ( cmp == null ) this.cmp = comparator#(T)::get_instance();
      else               this.cmp = cmp;
      if ( fmtr == null ) this.fmtr = hex_formatter#(T)::get_instance();
      else                this.fmtr = fmtr;
      if ( c ) void'( this.add_all( c ) );
   endfunction: new

   //--------------------------------------------------------------------------
   // Function: add
   //   (VIRTUAL) Adds the given element to this set if it is not already
   //   present.
   //
   // Argument:
   //   e - An element to be added to this set.
   //
   // Returns:
   //   If this set did not contain the given element, returns 1. Otherwise,
   //   returns 0.
   //
   // Example:
   // | set#(int) int_set = new();
   // |
   // | assert( int_set.add( 123 ) == 1 );
   // | assert( int_set.add( 123 ) == 0 ); // 123 is already in the set
   //--------------------------------------------------------------------------

   virtual function bit add( T e );
      if ( aa.exists( e ) ) begin
	 return 0;
      end else begin
	 aa[ e ] = 1;
	 return 1;
      end
   endfunction: add

   //--------------------------------------------------------------------------
   // Function: clear
   //   (VIRTUAL) Removes all of the elements from this set.
   //
   // Example:
   // | set#(int) int_set = new();
   // |
   // | int_set.clear();
   //--------------------------------------------------------------------------

   virtual function void clear();
      aa.delete();
   endfunction: clear

   //--------------------------------------------------------------------------
   // Function: clone
   //   (VIRTUAL) Returns a shallow copy of this set. The element themselves are
   //   not cloned.
   //
   // Returns:
   //   A copy of this set.
   //
   // Example:
   // | set#(int) int_set = new();
   // | collection#(int) cloned;
   // |
   // | cloned = int_set.clone();
   //--------------------------------------------------------------------------

   virtual function collection#( T ) clone();
      set#( T ) set = new();
      set.aa   = aa; // the elements themselves are not cloned
      set.fmtr = fmtr;
      return set;
   endfunction: clone

   //--------------------------------------------------------------------------
   // Function: contains
   //   (VIRTUAL) Returns 1 if this set contains the specified element.
   //
   // Argument:
   //   e - An element to be checked.
   //
   // Returns:
   //   If this set contains *e*, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | set#(int) int_set = new();
   // |
   // | void'( int_set.add( 123 ) );
   // | assert( int_set.contains( 123 ) == 1 );
   // | assert( int_set.contains( 456 ) == 0 );
   //--------------------------------------------------------------------------

   virtual function bit contains( T e );
      return aa.exists( e );
   endfunction: contains

   //--------------------------------------------------------------------------
   // Function: is_empty
   //   (VIRTUAL) Returns 1 if this set contains no elements.
   //
   // Returns:
   //   If this set is empty, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | set#(int) int_set = new();
   // |
   // | assert( int_set.is_empty() == 1 );
   // | void'( int_set.add( 123 ) );
   // | assert( int_set.is_empty() == 0 );
   //--------------------------------------------------------------------------

   virtual function bit is_empty();
      return size() == 0;
   endfunction: is_empty

   //--------------------------------------------------------------------------
   // Function: get_iterator
   //   (VIRTUAL) Returns an iterator over the elements in this set.
   //
   // Returns:
   //   An iterator.
   //
   // Example:
   // | set#(int) int_set = new();
   // | iterator#(int) it;
   // | string s;
   // |
   // | void'( int_set.add( 123 ) );
   // | void'( int_set.add( 456 ) );
   // | it = int_set.get_iterator();
   // | while ( it.has_next() ) s = { s, $sformatf( "%0d ", it.next() ) };
   // | assert( s == "123 456 " );
   //--------------------------------------------------------------------------

   virtual function iterator#( T ) get_iterator();

`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
      set_iterator#( T ) it = new();
`else
      set_iterator#( T ) it = new( this );
`endif      

      return it;
   endfunction: get_iterator

   //--------------------------------------------------------------------------
   // Function: remove
   //   (VIRTUAL) Removes the given element from this set if it is present.
   //
   // Argument:
   //   e - An element to remove.
   //
   // Returns:
   //   If *e* is removed, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | set#(int) int_set = new();
   // |
   // | void'( int_set.add( 123 ) );
   // | assert( int_set.remove( 123 ) == 1 );
   // | assert( int_set.remove( 123 ) == 0 ); // already removed
   //--------------------------------------------------------------------------

   virtual function bit remove( T e );
      if ( contains( e ) ) begin
	 aa.delete( e );
	 return 1;
      end else begin
	 return 0;
      end
   endfunction: remove

   //--------------------------------------------------------------------------
   // Function: size
   //   (VIRTUAL) Returns the number of elements in this set.
   //
   // Returns:
   //   The number of elements in this set.
   //
   // Example:
   // | set#(int) int_set = new();
   // |
   // | void'( int_set.add( 123 ) );
   // | assert( int_set.size() == 1 );
   //--------------------------------------------------------------------------

   virtual function int size();
      return aa.size();
   endfunction: size

endclass: set

`endif //  `ifndef CL_SET_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
