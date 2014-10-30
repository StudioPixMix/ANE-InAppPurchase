package com.studiopixmix.anes.inapppurchase;

import java.util.HashMap;
import java.util.Map;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.studiopixmix.anes.inapppurchase.functions.InAppPurchaseInitFunction;
import com.studiopixmix.anes.inapppurchase.functions.TestFunction;

public class InAppPurchaseExtensionContext extends FREContext {
	
	// CONSTRUCTOR :
	public InAppPurchaseExtensionContext() {
		super();
	}
	
	
	/////////////////
	// FRE METHODS //
	/////////////////

	/**
	 * Disposes the extension context instance.
	 */
	@Override
	public void dispose() {
		InAppPurchaseExtension.log("Context disposed.");
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
