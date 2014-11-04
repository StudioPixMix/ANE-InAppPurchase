package com.studiopixmix.anes.inapppurchase;

/**
 * A class that defines the types of the status events dispatched in the native code.
 * These type constants are the same that the types declared in <code>InAppPurchaseEvent</code> in
 * the ActionScript side.
 */
public class InAppPurchaseMessages {
	
	/** Event used for each log that have to bubble to the AS app. */
	public static final String LOG = "LOG";
	/** Event used at the end of the initialization method. It informs the ActionScript code that the initialization is finished
	 * and the in-app request can be processed. */
	public static final String INITIALIZED = "EVENT_INITIALIZED";
}
