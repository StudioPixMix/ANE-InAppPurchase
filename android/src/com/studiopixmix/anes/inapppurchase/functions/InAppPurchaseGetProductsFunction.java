package com.studiopixmix.anes.inapppurchase.functions;

import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.Arrays;

import org.json.JSONArray;
import org.json.JSONObject;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.RemoteException;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseExtension;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseExtensionContext;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseMessages;

public class InAppPurchaseGetProductsFunction implements FREFunction {
	
	// CONSTANTS :
	/** The key used for the products IDs bundle. */
	private static final String ITEM_ID_LIST = "ITEM_ID_LIST";
	/** The response code key used when getting the products details. The differents codes are detailed below. */
	private static final String RESPONSE_CODE = "RESPONSE_CODE";
	/** The key used for the products details, formated in an ArrayList of JSONs. */
	private static final String DETAILS_LIST = "DETAILS_LIST";
	
	/** 
	 * The error codes messages, in String, as described in the Google documentation. 
	 * 
	 * @see <a href="http://developer.android.com/google/play/billing/billing_reference.html#response-codes">Google response codes documentation</a>
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
		
		// The local variables have to be final, so it can be used in the async task.
		final InAppPurchaseExtensionContext context = (InAppPurchaseExtensionContext) c;
		final Activity activity = context.getActivity();
		final ArrayList<String> productsIds = FREArrayToArrayList((FREArray) args[0]);
		
		// The getSkuDetails method is synchronous, so it has to be executed in an asynchronous task to avoid blocking the main thread.
		(new AsyncTask<Void, Void, Void>() {
			@Override
			protected Void doInBackground(Void... params) {

				// Converts the given data to a bundle of products IDs.
				Bundle products = new Bundle();
				products.putStringArrayList(ITEM_ID_LIST, productsIds);
				
				// Retrieves the products details.
				Bundle skuDetails = null;
				try {
					skuDetails = context.getInAppBillingService().getSkuDetails(3, activity.getPackageName(), "inapp", products);
				}
				catch(RemoteException e) {
					InAppPurchaseExtension.logToAS("Error while retrieving the products details : " + e.toString());
					return null;
				}
				
				
				// Parsing the received JSON if the response code is success.
				int responseCode = skuDetails.getInt(RESPONSE_CODE);
				ArrayList<String> detailsJson;
				String finalJSON = null;
				if(responseCode == 0) {
					detailsJson = skuDetails.getStringArrayList(DETAILS_LIST);
					
					if(detailsJson == null || detailsJson.size() == 0) {
						InAppPurchaseExtension.logToAS("No products details retrieved!");
						return null;
					}
						
					int i, length = detailsJson.size();
					ArrayList<JSONObject> details = new ArrayList<JSONObject>();
					JSONObject currentObject;
					JSONObject currentJsonObject;
					
					// Number formatter used to format the localized price returned by Google to a normal double.
					NumberFormat format = NumberFormat.getInstance();
					Number number;
					
					for(i = 0 ; i < length ; i++) {
						try {
							currentJsonObject = new JSONObject(detailsJson.get(i));
							currentObject = new JSONObject();
							currentObject.put("id", currentJsonObject.get("productId"));
							currentObject.put("title", currentJsonObject.get("title"));
							currentObject.put("description", currentJsonObject.get("description"));
							// Formats the price to an amount rounded to 2 decimals.
							number = format.parse(currentJsonObject.get("price_amount_micros").toString());
							currentObject.put("price", format.parse(String.format("%.2f", number.doubleValue() / 1000000.0)).doubleValue());
							details.add(currentObject);
						}
						catch (Exception e) {
							InAppPurchaseExtension.logToAS("Error while parsing the products JSON! " + e.toString());
							return null;
						}
					}
					
					JSONArray toto = new JSONArray(details);
					finalJSON = toto.toString();
				}
				else {
					InAppPurchaseExtension.logToAS("Error while loading the products : " + ERRORS_MESSAGES.get(responseCode));
					return null;
				}
				
				context.dispatchStatusEventAsync(InAppPurchaseMessages.PRODUCTS_LOADED, finalJSON);
				
				return null;
			}
		}).execute();
		
		return null;
	}
	
	
	/**
	 * Returns the given FREArray as an String ArrayList. This method is used to cast the products IDs in FREArray
	 * into a java collection to communicate with the Google in-app billing service.
	 */
	private ArrayList<String> FREArrayToArrayList(FREArray array) {
		int i;
		long length = 0;
		ArrayList<String> list = new ArrayList<String>();

		try {
			length = array.getLength();
		}
		catch(Exception e) { InAppPurchaseExtension.logToAS("Error while reading the products IDs : " + e.toString()); }
		
		for(i = 0 ; i < length ; i++) {
			try {
				list.add(array.getObjectAt(i).getAsString());
			}
			catch(Exception e) { InAppPurchaseExtension.logToAS("Error while reading the products IDs : " + e.toString());}
		}
		
		return list;
	}

}
