/**
 * -----------------------------------------------------------------------
 * Node renderer. This subclasses BirdEye renderer so we can hook in
 * out own mouse click handler. The default handler for single click in 
 * the original codebase references specific items in it's 'parent' view 
 * which is not a good design decision IMHO. 
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
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextLineMetrics;
	
	import org.un.cava.birdeye.ravis.components.renderers.nodes.SimpleCircleNodeRenderer;
	
	/**
	 * This is a very very simple Renderer that just
	 * uses a plain small circle for the icon 
	 * */
	public class CircleNodeRenderer extends SimpleCircleNodeRenderer
	{
		private static var MAX_LABEL_LENGTH:int = 20;
		
		public function CircleNodeRenderer() 
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
		 * Initialise component overridded from parent class. 
		 * Here we hook in our own handlers.
		 * 
		 * @param initialise event.
		 */
		override protected function initComponent(e:Event):void 
		{
			super.initComponent(e);
			
			if (lb.label.length<MAX_LABEL_LENGTH)
			{
				var rect:Rectangle = measureTextFieldBounds(lb.label);
						
				// The label still needs some padding 20 seems to be about the right amount.
				lb.width = rect.width+20;
			}
			
			// We use E4X to extract the tooltip text we built in our gml xml description
			// of the graph. If it's null it will supress the 'Click to View Details' text
			// and simply display the node title which is what we want.
			var labelTooltip:String = this.data.data.@labelTooltip;
			lb.toolTip = labelTooltip;
			
			// **AJR** This is a PAIN IN THE ARSE. BirdEye please fix this nonsense
			if (RenderProperties.getInstance().clickHandler!=null)
			{
				this.addEventListener(MouseEvent.CLICK,RenderProperties.getInstance().clickHandler, false, 0, true);
			}
		}
	}
}