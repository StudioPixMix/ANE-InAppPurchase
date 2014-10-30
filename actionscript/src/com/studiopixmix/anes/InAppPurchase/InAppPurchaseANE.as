package com.studiopixmix.anes.InAppPurchase
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	
	public class InAppPurchaseANE extends EventDispatcher {
		private static const EXTENSION_ID:String = "com.studiopixmix.anes.InAppPurchase";
		
		private var extContext:ExtensionContext;
	
		public function InAppPurchaseANE() {
			extContext = ExtensionContext.createExtensionContext(EXTENSION_ID, "");
			
			extContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
			
			if (!extContext)
				dispatchANEEvent(InAppPurchaseEvent.LOG, "Could not create extension context.");
		}
		
		private function dispatchANEEvent(eventType:String, data:String = ""):void {
			dispatchEvent(new InAppPurchaseEvent(eventType, data));
		}
		
		public function test():void {
			dispatchANEEvent(InAppPurchaseEvent.LOG, extContext.call("test") as String);
		}
		
		
		//////////////
		// HANDLERS //
		//////////////
		
		/**
		 * Called on each Status Event from the native code. Switches on the event level to determine the event type
		 * and execute the right function.
		 */
		private function onStatusEvent(event:StatusEvent):void {
			if(event.level == InAppPurchaseEvent.LOG) {
				trace("Logged.");
				trace(event.code);
			}
		}
		
	}
}