Air Native Extension for In-app purchases on iOS and Android (ARM and x86)
==================================

### General info :
- Android In-app Billing Version 3 API. 
- Add this to your android manifest :

```xml
<android>
	<manifestAdditions><![CDATA[
		<manifest android:installLocation="auto">

			...

			<!-- IN APP PURCHASE -->
			<uses-permission android:name="com.android.vending.BILLING" />

			...

			<application>

				...

				<!-- IN APP PURCHASE -->
				<activity android:name="com.studiopixmix.anes.inapppurchase.activities.BillingActivity" android:theme="@android:style/Theme.Translucent.NoTitleBar.Fullscreen" />

			</application>

		</manifest>
	]]></manifestAdditions>
</android>
```

### Overview :
When initializing your app, call the initialize method to init the internal ANE.

The ANE will trigger all callbacks with events as the methods may not be synchronous, we recommend you to create an InAppPurchaseHandler class that will call the methods and handle the callbacks.
- Use the **getProducts()** method to retrieve your products details from the native store, such as its price, name, description, currency, etc... This method takes the list of the desired products IDs as parameter. Dispatches a *ProductsLoadedEvent* with the concerned products list, and eventually a *ProductsInvalidEvent* if some wrong products IDs were passed.
- Use the **buyProduct()** method to make a purchase attempt on the native store with the native product ID as parameter and eventually a developer payload if you want to enforce the purchase security. Dispatches whether a *PurchaseSuccessEvent* or a *PurchaseFailureEvent* following the purchase result.
- Use the **restorePurchase()** method to get a list of all products IDs purchased by the user. It's up to you to update your app unlocked content or player's items for example following the returned list. Dispatches whether a *PurchasesRetrievedEvent* or a *PurchasesRetrievingFailed* following the restore result.

For more info on the events data to handle in the callbacks, see the [full documentation here](https://rawgit.com/StudioPixMix/ANE-InAppPurchase/master/doc/index.html) .



For more info on the in-app purchases process for Android or iOS, see :
- http://developer.android.com/google/play/billing/billing_overview.html
- https://developer.apple.com/in-app-purchase/
