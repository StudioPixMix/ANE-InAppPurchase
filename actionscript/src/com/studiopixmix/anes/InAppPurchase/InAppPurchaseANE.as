package com.studiopixmix.anes.InAppPurchase
{
	import flash.events.EventDispatcher;
	import flash.external.ExtensionContext;
	
	public class InAppPurchaseANE extends EventDispatcher {
		private static const EXTENSION_ID:String = "com.studiopixmix.anes.InAppPurchase";
		
		private var extContext:ExtensionContext;
	
		public function InAppPurchaseANE() {
			extContext = ExtensionContext.createExtensionContext(EXTENSION_ID, "");
			
			if (!extContext)
				dispatchANEEvent(InAppPurchaseEvent.LOG, "Could not create extension context.");
		}
		
		private function dispatchANEEvent(eventType:String, data:String = ""):void {
			dispatchEvent(new InAppPurchaseEvent(eventType, data));
		}
		
		public function test():void {
			dispatchANEEvent(InAppPurchaseEvent.LOG, extContext.call("test") as String);
		}
	}
}