package com.studiopixmix.anes.InAppPurchase.event
{
	import flash.events.StatusEvent;

	/**
	 * Event dispatched when one or many products are declared invalid by the native store.
	 */
	public class ProductsInvalidEvent extends InAppPurchaseEvent {
		// PROPERTIES
		public var invalidProductsIds:Vector.<String>;
		
		// CONSTRUCTOR
		public function ProductsInvalidEvent(invalidProductsIds:Vector.<String>) {
			super(InAppPurchaseEvent.PRODUCTS_INVALID);
			
			this.invalidProductsIds = invalidProductsIds;
		}
		
		/**
		 * Builds a ProductInvalidEvent from the given StatusEvent.
		 * The invalid products ids are stored as a list of ids separated by "," in the "level" property of the event.
		 */
		public static function FromStatusEvent(statusEvent:StatusEvent):ProductsInvalidEvent {
			try {
				const productIdsAsString:String = statusEvent.level as String;
				const invalidProductsIds:Vector.<String> = Vector.<String>(productIdsAsString.split(","));
				
				return new ProductsInvalidEvent(invalidProductsIds);
			} catch (e:Error) {
			}
			
			return new ProductsInvalidEvent(new <String>[]);
		}
	}
}