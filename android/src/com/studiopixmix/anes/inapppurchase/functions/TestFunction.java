package com.studiopixmix.anes.inapppurchase.functions;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.studiopixmix.anes.inapppurchase.InAppPurchaseExtension;

/**
 * A simple test function executed when the <code>test</code> method is called in the
 * ActionScript side.
 */
public class TestFunction implements FREFunction {

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1) {
		
		InAppPurchaseExtension.logToAS("Hello world!");
		
		return null;
	}

}
