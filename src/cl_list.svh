//==============================================================================
//
// cl_list.svh (v0.1.0)
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

`ifndef CL_LIST_SVH
`define CL_LIST_SVH

//------------------------------------------------------------------------------
// Class: list
//   Implements an list_base using a queue.
//------------------------------------------------------------------------------

class list #( type T = int ) extends list_base#( T );
   
`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
/*
   local T q[$];
   
   class list_iterator #( type T = int ) extends iterator#( T );
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

   endclass: list_iterator

   class list_descending_iterator #( type T = int ) extends iterator#( T );
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

   endclass: list_descending_iterator
*/
`else // !`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
   T q[$];
`endif // !`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new list.
   //
   // Argument:
   //   c    - (OPTIONAL) A collection whose elements are to be added to this 
   //          list.
   //   cmp  - (OPTIONAL) A comparator to compare the elements of type *T*. If
   //          not specified or null, <comparator> #(T) is used. The default is
   //          null.
   //   fmtr - (OPTIONAL) An object that provides a function to convert the
   //           element of type *T* to a string. If not specified or null,
   //           <formatter> #(T) is used. The default is null.
   //
   // Example:
   // | list#(int) int_dq = new();
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
   //   Adds the given element at the end of this list.
   //
   // Argument:
   //   e - An element to be added to this list.
   //
   // Returns:
   //   Always returns 1.
   //
   // Example:
   // | list#(int) int_l = new();
   // | assert( int_l.add( 0 ) == 1 );
   //---------------------------------------------------------------------------

   virtual function bit add( T e );
      q.push_back( e );
      return 1;
   endfunction: add

   //---------------------------------------------------------------------------
   // Function: add_at
   //   Adds the given element at the specified position.
   //
   // Argument:
   //   index - The position at which the given element is to be added.
   //   e     - An element to be added.
   //---------------------------------------------------------------------------

   virtual function void add_at( int index, T e );
      q.insert( index, e );
   endfunction: add_at

   //!!!!!!!!!!!!!!!!!!!! TO BE CONTINUED FROM HERE !!!!!!!!!!!!!!!!!!!!
   //!!!!!!!!!!!!!!!!!!!! TO BE CONTINUED FROM HERE !!!!!!!!!!!!!!!!!!!!
   //!!!!!!!!!!!!!!!!!!!! TO BE CONTINUED FROM HERE !!!!!!!!!!!!!!!!!!!!

/*
   //---------------------------------------------------------------------------
   // Function: add_first
   //   Adds the given element at the front of this list.
   //
   // Argument:
   //   e - An element to be added to this list.
   //
   // Example:
   // | list#(int) int_l = new();
   // | int_l.add_first( 0 );
   //---------------------------------------------------------------------------

   virtual function void add_first( T e );
      q.push_front( e );
   endfunction: add_first

   //---------------------------------------------------------------------------
   // Function: add_last
   //   Adds the given element at the end of this list.
   //
   // Argument:
   //   e - An element to be added to this list.
   //
   // Example:
   // | list#(int) int_l = new();
   // | int_l.add_last( 0 );
   //---------------------------------------------------------------------------

   virtual function void add_last( T e );
      q.push_back( e );
   endfunction: add_last

   //---------------------------------------------------------------------------
   // Function: clear
   //   Removes all of the elements from this list.
   //
   // Example:
   // | list#(int) int_l = new();
   // | int_l.clear();
   //---------------------------------------------------------------------------

   virtual function void clear();
      q.delete();
   endfunction: clear

   //---------------------------------------------------------------------------
   // Function: clone
   //   Returns a shallow copy of this list. The element themselves are not
   //   cloned.
   //
   // Returns:
   //   A copy of this list.
   //
   // Example:
   // | list#(int) int_l = new();
   // | collection#(int) cloned_int_l;
   // | cloned_int_l = int_l.clone();
   //---------------------------------------------------------------------------

   virtual function collection#( T ) clone();
      list#( T ) l = new();
      l.q    = q; // the elements themselves are not cloned
      l.cmp  = cmp;
      l.fmtr = fmtr;
      return l;
   endfunction: clone

   //---------------------------------------------------------------------------
   // Function: contains
   //   Returns 1 if this list contains the specified element.
   //
   // Argument:
   //   e - An element to be checked.
   //
   // Returns:
   //   If this list contains *e*, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | list#(int) int_l = new();
   // | int_l.add( 0 );
   // | assert( int_l.contains( 0 ) == 1 );
   // | assert( int_l.contains( 1 ) == 0 );
   //---------------------------------------------------------------------------

   virtual function bit contains( T e );
      int  qi[$];
      
      if ( cmp )
	qi = q.find_first_index with ( cmp.eq( item, e ) );
      else
	qi = q.find_first_index with (collection#(T)::default_cmp.eq(item, e));
      return qi.size() != 0;
   endfunction: contains
*/
   //---------------------------------------------------------------------------
   // Function: get_at
   //   Retrieves the element at the given position.
   //
   // Argument:
   //   index - The index of the element to return.
   //
   // Returns:
   //   The element at the given position.
   //---------------------------------------------------------------------------

   virtual function T get_at( int index );
      return q[index];
   endfunction: get_at
