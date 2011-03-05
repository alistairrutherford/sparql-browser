/**
 * -----------------------------------------------------------------------
 * Edge label renderer. This subclasses BirdEye renderer.
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
 */
package com.nethreads.viewer.search.renderers
{	
	// Flash classes
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.text.TextLineMetrics;
	
	import org.un.cava.birdeye.ravis.components.renderers.edgeLabels.BaseEdgeLabelRenderer;
	
	public class EdgeLabelRenderer extends BaseEdgeLabelRenderer
	{
	
		/**
		 * Constructor
		 * 
		 */
		public function EdgeLabelRenderer() 
		{
			super();
		}
		
	    /**
	     *  Calculate the pixel width of text.
	     *
	     *  @param String to measure. 
	     */
	    private function measureTextFieldBounds(s:String):Rectangle
	    {
	        // Measure the text we need to display.
	        var lineMetrics:TextLineMetrics = measureText(s);
	        
	        return new Rectangle(0, 0,lineMetrics.width,lineMetrics.height);
	    }
			
		/**
		 * Initialise component overridded from parent class. Here we 
		 * hook in out own handlers.
		 * 
		 * @param initialise event.
		 */
		override protected function initComponent(e:Event):void 
		{
			super.initComponent(e);

			var rect:Rectangle = measureTextFieldBounds(lb.label);
					
			// The label still needs some padding 20 seems to be about the right amount.
			lb.width = rect.width+20;
			
			// Supress 'Click To View Details' tooltip
			lb.toolTip = null;
		}

	}
}

