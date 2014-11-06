//
//  TransactionObserver.m
//  InAppPurchaseIosExtension
//
//  Created by Antoine Kleinpeter on 05/11/14.
//  Copyright (c) 2014 studiopixmix. All rights reserved.
//

#import "TransactionObserver.h"
#import "FlashRuntimeExtensions.h"
#import "ExtensionDefs.h"

@interface TransactionObserver () <SKPaymentTransactionObserver>

@end

@implementation TransactionObserver

- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateFailed:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                DISPATCH_ANE_EVENT(self.context, EVENT_PURCHASE_FAILURE, (uint8_t*)[transaction.error.localizedDescription UTF8String]);
                break;
            
            case SKPaymentTransactionStatePurchased:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                DISPATCH_ANE_EVENT(self.context, EVENT_PURCHASE_SUCCESS, (uint8_t*)[[self buildJSONStringOfPurchaseWithTransaction:transaction] UTF8String]);
                break;
        }
    }
}

- (NSString *) buildJSONStringOfPurchaseWithTransaction:(SKPaymentTransaction *)transaction {
    NSNumber *transactionTimestamp = [NSNumber numberWithDouble:[transaction.transactionDate timeIntervalSince1970]];

    NSDictionary *purchaseDictionary = @{
        @"productId" : transaction.payment.productIdentifier,
        @"transactionTimestamp" : transactionTimestamp,
        @"applicationUsername" : transaction.payment.applicationUsername,
        @"transactionId" : transaction.transactionIdentifier,
        @"transactionReceipt" : [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding]
    };
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:purchaseDictionary options:NSJSONWritingPrettyPrinted error:nil];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}
@end
