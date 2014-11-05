package com.studiopixmix.anes.InAppPurchase
{
	import com.studiopixmix.anes.InAppPurchase.event.InAppPurchaseEvent;
	import com.studiopixmix.anes.InAppPurchase.event.ProductsInvalidEvent;
	import com.studiopixmix.anes.InAppPurchase.event.ProductsLoadedEvent;
	
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
		/** The logging function you want to use. Defaults to trace. */
		public static var loggingFunc:Function = trace;
		/** The prefix appended to every log message. Defaults to "[InAppPurchase]". */
		public static var logPrefix:String = "[InAppPurchase]";
		
		private var extContext:ExtensionContext;
	
		// CONSTRUCTOR
		
		/**
		 * Creates the extension context if possible.
		 */
		public function InAppPurchaseANE() {
			extContext = ExtensionContext.createExtensionContext(EXTENSION_ID, "");
			
			extContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
			
			if (!extContext)
				log("Could not create extension context.");
		}
		
		// METHODS
		/**
		 * Logs the given message if we have a logger registered.
		 */
		private function log(message:String, ... additionalMessages):void {
			if (loggingFunc == null)
				return;
			
			if(!additionalMessages)
				additionalMessages = [];
			
			loggingFunc((logPrefix && logPrefix.length > 0 ? logPrefix + " " : "") + message + " " + additionalMessages.join(" "));

		}
		
		/**
		 * Called on each Status Event from the native code. Switches on the event level to determine the event type
		 * and executes the right function.
		 */
		private function onStatusEvent(event:StatusEvent):void {
			if (event.code == InAppPurchaseEvent.LOG)
				log(event.level);
			else if (event.code == InAppPurchaseEvent.PRODUCTS_LOADED)
				dispatchEvent(ProductsLoadedEvent.FromStatusEvent(event));
			else if (event.code == InAppPurchaseEvent.PRODUCTS_INVALID)
				dispatchEvent(ProductsInvalidEvent.FromStatusEvent(event));
			else if (event.code == InAppPurchaseEvent.PURCHASE_SUCCESS)
				log("Purchase success !");
			else if (event.code == InAppPurchaseEvent.PURCHASE_FAILURE)
				log("Purchase failure !");
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
			extContext.call(NATIVE_METHOD_GET_PRODUCTS, productsIds);
		}
		
		/**
		 * Buys the given product.
		 */
		public function buyProduct(productId:String):void {
			extContext.call(NATIVE_METHOD_BUY_PRODUCT, productId);
		}
	}
}