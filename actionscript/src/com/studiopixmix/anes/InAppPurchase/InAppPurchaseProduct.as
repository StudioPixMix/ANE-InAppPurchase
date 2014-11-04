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
	}
}