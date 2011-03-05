/**
 * MapCollection - ArrayCollection wrapped with a Dictionary to provide fast lookup and
 * allow items to be iterable.
 * 
 */
package com.nethreads.viewer.search.model
{
    import mx.collections.ArrayCollection;
    import flash.utils.Dictionary;
    
    /**
    * Array collection wrapper which implements a lookup.
    * 
    */
    public class MapCollection
    {
        public var source:ArrayCollection = null;
        public var indexes:Dictionary = null;
        
        /**
        * Construct collection.
        * 
        * @param source ArrayCollection empty collection to use as core structure or null.
        */
        public function MapCollection(source:ArrayCollection=null):void
        {
            if (source==null)
            {
                this.source = new ArrayCollection();
            }
            else
                this.source = source;
                
            indexes = new Dictionary();
        }
        
        /**
        * Put item into map against key.
        * 
        * @param key String unique key.
        * @param item Object object stored against key.
        */
        public function putItem(key:Object, item:Object):void
        {
            var existing:Object = getItem(key);
            if (existing)
            {
                removeItem(key);
            }
            
            source.addItem(item);
            indexes[key] = item;
        }
        
        /**
        * Fetch item against key.
        * 
        * @param key String unique key.
        * 
        * @return Object target item.
        */
        public function getItem(key:Object):Object
        {
            var target:Object = null;
            
            try
            {    
                target = indexes[key];
            }
            catch (e:Error)
            {
            }
            
            return target;
        }

        /**
        * Remove item with key.
        * 
        * @param key String unique key
        */
        public function removeItem(key:Object):void
        {
            try
            {
                var item:Object = getItem(key);
                
                var index:Number = source.getItemIndex(item);
                
                source.removeItemAt(index);
                
                delete indexes[key];
                
                item = null;
            }
            catch(e:Error)
            {
                trace('Error removing item '+e);        
            }
        }
        
        /**
        * Clear items from structure.
        * 
        */
        public function clear():void
        {
            source.removeAll();
        }
        
        
    }
}