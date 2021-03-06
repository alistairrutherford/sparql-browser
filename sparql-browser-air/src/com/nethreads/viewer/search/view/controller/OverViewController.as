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
package com.nethreads.viewer.search.view.controller
{
    import flash.events.Event;

    import com.nethreads.viewer.search.events.ViewEvent;
    import com.nethreads.viewer.search.events.AlertEvent;

    [Event(name="alertEvent",type="com.nethreads.viewer.search.events.ViewEvent")]

    /**
    * View Controller for switching between overview elements.
    * 
    */   
    public class OverViewController extends ViewController
    {
    	/**
    	 * Ctor
    	 */
 		public function OverViewController()  
        {
			addListener(AlertEvent.EVENT_ALERT, notifyAlert);
		}
      
    	/**
    	 * Notify alert.
    	 * 
    	 * @param result Event type.
    	 */
        private function notifyAlert(result:Event):void 
        {
            var eventAlert:AlertEvent =  AlertEvent(result);
            
            var type:String = eventAlert.type;
            var message:String = eventAlert.message;
            
            var e:ViewEvent = new ViewEvent(type, message);
             
            // Pass event up to handlers for the owner view
            dispatchEvent(e);
        }
         
   }
}