package com.studiopixmix.anes.inapppurchase;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.ComponentName;
import android.content.ServiceConnection;
import android.os.IBinder;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.android.vending.billing.IInAppBillingService;
import com.studiopixmix.anes.inapppurchase.functions.InAppPurchaseBuyProductFunction;
import com.studiopixmix.anes.inapppurchase.functions.InAppPurchaseConsumeProductFunction;
import com.studiopixmix.anes.inapppurchase.functions.InAppPurchaseGetProductsFunction;
import com.studiopixmix.anes.inapppurchase.functions.InAppPurchaseInitFunction;
import com.studiopixmix.anes.inapppurchase.functions.InAppPurchaseRestorePurchasesFunction;

public class InAppPurchaseExtensionContext extends FREContext {
	
	// PROPERTIES :
	/** The service used to connect the application to the InAppBillingService on Google Play. */
	private IInAppBillingService mService;
	private ServiceConnection mServiceConn;
	
	/** The list of Runnable tasks to execute with the IInAppBillingService. As long as the service is available, the list
	 * will remain empty, as the Runnables can be executed right now ; if the service connection is lost, the Runnables will
	 * be enqueued to wait for the service reconnection. */
	private List<Runnable> tasksQueue;
	/** Whether the tasks queue is currently processing or not. Avoids to call several tasks at the same time. */
	private Boolean isExecuting = false;
	
	// CONSTRUCTOR :
	public InAppPurchaseExtensionContext() {
		super();
		
		tasksQueue = new ArrayList<Runnable>();
		connectToService();
	}
	
	
	//////////////////////
	// SPECIFIC METHODS //
	//////////////////////
	
	
	/**
	 * Starts a new ServiceConnection and sets the <code>mService</code> property on connection success. If the connection is lost,
	 * re-opens a connection again.
	 */
	private void connectToService() {
		
		InAppPurchaseExtension.logToAS("Connecting to the service ...");
		
		this.mServiceConn = new ServiceConnection() {
		   @Override
		   public void onServiceDisconnected(ComponentName name) {
			   InAppPurchaseExtension.logToAS("Service connection lost ... reconnecting ...");
			   mService = null;
			   connectToService();
		   }

		   @Override
		   public void onServiceConnected(ComponentName name, IBinder service) {
		       mService = IInAppBillingService.Stub.asInterface(service);
		       InAppPurchaseExtension.logToAS("Service connected.");
		       
		       processTasksQueue();
		   }
		};
	}
	
	
	
	/**
	 * Executes the given Runnable whether directly or after enqueuing it following the <code>mService</code> availability.
	 */
	public void executeWithService(Runnable runnable) {
		tasksQueue.add(runnable);
		processTasksQueue();
	}
	
	
	/**
	 * Process the current task queue, as long as the service is available or the queue isn't empty. This method can only be called 
	 * once at a time, and is executed at each <code>executeWithService</code> and each service connection.
	 */
	private void processTasksQueue() {
		InAppPurchaseExtension.logToAS("Processing the waiting tasks ...");
		
		if(mService == null) {
			InAppPurchaseExtension.logToAS("Service unavailable! aborting ...");
			return;
		}
		
		if(isExecuting) {
			InAppPurchaseExtension.logToAS("The queue is already processing ...");
			return;
		}
		
		InAppPurchaseExtension.logToAS("Processing " + tasksQueue.size() + " tasks ...");
		isExecuting = true;
		while(mService != null && tasksQueue.size() > 0) {
			tasksQueue.remove(0).run();
		}
		isExecuting = false;
		
		InAppPurchaseExtension.logToAS("Tasks queue processed.");
	}
	
	
	
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
		
		functions.put("initialize", new InAppPurchaseInitFunction());
		functions.put("getProducts", new InAppPurchaseGetProductsFunction());
		functions.put("buyProduct", new InAppPurchaseBuyProductFunction());
		functions.put("consumeProduct", new InAppPurchaseConsumeProductFunction());
		functions.put("restorePurchase", new InAppPurchaseRestorePurchasesFunction());
		
		InAppPurchaseExtension.log(functions.size() + " extension functions declared.");
		
		return functions;
	}

}