/*
   //---------------------------------------------------------------------------
   // Function: get_first
   //   Retrieves the head of the list and remove the element.
   //
   // Argument:
   //   e - The head of the list to be returned.
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
   //   Retrieves the tail of the list and remove the element.
   //
   // Argument:
   //   e - The tail of the list to be returned.
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
*/
   //---------------------------------------------------------------------------
   // Function: get_iterator
   //   Returns an iterator over the elements in this list.
   //
   // Returns:
   //   An iterator.
   //
   // Example:
   // | list#(int) int_l = new();
   // | iterator#(int) it = int_l.get_iterator();
   // | while ( it.has_next() ) $display( it.next() );
   //---------------------------------------------------------------------------

   virtual function iterator#( T ) get_iterator();

`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
      list_iterator#( T ) it = new();
`else
      list_iterator#( T ) it = new( this );
`endif      

      return it;
   endfunction: get_iterator

   //---------------------------------------------------------------------------
   // Function: get_bidir_iterator
   //   Returns a bidierectional iterator over the elements in this list.
   //
   // Returns:
   //   An iterator.
   //
   // Example:
   // | list#(int) int_l = new();
   // | bidir_iterator#(int) it = int_l.get_bidir_iterator();
   // | while ( it.has_next() ) $display( it.next() );
   //---------------------------------------------------------------------------

   virtual function bidir_iterator#( T ) get_bidir_iterator( int index = 0 );

`ifdef CL_SUPPORT_PARAMETERIZED_NESTED_CLASS
      list_bidir_iterator#( T ) it = new( index );
`else
      list_bidir_iterator#( T ) it = new( this, index );
`endif      

      return it;
   endfunction: get_bidir_iterator
/*
   //---------------------------------------------------------------------------
   // Function: peek
   //   Retrieves the head of the list but does not remove the element. This
   //   function is equivalent to *peek_first()*.
   //
   // Argument:
   //   e - The head of the list to be returned.
   //
   // Returns:
   //   If *e* is valid, returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   virtual function bit peek( ref T e );
      return peek_first( e );
   endfunction: peek

   //---------------------------------------------------------------------------
   // Function: peek_first
   //   Retrieves the head of the list but does not remove the element.
   //
   // Argument:
   //   e - The head of the list to be returned.
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
   //   Retrieves the tail of the list but does not remove the element.
   //
   // Argument:
   //   e - The tail of the list to be returned.
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
   //   Pops an element from the list as if it is a stack.
   //
   // Returns:
   //   The head of the list. If the list is empty, the behavior is undefined.
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
   //   Pushes an element to the list as if it is a stack.
   //
   // Argument:
   //   e - An element to push.
   //----------------------------------------------------------------------------

   virtual function void push( T e );
      q.push_front( e );
   endfunction: push

   //---------------------------------------------------------------------------
   // Function: remove
   //   Removes the specified element from this list. This function is
   //   equivalent to *remove_first_occurrence()*.
   //
   // Argument:
   //   e - An element to be removed.
   //
   // Returns:
   //   If this list changed as a result of the call, 1 is returned. Otherwise,
   //   0 is returned.
   //---------------------------------------------------------------------------

   virtual function bit remove( T e );
      return remove_first_occurrence( e );
   endfunction: remove

   //---------------------------------------------------------------------------
   // Function: remove_first
   //   Removes the first element from this list.
   //
   // Returns:
   //   If this list is not empty, 1 is returned. Otherwise, 0 is returned.
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
   //   Removes the last element from this list.
   //
   // Returns:
   //   If this list is not empty, 1 is returned. Otherwise, 0 is returned.
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
   //   list from head to tail.
   //
   // Argument:
   //   e - An element to be removed.
   //
   // Returns:
   //   If this list changed as a result of the call, 1 is returned. Otherwise,
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
   //   list from tail to head.
   //
   // Argument:
   //   e - An element to be removed.
   //
   // Returns:
   //   If this list changed as a result of the call, 1 is returned. Otherwise,
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
*/
   //---------------------------------------------------------------------------
   // Function: size
   //   Returns the number of elements in this list.
   //
   // Returns:
   //   The number of elements in this list.
   //
   // Example:
   // | list#(int) int_l = new();
   // | int_l.add( 0 );
   // | assert( int_l.size() == 1 );
   //---------------------------------------------------------------------------

   virtual function int size();
      return q.size();
   endfunction: size

endclass: list

`endif //  `ifndef CL_LIST_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
