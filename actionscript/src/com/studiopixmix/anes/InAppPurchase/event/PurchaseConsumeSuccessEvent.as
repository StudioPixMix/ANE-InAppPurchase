package com.studiopixmix.anes.InAppPurchase.event {
	import flash.events.StatusEvent;
	
	/**
	 * Event dispatched when a consume product call has succeeded. It contains the purchase token as data.
	 */
	public class PurchaseConsumeSuccessEvent extends InAppPurchaseANEEvent {
		
		// PROPERTIES :
		/** The purchase token of the consumed product. */
		public var purchaseToken:String;
		
		// CONSTRUCTOR :
		public function PurchaseConsumeSuccessEvent(purchaseToken:String) {
			super(InAppPurchaseANEEvent.CONSUME_SUCCESS);
			this.purchaseToken = purchaseToken;
		}
		
		/**
		 * Builds a PurchaseConsumeSuccessEvent from the given status event dispatched by the native side.
		 * The products are returned as a JSON string in the "level" property of the status event.
		 */
		public static function FromStatusEvent(statusEvent:StatusEvent):PurchaseConsumeSuccessEvent {
			return new PurchaseConsumeSuccessEvent(statusEvent.level);
		}
	}
}