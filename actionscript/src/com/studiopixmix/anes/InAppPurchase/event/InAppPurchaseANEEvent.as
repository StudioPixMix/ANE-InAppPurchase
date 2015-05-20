package com.studiopixmix.anes.InAppPurchase.event
{
	import flash.events.Event;

	/**
	 * An event dispatched by the in-app purchase ANE.
	 */
	public class InAppPurchaseANEEvent extends Event {
		
		// EVENT TYPE CONSTANTS
		/** Event used for each log that have to bubble to the AS app. */
		public static const LOG:String = "EVENT_LOG";
		/** Event dispatched when the init is complete. */
		public static const INITIALIZED:String = "EVENT_INITIALIZED";
		/** Event dispatched when the products have been loaded. */
		public static const PRODUCTS_LOADED:String = "EVENT_PRODUCTS_LOADED";
		/** Event dispatched when the buy intent has failed. */
		public static const PURCHASE_FAILURE:String = "EVENT_PURCHASE_FAILURE";
		/** Event dispatched when the user explicitely canceled the purchase. */
		public static const PURCHASE_CANCELED:String = "EVENT_PURCHASE_CANCELED";
		/** Event dispatched when the buy intent has succeeded and the product has been consumed. */
		public static const PURCHASE_SUCCESS:String = "EVENT_PURCHASE_SUCCESS";
		/** Event dispatched when one or more invalid product(s) have been passed to getProducts or buyProducts. */
		public static const PRODUCTS_INVALID:String = "EVENT_PRODUCTS_INVALID";
		/** Event dispatched when a product consumption succeeded. */
		public static const CONSUME_SUCCESS:String = "EVENT_CONSUME_SUCCESS";
		/** Event dispatched when a product consumption has failed. */
		public static const CONSUME_FAILED:String = "EVENT_CONSUME_FAILED";
		/** Event dispatched when calling the <code>restorePurchase</code> function. Dispatched after having requested the store for the user's previous purchases. */
		public static const PURCHASES_RETRIEVED:String = "EVENT_PURCHASES_RETRIEVED";
		/** Event dispatched when the call to <code>getPurchases</code> failed. */
		public static const PURCHASES_RETRIEVING_FAILED:String = "EVENT_PURCHASES_RETRIEVING_FAILED";
		
		
		public function InAppPurchaseANEEvent(type:String) {
			super(type);
		}
	}
}