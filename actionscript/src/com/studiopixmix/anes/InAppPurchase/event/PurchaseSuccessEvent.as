package com.studiopixmix.anes.InAppPurchase.event
{
	import com.studiopixmix.anes.InAppPurchase.SuccessfullPurchase;
	
	import flash.events.StatusEvent;

	/**
	 * Event dispatched when a purchase is successful.
	 */
	public class PurchaseSuccessEvent extends InAppPurchaseEvent {
		// PROPERTIES
		public var purchase:SuccessfullPurchase;
		
		// CONSTRUCTOR
		public function PurchaseSuccessEvent(purchase:SuccessfullPurchase) {
			super(InAppPurchaseEvent.PURCHASE_SUCCESS);
			
			this.purchase = purchase;
		}
		
		/**
		 * Builds a PurchaseSuccessEvent from the given status event.
		 * The purchase JSON data is stored in the "level" property of the status event.
		 */
		public static function FromStatusEvent(statusEvent:StatusEvent):PurchaseSuccessEvent {
			try {
				const purchase:SuccessfullPurchase = SuccessfullPurchase.FromJSONPurchase(JSON.parse(statusEvent.level));
				return new PurchaseSuccessEvent(purchase);
			} catch(e:Error) {
			}

			return new PurchaseSuccessEvent(new SuccessfullPurchase());
		}
	}
}