/**
 * -----------------------------------------------------------------------
 * Query Locator. Acts as a central repository of query and prefix.
 * 
 * We make this a locator as we are going to attempt to persist the
 * query and prefix settings across browser sessions using the flash
 * data area.
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
package com.nethreads.viewer.search.model
{
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;
	import com.adobe.cairngorm.model.IModelLocator;
	import com.nethreads.viewer.search.parser.IParser;
	import com.nethreads.viewer.search.parser.ParserQueries;
	import com.nethreads.viewer.search.parser.ParserQueryEndpoint;
	import com.nethreads.viewer.search.vo.EndpointVO;
	import com.nethreads.viewer.search.vo.QueryVO;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;

    [Event(name="propertyChange", type="flash.events.Event")]
    
    [Bindable]
	public final class QueryModelLocator extends EventDispatcher implements IModelLocator
	{
		
		/**
		 * Defines the Singleton instance of the Application ModelLocator
		 */
		private static var instance:QueryModelLocator;

		// Parser for loading query configuration data
		private var parserEndpoints:IParser = null;
		private var parserQueries:IParser = null;

		private var _endpoints:ArrayCollection = null;
		private var _queries:ArrayCollection = null;
		
        public static var DEFAULT_ENDPOINT:String = "http://dbpedia.org/sparql";

		private var DEFAULT_QUERY:String = 
			"SELECT distinct ?name ?birth ?death ?person WHERE { \n" +
			"   ?person dbpedia2:birthPlace <http://dbpedia.org/resource/Berlin> . \n" +
			"   ?person dbpedia2:birth ?birth . \n" +
			"   ?person foaf:name ?name . \n" +
			"   ?person dbpedia2:death ?death \n" +
			"   FILTER (?birth < '1900-01-01'^^xsd:date) . \n" +
			"} \n" +
			"ORDER BY ?name \n";

		public static var DEFAULT_QUERY_PREFIX:String = 
			"PREFIX owl: <http://www.w3.org/2002/07/owl#> \n" +
			"PREFIX xsd: <http://www.w3.org/2001/XMLSchema#> \n" + 
			"PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#> \n" + 
			"PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> \n" +
			"PREFIX foaf: <http://xmlns.com/foaf/0.1/> \n" +
			"PREFIX dc: <http://purl.org/dc/elements/1.1/> \n" + 
			"PREFIX : <http://dbpedia.org/resource/> \n" + 
			"PREFIX dbpedia2: <http://dbpedia.org/property/> \n" + 
			"PREFIX dbpedia: <http://dbpedia.org/> \n" +
			"PREFIX skos: <http://www.w3.org/2004/02/skos/core#>";
		
        private var _query:String = null;
        
        private var _prefix:String = null;

		private var _running:Boolean = false;
        
		/**
		 * Returns the Singleton instance of the Locator.
		 * 
		 */
		public static function getInstance() : QueryModelLocator
		{
			if (instance == null)
			{
				instance = new QueryModelLocator( new Private() );
			}
			return instance;
		}

		/**
		 * Ctor
		 * 
		 */
		public function QueryModelLocator(access:Private)
		{
			if (access == null)
			{
			    throw new CairngormError(CairngormMessageCodes.SINGLETON_EXCEPTION, "ModelLocator");
			}

			instance = this;
			
			parserEndpoints = new ParserQueryEndpoint();
			parserQueries = new ParserQueries();

			_query = DEFAULT_QUERY
			
			_prefix = DEFAULT_QUERY_PREFIX;
	
		}

		/**
		 * Query getter.
		 * 
		 */
		[Bindable(event="propertyChange")]
		public function get queries():ArrayCollection
		{
			return _queries;
		}

		/**
		 * Query setter.
		 * 
		 * @param value The Value String
		 */
		public function set queries(value:ArrayCollection):void
		{
			_queries = value;
			this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "queries", _queries, value));	
		}
		
		/**
		 * Endpoint getter.
		 * 
		 */
		[Bindable(event="propertyChange")]
		public function get endpoints():ArrayCollection
		{
			return _endpoints;
		}

		/**
		 * Endpoint setter.
		 * 
		 * @param value The Value String
		 */
		public function set endpoints(value:ArrayCollection):void
		{
			_endpoints = value;
			this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "endpoints", _endpoints, value));	
		}
		
		
		/**
		 * Query getter.
		 * 
		 */
		[Bindable(event="propertyChange")]
		public function get query():String
		{
			return _query;
		}

		/**
		 * Query setter.
		 * 
		 * @param value The Value String
		 */
		public function set query(value:String):void
		{
			_query = value;
			this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "query", _query, value));	
		}
		
		/**
		 * Prefix getter.
		 * 
		 */
		[Bindable(event="propertyChange")]
		public function get prefix():String
		{
			return _prefix;
		}

		/**
		 * Prefix setter.
		 * 
		 * @param value The Value String
		 */
		public function set prefix(value:String):void
		{
			_prefix = value;
			this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "prefix", _prefix, value));	
		}

		/**
		 * Query getter.
		 * 
		 */
		[Bindable(event="propertyChange")]
		public function get running():Boolean
		{
			return _running;
		}

		/**
		 * Query setter.
		 * 
		 * @param value The value
		 */
		public function set running(value:Boolean):void
		{
			_running = value;
			this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "running", _running, value));	
		}

		public function setDefaults():void
		{
			// TODO			
		}
		
		/**
		 * Update master list.
		 * 
		 * @data ArrayCollection The list of results.
		 * 
		 */		
		public function update(data:XML):void
		{
			// Extract endpoint data
			endpoints = parserEndpoints.parse(data);
			
			// Extract query data
			queries = parserQueries.parse(data);
		}
		
	}

}

/**
 * Inner class which restricts constructor access to Private
 */
class Private {}
