package com.studiopixmix.anes.InAppPurchase
{
	import flash.events.StatusEvent;

	/**
	 * Represents a successfull purchase.
	 * For more informations about the fields, see the related stores documentations.
	 */
	public class SuccessfullPurchase {
		// iOS and Android
		public var productId:String;
		public var transactionDate:Date;
		
		// iOS only
		public var applicationUsername:String;
		public var transactionId:String;
		public var transactionReceipt:String;
		
		// Android only
		public var developerPayload:String;
		public var purchaseToken:String;
		public var orderId:String;
		public var playStoreResponse:String;
		public var signature:String;
		
		public function SuccessfullPurchase() {
		}
		
		public function toString():String {
			return "<SuccessfullPurchase:[" +
				"productId:" + productId + "," +
				"transactionDate:" + transactionDate + ", " +
				"applicationUsername:" + applicationUsername + ", " +
				"transactionId:" + transactionId + ", " +
				"transactionReceipt:" + transactionReceipt + ", " +
				"developerPayload:" + developerPayload + ", " +
				"purchaseToken:" + purchaseToken + ", " +
				"orderId:" + orderId + ", " +
				"playStoreResponse:" + playStoreResponse + ", " +
				"signature:" + signature + "]>";
		}
		
		/**
		 * Builds a SuccessfullPurchase from the given JSON object.
		 */
		public static function FromJSONPurchase(jsonPurchase:Object):SuccessfullPurchase {
			const newPurchase:SuccessfullPurchase = new SuccessfullPurchase();
			
			newPurchase.productId = jsonPurchase.productId;
			newPurchase.transactionDate = new Date();
			newPurchase.transactionDate.setTime(jsonPurchase.transactionTimestamp * 1000);
			newPurchase.applicationUsername = jsonPurchase.hasOwnProperty("applicationUsername") ? jsonPurchase.applicationUsername : "";
			newPurchase.transactionId = jsonPurchase.hasOwnProperty("transactionId") ? jsonPurchase.transactionId : "";
			newPurchase.transactionReceipt = jsonPurchase.hasOwnProperty("transactionReceipt") ? jsonPurchase.transactionReceipt : "";
			newPurchase.developerPayload = jsonPurchase.hasOwnProperty("developerPayload") ? jsonPurchase.developerPayload : "";
			newPurchase.purchaseToken = jsonPurchase.hasOwnProperty("purchaseToken") ? jsonPurchase.purchaseToken : "";
			newPurchase.orderId = jsonPurchase.hasOwnProperty("orderId") ? jsonPurchase.orderId : "";
			newPurchase.playStoreResponse = jsonPurchase.hasOwnProperty("playStoreResponse") ? jsonPurchase.playStoreResponse : "";
			newPurchase.signature = jsonPurchase.hasOwnProperty("signature") ? jsonPurchase.signature : "";

			return newPurchase;
		}
	}
}