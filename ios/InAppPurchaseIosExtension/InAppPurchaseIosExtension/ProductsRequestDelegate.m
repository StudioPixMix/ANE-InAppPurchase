//
//  ProductsRequestDelegate.m
//  InAppPurchaseIosExtension
//
//  Created by Antoine Kleinpeter on 04/11/14.
//  Copyright (c) 2014 studiopixmix. All rights reserved.
//

#import "ProductsRequestDelegate.h"
#import "ExtensionDefs.h"
#import <StoreKit/StoreKit.h>

@interface ProductsRequestDelegate () <SKProductsRequestDelegate>

@end

@implementation ProductsRequestDelegate

- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    DISPATCH_LOG_EVENT(self.context, @"Products request did receive response.");
    
    self.currentResponse = response;
    
    [self dispatchEventForInvalidProducts];

    self.products = response.products;
    
    DISPATCH_LOG_EVENT(self.context, @"Building JSON of the loaded products.");

    NSString *productsReturned = [self buildJSONStringOfProducts:response.products];
    
    DISPATCH_LOG_EVENT(self.context, @"Dispatching JSON built.");
    
    DISPATCH_ANE_EVENT(self.context, EVENT_PRODUCTS_LOADED, (uint8_t*)productsReturned.UTF8String);
}

- (void) dispatchEventForInvalidProducts {
    if (self.currentResponse.invalidProductIdentifiers.count > 0)
        DISPATCH_ANE_EVENT(self.context, EVENT_PRODUCTS_INVALID, (uint8_t*)[[self.currentResponse.invalidProductIdentifiers componentsJoinedByString:@","] UTF8String]);
}

- (SKProduct *) getProductWithId:(NSString *)productId {
    if (self.products == nil)
        return nil;
  
    for (SKProduct *product in self.products) {
        if ([product.productIdentifier isEqualToString:productId])
            return product;
    }
    
    return nil;
}

- (NSString *) buildJSONStringOfProducts:(NSArray *)products {
    NSMutableArray *productsJSONArray = [[NSMutableArray alloc] init];
    
    for (SKProduct *product in products)
        [productsJSONArray addObject:[self buildJSONDictionaryOfProduct:product]];

    NSData *data = [NSJSONSerialization dataWithJSONObject:productsJSONArray options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSDictionary *) buildJSONDictionaryOfProduct:(SKProduct *)product {
    return [NSDictionary dictionaryWithObjectsAndKeys:
     product.productIdentifier, @"id",
     product.localizedTitle, @"title",
     product.localizedDescription, @"description",
     product.price, @"price",
     nil];
}
@end
