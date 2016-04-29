package com.studiopixmix.anes.InAppPurchase.event {
	import flash.events.StatusEvent;
	
	/**
	 * Event dispatched when a call to consumePurchase has failed. Contains the error message in the <code>message</code> property.
	 */
	public class PurchaseConsumeFailureEvent extends InAppPurchaseANEEvent {
		// PROPERTIES
		public var message:String;
		
		// CONSTRUCTOR
		public function PurchaseConsumeFailureEvent(message:String) {
			super(InAppPurchaseANEEvent.CONSUME_FAILED);
			
			this.message = message;
		}
		
		public static function FromStatusEvent(statusEvent:StatusEvent):PurchaseConsumeFailureEvent {
			return new PurchaseConsumeFailureEvent(statusEvent.level);
		}
	}
}