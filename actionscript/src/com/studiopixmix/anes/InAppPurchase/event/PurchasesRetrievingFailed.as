package com.studiopixmix.anes.InAppPurchase.event
{
	import flash.events.StatusEvent;

	/**
	 * Event dispatched if the request to the native store to retrieve the previous purchases of the user failed.
	 * This event contains the error message and the stacktrace.
	 */
	public class PurchasesRetrievingFailed extends InAppPurchaseANEEvent {
		
		// PROPERTIES :
		public var error:String;
		
		// CONSTRUCTOR :
		public function PurchasesRetrievingFailed(error:String) {
			super(InAppPurchaseANEEvent.PURCHASES_RETRIEVING_FAILED);
			this.error = error;
		}
		
		
		/**
		 * Builds a PurchasesRetrievingFailed from the given StatusEvent.
		 */
		public static function FromStatusEvent(statusEvent:StatusEvent):PurchasesRetrievingFailed {
			try {
				const error:String = statusEvent.level as String;
				return new PurchasesRetrievingFailed(error);
			} catch (e:Error) {
			}
			
			return new PurchasesRetrievingFailed(null);
		}
	}
}