package com.studiopixmix.anes.inapppurchase.functions;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.json.JSONArray;

import android.app.Activity;
import android.os.Bundle;
import android.os.RemoteException;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.android.vending.billing.IInAppBillingService;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseExtension;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseExtensionContext;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseMessages;

/**
 * A function that retrieves the user's previous purchase by requesting the store. This method returns 
 */
public class InAppPurchaseRestorePurchasesFunction implements FREFunction {
	
	// CONSTANTS :
	/** The list of the productIds previously bought by the user. */
	private static final String INAPP_PURCHASE_ITEM_LIST = "INAPP_PURCHASE_ITEM_LIST";
	/** The response code key used when getting the products details. The differents codes are detailed below. */
	private static final String RESPONSE_CODE = "RESPONSE_CODE";
	/** The continuation token used if the list was too long to fit in one request. If this property is not null in the response Bundle, a new call to
	 * <code>getPurchases</code> should be made with the continuation token as parameter.. */
	private static final String INAPP_CONTINUATION_TOKEN = "INAPP_CONTINUATION_TOKEN";
	
	
	/** 
	 * The error codes messages, in String, as described in the Google documentation. 
	 * 
	 * @see <a href="http://developer.android.com/google/play/billing/billing_reference.html#billing-codes">Google response codes documentation</a>
	 */
	private static final ArrayList<String> ERRORS_MESSAGES = new ArrayList<String>(Arrays.asList(
				"Success.",
				"User interrupted the request or cancelled the dialog!",
				"The network connection is down!",
				"Billing API version is not supported for the type requested!",
				"Requested product is not available for purchase!",
				"Invalid arguments provided to the API! Have you checked that your application is set for in-app purchases and has the necessary permissions in the manifest?",
				"Fatal error during the API action!",
				"Failure to purchase since item is already owned!",
				"Failure to consume since item is not owned"
			));

	@Override
	public FREObject call(FREContext c, FREObject[] args) {
		
		final InAppPurchaseExtensionContext context = (InAppPurchaseExtensionContext) c;
		
		context.executeWithService(new Runnable() {
			@Override
			public void run() {
				// The local variables have to be final, so it can be used in the async task.
				final Activity activity = context.getActivity();
				final IInAppBillingService iapService = context.getInAppBillingService();
				
				InAppPurchaseExtension.logToAS("Restoring the user's purchases ...");
				
				// Retrieves the products details.
				List<String> purchaseIds = null;
				try {
					purchaseIds = getPurchaseIds(iapService, activity.getPackageName(), "inapp", null);
					InAppPurchaseExtension.logToAS("PurchaseIds value : " + purchaseIds);
				}
				catch(Exception e) {
					InAppPurchaseExtension.logToAS("Error while retrieving the previous purchases : " + e.toString() + "\n at " + e.getStackTrace());
					context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASES_RETRIEVING_FAILED, e.getMessage());
					return;
				}
				
				if(purchaseIds == null || purchaseIds.size() == 0) {
					InAppPurchaseExtension.logToAS("no purchases to restore, returning ...");
					context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASES_RETRIEVED, null);
					return;
				}
				
				// We have at least 1 purchase to restore.
				String purchases = purchaseIds.get(0);
				for(int i = 1 ; i < purchaseIds.size() ; i++)
					purchases += "," + purchaseIds.get(i);
				
				InAppPurchaseExtension.logToAS("Found " + purchaseIds.size() + " purchases to restore ... returning their IDs : " + purchases);
				context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASES_RETRIEVED, purchases);
			}
		});
		
		return null;
	}
	
	
	/**
	 * Recursively calls <code>getPruchases</code> to retrieve all the purchased products for the user. The method uses a continuation token
	 * to handle the case where the list of purchases is too large to fit in one request.
	 * 
	 * @throws RemoteException
	 */
	private List<String> getPurchaseIds(IInAppBillingService iapService, String packageName, String type, String continuationToken) throws RemoteException {
		Bundle bundle = iapService.getPurchases(InAppPurchaseExtension.API_VERSION, packageName, type, continuationToken);
		
		// Parsing the received JSON if the response code is success.
		int responseCode = bundle.getInt(RESPONSE_CODE);
		ArrayList<String> productsIds = null;
		
		if(responseCode == 0) {
			productsIds = bundle.getStringArrayList(INAPP_PURCHASE_ITEM_LIST);
			InAppPurchaseExtension.logToAS("Native store returned " + productsIds);
			String cToken = bundle.getString(INAPP_CONTINUATION_TOKEN);
			
			if(continuationToken != null) {
				InAppPurchaseExtension.logToAS("There is a continuation token, fetching the next purchases ...");
				
				// There is a continuation token, retrieving next part ...
				List<String> ids = getPurchaseIds(iapService, packageName, type, cToken);
				if(ids != null)
					productsIds.addAll(ids);
			}
		}
		
		else {
			InAppPurchaseExtension.logToAS("Error while loading the products : " + ERRORS_MESSAGES.get(responseCode));
		}
		
		return productsIds;
	}

}
