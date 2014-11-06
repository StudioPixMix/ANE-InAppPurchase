//
//  TransactionObserver.h
//  InAppPurchaseIosExtension
//
//  Created by Antoine Kleinpeter on 05/11/14.
//  Copyright (c) 2014 studiopixmix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "FlashRuntimeExtensions.h"

@interface TransactionObserver : NSObject<SKPaymentTransactionObserver>

@property (nonatomic, assign) FREContext context;

@end
