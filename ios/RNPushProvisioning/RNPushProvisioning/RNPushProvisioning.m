//
//  RNPushProvisioning.m
//  RNPushProvisioning
//
//  Created by Pablo Arellano on 10/17/23.
//

#import "RNPushProvisioning.h"
#import <React/RCTLog.h>
#import <PassKit/PassKit.h>

@implementation RNPushProvisioning

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(checkAvailability:(NSString *)name location:(NSString *)location) {
    if ([PKAddPaymentPassViewController canAddPaymentPass]) {
        // Your device cannot add payment passes
        PKAddPaymentPassRequestConfiguration *configuration = [[PKAddPaymentPassRequestConfiguration alloc] initWithEncryptionScheme:PKEncryptionSchemeECC_V2];
        configuration.localizedDescription = @"Tarjeta Nelo Test";
        configuration.primaryAccountSuffix = @"1234";
        configuration.cardholderName = @"Johnny Thunders";
        configuration.paymentNetwork = @"Visa";
        PKAddPaymentPassViewController *addPaymentVC = [[PKAddPaymentPassViewController alloc] initWithRequestConfiguration:configuration delegate:self];
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;

        [rootViewController presentViewController:addPaymentVC animated:YES completion:nil];

        RCTLogInfo(@"Can add payment pass");
    } else {
        // Your device can add payment passes
        RCTLogInfo(@"Cannot add payment pass");
    }
}

@end
