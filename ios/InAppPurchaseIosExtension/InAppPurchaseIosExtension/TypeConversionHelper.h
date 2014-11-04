//
//  TypeConversionHelper.h
//  InAppPurchaseANE
//
//  Created by Antoine Kleinpeter on 30/10/14.
//  Copyright (c) 2014 studiopixmix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FlashRuntimeExtensions.h"

@interface TypeConversionHelper : NSObject

- (FREResult) FREGetObject:(FREObject)object asInt:(int32_t*)value;
- (FREResult) FREGetObject:(FREObject)object asBoolean:(uint32_t*)value;
- (FREResult) FREGetObject:(FREObject)object asString:(NSString**)value;

- (FREResult) FREGetString:(NSString*)string asObject:(FREObject*)asObject;
- (FREResult) FREGetInt:(int32_t)value asObject:(FREObject*)asObject;
- (FREResult) FREGetDouble:(double)value asObject:(FREObject*)asObject;
- (FREResult) FREGetBool:(BOOL)value asObject:(FREObject*)asObject;

- (NSArray *) FREGetObjectAsStringArray:(FREObject)object;

@end
