//==============================================================================
//
// cl_deque.svh (v0.1.0)
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
//==============================================================================

`ifndef CL_DEQUE_SVH
`define CL_DEQUE_SVH

//------------------------------------------------------------------------------
// Class: deque
//   Implements a double-ended queue using a queue.
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
   //   cmp  - (OPTIONAL) A comparator to compare the elements of type *T*. If
   //          not specified or null, <comparator> #(T) is used. The default is
   //          null.
   //   fmtr - (OPTIONAL) An object that provides a function to convert the
   //           element of type *T* to a string. If not specified or null,
   //           <formatter> #(T) is used. The default is null.
   //
   // Example:
   // | deque#(int) int_dq = new();
   //---------------------------------------------------------------------------

   function new( collection#(T) c = null,
		 comparator#(T) cmp = null,
		 formatter#(T) fmtr = null );
      this.cmp  = cmp;
      this.fmtr = fmtr;
      if ( c ) void'( this.add_all( c ) );
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: add
   //   Adds the given element at the end of this deque.
   //
   // Argument:
   //   e - An element to be added to this deque.
   //
   // Returns:
   //   Always returns 1.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | assert( int_dq.add( 0 ) == 1 );
   //---------------------------------------------------------------------------

   virtual function bit add( T e );
      add_last( e );
      return 1;
   endfunction: add

   //---------------------------------------------------------------------------
   // Function: add_first
   //   Adds the given element at the front of this deque.
   //
   // Argument:
   //   e - An element to be added to this deque.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | int_dq.add_first( 0 );
   //---------------------------------------------------------------------------

   virtual function void add_first( T e );
      q.push_front( e );
   endfunction: add_first

   //---------------------------------------------------------------------------
   // Function: add_last
   //   Adds the given element at the end of this deque.
   //
   // Argument:
   //   e - An element to be added to this deque.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | int_dq.add_last( 0 );
   //---------------------------------------------------------------------------

   virtual function void add_last( T e );
      q.push_back( e );
   endfunction: add_last

   //---------------------------------------------------------------------------
   // Function: clear
   //   Removes all of the elements from this deque.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | int_dq.clear();
   //---------------------------------------------------------------------------

   virtual function void clear();
      q.delete();
   endfunction: clear

   //---------------------------------------------------------------------------
   // Function: clone
   //   Returns a shallow copy of this deque. The element themselves are not
   //   cloned.
   //
   // Returns:
   //   A copy of this deque.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | collection#(int) cloned_int_dq;
   // | cloned_int_dq = int_dq.clone();
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
   //   Returns 1 if this deque contains the specified element.
   //
   // Argument:
   //   e - An element to be checked.
   //
   // Returns:
   //   If this deque contains *e*, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | int_dq.add( 0 );
   // | assert( int_dq.contains( 0 ) == 1 );
   // | assert( int_dq.contains( 1 ) == 0 );
   //---------------------------------------------------------------------------

   virtual function bit contains( T e );
      int  qi[$];
      
      if ( cmp )
	qi = q.find_first_index with ( cmp.eq( item, e ) );
      else
	qi = q.find_first_index with (collection#(T)::default_cmp.eq(item, e));
      return qi.size() != 0;
   endfunction: contains

   //---------------------------------------------------------------------------
   // Function: get
   //   Retrieves the head of the deque and remove the element. This function 
   //   is equivalent to *get_first()*.
   //
   // Argument:
   //   e - The head of the deque to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   virtual function bit get( ref T e );
      return get_first( e );
   endfunction: get

   //---------------------------------------------------------------------------
   // Function: get_first
   //   Retrieves the head of the deque and remove the element.
   //
   // Argument:
   //   e - The head of the deque to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
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
   //   Retrieves the tail of the deque and remove the element.
   //
   // Argument:
   //   e - The tail of the deque to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
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
   //   Returns an iterator over the elements in this deque.
   //
   // Returns:
   //   An iterator.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | iterator#(int) it = int_dq.get_iterator();
   // | while ( it.has_next() ) $display( it.next() );
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
   //   Returns an iterator over the elements in this deque in reverse order.
   //
   // Returns:
   //   An iterator.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | iterator#(int) it = int_dq.get_descending_iterator();
   // | while ( it.has_next() ) $display( it.next() );
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
   //   Retrieves the head of the deque but does not remove the element. This
   //   function is equivalent to *peek_first()*.
   //
   // Argument:
   //   e - The head of the deque to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   virtual function bit peek( ref T e );
      return peek_first( e );
   endfunction: peek

   //---------------------------------------------------------------------------
   // Function: peek_first
   //   Retrieves the head of the deque but does not remove the element.
   //
   // Argument:
   //   e - The head of the deque to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
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
   //   Retrieves the tail of the deque but does not remove the element.
   //
   // Argument:
   //   e - The tail of the deque to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
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
   //   Pops an element from the deque as if it is a stack.
   //
   // Returns:
   //   The head of the deque. If the deque is empty, the behavior is undefined.
   //----------------------------------------------------------------------------

   virtual function T pop();
      // T o;
      //
      // if ( is_empty() ) return o;
      // else              return q.pop_front();

      return q.pop_front();
   endfunction: pop

   //----------------------------------------------------------------------------
   // Function: push
   //   Pushes an element to the deque as if it is a stack.
   //
   // Argument:
   //   e - An element to push.
   //----------------------------------------------------------------------------

   virtual function void push( T e );
      q.push_front( e );
   endfunction: push

   //---------------------------------------------------------------------------
   // Function: remove
   //   Removes the specified element from this deque. This function is
   //   equivalent to *remove_first_occurrence()*.
   //
   // Argument:
   //   e - An element to be removed.
   //
   // Returns:
   //   If this deque changed as a result of the call, 1 is returned. Otherwise,
   //   0 is returned.
   //---------------------------------------------------------------------------

   virtual function bit remove( T e );
      return remove_first_occurrence( e );
   endfunction: remove

   //---------------------------------------------------------------------------
   // Function: remove_first
   //   Removes the first element from this deque.
   //
   // Returns:
   //   If this deque is not empty, 1 is returned. Otherwise, 0 is returned.
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
   //   Removes the last element from this deque.
   //
   // Returns:
   //   If this deque is not empty, 1 is returned. Otherwise, 0 is returned.
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
   //   Removes the first occurrence of the specified element by traversing the
   //   deque from head to tail.
   //
   // Argument:
   //   e - An element to be removed.
   //
   // Returns:
   //   If this deque changed as a result of the call, 1 is returned. Otherwise,
   //   0 is returned.
   //---------------------------------------------------------------------------

   virtual function bit remove_first_occurrence( T e );
      int  qi[$];
      
      if ( cmp )
	qi = q.find_first_index with ( cmp.eq( item, e ) );
      else
	qi = q.find_first_index with (collection#(T)::default_cmp.eq(item, e));

      if ( qi.size() == 0 ) begin
	 return 0;
      end else begin
	 q.delete( qi[0] );
	 return 1;
      end
   endfunction: remove_first_occurrence

   //---------------------------------------------------------------------------
   // Function: remove_last_occurrence
   //   Removes the last occurrence of the specified element by traversing the
   //   deque from tail to head.
   //
   // Argument:
   //   e - An element to be removed.
   //
   // Returns:
   //   If this deque changed as a result of the call, 1 is returned. Otherwise,
   //   0 is returned.
   //---------------------------------------------------------------------------

   virtual function bit remove_last_occurrence( T e );
      int  qi[$];
      
      if ( cmp )
	qi = q.find_last_index with ( cmp.eq( item, e ) );
      else
	qi = q.find_last_index with ( collection#(T)::default_cmp.eq(item, e) );

      if ( qi.size() == 0 ) begin
	 return 0;
      end else begin
	 q.delete( qi[0] );
	 return 1;
      end
   endfunction: remove_last_occurrence

   //---------------------------------------------------------------------------
   // Function: size
   //   Returns the number of elements in this deque.
   //
   // Returns:
   //   The number of elements in this deque.
   //
   // Example:
   // | deque#(int) int_dq = new();
   // | int_dq.add( 0 );
   // | assert( int_dq.size() == 1 );
   //---------------------------------------------------------------------------

   virtual function int size();
      return q.size();
   endfunction: size
   
endclass: deque

`endif //  `ifndef CL_DEQUE_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
