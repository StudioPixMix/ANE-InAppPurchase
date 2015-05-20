package com.studiopixmix.anes.inapppurchase.functions;

import android.content.Context;
import android.content.Intent;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseExtensionContext;

/**
 * A method used to initialize the ANE, binds the activity to the In-app billing service
 * on Google Play through a ServiceConnection.
 */
public class InAppPurchaseInitFunction implements FREFunction {

	@Override
	public FREObject call(FREContext context, FREObject[] args) {
		
		// Binds the in-app billing service to the ServiceConnection created above.
		Intent serviceIntent = new Intent("com.android.vending.billing.InAppBillingService.BIND");
		serviceIntent.setPackage("com.android.vending");
		context.getActivity().bindService(serviceIntent, ((InAppPurchaseExtensionContext) context).getServiceConnection(), Context.BIND_AUTO_CREATE);
		
		return null;
	}
	
	
	
	/**
	 * Retrieves the previous purchases to check if any of them has not been consumed yet. 
	 * If it is the case, consumes it in an asynchronous task.
	 */
//	public static void checkPreviousPurchases(InAppPurchaseExtensionContext context) {
//		
//		final InAppPurchaseExtensionContext c = context;
//		
//		c.executeWithService(new Runnable() {
//			@Override
//			public void run() {
//				// The local variables used in the asynchronous task.
//				final String packageName = c.getActivity().getPackageName();
//				final IInAppBillingService iapService = c.getInAppBillingService();
//				
//				// The getSkuDetails method is synchronous, so it has to be executed in an asynchronous task to avoid blocking the main thread.
//				(new AsyncTask<Void, Void, Void>() {
//					@Override
//					protected Void doInBackground(Void... params) {
//						try {
//							
//							InAppPurchaseExtension.logToAS("Trying to finalize incomplete previous purchases ...");
//							Bundle previousPurchases = iapService.getPurchases(InAppPurchaseExtension.API_VERSION, packageName, "inapp", null);
//							
//							ArrayList<String> itemsJson = previousPurchases.getStringArrayList("INAPP_PURCHASE_DATA_LIST");
//							ArrayList<String> dataSignatures = previousPurchases.getStringArrayList("INAPP_DATA_SIGNATURE_LIST");
//							
//							int i, n = itemsJson.size();
//							
//							if(n > 0) {
//								for(i = 0 ; i < n ; i++) {
//									InAppPurchaseBuyProductFunction.consumeProduct(new JSONObject(itemsJson.get(i)), c, itemsJson.get(i), dataSignatures.get(i));
//								}
//								
//								InAppPurchaseExtension.logToAS(n + " previous item(s) has been consumed.");
//							}
//							else
//								InAppPurchaseExtension.logToAS("No previous purchase consumption is pending, everything's fine.");
//						}
//						catch(Exception e) {
//							InAppPurchaseExtension.logToAS("The previous purchases check has failed! " + e.toString());
//						}
//						
//						return null;
//					}
//				}).execute();
//			}
//		});
//	}

}
