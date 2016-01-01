//==============================================================================
//
// cl_kitchen_timer.svh (v0.6.1)
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

`ifndef CL_KITCHEN_TIMER_SVH
`define CL_KITCHEN_TIMER_SVH

//------------------------------------------------------------------------------
// Class: kitchen_timer
//   Counts a simulation time (not a wall clock time) and triggers an event once
//   the timer expires. This class is _not_ thread-safe.
//------------------------------------------------------------------------------

class kitchen_timer;
   typedef enum { STOPPED, RUNNING, PAUSED } state_e;
   
   local state_e state;
   local time    delay;
   local time 	 start_time;
   local time 	 elapsed;
   local time 	 remaining;

   //---------------------------------------------------------------------------
   // Event: ring
   //   Triggers when the specified delay elapsed.
   //---------------------------------------------------------------------------

   event ring;

   //---------------------------------------------------------------------------
   // Function: new
   //   Creates a new timer.
   //
   // Argumment:
   //   delay - (OPTIONAL) The delay for the timer to ring. The default is 0.
   //---------------------------------------------------------------------------

   function new( time delay = 0 );
      set_delay( delay );
   endfunction: new

   //---------------------------------------------------------------------------
   // Function: set_delay
   //   Sets the delay for the timer to ring. This function resets the timer.
   //
   // Argumment:
   //   delay - The delay for the timer to ring.
   //
   // Example:
   // | kitchen_timer kt = new();
   // | kt.set_delay( 100 );
   // | kt.start();
   // | @kt.ring;
   // | assert( kt.get_elapsed() == 100 );
   //---------------------------------------------------------------------------

   function void set_delay( time delay );
      this.delay = delay;
      reset();
   endfunction: set_delay

   //---------------------------------------------------------------------------
   // Function: add_delay
   //   Adds the specified delay. If the timer is currently running, the timer
   //   is paused, added the delay, then resumed.
   //
   // Argument:
   //   delay - The additional delay for the timer to ring.
   //---------------------------------------------------------------------------

   function void add_delay( time delay );
      if ( is_running() ) begin
	 pause();
	 this.delay += delay;
	 remaining  += delay;
	 resume();
      end else begin
	 this.delay += delay;
	 remaining  += delay;
      end
   endfunction: add_delay

   //---------------------------------------------------------------------------
   // Function: set_random_delay
   //   Set the random delay for the timer to ring between the specified
   //   range. This function resets the timer.
   //
   // Arguments:
   //   delay1 - The delay boundary 1.
   //   delay2 - The delay boundary 2. The delay is randomized between *delay1*
   //            and *delay2*, inclusive.
   //
   // Returns:
   //   The randomized delay value.
   //
   // Example:
   // | kitchen_timer kt = new();
   // | time random_delay = kt.set_random_delay( 100, 200 );
   // | kt.start();
   // | @kt.ring;
   // | assert( kt.get_elapsed() == random_delay );
   //---------------------------------------------------------------------------

   function time set_random_delay( time delay1,
				   time delay2 );
      if ( delay1 == delay2 ) begin
	 delay = delay1;
      end else begin
	 if ( delay1 > delay2 ) putil#(time)::swap( delay1, delay2 );
	 delay = ( { $urandom, $urandom } ) % ( delay2 - delay1 ) + delay1;
      end
      reset();
      return delay;
   endfunction: set_random_delay

   //---------------------------------------------------------------------------
   // Function: start
   //   Starts the timer. The <ring> event is triggered when the remaining time
   //   becomes 0.  The timer can be stopped by calling <stop> or be paused by
   //   calling <pause>. If the timer is already started, no action is taken.
   //
   // Example:
   // | kitchen_timer kt = new();
   // | kt.set_delay( 100 );
   // | kt.start();
   // | @kt.ring;
   // | assert( kt.get_elapsed() == 100 );
   //---------------------------------------------------------------------------

   function void start();
      if ( is_running() ) return; // already started
      fork // firewall
	 begin
	    fork
	       begin
		  start_time = $time;
		  remaining -= elapsed;
		  assert ( remaining > 0 ) else
		    $warning( "The kitchen timer triggers immediately." );
		  #remaining ->ring;
		  stamp();
		  state = STOPPED;
	       end
	       begin
		  state = RUNNING;
		  wait( state != RUNNING ) ;
	       end
	    join_any
	    disable fork;
	 end
      join_none
   endfunction: start

   //---------------------------------------------------------------------------
   // Function: stop
   //   Stops the timer. The elapsed time is stamped if the timer was running.
   //
   // Example:
   // | kitchen_timer kt = new();
   // | kt.set_delay( 100 );
   // | kt.start();
   // | #50 kt.stop();
   // | assert( kt.get_elapsed() == 50 );
   //---------------------------------------------------------------------------

   function void stop();
      if ( is_running() ) stamp();
      state = STOPPED;
   endfunction: stop

   //---------------------------------------------------------------------------
   // Function: pause
   //   Pauses the timer. The elapsed time is stamped if the timer was
   //   running. The timer can be resumed by calling <resume>. If the timer was
   //   not running, no action is taken.
   //
   // Example:
   // | kitchen_timer kt = new();
   // | kt.set_delay( 100 );
   // | kt.start();
   // | #50 kt.pause();
   // | assert( kt.get_elapsed() == 50 );
   //---------------------------------------------------------------------------

   function void pause();
      if ( is_running() ) begin
	 stamp();
	 state = PAUSED;
      end
   endfunction: pause

   //---------------------------------------------------------------------------
   // Function: resume
   //   Resumes the timer, if the timer was paused. Otherwise, no action is
   //   taken.
   //
   // Example:
   // | kitchen_timer kt = new();
   // | kt.set_delay( 100 );
   // | kt.start();
   // | #30 kt.pause();
   // | assert( kt.get_elapsed() == 30 );
   // | kt.resume();
   // | @kt.ring;
   // | assert( kt.get_elapsed() == 70 );
   //---------------------------------------------------------------------------

   function void resume();
      if ( is_paused() ) start();
   endfunction: resume

   //---------------------------------------------------------------------------
   // Function: reset
   //   Resets the timer.
   //---------------------------------------------------------------------------

   function void reset();
      elapsed   = 0;
      remaining = delay;
      state     = STOPPED;
   endfunction: reset

   //---------------------------------------------------------------------------
   // Function: get_elapsed
   //   Returns the elapsed time since the timer was last started or resumed. If
   //   the timer is paused or stopped, returns the elapsed time to the last
   //   paused or stopped time.
   //
   // Returns:
   //   The elapsed time.
   //
   // Example:
   // | kitchen_timer kt = new();
   // | kt.set_delay( 100 );
   // | kt.start();
   // | @kt.ring;
   // | assert( kt.get_elapsed() == 100 );
   //---------------------------------------------------------------------------

   function time get_elapsed();
      if ( is_running() ) stamp();
      return elapsed;
   endfunction: get_elapsed

   //---------------------------------------------------------------------------
   // Function: get_remaining
   //   Returns the remaining time to ring.  If the timer is paused or stopped,
   //   returns the remaining time from the last paused or stopped time.
   //
   // Returns:
   //   The remaining time.
   //
   // Example:
   // | kitchen_timer kt = new();
   // | kt.set_delay( 100 );
   // | kt.start();
   // | #30;
   // | assert( kt.get_remaining() == 70 );
   // | @kt.ring;
   // | assert( kt.get_remaining() == 0 );
   //---------------------------------------------------------------------------

   function time get_remaining();
      if ( is_running() ) stamp();
      return remaining - elapsed;
   endfunction: get_remaining

   //---------------------------------------------------------------------------
   // Function: is_stopped
   //   Returns 1 if the timer is currently stopped.
   //
   // Returns:
   //   If the timer is currently stopped, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | kitchen_timer kt = new();
   // | kt.set_delay( 100 );
   // | kt.start();
   // | #30;
   // | assert( kt.is_stopped() == 0 );
   // | @kt.ring;
   // | assert( kt.is_stopped() == 1 );
   //---------------------------------------------------------------------------

   function bit is_stopped();
      return state == STOPPED;
   endfunction: is_stopped
   
   //---------------------------------------------------------------------------
   // Function: is_running
   //   Returns 1 if the timer is currently running.
   //
   // Returns:
   //   If the timer is currently running, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | kitchen_timer kt = new();
   // | kt.set_delay( 100 );
   // | kt.start();
   // | #30;
   // | assert( kt.is_running() == 1 );
   // | @kt.ring;
   // | assert( kt.is_running() == 0 );
   //---------------------------------------------------------------------------

   function bit is_running();
      return state == RUNNING;
   endfunction: is_running
   
   //---------------------------------------------------------------------------
   // Function: is_paused
   //   Returns 1 if the timer is currently paused.
   //
   // Returns:
   //   If the timer is currently paused, returns 1. Otherwise, returns 0.
   //
   // Example:
   // | kitchen_timer kt = new();
   // | kt.set_delay( 100 );
   // | kt.start();
   // | #50 kt.pause();
   // | assert( kt.is_paused() == 1 );
   // | kt.resume();
   // | #10;
   // | assert( kt.is_paused() == 0 );
   //---------------------------------------------------------------------------

   function bit is_paused();
      return state == PAUSED;
   endfunction: is_paused

   //---------------------------------------------------------------------------
   // Function: get_state
   //   Returns the current state of the timer.
   //
   // Returns:
   //   The current state of the timer.
   //
   // Example:
   // | kitchen_timer kt = new();
   // | kt.set_delay( 100 );
   // | kt.start();
   // | #50 kt.pause();
   // | assert( kt.get_state() == kitchen_timer::PAUSED );
   // | kt.resume();
   // | #10;
   // | assert( kt.get_state() == kitchen_timer::RUNNING );
   //---------------------------------------------------------------------------

   function state_e get_state();
      return state;
   endfunction: get_state

   local function void stamp();
      elapsed = $time - start_time;
   endfunction: stamp
   
endclass: kitchen_timer

`endif //  `ifndef CL_KITCHEN_TIMER_SVH

//==============================================================================
// Copyright (c) 2013, 2014, 2015, 2016 ClueLogic, LLC
// http://cluelogic.com/
//==============================================================================
