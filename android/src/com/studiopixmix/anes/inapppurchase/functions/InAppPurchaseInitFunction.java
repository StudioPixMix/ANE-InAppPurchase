package com.studiopixmix.anes.inapppurchase.functions;

import android.content.Context;
import android.content.Intent;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseExtensionContext;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseMessages;

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

}
