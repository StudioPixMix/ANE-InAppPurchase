package com.studiopixmix.anes.InAppPurchase.event
{
	import com.studiopixmix.anes.InAppPurchase.InAppPurchaseProduct;
	
	import flash.events.StatusEvent;

	/**
	 * Event dispatched when one or many products are declared invalid by the native store.
	 */
	public class ProductsInvalidEvent extends InAppPurchaseEvent {
		// PROPERTIES
		public var invalidProductsIds:Vector.<String>;
		
		// CONSTRUCTOR
		public function ProductsInvalidEvent() {
			super(InAppPurchaseEvent.PRODUCTS_INVALID);
			
			this.invalidProductsIds = new Vector.<String>();
		}
		
		/**
		 * Builds a ProductInvalidEvent from the given StatusEvent.
		 * The invalid products ids are stored as a list of ids separated by "," in the "level" property of the event.
		 */
		public static function FromStatusEvent(statusEvent:StatusEvent):ProductsInvalidEvent {
			const newEvent:ProductsInvalidEvent = new ProductsInvalidEvent();
			
			try {
				const productIdsAsString:String = statusEvent.level as String;
				newEvent.invalidProductsIds = Vector.<String>(productIdsAsString.split(","));
			} catch (e:Error) {
			}
			
			return newEvent;
		}
	}
}