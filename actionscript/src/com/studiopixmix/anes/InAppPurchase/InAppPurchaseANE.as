package com.studiopixmix.anes.InAppPurchase
{
	import com.studiopixmix.anes.InAppPurchase.event.InAppPurchaseANEEvent;
	import com.studiopixmix.anes.InAppPurchase.event.LogEvent;
	import com.studiopixmix.anes.InAppPurchase.event.ProductsInvalidEvent;
	import com.studiopixmix.anes.InAppPurchase.event.ProductsLoadedEvent;
	import com.studiopixmix.anes.InAppPurchase.event.PurchaseFailureEvent;
	import com.studiopixmix.anes.InAppPurchase.event.PurchaseSuccessEvent;
	import com.studiopixmix.anes.InAppPurchase.event.PurchasesRetrievedEvent;
	import com.studiopixmix.anes.InAppPurchase.event.PurchasesRetrievingFailed;
	
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	
	/**
	 * To use this extension, create a new instance and call initialize() before trying to interact with it.
	 * Once the ANE is initialized, 
	 */
	public class InAppPurchaseANE extends EventDispatcher {
		
		// CONSTANTS
		private static const EXTENSION_ID:String = "com.studiopixmix.anes.inapppurchase";
		
		private static const NATIVE_METHOD_GET_PRODUCTS:String = "getProducts";
		private static const NATIVE_METHOD_INITIALIZE:String = "initialize";
		private static const NATIVE_METHOD_BUY_PRODUCT:String = "buyProduct";
		private static const NATIVE_METHOD_RESTORE_PURCHASES:String = "restorePurchase";
		
		private static const INITIALIZED:String = "EVENT_INITIALIZED";
		
		// PROPERTIES
		private var extContext:ExtensionContext;
		private var isInitialized:Boolean;
		private var pendingFunctionsToCall:Vector.<Function>;
		private var pendingArguments:Vector.<Array>;
		
		
		// CONSTRUCTOR
		/**
		 * Creates the extension context if possible. Call <code>initialize()</code> before using the rest of the extension.
		 */
		public function InAppPurchaseANE() {
			isInitialized = false;
			pendingFunctionsToCall = new Vector.<Function>();
			pendingArguments = new Vector.<Array>();
			
			extContext = ExtensionContext.createExtensionContext(EXTENSION_ID, "");
			
			if (extContext != null)
				extContext.addEventListener(StatusEvent.STATUS, onStatusEvent);
		}
		
		
		////////////////
		// PUBLIC API //
		////////////////
		
		/**
		 * Calls the <code>initialize</code> method in the native code. This method MUST be called before doing any in-app purchase.
		 */
		public function initialize():void {
			if (!isSupported())
				return;
			
			extContext.call(NATIVE_METHOD_INITIALIZE);
		}
		
		/**
		 * Request the given products information. Dispatches PRODUCTS_LOADED and PRODUCTS_INVALID events.
		 */
		public function getProducts(productsIds:Vector.<String>):void {
			if (!isSupported())
				return;
			
			if (!isInitialized) {
				enqueueUntilInitCompletes(getProducts, [productsIds]);
				return;
			}
			
			if (productsIds.length == 0) {
				dispatchEvent(new ProductsInvalidEvent(productsIds));
				return;
			}
			
			extContext.call(NATIVE_METHOD_GET_PRODUCTS, productsIds);
		}
		
		/**
		 * Buys the given product. Dispatches PURCHASE_SUCCESS and PURCHASE_FAILURE events.
		 * 
		 * @param productId		The native product ID
		 * @param devPayload 	An optional developper payload (Android-only)
		 */
		public function buyProduct(productId:String, devPayload:String = null):void {
			if (!isSupported())
				return;
			
			if (!isInitialized) {
				enqueueUntilInitCompletes(buyProduct, [productId, devPayload]);
				return;
			}
			
			extContext.call(NATIVE_METHOD_BUY_PRODUCT, productId, devPayload);
		}
		
		/**
		 * Requests the native store to get the user's previous purchases. This will return a list of product IDs previously purchased
		 * on the store by the current user. You can use this list in your app to update the unlocked content of your player, for example.
		 * Dispatches PURCHASES_RETRIEVED or PURCHASES_RETRIEVING_FAILED events.
		 */
		public function restorePurchases():void {
			if(!isSupported())
				return;
			
			if (!isInitialized) {
				enqueueUntilInitCompletes(restorePurchases, []);
				return;
			}
			
			extContext.call(NATIVE_METHOD_RESTORE_PURCHASES);
		}
		
		
		/////////////////
		// PRIVATE API //
		/////////////////
		
		/**
		 * Whether the ANE is supported on the current device or not.
		 * This ANE only works on iOS and Android.
		 */
		private function isSupported():Boolean {
			return Capabilities.manufacturer.indexOf('iOS') > -1 || Capabilities.manufacturer.indexOf('Android') > -1;
		}
		
		/**
		 * Called on each Status Event from the native code.
		 * According to the event type, we dispatch the corresponding event filled with its data.
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
			else if (event.code == InAppPurchaseANEEvent.PURCHASES_RETRIEVED)
				eventToDispatch = PurchasesRetrievedEvent.FromStatusEvent(event);
			else if (event.code == InAppPurchaseANEEvent.PURCHASES_RETRIEVING_FAILED)
				eventToDispatch = PurchasesRetrievingFailed.FromStatusEvent(event);
			else if (event.code == INITIALIZED)
				onInitialized();
			
			if(eventToDispatch != null)
				dispatchEvent(eventToDispatch);
		}
		
		/**
		 * Enqueues the given function call until the ANE is initialized.
		 */
		private function enqueueUntilInitCompletes(methodToCall:Function, arguments:Array):void {
			pendingFunctionsToCall.push(methodToCall);
			pendingArguments.push(arguments);
		}
		
		/**
		 * Executes all pending methods calls registered during initialization.
		 */
		private function onInitialized():void {
			isInitialized = true;
			
			var i:int, n:int = pendingFunctionsToCall.length;
			for(i = 0 ; i < n ; i++) {
				pendingFunctionsToCall[i].apply(this, pendingArguments[i]);
			}
		}
	}
}