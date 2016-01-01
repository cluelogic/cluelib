//==============================================================================
//
// cl_set_base.svh (v0.6.1)
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

`ifndef CL_SET_BASE_SVH
`define CL_SET_BASE_SVH

//------------------------------------------------------------------------------
// Class: set_base
//   (VIRTUAL) Defines the core functionality of a <set>.
//
// Parameter:
//   T - (OPTIONAL) The type of data collected in a <set>. The default is *int*.
//------------------------------------------------------------------------------

virtual class set_base #( type T = int ) extends collection#( T );

   //---------------------------------------------------------------------------
   // Function: equals
   //   (VIRTUAL) Returns 1 if the given collection equals this set.
   //
   // Argument:
   //   c - A collection to compare with.
   //
   // Returns:
   //   If the given collection is this set, returns 1. If the size of the given
   //   collection is not the same as the size of this set, returns 0. If the
   //   sizes are the same and this set contains all the elements in the given
   //   collection, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | set#(int) int_set0 = new();
   // | set#(int) int_set1 = new();
   // |
   // | void'( int_set0.add( 123 ) );
   // | void'( int_set1.add( 123 ) );
   // | assert( int_set0.equals( int_set1 ) == 1 );
   //---------------------------------------------------------------------------

   virtual function bit equals( collection#(T) c );
      if ( this == c ) return 1;
      if ( this.size() != c.size() ) return 0;
      return this.contains_all( c );
   endfunction: equals
      
   //---------------------------------------------------------------------------
   // Function hash_code
   //---------------------------------------------------------------------------
/*
   virtual function int hash_code();
   endfunction: hash_code
*/
   //---------------------------------------------------------------------------
   // Function: remove_all
   //   (VIRTUAL) Removes the elements in the given collection from this set.
   //
   // Argument:
   //   c - A collection containing elements to be removed from this set.
   //
   // Returns:
   //   If this set changed as a result of the call, 1 is returned.  Otherwise,
   //   0 is returned.
   //
   // Example:
   // | set#(int) int_set0 = new();
   // | set#(int) int_set1 = new();
   // |
   // | void'( int_set0.add( 123 ) );
   // | void'( int_set0.add( 456 ) );
   // | void'( int_set1.add( 123 ) );
   // | assert( int_set0.remove_all( int_set1 ) == 1 );
   //---------------------------------------------------------------------------

   virtual function bit remove_all( collection#(T) c );
      bit  result = 0;
      
      if ( this.size() < c.size() ) begin
	 iterator#( T ) it = this.get_iterator();
	 while ( it.has_next() ) begin
	    if ( c.contains( it.next() ) ) begin
	       it.remove();
	       result = 1;
	    end
	 end
      end else begin // 'c' has fewer elements
	 iterator#( T ) it = c.get_iterator();
	 while ( it.has_next() ) result |= this.remove( it.next() );
      end // else: !if( this.size() < c.size() )
      return result;
   endfunction: remove_all

endclass: set_base

`endif //  `ifndef CL_SET_BASE_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
