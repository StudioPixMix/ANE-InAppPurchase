package com.studiopixmix.anes.InAppPurchase.event
{
	import com.studiopixmix.anes.InAppPurchase.InAppPurchaseProduct;
	
	import flash.events.StatusEvent;

	/**
	 * Event dispatched when products are loaded from the native store.
	 */
	public class ProductsLoadedEvent extends InAppPurchaseEvent {
		// PROPERTIES
		public var products:Vector.<InAppPurchaseProduct>;

		// CONSTRUCTOR
		public function ProductsLoadedEvent() {
			super(InAppPurchaseEvent.PRODUCTS_LOADED);
			
			this.products = new Vector.<InAppPurchaseProduct>();
		}
		
		/**
		 * Builds a ProductsLoadedEvent from the given status event dispatched by the native side.
		 * The products are returned as a JSON string in the "level" property of the status event.
		 */
		public static function FromStatusEvent(statusEvent:StatusEvent):ProductsLoadedEvent {
			const newEvent:ProductsLoadedEvent = new ProductsLoadedEvent();
			
			try {
				const productsArray:Array = JSON.parse(statusEvent.level) as Array;
				const numProductsInArray:int = productsArray.length;
				
				for (var i:int = 0; i < numProductsInArray; i++)
					newEvent.products.push(InAppPurchaseProduct.FromJSONProduct(productsArray[0]));
			} catch(e:Error) {
			}
			
			return newEvent;
		}
	}
}