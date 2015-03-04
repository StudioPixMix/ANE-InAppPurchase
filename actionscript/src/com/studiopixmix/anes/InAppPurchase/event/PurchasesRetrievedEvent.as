package com.studiopixmix.anes.InAppPurchase.event
{
	import flash.events.StatusEvent;

	/**
	 * Event dispatched when the the request to the store to retrieve the user's previous purchases succeeded. 
	 * This event contains a collection of product IDs 
	 */
	public class PurchasesRetrievedEvent extends InAppPurchaseANEEvent {
		
		// PROPERTIES :
		/** The collection of all the product IDs of the previous purchases of the user. */
		public var purchases:Vector.<String>;
		
		// CONSTRUCTOR :
		public function PurchasesRetrievedEvent(purchases:Vector.<String>) {
			super(InAppPurchaseANEEvent.PURCHASES_RETRIEVED);
			this.purchases = purchases;
		}
		
		
		/**
		 * Builds a PurchasesRetrievedEvent from the given StatusEvent.
		 * The previous purchases are stored as a list of ids separated by "," in the "level" property of the event.
		 */
		public static function FromStatusEvent(statusEvent:StatusEvent):PurchasesRetrievedEvent {
			try {
				const productIdsAsString:String = statusEvent.level as String;
				const purchases:Vector.<String> = productIdsAsString != null ? Vector.<String>(productIdsAsString.split(",")) : null;
				
				return new PurchasesRetrievedEvent(purchases);
			} catch (e:Error) {
			}
			
			return new PurchasesRetrievedEvent(new <String>[]);
		}
	}
}