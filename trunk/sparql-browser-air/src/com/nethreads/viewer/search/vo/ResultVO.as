/**
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
package com.nethreads.viewer.search.vo
{
    import com.adobe.cairngorm.vo.IValueObject;
    
    import mx.collections.ArrayCollection;

	[Bindable] 
    public class ResultVO implements IValueObject
    {
	    // List of DocumentVO
	    public var id:String = null;
	    public var description:String = null;
	    public var bindings:ArrayCollection = null;
	    public var labels:ArrayCollection = null
        
        public function ResultVO():void
        {
        	bindings = new ArrayCollection();
        }
        
        public function toString() : String
        {
            var s : String = "ResultVO[";
            s += ", id=";
            s += id;
            s += ", bindings=";
            s += bindings;
            s += " ]";
            return s;
        }
    }
    
}