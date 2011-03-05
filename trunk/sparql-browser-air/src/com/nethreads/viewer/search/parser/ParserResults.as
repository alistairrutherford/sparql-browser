/**
 * -----------------------------------------------------------------------
 * Result XML parser.
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
package com.nethreads.viewer.search.parser
{
    import com.nethreads.viewer.search.vo.BindingVO;
    import com.nethreads.viewer.search.vo.BlankVO;
    import com.nethreads.viewer.search.vo.LiteralVO;
    import com.nethreads.viewer.search.vo.ResultVO;
    import com.nethreads.viewer.search.vo.URIVO;
    
    import mx.collections.ArrayCollection;

	public class ParserResults implements IParser
	{
		// These namespaces need to be defined in order to parse the result xml
		// correctly.		
        private namespace webNameSpace = "http://www.w3.org/XML/1998/namespace";
        use namespace webNameSpace;
        private namespace xsiNameSpace = "http://www.w3.org/2001/XMLSchema-instance";
        use namespace xsiNameSpace;
        private namespace sparqlNameSpace = "http://www.w3.org/2005/sparql-results#";
        use namespace sparqlNameSpace;
        
        private static var _count:Number = 0;
        
        /**
        * Parse results XML.
        * 
        * @param data The XML to parse.
        * 
        */
		public function parse(data:XML):ArrayCollection
		{
			// Extract results.
            var resultsXML:XMLList = data..result;
            
            // Build our array to hold vo's
			var items:ArrayCollection = new ArrayCollection();
			
		    for each (var resultXML:* in resultsXML) // e4x
            {
                var result:ResultVO = new ResultVO();
                
                // Sheesh, can we not get a fn to generate a UUID?
                _count++;
                result.id = _count.toString();
                
                
                // Extract all binding from result.
                var bindingsXML:XMLList = resultXML..binding;
				
                for each (var bindingXML:* in bindingsXML)
                {
	                var name:String = bindingXML.@name;
	                
	                // Make binding
	                var bindingItem:BindingVO = new BindingVO();
	                bindingItem.name = name;
	                
	                var literal:String  = bindingXML.literal;
	                var uri:String = bindingXML.uri;
	                var blank:String = bindingXML.bnode;
	                
	                // We need to generate different types so consuming process can
	                // differentiate betweem them.
	                
	                // Literal
	                if (literal!=null && literal!="")
	                {
		                var literalItem:LiteralVO = new LiteralVO();
	                	_count++;
		                literalItem.id = _count.toString();
		                literalItem.literal = stripString(literal);
		                literalItem.lang = bindingXML.literal.@lang;

		                bindingItem.elements.addItem(literalItem);
	                }
	                else // URI
		                if (uri!=null && uri!="")
		                {
			                var uriItem:URIVO = new URIVO();
		                	_count++;
			                uriItem.id = _count.toString();
			                uriItem.uri = uri;
			                var index:int = uri.lastIndexOf("/");
			                if (index>0)
			                {
			                	uriItem.short = uri.substr(index+1, (uri.length-index-1));
			                }
			                else
			                {
			                	uriItem.short = uri;
			                }
			                
			                bindingItem.elements.addItem(uriItem);
		                }
		                else // Blank Node
			                if (uri!=null && uri!="")
			                {
				                var blankItem:BlankVO = new BlankVO();
			                	_count++;
				                blankItem.id = _count.toString();
				                bindingItem.elements.addItem(blankItem);
			                }
	                
	                result.bindings.addItem(bindingItem);
                }
                
                // Do some magic to generate a result desciption from it's contents.
                result.description = makeDescription(bindingsXML);
                
                // Do some magic to build labels to desribe bindings
                result.labels = makeLabels(result);
                
                items.addItem(result);
            }

			return items;			
		}

		/**
		 * Make text labels for binding results.
		 * 
		 * @param The result object.
		 * 
		 */		
		private function makeLabels(item:ResultVO):ArrayCollection
		{
			var labels:ArrayCollection = null;
			
        	if (item.bindings!=null)
        	{
				labels = new ArrayCollection(); 
				for each (var binding:BindingVO in item.bindings)
				{
					labels.addItem(makeLabel(binding));
				}
        	}
        	
        	return labels
		}
		
		/**
		 * Build a label for binding elements.
		 * 
		 * @param Binding object
		 */
        private function makeLabel(binding:BindingVO):String
        {
        	var value:String = "";
        	
			// If we are going to have to concatenate strings together then
			// stick a joining character inbetween.
			var seperator:String = "";
			if (binding.elements!=null && binding.elements.length>1)
			{
				seperator = ":";
			}
			
			// For each binding element.
			for each (var element:Object in binding.elements)
			{
				// URI, Literal..
				if (element is URIVO)
				{
					value = value+seperator+element.short;
				}
				else if (element is LiteralVO)
				{
					value = value+seperator+element.literal;
				}
				else
				{
					value = value+seperator+element.toString();
				}
			}
            
            return value;    
        }

		/**
		 * Attempt to extract a relevant description from results contents.
		 * 
		 * @param bindingsXML XMLList 
		 * 
		 */
        private function makeDescription(bindingsXML:XMLList):String
        {
        	var description:String = "";
        	
			// Try URI since the subject will always be relevant.
			var uris:XMLList = bindingsXML.uri
            if (uris.length()>0)
            {
            	// Just go with the first one.
            	description = extractSubjectFromURI(unescape(bindingsXML.uri[0]));
            }
            else
            {
	            // Make a description.
	            var literals:XMLList = bindingsXML.literal;
	            if (literals.length()>0)
	            {
	            	description = stripString(literals[0]);
	            }
	            else
	            {
	            	description = "Result "+_count;
	            }
            }
            
            return description;
        }

		/**
		 * Extract subject from URI and format into a string which can
		 * be used as a human readable description (i.e. without underscores).
		 * 
		 */		
		private function extractSubjectFromURI(uri:String):String
		{
			var subject:String = uri;
			
			var components:Array = uri.split("/");
			var subjectPart:String = components[components.length-1];
			
			if (subjectPart.search("_")!=0)
			{
				var myPattern:RegExp = /_/g;
				subject = subjectPart.replace(myPattern," ");
			}
			else
			{
				subject = subjectPart;
			}
			
			return stripString(subject);
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
			
			var myPattern:RegExp = /&/g;
			newString = newString.replace(myPattern, "&amp;");
			myPattern = /\'/g;
			newString = newString.replace(myPattern, "");
			myPattern = /\</g;
			newString = newString.replace(myPattern, "");
			myPattern = /\>/g;
			newString = newString.replace(myPattern, "");
			myPattern = /\"/g;
			newString = newString.replace(myPattern, "");

			myPattern = /\\/g;
			newString = newString.replace(myPattern, "");
			
			return newString;
		}		
	}
}