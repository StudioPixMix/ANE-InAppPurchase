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
    
    for (NSString *productId in response.invalidProductIdentifiers) {
        NSString *logMessage = [[NSString alloc] initWithFormat:@"Invalid product : %@", productId];
        DISPATCH_LOG_EVENT(self.context, logMessage);
    }
    
    self.products = response.products;
    
    DISPATCH_LOG_EVENT(self.context, @"Building JSON of the loaded products.");
    
    NSMutableArray *productsArray = [[NSMutableArray alloc] init];
    
    for (SKProduct *product in response.products) {
        NSDictionary *productJson = [NSDictionary dictionaryWithObjectsAndKeys:
                                     product.productIdentifier, @"id",
                                     product.localizedTitle, @"title",
                                     product.localizedDescription, @"description",
                                     product.price, @"price",
                                     nil];
        [productsArray addObject:productJson];
    }
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:productsArray options:NSJSONWritingPrettyPrinted error:nil];

    NSString *productsReturned = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    DISPATCH_LOG_EVENT(self.context, @"Dispatching JSON built.");
    
    DISPATCH_ANE_EVENT(self.context, EVENT_PRODUCTS_LOADED, (uint8_t*)productsReturned.UTF8String);
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
@end
