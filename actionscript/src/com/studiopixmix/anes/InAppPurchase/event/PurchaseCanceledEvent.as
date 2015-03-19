package com.studiopixmix.anes.InAppPurchase.event {
	import flash.events.StatusEvent;
	
	/**
	 * 
	 */
	public class PurchaseCanceledEvent extends InAppPurchaseANEEvent {
		
		// CONSTRUCTOR
		public function PurchaseCanceledEvent() {
			super(InAppPurchaseANEEvent.PURCHASE_CANCELED);
		}
		
		/**
		 * Builds a PurchaseCanceledEvent from the given status event.
		 */
		public static function FromStatusEvent(statusEvent:StatusEvent):PurchaseCanceledEvent {
			return new PurchaseCanceledEvent();
		}
	}
}