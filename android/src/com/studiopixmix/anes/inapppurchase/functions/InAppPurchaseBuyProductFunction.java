package com.studiopixmix.anes.inapppurchase.functions;

import java.util.ArrayList;
import java.util.Arrays;

import org.json.JSONObject;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseExtension;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseExtensionContext;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseMessages;
import com.studiopixmix.anes.inapppurchase.activities.BillingActivity;

/**
 * A function that handles the purchase flow and has also a <code>consumeProduct</code> static method
 * that can be used anywhere on the native side.
 */
public class InAppPurchaseBuyProductFunction implements FREFunction {
	
	// CONSTANTS :
	/** The bundle key of the response code after a buy intent. */
	private static final String RESPONSE_CODE = "RESPONSE_CODE";
	/** The request code for the buy intent. */
	private static final int BUY_REQUEST_CODE = 111111;
	
	
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

	
	// PROPERTIES :
	/** The context passed to the main method, it will be used in the activity response. */
	private static InAppPurchaseExtensionContext context;
	
	
	/////////////
	// METHODS //
	/////////////
	
	@Override
	public FREObject call(FREContext c, FREObject[] args) {
		
		context = (InAppPurchaseExtensionContext) c;
		
		String productId = null;
		Bundle buyIntentBundle = null;
		
		// Retrieving the desired product ID.
		try {
			productId = args[0].getAsString();
		}
		catch(Exception e) { InAppPurchaseExtension.logToAS("Error while retrieving the product ID! " + e.toString()); context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASE_FAILURE, e.toString()); return null;}
		
		try {
			buyIntentBundle = context.getInAppBillingService().getBuyIntent(InAppPurchaseExtension.API_VERSION, context.getActivity().getPackageName(), productId, "inapp", "DEVELOPER_PAYLOAD");
		}
		catch(Exception e) { InAppPurchaseExtension.logToAS("Error while the buy intent! " + e.toString()); context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASE_FAILURE, e.toString()); return null;}
		
		
		int responseCode = buyIntentBundle.getInt(RESPONSE_CODE);
		if(responseCode == 0) {
			
			// Everything's fine, starting the buy intent.
			PendingIntent pendingIntent = buyIntentBundle.getParcelable("BUY_INTENT");
			try {
				
				// Creates the new activity to do the billing process, and adding it the extra info to start the request.
				Intent intent = new Intent(context.getActivity(), BillingActivity.class);
				intent.putExtra("pendingIntent", pendingIntent);
				intent.putExtra("requestCode", BUY_REQUEST_CODE);
				context.getActivity().startActivity(intent);
			}
			catch(Exception e) { 
					InAppPurchaseExtension.logToAS("Error while the buy intent!\n " + e.toString() + "\n" + InAppPurchaseExtension.getStackString(e));
					context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASE_FAILURE, e.toString()); 
					return null;
				}
		}
		else {
			InAppPurchaseExtension.logToAS("Error while the buy intent : " + ERRORS_MESSAGES.get(responseCode));
		}
		
		return null;
	}
	
	
	/**
	 * The response of the pending intent. 
	 */
	public static void onIntentFinished(Activity sourceActivity, int requestCode, int resultCode, Intent data) {
		
		sourceActivity.finish();
		sourceActivity = null;
		
		if(requestCode == BUY_REQUEST_CODE) {
			
			if(resultCode == Activity.RESULT_CANCELED) {
				InAppPurchaseExtension.logToAS("Purchase has been cancelled!");
				context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASE_FAILURE, "Purchase has been cancelled!");
			}
			else {
				int responseCode = data.getIntExtra("RESPONSE_CODE", 0);
			    String purchaseData = data.getStringExtra("INAPP_PURCHASE_DATA");
			    String dataSignature = data.getStringExtra("INAPP_DATA_SIGNATURE");

				// TODO : Verify the Data signature.
			    
			    if(responseCode == 0) {
			    	try {
			    		JSONObject item = new JSONObject(purchaseData);
			    		consumeProduct(item, context);
			    		
			    	}
			    	catch(Exception e) {context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASE_FAILURE, "Error while converting the bought product data to JSONObject!");  }
			    }
			    else {
			    	InAppPurchaseExtension.logToAS("The purchase failed! " + ERRORS_MESSAGES.get(responseCode));
					context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASE_FAILURE, ERRORS_MESSAGES.get(responseCode));
			    }
			}
		}
	}
	
	
	/**
	 * Consumes the given product. This method is called at the end of each purchase, and at each initialization if the 
	 * <code>getPurchases</code> method returned a product that has not been consumed.
	 */
	
	public static void consumeProduct(JSONObject purchase, InAppPurchaseExtensionContext c) {
		
		// The local variables used in the asynchronous task.
		final JSONObject item = purchase;
		final InAppPurchaseExtensionContext context = c;
		final Activity activity = c.getActivity();
		
		// The getSkuDetails method is synchronous, so it has to be executed in an asynchronous task to avoid blocking the main thread.
		(new AsyncTask<Void, Void, Void>() {
			@Override
			protected Void doInBackground(Void... params) {
				int response = -1;
				try {
					response = context.getInAppBillingService().consumePurchase(InAppPurchaseExtension.API_VERSION, activity.getPackageName(), item.getString("purchaseToken"));
				}
				catch(Exception e) { 
					InAppPurchaseExtension.logToAS("The consume product has failed!");
					context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASE_FAILURE, "The consume product has failed!");
					return null;
				}
				
				if(response == 0) {
					try {
						JSONObject data = new JSONObject();
						data.put("productId", item.getString("productId"));
						data.put("date", item.getInt("purchaseTime"));
						data.put("developerPayload", item.get("developerPayload"));
						data.put("purchaseToken", item.get("purchaseToken"));
						data.put("orderId", item.get("orderId"));
						// TODO
						data.put("signature", "");
						data.put("playstoreResponse", item.toString());
						
						InAppPurchaseExtension.logToAS("The product has been successfully consumed! returning it with the event ...");
						context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASE_SUCCESS, data.toString());
					}
					catch(Exception e) {
						InAppPurchaseExtension.logToAS("The consume product has failed!");
						context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASE_FAILURE, "The consume product has failed!");
					}
				}
				else {
					InAppPurchaseExtension.logToAS("The consume product has failed!");
					context.dispatchStatusEventAsync(InAppPurchaseMessages.PURCHASE_FAILURE, "The consume product has failed!");
				}
				
				return null;
			}
		}).execute();
	}

}
