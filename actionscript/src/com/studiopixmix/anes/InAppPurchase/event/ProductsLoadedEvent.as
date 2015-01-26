package com.studiopixmix.anes.InAppPurchase.event
{
	import com.studiopixmix.anes.InAppPurchase.InAppPurchaseProduct;
	
	import flash.events.StatusEvent;

	/**
	 * Event dispatched when products are loaded from the native store.
	 */
	public class ProductsLoadedEvent extends InAppPurchaseANEEvent {
		// PROPERTIES
		public var products:Vector.<InAppPurchaseProduct>;

		// CONSTRUCTOR
		public function ProductsLoadedEvent(products:Vector.<InAppPurchaseProduct>) {
			super(InAppPurchaseANEEvent.PRODUCTS_LOADED);
			
			this.products = products;
		}
		
		/**
		 * Builds a ProductsLoadedEvent from the given status event dispatched by the native side.
		 * The products are returned as a JSON string in the "level" property of the status event.
		 */
		public static function FromStatusEvent(statusEvent:StatusEvent):ProductsLoadedEvent {
			try {
				const productsArray:Array = JSON.parse(statusEvent.level) as Array;
				const numProductsInArray:int = productsArray.length;
				const products:Vector.<InAppPurchaseProduct> = new Vector.<InAppPurchaseProduct>();
				
				for (var i:int = 0; i < numProductsInArray; i++)
					products.push(InAppPurchaseProduct.FromJSONProduct(productsArray[i]));
				
				return new ProductsLoadedEvent(products);
			} catch(e:Error) {
			}
			
			return new ProductsLoadedEvent(new <InAppPurchaseProduct>[]);
		}
	}
}