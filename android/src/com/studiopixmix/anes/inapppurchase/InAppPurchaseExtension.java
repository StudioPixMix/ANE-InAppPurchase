package com.studiopixmix.anes.inapppurchase;

import sun.util.logging.resources.logging;
import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

/**
 * The main extension file. Mainly instantiates the ExtensionContext.
 */
public class InAppPurchaseExtension implements FREExtension {
	
	// PROPERTIES :
	/** The logging TAG. */
	public static String TAG = "InAppPurchaseExtension";
	
	
	// METHODS :
	/**
	 * Creates a new extension context.
	 */
	@Override
	public FREContext createContext(String type) {
		return new InAppPurchaseExtensionContext();
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
}
