//
//  InAppPurchaseANE.m
//  InAppPurchaseANE
//
//  Created by Antoine Kleinpeter on 30/10/14.
//  Copyright (c) 2014 studiopixmix. All rights reserved.
//
#import "FlashRuntimeExtensions.h"
#import "TypeConversionHelper.h"
#import "ExtensionDefs.h"
#import <StoreKit/StoreKit.h>
#import "ProductsRequestDelegate.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }


TypeConversionHelper* typeConversionHelper;
ProductsRequestDelegate *productsRequestDelegate;

DEFINE_ANE_FUNCTION(test) {
    FREObject test;
    
    if ([typeConversionHelper FREGetString:@"It works !" asObject:&test] == FRE_OK)
        return test;
    
    return NULL;
}

DEFINE_ANE_FUNCTION(getProducts) {
    NSArray *productIdsRequested = [typeConversionHelper FREGetObjectAsStringArray:argv[0]];
    
    NSString *logMessage = [NSString stringWithFormat:@"Starting an SKProductsRequest with products %@", [productIdsRequested componentsJoinedByString:@", "]];
    DISPATCH_LOG_EVENT(context, logMessage);
    
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithArray:productIdsRequested]];
    
    productsRequestDelegate.context = context;
    productsRequest.delegate = productsRequestDelegate;
    
    [productsRequest start];
    
    return NULL;
}

void InAppPurchaseIosExtensionContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet )
{
    static FRENamedFunction mopubFunctionMap[] =
    {
        MAP_FUNCTION(test, NULL ),
        MAP_FUNCTION(getProducts, NULL)
    };
        
    *numFunctionsToSet = sizeof( mopubFunctionMap ) / sizeof( FRENamedFunction );
    *functionsToSet = mopubFunctionMap;
}

void InAppPurchaseIosExtensionContextFinalizer( FREContext ctx )
{
	return;
}

void InAppPurchaseIosExtensionInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet )
{
    extDataToSet = NULL;
    *ctxInitializerToSet = &InAppPurchaseIosExtensionContextInitializer;
    *ctxFinalizerToSet = &InAppPurchaseIosExtensionContextFinalizer;
    
    typeConversionHelper = [[TypeConversionHelper alloc] init];
    productsRequestDelegate = [[ProductsRequestDelegate alloc] init];
}

void InAppPurchaseIosExtensionFinalizer()
{
    return;
}
