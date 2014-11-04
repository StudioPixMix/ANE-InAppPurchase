package com.studiopixmix.anes.InAppPurchase
{
	import flash.events.Event;

	/**
	 * An event dispatched by the in-app purchase ANE.
	 */
	public class InAppPurchaseEvent extends Event {
		/** data : log message. */
		public static const LOG:String = "EVENT_LOG";
		/** data : products:Vector.<InAppPurchaseProduct> */
		public static const PRODUCTS_LOADED:String = "EVENT_PRODUCTS_LOADED";
		
		public var data:Object;
		
		public function InAppPurchaseEvent(type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}