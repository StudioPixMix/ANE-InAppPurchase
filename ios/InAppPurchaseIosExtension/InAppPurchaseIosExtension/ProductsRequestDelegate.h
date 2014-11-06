//
//  ProductsRequestDelegate.h
//  InAppPurchaseIosExtension
//
//  Created by Antoine Kleinpeter on 04/11/14.
//  Copyright (c) 2014 studiopixmix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlashRuntimeExtensions.h"
#import <StoreKit/StoreKit.h>

@interface ProductsRequestDelegate : NSObject<SKProductsRequestDelegate>

@property (nonatomic, assign) FREContext context;
@property (nonatomic, strong) NSArray *products;

- (SKProduct *) getProductWithId:(NSString *)productId;

@end
