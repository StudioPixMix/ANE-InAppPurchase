package com.studiopixmix.anes.InAppPurchase
{
	import flash.events.Event;

	/**
	 * An event dispatched by the in-app purchase ANE.
	 */
	public class InAppPurchaseEvent extends Event {
		public static const LOG:String = "LOG";
		
		private var data:String;
		
		public function InAppPurchaseEvent(type:String, data:String = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}