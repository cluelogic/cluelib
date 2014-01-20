//==============================================================================
//
// cl_sub_list_base.svh (v0.1.0)
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
// ==============================================================================

`ifndef CL_SUB_LIST_BASE_SVH
`define CL_SUB_LIST_BASE_SVH

//------------------------------------------------------------------------------
// Class: sub_list_base
//   Defines the core functionality of a list.
//------------------------------------------------------------------------------

virtual class sub_list_base #( type T = int ) extends list_base#( T );

   local list_base#(T) backed_list;
   local int offset;
   local int sub_list_size;
   
   //---------------------------------------------------------------------------
   // Function: new
   //---------------------------------------------------------------------------

   function new( list_base#(T) backed_list, int from_index, int to_index );
      this.backed_list = backed_list;
      offset = from_index;
      sub_list_size = to_index - from_index;
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: add_at
   //   Adds the given element at the specified position.
   //
   // Argument:
   //   index - The position at which the given element is to be added.
   //   e     - An element to be added.
   //---------------------------------------------------------------------------

   virtual function void add_at( int index, T e );
      if ( index < sub_list_size )
	backed_list.add_at( index + offset, e );
      else
	$fatal( "add_at: index=%0d must be less than %0d", index, sub_list_size );
   endfunction: add_at

   //---------------------------------------------------------------------------
   // Function: add_all
   //   Adds all of the elements in the given collection to this sub-list.
   //
   // Argument:
   //   c - Collection containing elements to be added to this sub-list.
   //
   // Returns:
   //   If this sub-list changed as a result of the call, 1 is returned. 
   //   Otherwise, 0 is returned.
   //---------------------------------------------------------------------------

   virtual function bit add_all( collection#( T ) c );
      return add_all_at( size(), c );
   endfunction: add_all

   //---------------------------------------------------------------------------
   // Function: add_all_at
   //   Adds all of the elements in the given collection to this list at the
   //   specified position.
   //
   // Argument:
   //   index - The position at which the first element of the given collection
   //           is to be added.
   //   c     - Collection containing elements to be added to this list.
   //
   // Returns:
   //   If this list changed as a result of the call, 1 is returned.  Otherwise,
   //   0 is returned.
   //---------------------------------------------------------------------------

   virtual function bit add_all_at( int index, collection#( T ) c );
      if ( index < sub_list_size ) begin
	 return backed_list.add_all_at( index + offset, c );
      end else begin
	 $fatal( "add_all_at: index=%0d must be less than %0d", index, sub_list_size );
	 return 0;
      end
   endfunction: add_all_at

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
      if ( index < sub_list_size ) begin
	 return backed_list.get_at( index );
      end else begin
	 T dummy;
	 
	 $fatal( "get_at: index=%0d must be less than %0d", index, sub_list_size );
	 return dummy;
      end
   endfunction: get_at

   //---------------------------------------------------------------------------
   // Function: get_iterator
   //   Returns an iterator over the elements contained in this sub-list.
   //
   // Returns:
   //   An iterator over the elements contained in this sub-list.
   //---------------------------------------------------------------------------

   virtual function iterator#( T ) get_iterator();
      return get_bidir_iterator();
   endfunction: get_iterator

   //---------------------------------------------------------------------------
   // Function: get_bidir_iterator
   //   Returns a list iterator over the elements contained in this list.
   //
   // Argument:
   //   index - (OPTIONAL) The index of the first element to be returned from
   //   the list iterator. The default is 0.
   //
   // Returns:
   //   A list iterator over the elements contained in this list.
   //---------------------------------------------------------------------------

   virtual function bidir_iterator#( T ) get_bidir_iterator( int index = 0 );
      return null; // !!! change this later !!!
   endfunction: get_bidir_iterator

   //---------------------------------------------------------------------------
   // Function: remove_at
   //   Removes the element at the specified position.
   //
   // Argument:
   //   index - The index of the element to be removed.
   //
   // Returns:
   //   The element that was removed from this list.
   //---------------------------------------------------------------------------

   virtual function T remove_at( int index );
      if ( index < sub_list_size ) begin
	 return backed_list.remove_at( index );
      end else begin
	 T dummy;
	 
	 $fatal( "remove_at: index=%0d must be less than %0d", index, sub_list_size );
	 return dummy;
      end
   endfunction: remove_at

   //---------------------------------------------------------------------------
   // Function: remove_range
   //   Removes the elements from *from_index* (inclusive) to *to_index*
   //   (exclusive).
   //
   // Argument:
   //   from_index - The index of the first element to be removed.
   //   to_index   - The index of the one before the last element to be removed.
   //---------------------------------------------------------------------------

   virtual protected function void remove_range( int from_index, int to_index );
      if ( from_index < sub_list_size && to_index < sub_list_size )
	backed_list.remove_range( from_index, to_index );
      else
	$fatal( "remove_range: from_index=%0d and to_index=%0d must be less than %0d",
		from_index, to_index, sub_list_size );
   endfunction: remove_range

   //---------------------------------------------------------------------------
   // Function: set_at
   //   Replaces the element at the specified position with the given element.
   //
   // Argument:
   //   index - The index of the element to replace.
   //   e     - An element to be set.
   //
   // Returns:
   //   The element that was replaced.
   //---------------------------------------------------------------------------

   virtual function T set_at( int index, T e );
      if ( index < sub_list_size ) begin
	 return backed_list.set_at( index, e );
      end else begin
	 T dummy;
	 
	 $fatal( "set_at: index=%0d must be less than %0d", index, sub_list_size );
	 return dummy;
      end
   endfunction: set_at

   //---------------------------------------------------------------------------
   // Function: size
   //   Returns the number of elements in this sub-list.
   //
   // Returns:
   //   The number of elements in this sub-list.
   //---------------------------------------------------------------------------

   virtual function int size();
      return sub_list_size;
   endfunction: size

endclass: sub_list_base

`endif //  `ifndef CL_SUB_LIST_BASE_SVH

//==============================================================================
// Copyright (c) 2013, 2014 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
