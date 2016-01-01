//==============================================================================
//
// cl_collection.svh (v0.6.1)
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

`ifndef CL_COLLECTION_SVH
`define CL_COLLECTION_SVH

//------------------------------------------------------------------------------
// Class: collection
//   (VIRTUAL) Defines the core functionality of a collection.
//
// Parameter:
//   T - (OPTIONAL) The type of collected data. The default is *int*.
//------------------------------------------------------------------------------

virtual class collection#( type T = int );

   //---------------------------------------------------------------------------
   // Typedef: da_type
   //   The shorthand of the dynamic array of type *T*.
   //---------------------------------------------------------------------------

   typedef T da_type[];

   //---------------------------------------------------------------------------
   // Property: cmp
   //   (PROTECTED) A comparator to compare the elements of type *T*.
   //---------------------------------------------------------------------------
   
   protected comparator#( T ) cmp = null;

   //---------------------------------------------------------------------------
   // Property: fmtr
   //   (PROTECTED) An object that provides a function to convert the element of
   //   type *T* to a string.
   //---------------------------------------------------------------------------
   
   protected formatter#( T ) fmtr = null;

   //---------------------------------------------------------------------------
   // Function: add
   //   (VIRTUAL) Adds the given element.
   //
   // Argument:
   //   e - An element to be added.
   //
   // Returns:
   //   If this collection changed as a result of the call, 1 is returned. 
   //   Otherwise, 0 is returned.
   //---------------------------------------------------------------------------

   virtual function bit add( T e );

`ifdef CL_SUPPORT_FATAL_SEVERITY_TASK
      $fatal( 2, "add() is not supported" );
`else
      $display( "add() is not supported" );
      $finish( 2 );
