package com.studiopixmix.anes.inapppurchase;

import java.util.HashMap;
import java.util.Map;

import android.content.ComponentName;
import android.content.ServiceConnection;
import android.os.IBinder;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.android.vending.billing.IInAppBillingService;
import com.studiopixmix.anes.inapppurchase.functions.InAppPurchaseInitFunction;
import com.studiopixmix.anes.inapppurchase.functions.TestFunction;

public class InAppPurchaseExtensionContext extends FREContext {
	
	// PROPERTIES :
	/** The service used to connect the application to the InAppBillingService on Google Play. */
	private IInAppBillingService mService;
	private ServiceConnection mServiceConn = new ServiceConnection() {
	   @Override
	   public void onServiceDisconnected(ComponentName name) {
	       mService = null;
	   }

	   @Override
	   public void onServiceConnected(ComponentName name, 
	      IBinder service) {
	       mService = IInAppBillingService.Stub.asInterface(service);
	   }
	};
	
	// CONSTRUCTOR :
	public InAppPurchaseExtensionContext() {
		super();
	}
	
	
	//////////////////////
	// SPECIFIC METHODS //
	//////////////////////
	
	/**
	 * Returns the activity's InAppBillingService that should be used to communicate with the
	 * Google Play service.
	 */
	public IInAppBillingService getInAppBillingService() {
		return this.mService;
	}
	
	/**
	 * Returns the ServiceConnection used by the InAppBillingService. This method should only be
	 * used at the initialization of the ANE.
	 */
	public ServiceConnection getServiceConnection() {
		return this.mServiceConn;
	}
	
	
	/////////////////
	// FRE METHODS //
	/////////////////

	/**
	 * Disposes the extension context instance.
	 */
	@Override
	public void dispose() {
		
		// Unbinds the InAppBillingService if needed. This prevents memory leaks on the device.
		if (mService != null) 
	        getActivity().unbindService(mServiceConn);
	}

	
	/**
	 * Declares the functions mappings.
	 */
	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functions = new HashMap<String, FREFunction>();
		
		functions.put("inapppurchase_init", new InAppPurchaseInitFunction());
		functions.put("test", new TestFunction());
		
		InAppPurchaseExtension.log(functions.size() + " extension functions declared.");
		
		return functions;
	}

}
