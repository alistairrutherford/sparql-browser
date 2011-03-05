/**
 * -----------------------------------------------------------------------
 * Data services delegate.
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
package com.nethreads.viewer.search.business
{
	import com.adobe.cairngorm.business.ServiceLocator;
	import com.nethreads.viewer.search.model.MetaDataLocator;
	import com.nethreads.viewer.search.model.QueryModelLocator;
	
	import mx.rpc.IResponder;

	/**
	 * Delegate which maps to function on java server side. 
	 * 
	 */
	public class SearchDelegate
	{
		private var responder : IResponder;
		private var service : Object;

		public static var LIMIT:String = "LIMIT";

        /**
        * Search service delegate.
        * 
        * @param responder IResponder object reference.
        * 
        */		
		public function SearchDelegate(responder:IResponder)
		{		
			var locator:ServiceLocator = ServiceLocator.getInstance();
			
			this.service = ServiceLocator.getInstance().getHTTPService("sparqlQueryService");
			
			this.responder = responder;
		}

        /**
        * Fetch search result results.
        * 
        * @param query String search query.
        * @param site String specific site url
        * 
        */		
		public function getResults(query:String, prefix:String, limit:Number, endpoint:String): void
		{			
			var queryFull:String = prefix + "\n" + query;
			
			// Tag limit if set
			if (limit>0)
			{
				queryFull = queryFull + " "+LIMIT+" "+limit.toString();
			}
			
			var params:Object = 
			{
				'url':endpoint,
				'query':queryFull,
				'format':'application/sparql-results+xml'
			};
			
			service.request = params;
			
			// We need this for standalone operation only.
			if (MetaDataLocator.USE_PROXY)
			{
				service.url = MetaDataLocator.PROXY_URL;
			}
			else
			{
				service.url = endpoint;
			}
				
		    // Issue request
			var call : Object = service.send();

			// Set global status of query to 'running'
			QueryModelLocator.getInstance().running = true;

			call.addResponder(responder);
		}

		/**
		 * Cancel query.
		 * 
		 */
		public function cancel():void
		{
			//Services(locator).sparqlQueryService.cancel();
			service.cancel();
			
			// Set global status of query to not 'running'
			QueryModelLocator.getInstance().running = false;
		}
	}
}