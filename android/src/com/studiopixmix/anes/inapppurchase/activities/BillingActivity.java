package com.studiopixmix.anes.inapppurchase.activities;

import com.studiopixmix.anes.inapppurchase.InAppPurchaseExtension;
import com.studiopixmix.anes.inapppurchase.functions.InAppPurchaseBuyProductFunction;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;

public class BillingActivity extends Activity {
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		super.onActivityResult(requestCode, resultCode, data);
		
		InAppPurchaseBuyProductFunction.onIntentFinished(this, requestCode, resultCode, data);
	}
	
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		final Bundle extras = getIntent().getExtras();
		final PendingIntent pendingIntent = (PendingIntent) extras.get("pendingIntent");
		final int requestCode = extras.getInt("requestCode");
		
		try {
			this.startIntentSenderForResult(pendingIntent.getIntentSender(), requestCode, new Intent(), 0, 0, 0);
		}
		catch (Exception e) {
			InAppPurchaseExtension.logToAS("Error while starting the buy intent! " + InAppPurchaseExtension.getStackString(e));
		}
	}
}
