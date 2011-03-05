/**
 * -----------------------------------------------------------------------
 * Endpoints XML parser.
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
    import com.nethreads.viewer.search.vo.EndpointVO;
    
    import mx.collections.ArrayCollection;
    import mx.utils.StringUtil;

	public class ParserQueryEndpoint implements IParser
	{
        /**
        * Parse results XML.
        * 
        * @param data The XML to parse.
        * 
        */
		public function parse(data:XML):ArrayCollection
		{
			var values:ArrayCollection = new ArrayCollection();
			
			// Extract results.
            var resultsXML:XMLList = data..endpoint;
           
		    for each (var endpointXML:* in resultsXML) // e4x
            {
                var endpoint:EndpointVO = new EndpointVO();
                
                var url:String = StringUtil.trim(endpointXML.value);
                var title:String = StringUtil.trim(endpointXML.@title);
                
                endpoint.id = endpointXML.@id;
                endpoint.title = title;
                endpoint.label = url;
                endpoint.value = url;
                
                values.addItem(endpoint);
            }

            return values 
		}
	}
}