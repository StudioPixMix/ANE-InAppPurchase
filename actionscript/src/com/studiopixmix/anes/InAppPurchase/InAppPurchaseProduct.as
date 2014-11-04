package com.studiopixmix.anes.InAppPurchase
{
	/**
	 * Represents a product that can be purchased in the app
	 * On iOS, this is the AS equivalent of SKProduct.
	 */
	public class InAppPurchaseProduct {
		// PROPERTIES
		
		/**
		 * iOS equivalent : productIdentifier
		 */
		public var id:String;
		
		/**
		 * iOS equivalent : localizedTitle
		 */
		public var title:String;
		
		/**
		 * iOS equivalent : localizedDescription
		 */
		public var description:String;
		
		/**
		 * iOS equivalent : price
		 */
		public var price:Number;
		
		// CONSTRUCTOR
		public function InAppPurchaseProduct() {
		}
		
		/**
		 * Builds an InAppPurchaseProduct from the given JSON object.
		 */
		public static function FromJSONProduct(jsonProduct:Object):InAppPurchaseProduct {
			const product:InAppPurchaseProduct = new InAppPurchaseProduct();
			
			product.id = jsonProduct.id;
			product.title = jsonProduct.title;
			product.description = jsonProduct.description;
			product.price = jsonProduct.price;
			
			return product;
		}
		
		public function toString():String {
			return "<InAppPurchaseProduct[id:" + id + ", title:" + title + ", price:" + price + "]>";
		}
	}
}