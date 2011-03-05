/**
 * -----------------------------------------------------------------------
 * Custom renderer properties. 
 * 
 * - Single click handler function.
 * 
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
package com.nethreads.viewer.search.renderers
{
	public final class RenderProperties
	{
		public var clickHandler:Function = null;
				
		/**
		 * Defines the Singleton instance of the Application ModelLocator
		 */
		private static var instance:RenderProperties;
		
		/**
		 * Returns the Singleton instance of the Application ModelLocator.
		 * 
		 */
		public static function getInstance() : RenderProperties
		{
			if (instance == null)
			{
				instance = new RenderProperties( new Private() );
			}
			return instance;
		}

		/**
		 * 
		 */
		public function RenderProperties(access:Private)
		{
			if (access == null)
			{
			    throw new Error("ModelLocator");
			}
					
			instance = this;
		}

		
		/**
		 * Register icon click handler.
		 * 
		 */
		public function registerClickHandler(handler:Function):void
		{
			clickHandler = handler;
		}
	}

}

/**
 * Inner class which restricts constructor access to Private
 */
class Private {}
