//
//  InAppPurchaseANE.m
//  InAppPurchaseANE
//
//  Created by Antoine Kleinpeter on 30/10/14.
//  Copyright (c) 2014 studiopixmix. All rights reserved.
//
#import "FlashRuntimeExtensions.h"
#import "TypeConversionHelper.h"

#define DEFINE_ANE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

#define MAP_FUNCTION(fn, data) { (const uint8_t*)(#fn), (data), &(fn) }

TypeConversionHelper* typeConversionHelper;

DEFINE_ANE_FUNCTION(test)
{
    FREObject test;
    
    if ([typeConversionHelper FREGetString:@"Hello world !" asObject:&test] == FRE_OK)
        return test;
    
    return NULL;
}

void InAppPurchaseANEContextInitializer( void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToSet, const FRENamedFunction** functionsToSet )
{
    static FRENamedFunction mopubFunctionMap[] =
    {
        MAP_FUNCTION(test, NULL )
    };
        
    *numFunctionsToSet = sizeof( mopubFunctionMap ) / sizeof( FRENamedFunction );
    *functionsToSet = mopubFunctionMap;
}

void InAppPurchaseANEContextFinalizer( FREContext ctx )
{
	return;
}

void InAppPurchaseANEExtensionInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet )
{
    extDataToSet = NULL;
    *ctxInitializerToSet = &InAppPurchaseANEContextInitializer;
    *ctxFinalizerToSet = &InAppPurchaseANEContextFinalizer;
    
    typeConversionHelper = [[TypeConversionHelper alloc] init];
}

void MoPubExtensionFinalizer()
{
    return;
}
