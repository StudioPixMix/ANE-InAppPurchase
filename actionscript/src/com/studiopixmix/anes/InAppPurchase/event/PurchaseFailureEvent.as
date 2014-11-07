package com.studiopixmix.anes.InAppPurchase.event
{
	import flash.events.StatusEvent;

	/**
	 * Dispatched when a purchase fails.
	 */
	public class PurchaseFailureEvent extends InAppPurchaseEvent {
		// PROPERTIES
		public var message:String;
		
		// CONSTRUCTOR
		public function PurchaseFailureEvent(message:String) {
			super(InAppPurchaseEvent.PURCHASE_FAILURE);
			
			this.message = message;
		}
		
		public static function FromStatusEvent(statusEvent:StatusEvent):PurchaseFailureEvent {
			return new PurchaseFailureEvent(statusEvent.level);
		}
	}
}