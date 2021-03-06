/**
 * -----------------------------------------------------------------------
 * Get search clusters Cairngorm event.
 * -----------------------------------------------------------------------
 * Copyright 2008 -  Alistair Rutherford - www.netthreads.co.uk, Jan 2008
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 * 
 * -----------------------------------------------------------------------
 */
package com.nethreads.viewer.search.events.data
{
	import flash.events.Event;
	import com.adobe.cairngorm.control.CairngormEvent;

	public class GetResultsEvent extends CairngormEvent
	{
		public static var EVENT_NAME:String = "getResultsEvent";
		
		public var query:String;
		public var prefix:String;
		public var limit:Number;
		public var endpoint:String;

		/**
		 * Constructor.
		 */
		public function GetResultsEvent(query:String, prefix:String="", limit:Number=0, endpoint:String="")
		{
			super(EVENT_NAME);
			
			this.query = query;
			this.prefix = prefix;
			this.limit = limit;
			this.endpoint = endpoint;
		}
     	
     	/**
     	 * Override the inherited clone() method, but don't return any state.
     	 */
		override public function clone() : Event
		{
			return new GetResultsEvent(this.query, this.prefix, this.limit, this.endpoint);
		}	
	}
	
}