/**
 * -----------------------------------------------------------------------
 * Results Locator. Acts as a central repository of search results and
 * builds graph gml.
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
	import flash.events.IEventDispatcher;
	import flash.xml.XMLNode;
	import flash.utils.escapeMultiByte;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.controls.Label;

	import com.adobe.cairngorm.model.IModelLocator;
	import com.adobe.cairngorm.CairngormError;
	import com.adobe.cairngorm.CairngormMessageCodes;

	import com.nethreads.viewer.search.vo.ResultVO;
	import com.nethreads.viewer.search.vo.BindingVO;
	import com.nethreads.viewer.search.parser.IParser;
	import com.nethreads.viewer.search.parser.ParserResults;
	import com.nethreads.viewer.search.vo.URIVO;
	import com.nethreads.viewer.search.vo.LiteralVO;
	import com.nethreads.viewer.search.model.MetaDataLocator;

    [Event(name="propertyChange", type="flash.events.Event")]
    
    [Bindable]
	public final class ResultModelLocator extends EventDispatcher implements IModelLocator
	{
		/**
		 * Defines the Singleton instance of the Application ModelLocator
		 */
		private static var instance:ResultModelLocator;

        private var _results:ArrayCollection = null
        
        private var _gml:XML = null;

        private var _xml:XML = null;

		private var _startNode:String = ROOT_NODE;

		private var parser:IParser = null;
		        
        private var bindingToResultDict:Dictionary = null;

		private static var ROOT_NODE:String = 'vizgraph';

		private var ERROR_GRAPH:XML = <Graph><Node id="vizgraph" name="Error Building Graph" description="This is a description" nodeColor="0x333333" nodeSize="32" nodeClass="earth" nodeIcon="center" x="10" y="10"/></Graph>

		/**
		 * Returns the Singleton instance of the Application ModelLocator.
		 * 
		 */
		public static function getInstance() : ResultModelLocator
		{
			if (instance == null)
			{
				instance = new ResultModelLocator( new Private() );
			}
			return instance;
		}

		/**
		 * GML data getter.
		 * 
		 */
		[Bindable(event="propertyChange")]
		public function get startNode():String
		{
			return _startNode;
		}

		/**
		 * GML Data setter.
		 * 
		 * @param values XML The GML which represents cluster graph.
		 * 
		 */
		public function set startNode(value:String):void
		{
			_startNode = value;
			this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "startNode", _startNode, value));	
		}

		/**
		 * Ctor
		 * 
		 */
		public function ResultModelLocator(access:Private)
		{
			if (access == null)
			{
			    throw new CairngormError(CairngormMessageCodes.SINGLETON_EXCEPTION, "ModelLocator");
			}
			
			_results = new ArrayCollection();
	
			bindingToResultDict = new Dictionary(false);
			
			parser = new ParserResults();
		
			instance = this;
		}

		/**
		 * Cluster data getter.
		 * 
		 */
		[Bindable(event="propertyChange")]
		public function get results():ArrayCollection
		{
			return _results;
		}

		/**
		 * Cluster data setter.
		 * 
		 * @param values ArrayCollection The list of results.
		 */
		public function set results(values:ArrayCollection):void
		{
			_results = values;
			this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "results", _results, values));	
		}
		
		/**
		 * GML data getter.
		 * 
		 */
		[Bindable(event="propertyChange")]
		public function get gml():XML
		{
			return _gml;
		}

		/**
		 * GML Data setter.
		 * 
		 * @param values XML The GML which represents cluster graph.
		 * 
		 */
		public function set gml(values:XML):void
		{
			_gml = values;
			this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "gml", _gml, values));	
		}

		/**
		 * XML data getter.
		 * 
		 */
		[Bindable(event="propertyChange")]
		public function get xml():XML
		{
			return _xml;
		}

		/**
		 * XML Data setter.
		 * 
		 * @param values XML results.
		 * 
		 */
		public function set xml(values:XML):void
		{
			_xml= values;
			this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this, "xml", _gml, values));	
		}
		
		/**
		 * Update master list.
		 * 
		 * @data ArrayCollection The list of results.
		 * 
		 */		
		public function update(data:XML):void
		{
			// Assign copy of xml.
			xml = data;
			
			// In with the new.
			results = parser.parse(data);
			
			// build GML structure
			updateGML(results);
		}
		

		/**
		 * Build GML structure from data.
		 * 
		 * Results are attached to a central hub node.
		 * Bindings are attached to results.
		 * Results which share a binding reference are connected together.
		 * 
		 * @param data ArrayCollection The node data.
		 * 
		 */
		private function updateGML(data:ArrayCollection):void
		{

			var xmlStrings:Object = {gmlString:"", nodeString:"", edgeString:""};
					
			reset();

			xmlStrings.gmlString += "<Graph>";
			
			xmlStrings.nodeString += "<Node id='"+ROOT_NODE+"' name='Results' nodeColor='0x000000' nodeSize='32' nodeClass='earth' nodeIcon='center' description='Search results' labelTooltip='Double click to focus'/>";

			// For each result of search results.			
			for each (var result:ResultVO in data)
			{
				var nodeId:String = result.id;
				
				var name:String = result.description;
				var description:String = result.description;
				
				var resultNode:String = "<Node id='"+nodeId+"' name='"+name+"' nodeColor='0x8F8FFF' nodeSize='12' nodeClass='tree' nodeIcon='2' description='"+description+"' labelTooltip='Double click to focus'/>";
				xmlStrings.nodeString += resultNode;

				// From centre to result
				xmlStrings.edgeString +="<Edge fromID='vizgraph' toID='" + nodeId + "' edgeLabel=''/>";

				// For each result binding
				for each (var binding:BindingVO in result.bindings)
				{
					var bindingID:String = null;;
					
					// For each binding element.
					for each (var element:Object in binding.elements)
					{
						// URI, Literal..
						if (element is URIVO)
						{
							bindingID = processURIElement(nodeId, binding.name, element, xmlStrings);
						}
						else if (element is LiteralVO)
						{
						    bindingID = processLiteralElement(binding.name, element, xmlStrings);
						}
						
						if (bindingID!=null)
						{
							// Make Edge from cluster to document.
							xmlStrings.edgeString +="<Edge fromID='"+nodeId	+ "' toID='"+ bindingID + "' edgeLabel='"+ binding.name +"'/>";
						}
					}
					
				}
				
			}
			
			// Build whole xml
			xmlStrings.gmlString += xmlStrings.nodeString + xmlStrings.edgeString + "</Graph>";

			try
			{
				// Set data
				trace(xmlStrings.gmlString);
				gml = new XML(xmlStrings.gmlString);
			}
			catch(e:Error)
			{
				trace(e);				
				gml = ERROR_GRAPH;
			}
			
		}

		/**
		 * Process URI element. This is a more complicated rtn than the literal function as we will attempt
		 * to identify if a node with the same URI already exists and if so we will generate a link from the
		 * related nodes to the element owner node.
		 * 
		 * @param name String The owner node name.
		 * @param element Object The element to process in uncast form.
		 * @param xmlStrings Object The string to build the gml passed as an object so they can be modified.
		 * 
		 */
		private function processURIElement(nodeId:String, name:String, element:Object, xmlStrings:Object):String
		{
			var voURI:URIVO = URIVO(element);
			
			// Any related nodes.
			var related:ArrayCollection= getExistingResultLinks(voURI.uri);
			
			// Doesn't already exist
			if (related.length==0)
			{
				var description:String = "uri: "+voURI.uri;
	
				var documentNode:String = "		<Node id='" +voURI.id
				    +"' name='"+voURI.short
					+"' nodeColor='0x00FF00' nodeSize='21' nodeClass='leaf' nodeIcon='10' description='" +description
					+"' url='"+voURI.uri
					+"' urlEsc='"+escapeMultiByte(voURI.uri)
				    +"' labelTooltip='Click to view URI in browse tab'/>";
				xmlStrings.nodeString += documentNode;
				
				// Associate owner node with uri
				related.addItem(nodeId);
			}
			else
			{
				// Draw connection from related results to this one
				for each (var id:String in related)
				{
					// Make Edge from cluster to document.
					xmlStrings.edgeString +="<Edge fromID='"+id+"' toID='"+nodeId+"' edgeLabel='"+ name +"'/>";
				}
			}
			
			return voURI.id;
		}

		/**
		 * Process Literal Element.
		 * 
		 * @param name String The owner node name.
		 * @param element Object The element to process in uncast form.
		 * @param xmlStrings Object The string to build the gml passed as an object so they can be modified.
		 * 
		 */
		private function processLiteralElement(name:String, element:Object, xmlStrings:Object):String
		{
			var voLiteral:LiteralVO = LiteralVO(element);

			// We'll use the literal as id since it should be unique (I think).
			var elementID:String = voLiteral.literal;

			//var description:String = name+":"+voLiteral.literal;
			var description:String = voLiteral.literal;
			
			// Document node.
			var documentNode:String = "		<Node id='" +voLiteral.id
			    +"' name='"+description
				+"' nodeColor='0xF00000' nodeSize='27' nodeClass='leaf' nodeIcon='16' description='" +description
				+"' url=''"
			    +" labelTooltip='"+description+"'/>";
			    
			xmlStrings.nodeString += documentNode;
			
			return voLiteral.id;
		}

		/**
		 * Returns map of existing results links for binding.
		 *  
		 * More than one result can share a binding.
		 * 
		 * @param bindingId String The binding identifier.
		 * 
		 */
		private function getExistingResultLinks(bindingId:String):ArrayCollection
		{
			var resultLinks:ArrayCollection = bindingToResultDict[bindingId];
			
			if (resultLinks==null)
			{
				resultLinks = new ArrayCollection();
				bindingToResultDict[bindingId] = resultLinks;
			}
			
			return resultLinks;
		}

		/**
		 * Reset graph items.
		 * 
		 */
		private function reset():void
		{
			bindingToResultDict = new Dictionary(false);
		}
        
		/**
		 * Strip string of characters which will confuse the node definitions.
		 * 
		 * @param value The data string.
		 * 
		 */	
		private function stripString(value:String):String
		{
			var newString:String = value; //escapeMultiByte(value);
			
			var myPattern:RegExp = /&/;
			newString = newString.replace(myPattern, "&amp;");
			myPattern = /\'/g;
			newString = newString.replace(myPattern, "");
			myPattern = /\</g;
			newString = newString.replace(myPattern, "");
			myPattern = /\>/g;
			newString = newString.replace(myPattern, "");
			myPattern = /\"/g;
			newString = newString.replace(myPattern, "");

			return newString;
		}

		/**
		 * Returns result object whose id matches supplied value.
		 * 
		 * @param id The string identifier for result
		 */
		public function getResult(id:String):ResultVO
		{
			var target:ResultVO = null;
			
			if (results!=null)
			{
				var found:Boolean = false;
				var index:Number = 0;
				while (!found && index<results.length)
				{
					var result:ResultVO = ResultVO(results.getItemAt(index));
					if (result.id==id)
					{
						target = result;
						found = true;
					}
					else
					{
						index++;
					}
				}
			}
			
			return target;
		}
	}

}

/**
 * Inner class which restricts constructor access to Private
 */
class Private {}
