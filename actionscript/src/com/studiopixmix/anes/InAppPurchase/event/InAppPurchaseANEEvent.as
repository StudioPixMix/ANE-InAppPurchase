package com.studiopixmix.anes.InAppPurchase.event
{
	import flash.events.Event;

	/**
	 * An event dispatched by the in-app purchase ANE.
	 */
	public class InAppPurchaseANEEvent extends Event {
		// EVENT TYPE CONSTANTS
		public static const LOG:String = "EVENT_LOG";
		public static const PRODUCTS_LOADED:String = "EVENT_PRODUCTS_LOADED";
		public static const PRODUCTS_INVALID:String = "EVENT_PRODUCTS_INVALID";
		public static const PURCHASE_SUCCESS:String = "EVENT_PURCHASE_SUCCESS";
		public static const PURCHASE_FAILURE:String = "EVENT_PURCHASE_FAILURE";
		public static const PURCHASES_RETRIEVED:String = "EVENT_PURCHASES_RETRIEVED";
		public static const PURCHASES_RETRIEVING_FAILED:String = "EVENT_PURCHASES_RETRIEVING_FAILED";
		
		public function InAppPurchaseANEEvent(type:String) {
			super(type);
		}
	}
}