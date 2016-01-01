//==============================================================================
//
// cl_deque.svh (v0.6.1)
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

`ifndef CL_DEQUE_SVH
`define CL_DEQUE_SVH

//------------------------------------------------------------------------------
// Class: deque
//   Implements a double-ended queue using a queue.
//
// Parameter:
//   T - (OPTIONAL) The type of data collected in a deque. The default is *int*.
//------------------------------------------------------------------------------

class deque #( type T = int ) extends collection#( T );
   
`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
   local T q[$];
   
   class deque_iterator #( type T = int ) extends iterator#( T );
      local int cur_index;
      local int q_size;

      function new();
	 q_size = q.size();
	 cur_index = 0;
      endfunction: new

      virtual function bit has_next();
	 return cur_index < q_size;
      endfunction: has_next

      virtual function T next();
	 return q[cur_index++];
      endfunction: next

      virtual function void remove();
	 q.delete( --cur_index );
	 q_size--;
      endfunction: remove

   endclass: deque_iterator

   class deque_descending_iterator #( type T = int ) extends iterator#( T );
      local int cur_index;
      local int q_size;

      function new();
	 q_size = q.size();
	 cur_index = q_size - 1;
      endfunction: new

      virtual function bit has_next();
	 return cur_index >= 0;
      endfunction: has_next

      virtual function T next();
	 return q[cur_index--];
      endfunction: next

      virtual function void remove();
	 q.delete( cur_index + 1 ); // keep the cur_index value
	 q_size--;
      endfunction: remove

   endclass: deque_descending_iterator

`else // !`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
   T q[$];
