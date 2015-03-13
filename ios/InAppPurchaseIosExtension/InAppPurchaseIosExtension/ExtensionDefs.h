//
//  ExtensionEvent.h
//  InAppPurchaseIosExtension
//
//  Created by Antoine Kleinpeter on 04/11/14.
//  Copyright (c) 2014 studiopixmix. All rights reserved.
//

#ifndef InAppPurchaseIosExtension_ExtensionEvent_h
#define InAppPurchaseIosExtension_ExtensionEvent_h

#define EVENT_LOG (uint8_t*)[@"EVENT_LOG" UTF8String]
#define EVENT_INITIALIZED (uint8_t*)[@"EVENT_INITIALIZED" UTF8String]
#define EVENT_PRODUCTS_LOADED (uint8_t*)[@"EVENT_PRODUCTS_LOADED" UTF8String]
#define EVENT_PRODUCTS_INVALID (uint8_t*)[@"EVENT_PRODUCTS_INVALID" UTF8String]
#define EVENT_PURCHASE_SUCCESS (uint8_t*)[@"EVENT_PURCHASE_SUCCESS" UTF8String]
#define EVENT_PURCHASE_FAILURE (uint8_t*)[@"EVENT_PURCHASE_FAILURE" UTF8String]
#define EVENT_PURCHASES_RETRIEVED (uint8_t*)[@"EVENT_PURCHASES_RETRIEVED" UTF8String]
#define EVENT_PURCHASES_RETRIEVING_FAILED (uint8_t*) [@"EVENT_PURCHASES_RETRIEVING_FAILED" UTF8String]


#define DISPATCH_ANE_EVENT(context, event, data) FREDispatchStatusEventAsync(context, event, data)
#define DISPATCH_LOG_EVENT(context, logMessage) FREDispatchStatusEventAsync(context, EVENT_LOG, (uint8_t*)logMessage.UTF8String);NSLog(@"%@", logMessage);

#endif
