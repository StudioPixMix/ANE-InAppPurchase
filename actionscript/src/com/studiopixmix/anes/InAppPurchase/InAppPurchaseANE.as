package com.studiopixmix.anes.InAppPurchase
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	/**
	 * 
	 */
	public class InAppPurchaseANE extends EventDispatcher {
		// CONSTANTS
		private static const EXTENSION_ID:String = "com.studiopixmix.anes.inapppurchase";
		
		private static const NATIVE_METHOD_TEST:String = "test";
		private static const NATIVE_METHOD_GET_PRODUCTS:String = "getProducts";
		
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
				dispatchANEEvent(InAppPurchaseEvent.LOG, "Could not create extension context.");
		}
		
		// METHODS
		/**
		 * Called on each Status Event from the native code. Switches on the event level to determine the event type
		 * and executes the right function.
		 */
		private function onStatusEvent(event:StatusEvent):void {
			if (event.code == InAppPurchaseEvent.LOG)
				dispatchANEEvent(InAppPurchaseEvent.LOG, event.level);
		}
		
		/**
		 * Helper to dispatch an InAppPurchaseEvent.
		 */
		private function dispatchANEEvent(eventType:String, data:String = ""):void {
			dispatchEvent(new InAppPurchaseEvent(eventType, data));
		}
		
		/**
		 * Test method to see if the ANE is working. Calls the "test" native method.
		 */
		public function test():void {
			dispatchANEEvent(InAppPurchaseEvent.LOG, extContext.call(NATIVE_METHOD_TEST) as String);
		}
		
		/**
		 * Request the given products informations.
		 */
		public function getProducts(productsIds:Vector.<String>):void {
			extContext.call(NATIVE_METHOD_GET_PRODUCTS, productsIds);
		}
	}
}