`endif // !`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new deque.
   //
   // Argument:
   //   c    - (OPTIONAL) A collection whose elements are to be added to this 
   //          deque.
   //   cmp - (OPTIONAL) A strategy object used to compare the elements of type
   //         *T*. If not specified or *null*, <comparator> *#(T)* is used. The
   //         default is *null*.
   //   fmtr - (OPTIONAL) A strategy object that provides a function to convert
   //          the element of type *T* to a string. If not specified or *null*,
   //          <hex_formatter> *#(T)* is used. The default is *null*.
   //
   // Example:
   // | deque#(int) int_dq = new();
   //---------------------------------------------------------------------------

   function new( collection#(T) c = null,
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
   //   (VIRTUAL) Adds the given element at the end of this deque.
   //
   // Argument:
   //   e - An element to be added to this deque.
   //
   // Returns:
   //   Always returns 1.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | assert( int_dq.add( 123 ) == 1 );
   //---------------------------------------------------------------------------

   virtual function bit add( T e );
      add_last( e );
      return 1;
   endfunction: add

   //---------------------------------------------------------------------------
   // Function: add_first
   //   (VIRTUAL) Adds the given element at the front of this deque.
   //
   // Argument:
   //   e - An element to be added to this deque.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | int_dq.add_first( 123 );
   //---------------------------------------------------------------------------

   virtual function void add_first( T e );
      q.push_front( e );
   endfunction: add_first

   //---------------------------------------------------------------------------
   // Function: add_last
   //   (VIRTUAL) Adds the given element at the end of this deque.
   //
   // Argument:
   //   e - An element to be added to this deque.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | int_dq.add_last( 123 );
   //---------------------------------------------------------------------------

   virtual function void add_last( T e );
      q.push_back( e );
   endfunction: add_last

   //---------------------------------------------------------------------------
   // Function: clear
   //   (VIRTUAL) Removes all of the elements from this deque.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | int_dq.clear();
   //---------------------------------------------------------------------------

   virtual function void clear();
      q.delete();
   endfunction: clear

   //---------------------------------------------------------------------------
   // Function: clone
   //   (VIRTUAL) Returns a shallow copy of this deque. The element themselves
   //   are not cloned.
   //
   // Returns:
   //   A copy of this deque.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | collection#(int) cloned;
   // |
   // | cloned = int_dq.clone();
   //---------------------------------------------------------------------------

   virtual function collection#( T ) clone();
      deque#( T ) dq = new();
      dq.q    = q; // the elements themselves are not cloned
      dq.cmp  = cmp;
      dq.fmtr = fmtr;
      return dq;
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: contains
   //   (VIRTUAL) Returns 1 if this deque contains the specified element.
   //
   // Argument:
   //   e - An element to be checked.
   //
   // Returns:
   //   If this deque contains *e*, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | void'( int_dq.add( 123 ) );
   // | assert( int_dq.contains( 123 ) == 1 );
   // | assert( int_dq.contains( 456 ) == 0 );
   //---------------------------------------------------------------------------

   virtual function bit contains( T e );
      int qi[$];
      
      qi = q.find_first_index with ( cmp.eq( item, e ) );
      return qi.size() != 0;
   endfunction: contains

   //---------------------------------------------------------------------------
   // Function: get
   //   (VIRTUAL) Retrieves the head of the deque and remove the element. This
   //   function is equivalent to <get_first>.
   //
   // Argument:
   //   e - The head of the deque to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | int i;
   // |
   // | void'( int_dq.add( 123 ) );
   // | assert( int_dq.get( i ) == 1 );
   // | assert( i == 123 );
   //
   // See Also:
   //   <get_first>
   //---------------------------------------------------------------------------

   virtual function bit get( ref T e );
      return get_first( e );
   endfunction: get

   //---------------------------------------------------------------------------
   // Function: get_first
   //   (VIRTUAL) Retrieves the head of the deque and remove the element.
   //
   // Argument:
   //   e - The head of the deque to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | int i;
   // |
   // | void'( int_dq.add( 123 ) );
   // | assert( int_dq.get_first( i ) == 1 );
   // | assert( i == 123 );
   //
   // See Also:
   //   <get>
   //---------------------------------------------------------------------------

   virtual function bit get_first( ref T e );
      if ( is_empty() ) begin
	 return 0;
      end else begin
         e = q.pop_front();
	 return 1;
      end
   endfunction: get_first

   //---------------------------------------------------------------------------
   // Function: get_last
   //   (VIRTUAL) Retrieves the tail of the deque and remove the element.
   //
   // Argument:
   //   e - The tail of the deque to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | int i;
   // |
   // | void'( int_dq.add( 123 ) );
   // | assert( int_dq.get_last( i ) == 1 );
   // | assert( i == 123 );
   //
   // See Also:
   //   <get_first>
   //---------------------------------------------------------------------------

   virtual function bit get_last( ref T e );
      if ( is_empty() ) begin
	 return 0;
      end else begin
         e = q.pop_back();
	 return 1;
      end
   endfunction: get_last

   //---------------------------------------------------------------------------
   // Function: get_iterator
   //   (VIRTUAL) Returns an iterator over the elements in this deque.
   //
   // Returns:
   //   An iterator.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | iterator#(int) it;
   // | string s;
   // |
   // | void'( int_dq.add( 123 ) );
   // | void'( int_dq.add( 456 ) );
   // | it = int_dq.get_iterator();
   // | while ( it.has_next() ) s = { s, $sformatf( "%0d ", it.next() ) };
   // | assert( s == "123 456 " );
   //---------------------------------------------------------------------------

   virtual function iterator#( T ) get_iterator();

`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
      deque_iterator#( T ) it = new();
`else
      deque_iterator#( T ) it = new( this );
`endif      

      return it;
   endfunction: get_iterator

   //---------------------------------------------------------------------------
   // Function: get_descending_iterator
   //   (VIRTUAL) Returns an iterator over the elements in this deque in reverse
   //   order.
   //
   // Returns:
   //   A descending iterator.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | iterator#(int) it;
   // | string s;
   // |
   // | void'( int_dq.add( 123 ) );
   // | void'( int_dq.add( 456 ) );
   // | it = int_dq.get_descending_iterator();
   // | while ( it.has_next() ) s = { s, $sformatf( "%0d ", it.next() ) };
   // | assert( s == "456 123 " );
   //---------------------------------------------------------------------------

   virtual function iterator#( T ) get_descending_iterator();

`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
      deque_descending_iterator#( T ) it = new();
`else
      deque_descending_iterator#( T ) it = new( this );
`endif      

      return it;
   endfunction: get_descending_iterator

   //---------------------------------------------------------------------------
   // Function: peek
   //   (VIRTUAL) Retrieves the head of the deque but does not remove the
   //   element. This function is equivalent to <peek_first>.
   //
   // Argument:
   //   e - The head of the deque to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | int i;
   // |
   // | void'( int_dq.add( 123 ) );
   // | void'( int_dq.add( 456 ) );
   // | assert( int_dq.peek( i ) == 1 );
   // | assert( i == 123 );
   //
   // See Also:
   //   <peek_first>
   //---------------------------------------------------------------------------

   virtual function bit peek( ref T e );
      return peek_first( e );
   endfunction: peek

   //---------------------------------------------------------------------------
   // Function: peek_first
   //   (VIRTUAL) Retrieves the head of the deque but does not remove the
   //   element.
   //
   // Argument:
   //   e - The head of the deque to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | int i;
   // |
   // | void'( int_dq.add( 123 ) );
   // | void'( int_dq.add( 456 ) );
   // | assert( int_dq.peek_first( i ) == 1 );
   // | assert( i == 123 );
   //
   // See Also:
   //   <peek>, <peek_last>
   //---------------------------------------------------------------------------

   virtual function bit peek_first( ref T e );
      if ( is_empty() ) begin
	 return 0;
      end else begin
         e = q[0];
	 return 1;
      end
   endfunction: peek_first

   //---------------------------------------------------------------------------
   // Function: peek_last
   //   (VIRTUAL) Retrieves the tail of the deque but does not remove the element.
   //
   // Argument:
   //   e - The tail of the deque to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | int i;
   // |
   // | void'( int_dq.add( 123 ) );
   // | void'( int_dq.add( 456 ) );
   // | assert( int_dq.peek_last( i ) == 1 );
   // | assert( i == 456 );
   //
   // See Also:
   //   <peek_first>
   //---------------------------------------------------------------------------

   virtual function bit peek_last( ref T e );
      if ( is_empty() ) begin
	 return 0;
      end else begin
         e = q[$];
	 return 1;
      end
   endfunction: peek_last

   //----------------------------------------------------------------------------
   // Function: pop
   //   (VIRTUAL) Pops an element from the deque as if it is a stack.
   //
   // Returns: 
   //   The head of the deque. If the deque is empty, the value of type *T* read
   //   from a nonexistent queue entry is returned (See IEEE Std 1800-2012 Table
   //   7-1).
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | int_dq.push( 123 );
   // | int_dq.push( 456 );
   // | assert( int_dq.pop() == 456 );
   //----------------------------------------------------------------------------

   virtual function T pop();
      return q.pop_front();
   endfunction: pop

   //----------------------------------------------------------------------------
   // Function: push
   //   (VIRTUAL) Pushes an element to the deque as if it is a stack.
   //
   // Argument:
   //   e - An element to push.
   //
   // Returns:
   //   None.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | int_dq.push( 123 );
   //----------------------------------------------------------------------------

   virtual function void push( T e );
      q.push_front( e );
   endfunction: push

   //---------------------------------------------------------------------------
   // Function: remove
   //   (VIRTUAL) Removes the specified element from this deque. This function
   //   is equivalent to <remove_first_occurrence>.
   //
   // Argument:
   //   e - An element to be removed.
   //
   // Returns:
   //   If this deque changed as a result of the call, 1 is returned. Otherwise,
   //   0 is returned.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | void'( int_dq.add( 123 ) );
   // | void'( int_dq.add( 456 ) );
   // | assert( int_dq.remove( 123 ) == 1 );
   // | assert( int_dq.remove( 789 ) == 0 );
   //
   // See Also:
   //   <remove_first_occurence>
   //---------------------------------------------------------------------------

   virtual function bit remove( T e );
      return remove_first_occurrence( e );
   endfunction: remove

   //---------------------------------------------------------------------------
   // Function: remove_first
   //   (VIRTUAL) Removes the first element from this deque.
   //
   // Returns:
   //   If this deque is not empty, 1 is returned. Otherwise, 0 is returned.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | void'( int_dq.add( 123 ) );
   // | assert( int_dq.remove_first() == 1 );
   // | assert( int_dq.remove_first() == 0 ); // deque is empty
   //---------------------------------------------------------------------------

   virtual function bit remove_first();
      if ( is_empty() ) begin
	 return 0;
      end else begin
	 void'( q.pop_front() );
	 return 1;
      end
   endfunction: remove_first

   //---------------------------------------------------------------------------
   // Function: remove_last
   //   (VIRTUAL) Removes the last element from this deque.
   //
   // Returns:
   //   If this deque is not empty, 1 is returned. Otherwise, 0 is returned.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | void'( int_dq.add( 123 ) );
   // | assert( int_dq.remove_last() == 1 );
   // | assert( int_dq.remove_last() == 0 ); // deque is empty
   //---------------------------------------------------------------------------

   virtual function bit remove_last();
      if ( is_empty() ) begin
	 return 0;
      end else begin
	 void'( q.pop_back() );
	 return 1;
      end
   endfunction: remove_last

   //---------------------------------------------------------------------------
   // Function: remove_first_occurrence
   //   (VIRTUAL) Removes the first occurrence of the specified element by
   //   traversing the deque from head to tail.
   //
   // Argument:
   //   e - An element to be removed.
   //
   // Returns:
   //   If this deque changed as a result of the call, 1 is returned. Otherwise,
   //   0 is returned.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | void'( int_dq.add( 123 ) );
   // | void'( int_dq.add( 456 ) );
   // | assert( int_dq.remove_first_occurrence( 123 ) == 1 );
   // | assert( int_dq.remove_first_occurrence( 789 ) == 0 );
   //
   // See Also:
   //   <remove>, <remove_last_occurrence>
   //---------------------------------------------------------------------------

   virtual function bit remove_first_occurrence( T e );
      int  qi[$];
      
      qi = q.find_first_index with ( cmp.eq( item, e ) );
      if ( qi.size() == 0 ) begin
	 return 0;
      end else begin
	 q.delete( qi[0] );
	 return 1;
      end
   endfunction: remove_first_occurrence

   //---------------------------------------------------------------------------
   // Function: remove_last_occurrence
   //   (VIRTUAL) Removes the last occurrence of the specified element by
   //   traversing the deque from tail to head.
   //
   // Argument:
   //   e - An element to be removed.
   //
   // Returns:
   //   If this deque changed as a result of the call, 1 is returned. Otherwise,
   //   0 is returned.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | void'( int_dq.add( 123 ) );
   // | void'( int_dq.add( 456 ) );
   // | assert( int_dq.remove_last_occurrence( 123 ) == 1 );
   // | assert( int_dq.remove_last_occurrence( 789 ) == 0 );
   //
   // See Also:
   //   <remove>, <remove_first_occurrence>
   //---------------------------------------------------------------------------

   virtual function bit remove_last_occurrence( T e );
      int  qi[$];
      
      qi = q.find_last_index with ( cmp.eq( item, e ) );
      if ( qi.size() == 0 ) begin
	 return 0;
      end else begin
	 q.delete( qi[0] );
	 return 1;
      end
   endfunction: remove_last_occurrence

   //---------------------------------------------------------------------------
   // Function: size
   //   (VIRTUAL) Returns the number of elements in this deque.
   //
   // Returns:
   //   The number of elements in this deque.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // |
   // | void'( int_dq.add( 123 ) );
   // | assert( int_dq.size() == 1 );
   //---------------------------------------------------------------------------

   virtual function int size();
      return q.size();
   endfunction: size
   
endclass: deque

`endif //  `ifndef CL_DEQUE_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
