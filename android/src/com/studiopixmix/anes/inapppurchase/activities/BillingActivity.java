package com.studiopixmix.anes.inapppurchase.activities;

import com.studiopixmix.anes.inapppurchase.InAppPurchaseExtension;
import com.studiopixmix.anes.inapppurchase.functions.InAppPurchaseBuyProductFunction;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;

/**
 * An activity that handles the pending intent created when calling the <code>InAppPurchaseBuyProductFunction</code>
 * method. Before starting it, the following extra data must be passed to the intent :<br/>
 * <ul><li> PENDING_INTENT : the pending intent object created in the <code>InAppPurchaseBuyProductFunction</code> method, 
 * that will be started on onCreate.</li>
 * <li> REQUEST_CODE : the request code used for the pending intent. This request code will be returned in the onActivityResult,
 * then passed to the <code>onIntentFinished</code> method.</li>
 * <li> DEV_PAYLOAD : the developer payload passed to the top-level call to <code>buyProduct</code>. This payload will be compared
 * to the returned product payload in the onActivityResponse. If the two payloads doesn't match, a purchase failed event will be dispatched, 
 * for security reasons.</li></ul>
 * <br/>
 * <br/>
 * @see InAppPurchaseBuyProductFunction
 */
public class BillingActivity extends Activity {
	
	// PROPERTIES :
	/** The developer payload, passed as an extra data to the activity and initialized on onCreate. */
	private String developerPayLoad;
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
		
		InAppPurchaseBuyProductFunction.onIntentFinished(this, requestCode, resultCode, data, developerPayLoad);
	}
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		try {
			// Retrieves the extra data that have to be passed previously.
			final Bundle extras = getIntent().getExtras();
			final PendingIntent pendingIntent = (PendingIntent) extras.get("PENDING_INTENT");
			final int requestCode = extras.getInt("REQUEST_CODE");
			developerPayLoad = extras.getString("DEV_PAYLOAD");
		
			// Then starts the pending intent.
			this.startIntentSenderForResult(pendingIntent.getIntentSender(), requestCode, new Intent(), 0, 0, 0);
		}
		catch (Exception e) {
			InAppPurchaseExtension.logToAS("Error while starting the buy intent! " + InAppPurchaseExtension.getStackString(e));
		}
	}
}
