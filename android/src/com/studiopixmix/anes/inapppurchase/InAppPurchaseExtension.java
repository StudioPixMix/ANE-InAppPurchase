package com.studiopixmix.anes.inapppurchase;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/**
 * The main extension file. Mainly instantiates the ExtensionContext.
 */
public class InAppPurchaseExtension implements FREExtension {
	
	// CONSTANTS :
	/** The in-app billing API version. */
	public static final int API_VERSION = 3;
	
	
	// PROPERTIES :
	/** The logging TAG. */
	public static String TAG = "InAppPurchaseExtension";
	/** A reference to the InAppPurchase extension context. */
	public static InAppPurchaseExtensionContext iapContext;
	
	
	// METHODS :
	/**
	 * Creates a new extension context.
	 */
	@Override
	public FREContext createContext(String type) {
		iapContext = new InAppPurchaseExtensionContext();
		return iapContext;
	}
	
	@Override
	public void dispose() {
		log("Extension disposed.");
	}
	
	@Override
	public void initialize() {
		log("Extension initialized.");
	}
	
	
	
	/////////////
	// LOGGING //
	/////////////
	
	/**
	 * Logs the given message at info level.
	 */
	public static void log(String message) {
		Log.i(TAG, message);
	}
	
	/**
	 * Logs the given message at warning level.
	 */
	public static void logW(String message) {
		Log.w(TAG, message);
	}
	
	/**
	 * Logs the given message at error level.
	 */
	public static void logE(String message) {
		Log.e(TAG, message);
	}
	
	/**
	 * Logs the given message to the ActionScript part using a StatusEvent, if the context
	 * exists. If it does not exist, does nothing.
	 */
	public static void logToAS(String message) {
		log(message);
		
		if(iapContext != null)
			iapContext.dispatchStatusEventAsync(InAppPurchaseMessages.LOG, "[" + TAG + "] : " + message);
	}
	
	
	
	///////////
	// Utils //
	///////////
	
	/**
	 * Returns a complete formated String stack trace for the given Exception.
	 */
	public static String getStackString(Exception e) {
		String stackTrace = e.toString() + "\n";
		StackTraceElement[] stackArray = e.getStackTrace();
		int i, n = stackArray.length;
		for(i = 0 ; i < n ; i++) {
			stackTrace += ("	" + stackArray[i].toString() + "\n");
		}
		
		return stackTrace;
	}
}
