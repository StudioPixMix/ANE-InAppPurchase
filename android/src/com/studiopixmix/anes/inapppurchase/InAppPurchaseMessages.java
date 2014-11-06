package com.studiopixmix.anes.inapppurchase;

/**
 * A class that defines the types of the status events dispatched in the native code.
 * These type constants are the same that the types declared in <code>InAppPurchaseEvent</code> in
 * the ActionScript side.
 */
public class InAppPurchaseMessages {
	
	/** Event used for each log that have to bubble to the AS app. */
	public static final String LOG = "EVENT_LOG";
	/** Event dispatched when the products have been loaded. */
	public static final String PRODUCTS_LOADED = "EVENT_PRODUCTS_LOADED";
}
