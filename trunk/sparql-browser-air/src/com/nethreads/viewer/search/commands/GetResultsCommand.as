/**
 * -----------------------------------------------------------------------
 * Get query results from web server command.
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
package com.nethreads.viewer.search.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.nethreads.viewer.search.business.SearchDelegate;
	import com.nethreads.viewer.search.events.AlertEvent;
	import com.nethreads.viewer.search.events.data.GetResultsEvent;
	import com.nethreads.viewer.search.model.QueryModelLocator;
	import com.nethreads.viewer.search.model.ResultModelLocator;
	
	import mx.rpc.IResponder;
	import mx.rpc.events.FaultEvent;
	
	public class GetResultsCommand implements ICommand, IResponder
	{
		public var query:String = "";
		public var prefix:String = "";
		public var limit:Number = -1;
		public var endpoint:String = "";
	
	    /**
	    * Creates delegate service object and executes server request for data.
	    * 
	    * Parameters for request are passed as part of Cairngorm event mapped to this
	    * command through controller class.
	    * 
	    * 
	    */
		public function execute(event:CairngormEvent): void
		{
		    var delegate:SearchDelegate = new SearchDelegate(this);
            var searchEvent:GetResultsEvent = GetResultsEvent(event);

            query = searchEvent.query;
            prefix = searchEvent.prefix;
            limit = searchEvent.limit;
            endpoint = searchEvent.endpoint;
            
            trace('Sending request to server '+query);
            
	        delegate.getResults(query, prefix, limit, endpoint);
		}
	
	    /**
	    * Called when data is returned from server.
	    * 
	    */
		public function result( event : Object ) : void
		{				
			var results:XML = event.result;

			if (results!=null)
			{			
				var model:ResultModelLocator = ResultModelLocator.getInstance();
	
	            trace('Received data back from server');
				
	            if (results!=null)
	            {
	                // Add to model
	                model.update(results);
	                
					// Set global status of query to not 'running'
					QueryModelLocator.getInstance().running = false;
	            }
            }
            else
            {
            	trace('Null response');
            }
		}
		
	    /**
	    * Handle fault.
	    * 
	    */
		public function fault(event:Object) : void
		{
			var faultEvent : FaultEvent = FaultEvent( event );
            
            var alertEvent:AlertEvent = new AlertEvent("Query error. Check query or network connection.");
            alertEvent.dispatch();

			// Set global status of query to not 'running'
			QueryModelLocator.getInstance().running = false;
            
            trace(faultEvent.message);
		}
		
	}
}