`endif

      return 0;
   endfunction: add

   //---------------------------------------------------------------------------
   // Function: add_all
   //   (VIRTUAL) Adds all of the elements in the given collection to this
   //   collection.
   //
   // Argument:
   //   c - A collection containing elements to be added to this collection.
   //
   // Returns:
   //   If this collection changed as a result of the call, 1 is returned. 
   //   Otherwise, 0 is returned.
   //---------------------------------------------------------------------------

   virtual function bit add_all( collection#( T ) c );
      iterator#( T ) it = c.get_iterator();
      bit  result = 0;

      while ( it.has_next() ) result |= this.add( it.next() );
      return result;
   endfunction: add_all

   //---------------------------------------------------------------------------
   // Function: clear
   //   (VIRTUAL) Removes all of the elements from this collection.
   //
   // Returns:
   //   None.
   //---------------------------------------------------------------------------

   virtual function void clear();
      iterator#( T ) it = this.get_iterator();
      T item;
      
      while ( it.has_next() ) begin
	 item = it.next();
	 it.remove();
      end
   endfunction: clear

   //---------------------------------------------------------------------------
   // Function: contains
   //   (VIRTUAL) Returns 1 if this collection contains the specified element.
   //
   // Argument:
   //   e - An element to be tested.
   //
   // Returns:
   //   If this collection contains the specified element, returns 1. Otherwise,
   //   returns 0.
   //---------------------------------------------------------------------------
   
   virtual function bit contains( T e );
      iterator#( T ) it = this.get_iterator();
      while ( it.has_next() ) begin
	 T item = it.next();

	 if ( cmp.eq( e, item ) ) return 1;
      end
      return 0;
   endfunction: contains
   
   //---------------------------------------------------------------------------
   // Function: contains_all
   //   (VIRTUAL) Returns 1 if this collection contains all of the elements in
   //   the specified collection.
   //
   // Argument:
   //   c - A collection to be checked.
   //
   // Returns:
   //   If this collection contains all of the elements in the specified
   //   collection, returns 1. Otherwise, returns 0.
   //---------------------------------------------------------------------------

   virtual function bit contains_all( collection#( T ) c );
      iterator #( T ) it = c.get_iterator();
      while ( it.has_next() ) begin
	 if ( this.contains( it.next() ) == 0 ) return 0;
      end
      return 1;
   endfunction: contains_all
   
   //---------------------------------------------------------------------------
   // Function: is_empty
   //   (VIRTUAL) Returns 1 if this collection contains no elements.
   //
   // Returns:
   //   If this collection contains no elements, returns 1. Otherwise, returns
   //   0.
   //---------------------------------------------------------------------------

   virtual function bit is_empty();
      return this.size() == 0;
   endfunction: is_empty

   //---------------------------------------------------------------------------
   // Function: get_iterator
   //   (PURE) (VIRTUAL) Returns an iterator over the elements contained in this
   //   collection.
   //
   // Returns:
   //   An iterator over the elements contained in this collection.
   //---------------------------------------------------------------------------

   pure virtual function iterator#( T ) get_iterator();

   //---------------------------------------------------------------------------
   // Function: remove
   //   (VIRTUAL) Removes the specified element from this collection.
   //
   // Argument:
   //   e - An element to be removed.
   //
   // Returns:
   //   If this collection changed as a result of the call, 1 is returned. 
   //   Otherwise, 0 is returned.
   //---------------------------------------------------------------------------

   virtual function bit remove( T e );
      iterator#( T ) it = this.get_iterator();
      while ( it.has_next() ) begin
	 T item = it.next();
	 if ( cmp.eq( e, item ) ) begin
	    it.remove();
	    return 1;
	 end
      end
      return 0;
   endfunction: remove

   //---------------------------------------------------------------------------
   // Function: remove_all
   //   (VIRTUAL) Removes the elements in the given collection from this
   //   collection.
   //
   // Argument:
   //   c - A collection containing elements to be removed from this collection.
   //
   // Returns:
   //   If this collection changed as a result of the call, 1 is returned. 
   //   Otherwise, 0 is returned.
   //---------------------------------------------------------------------------

   virtual function bit remove_all( collection#( T ) c );
      iterator #( T ) it = this.get_iterator();
      bit  result = 0;
      
      while ( it.has_next() ) begin
	 if ( c.contains( it.next() ) ) begin
	    it.remove();
	    result = 1;
	 end
      end	 
      return result;
   endfunction: remove_all

   //---------------------------------------------------------------------------
   // Function: retain_all
   //   (VIRTUAL) Retains only the elements in this collection that are
   //   contained in the specified collection.
   //
   // Argument:
   //   c - A collection containing elements to be retained in this collection.
   //
   // Returns:
   //   If this collection changed as a result of the call, 1 is returned. 
   //   Otherwise, 0 is returned.
   //---------------------------------------------------------------------------

   virtual function bit retain_all( collection#( T ) c );
      iterator #( T ) it = this.get_iterator();
      bit  result = 0;
      
      while ( it.has_next() ) begin
	 if ( c.contains( it.next() ) == 0 ) begin
	    it.remove();
	    result = 1;
	 end
      end	 
      return result;
   endfunction: retain_all

   //---------------------------------------------------------------------------
   // Function: size
   //   (VIRTUAL) Returns the number of elements in this collection.
   //
   // Returns:
   //   The number of elements in this collection.
   //---------------------------------------------------------------------------

   virtual function int size();
      iterator #( T ) it = this.get_iterator();
      int cnt = 0;
      
      while ( it.has_next() ) begin
	 void'( it.next() );
	 cnt++;
      end	 
      return cnt;
   endfunction: size

   //---------------------------------------------------------------------------
   // Function: to_dynamic_array
   //   (VIRTUAL) Returns a new dynamic array that contains the elements in this
   //   collection.
   //
   // Returns:
   //   A new dynamic array that contains the elements in this collection.
   //---------------------------------------------------------------------------

   virtual function da_type to_dynamic_array();
      iterator#( T ) it = this.get_iterator();
      int  i = 0;
      da_type da = new[ this.size() ];

      while ( it.has_next() ) da[i++] = it.next();
      return da;
   endfunction: to_dynamic_array

   //---------------------------------------------------------------------------
   // Function to_string
   //   (VIRTUAL) Returns a string representation of this collection.
   //
   // Returns:
   //   A string that represents this collection.
   //---------------------------------------------------------------------------

   virtual function string to_string();
      string s;
      iterator #( T ) it = this.get_iterator();

      s = "[ ";
      while ( it.has_next() )
	s = { s, fmtr.to_string( it.next() ), " " };
      s = { s, "]" };
      return s;
   endfunction: to_string

endclass: collection

`endif //  `ifndef CL_COLLECTION_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
