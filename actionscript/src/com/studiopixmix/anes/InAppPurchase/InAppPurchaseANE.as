package com.studiopixmix.anes.InAppPurchase
{
	import com.studiopixmix.anes.InAppPurchase.event.InAppPurchaseANEEvent;
	import com.studiopixmix.anes.InAppPurchase.event.LogEvent;
	import com.studiopixmix.anes.InAppPurchase.event.ProductsInvalidEvent;
	import com.studiopixmix.anes.InAppPurchase.event.ProductsLoadedEvent;
	import com.studiopixmix.anes.InAppPurchase.event.PurchaseFailureEvent;
	import com.studiopixmix.anes.InAppPurchase.event.PurchaseSuccessEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	/**
	 * 
	 */
	public class InAppPurchaseANE extends EventDispatcher {
		// CONSTANTS
		private static const EXTENSION_ID:String = "com.studiopixmix.anes.inapppurchase";
		
		private static const NATIVE_METHOD_GET_PRODUCTS:String = "getProducts";
		private static const NATIVE_METHOD_INITIALIZE:String = "initialize";
		private static const NATIVE_METHOD_BUY_PRODUCT:String = "buyProduct";
		
		// PROPERTIES
		private var extContext:ExtensionContext;
	
		// CONSTRUCTOR
		
		/**
		 * Creates the extension context if possible.
		 */
		public function InAppPurchaseANE() {
			extContext = ExtensionContext.createExtensionContext(EXTENSION_ID, "");
			
			extContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
			
			if (!extContext)
				dispatchEvent(new LogEvent("Could not create extension context."));
		}
		
		// METHODS
		/**
		 * Called on each Status Event from the native code. Switches on the event level to determine the event type
		 * and executes the right function.
		 */
		private function onStatusEvent(event:StatusEvent):void {
			var eventToDispatch:InAppPurchaseANEEvent;
			
			if (event.code == InAppPurchaseANEEvent.LOG)
				eventToDispatch = LogEvent.FromStatusEvent(event);
			else if (event.code == InAppPurchaseANEEvent.PRODUCTS_LOADED)
				eventToDispatch = ProductsLoadedEvent.FromStatusEvent(event);
			else if (event.code == InAppPurchaseANEEvent.PRODUCTS_INVALID)
				eventToDispatch = ProductsInvalidEvent.FromStatusEvent(event);
			else if (event.code == InAppPurchaseANEEvent.PURCHASE_SUCCESS)
				eventToDispatch = PurchaseSuccessEvent.FromStatusEvent(event);
			else if (event.code == InAppPurchaseANEEvent.PURCHASE_FAILURE)
				eventToDispatch = PurchaseFailureEvent.FromStatusEvent(event);
			
			dispatchEvent(eventToDispatch);
		}
		
		/**
		 * Calls the <code>initialize</code> method in the native code. This method MUST be called before doing any in-app purchase.
		 */
		public function initialize():void {
			extContext.call(NATIVE_METHOD_INITIALIZE);
		}
		
		/**
		 * Request the given products informations.
		 */
		public function getProducts(productsIds:Vector.<String>):void {
			if (productsIds.length == 0) {
				dispatchEvent(new ProductsInvalidEvent(productsIds));
				return;
			}
			
			extContext.call(NATIVE_METHOD_GET_PRODUCTS, productsIds);
		}
		
		/**
		 * Buys the given product.
		 * @param devPayload Android-only. Optional.
		 */
		public function buyProduct(productId:String, devPayload:String):void {
			extContext.call(NATIVE_METHOD_BUY_PRODUCT, productId, devPayload);
		}
	}
}