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
		/** The logging function you want to use. Defaults to trace. */
        public static var logger:Function = trace;
        /** The prefix appended to every log message. Defaults to "[Inneractive]". */
        public static var logPrefix:String = "[InAppPurchaseANE]";

	
		// CONSTRUCTOR
		
		/**
		 * Creates the extension context if possible.
		 */
		public function InAppPurchaseANE() {
			extContext = ExtensionContext.createExtensionContext(EXTENSION_ID, "");
			log("Context created : " + extContext);
			
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
				log(event.level);
			else if (event.code == InAppPurchaseEvent.PRODUCTS_LOADED) {
				try {
					const productsArray:Array = JSON.parse(event.level) as Array;
					const numProductsInArray:int = productsArray.length;
					
					const productsVector:Vector.<InAppPurchaseProduct> = new Vector.<InAppPurchaseProduct>();
					
					for (var i:int = 0; i < numProductsInArray; i++)
						productsVector.push(createInAppPurchaseProductFromJSON(productsArray[0]));
				} catch (e:Error) {
					dispatchANEEvent(InAppPurchaseEvent.LOG, "");
					
				}
					
				dispatchANEEvent(InAppPurchaseEvent.PRODUCTS_LOADED, productsVector);
			}
		}
		
		private function createInAppPurchaseProductFromJSON(jsonProduct:Object):InAppPurchaseProduct {
			const product:InAppPurchaseProduct = new InAppPurchaseProduct();
			
			product.id = jsonProduct.id;
			product.title = jsonProduct.title;
			product.description = jsonProduct.description;
			product.price = jsonProduct.price;
			
			return product;
		}
		
		/**
		 * Helper to dispatch an InAppPurchaseEvent.
		 */
		private function dispatchANEEvent(eventType:String, data:Object):void {
			dispatchEvent(new InAppPurchaseEvent(eventType, data));
		}
		
		/**
		 * Test method to see if the ANE is working. Calls the "test" native method.
		 */
		public function test():void {
		    log("Testing the ane ...");
			dispatchANEEvent(InAppPurchaseEvent.LOG, extContext.call(NATIVE_METHOD_TEST) as String);
		}
		
		/**
		 * Request the given products informations.
		 */
		public function getProducts(productsIds:Vector.<String>):void {
			extContext.call(NATIVE_METHOD_GET_PRODUCTS, productsIds);
		}
		
		
		/////////////
        // LOGGING //
        /////////////
        
        /**
         * Outputs the given message(s) using the provided logger function, or using trace.
         */
        private static function log(message:String, ... additionnalMessages):void {
            if(logger == null) return;
            
            if(!additionnalMessages)
                additionnalMessages = [];
            
            logger((logPrefix && logPrefix.length > 0 ? logPrefix + " " : "") + message + " " + additionnalMessages.join(" "));
        }

	}
}