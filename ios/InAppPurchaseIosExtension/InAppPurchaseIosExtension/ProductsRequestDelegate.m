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

- (id) initWithContext:(FREContext)context {
    self = [super init];
    
    if (self)
        self.context = context;
    
    return self;
}

- (void) productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    DISPATCH_LOG_EVENT(self.context, @"Products request did receive response.");
    
    for (NSString *productId in response.invalidProductIdentifiers) {
        NSString *logMessage = [[NSString alloc] initWithFormat:@"Invalid product : %@", productId];
        DISPATCH_LOG_EVENT(self.context, logMessage);
    }
    
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
    
    DISPATCH_ANE_EVENT(self.context, EVENT_PRODUCTS_LOADED, (uint8_t*)productsReturned.UTF8String);
}
@end
