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
	/** Event dispatched when the buy intent has failed. */
	public static final String PURCHASE_FAILURE = "EVENT_PURCHASE_FAILURE";
	/** Event dispatched when the user explicitely canceled the purchase. */
	public static final String PURCHASE_CANCELED = "EVENT_PURCHASE_CANCELED";
	/** Event dispatched when the buy intent has succeeded and the product has been consumed. */
	public static final String PURCHASE_SUCCESS = "EVENT_PURCHASE_SUCCESS";
	/** Event dispatched when one or more invalid product(s) have been passed to getProducts or buyProducts. */
	public static final String PRODUCTS_INVALID = "EVENT_PRODUCTS_INVALID";
	/** Event dispatched when a product consumption succeeded. */
	public static final String CONSUME_SUCCESS = "EVENT_CONSUME_SUCCESS";
	/** Event dispatched when a product consumption has failed. */
	public static final String CONSUME_FAILED = "EVENT_CONSUME_FAILED";
	/** Event dispatched when calling the <code>restorePurchase</code> function. Dispatched after having requested the store for the user's previous purchases. */
	public static final String PURCHASES_RETRIEVED = "EVENT_PURCHASES_RETRIEVED";
	/** Event dispatched when the call to <code>getPurchases</code> failed. */
	public static final String PURCHASES_RETRIEVING_FAILED = "EVENT_PURCHASES_RETRIEVING_FAILED";
}
