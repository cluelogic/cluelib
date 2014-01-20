//==============================================================================
//
// cl_list_base.svh (v0.1.0)
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

`ifndef CL_LIST_BASE_SVH
`define CL_LIST_BASE_SVH

typedef class sub_list_base;

//------------------------------------------------------------------------------
// Class: list_base
//   Provides the default implementations of list functions.
//------------------------------------------------------------------------------

virtual class list_base #( type T = int ) extends collection#( T );

   protected int mod_count;

   //---------------------------------------------------------------------------
   // Function: add
   //   Appends the given item to the end of this list.
   //
   // Argument:
   //   e - Item to be appended to this list.
   //
   // Returns:
   //   Always returns 1.
   //---------------------------------------------------------------------------

   virtual function bit add( T e );
      add_at( size(), e );
      return 1;
   endfunction: add

   //---------------------------------------------------------------------------
   // Function: add_at
   //   Inserts the given item at the given position in this list.
   //
   // Argument:
   //   index - Index at which the given item is to be inserted.
   //   e     - Item to be inserted.
   //---------------------------------------------------------------------------

   virtual function void add_at( int index, T e );
      $fatal( 1, "add_at() is not supported" );
   endfunction: add_at

   //---------------------------------------------------------------------------
   // Function: add_all_at
   //   Inserts all of the items in the given collection into this list
   //   at the given position.
   //
   // Argument:
   //   index - Index at which to insert the first item from the given
   //           collection.
   //   c     - Collection containing items to be added to this list.
   //
   // Returns:
   //   1 if this list changed as a result of the call.
   //---------------------------------------------------------------------------

   virtual function bit add_all_at( int index, collection#( T ) c );
      iterator#( T ) it = c.get_iterator();
      int  i = index;

      while ( it.has_next() ) add_at( i++, it.next() );
      return ( i != index );
   endfunction: add_all_at

   //---------------------------------------------------------------------------
   // Function: clear
   //   Removes all of the items from this list.
   //---------------------------------------------------------------------------

   virtual function void clear();
      remove_range( 0, size() );
   endfunction: clear

   //---------------------------------------------------------------------------
   // Function: equals
   //   Returns 1 if the given collection equals this list.
   //
   // Argument:
   //   c - A collection to compare with.
   //
   // Returns:
   //   If the given collection is this list, returns 1. If the size of the
   //   given collection is not the same as the size of this list, returns 0. If
   //   the sizes are the same and all the items in the given collection are
   //   the same as those of this list, returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   virtual function bit equals( collection#(T) c );
      iterator#( T ) it;
      iterator#( T ) c_it;

      if ( this == c ) return 1;
      if ( this.size() != c.size() ) return 0;
      
      it = this.get_iterator();
      c_it = c.get_iterator();
      while ( it.has_next() ) begin
	 if ( cmp ) begin
	    if ( cmp.ne( it.next(), c_it.next() ) ) return 0;
	 end else begin
	    if ( default_cmp.ne( it.next(), c_it.next() ) ) return 0;
	 end
      end
      return 1;
   endfunction: equals

   //---------------------------------------------------------------------------
   // Function: get_at
   //   Retrieves the item at the given position.
   //
   // Argument:
   //   index - The index of the item to return.
   //
   // Returns:
   //   The item at the given position.
   //---------------------------------------------------------------------------

   pure virtual function T get_at( int index );

   //---------------------------------------------------------------------------
   // Function hash_code
   //---------------------------------------------------------------------------
/*
   virtual function int hash_code();
   endfunction: hash_code
*/
   //---------------------------------------------------------------------------
   // Function: index_of
   //   Returns the index of the first occurrence of the given item in this
   //   list.
   //
   // Argument:
   //   e - An item to search for.
   //
   // Returns:
   //   The index of the first occurrence of *e* if found. Returns -1 if *e* is
   //   not found.
   //---------------------------------------------------------------------------

   virtual function int index_of( T e );
      bidir_iterator#( T ) lit = this.get_bidir_iterator();
      int  i = 0;

      while ( lit.has_next() ) begin
	 if ( cmp ) begin
	    if ( cmp.eq( lit.next(), e ) ) return i;
	 end else begin
	    if ( default_cmp.eq( lit.next(), e ) ) return i;
	 end
	 i++;
      end
      return -1;
   endfunction: index_of
   
   //---------------------------------------------------------------------------
   // Function: last_index_of
   //   Returns the index of the last occurrence of the given item in this
   //   list.
   //
   // Argument:
   //   e - An item to search for.
   //
   // Returns:
   //   The index of the last occurrence of *e* if found. Returns -1 if *e* is
   //   not found.
   //---------------------------------------------------------------------------

   virtual function int last_index_of( T e );
      bidir_iterator#( T ) lit = this.get_bidir_iterator( size() );
      int  i = 0;

      while ( lit.has_previous() ) begin
	 if ( cmp ) begin
	    if ( cmp.eq( lit.previous(), e ) ) return i;
	 end else begin
	    if ( default_cmp.eq( lit.previous(), e ) ) return i;
	 end
	 i++;
      end
      return -1;
   endfunction: last_index_of
   
   //---------------------------------------------------------------------------
   // Function: get_bidir_iterator
   //   Returns a list iterator over the items contained in this list.
   //
   // Argument:
   //   index - (OPTIONAL) The index of the first item to be returned from
   //   the list iterator. The default is 0.
   //
   // Returns:
   //   A list iterator over the items contained in this list.
   //---------------------------------------------------------------------------

   pure virtual function bidir_iterator#( T ) get_bidir_iterator( int index = 0 );

   //---------------------------------------------------------------------------
   // Function: remove_at
   //   Removes the item at the given position.
   //
   // Argument:
   //   index - The index of the item to be removed.
   //
   // Returns:
   //   The item that was removed from this list.
   //---------------------------------------------------------------------------

   virtual function T remove_at( int index );
      T dummy;
      
      $fatal( 1, "remove_at() is not supported" );
      return dummy;
   endfunction: remove_at

   //---------------------------------------------------------------------------
   // Function: remove_range
   //   Removes the items from *from_index* (inclusive) to *to_index*
   //   (exclusive).
   //
   // Argument:
   //   from_index - The index of the first item to be removed.
   //   to_index   - The index of the one before the last item to be removed.
   //---------------------------------------------------------------------------

   virtual protected function void remove_range( int from_index, int to_index );
      bidir_iterator#( T ) lit = this.get_bidir_iterator( from_index - 1 );
      int  i = from_index;

      while ( lit.has_next() && i < to_index ) begin
	 T item = lit.next();
	 lit.remove();
	 i++;
      end
   endfunction: remove_range

   //---------------------------------------------------------------------------
   // Function: set_at
   //   Replaces the item at the given position with the given item.
   //
   // Argument:
   //   index - The index of the item to replace.
   //   e     - An item to be set.
   //
   // Returns:
   //   The item that was replaced.
   //---------------------------------------------------------------------------

   virtual function T set_at( int index, T e );
      T dummy;
      
      $fatal( 1, "set_at() is not supported" );
      return dummy;
   endfunction: set_at

   //---------------------------------------------------------------------------
   // Function: sub_list
   //   Returns a sub-list view of this list from *from_index* (inclusive) to
   //   *to_index* (exclusive).
   //
   // Argument:
   //   from_index - The index of the first item of the sub-list.
   //   to_index   - The index of the one before the last item of the 
   //                sub-list.
   //
   // Returns:
   //   A sub-list of this list.
   //---------------------------------------------------------------------------

   virtual function list_base#(T) sub_list( int from_index, int to_index );
      sub_list_base#(T) sl = new( this, from_index, to_index );

      return sl;
   endfunction: sub_list

endclass: list_base

`endif //  `ifndef CL_LIST_BASE_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
