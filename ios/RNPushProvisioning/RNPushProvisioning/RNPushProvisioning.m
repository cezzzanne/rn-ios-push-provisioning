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

RCT_EXPORT_METHOD(checkAvailability:(NSString *)localizedDescription primaryAccountSuffix:(NSString *)suffix cardholderName:(NSString *)name paymentNetwork:(NSString *)network callback:(RCTResponseSenderBlock)callback) {
    if ([PKAddPaymentPassViewController canAddPaymentPass]) {
        // We can add a payment pass on device
        PKAddPaymentPassRequestConfiguration *configuration = [[PKAddPaymentPassRequestConfiguration alloc] initWithEncryptionScheme:PKEncryptionSchemeECC_V2];
        
        // These are purely UI values we show to the user
        configuration.localizedDescription = localizedDescription;
        configuration.primaryAccountSuffix = primaryAccountSuffix;
        configuration.cardholderName = cardholderName;
        configuration.paymentNetwork = paymentNetwork;
        PKAddPaymentPassViewController *addPaymentVC = [[PKAddPaymentPassViewController alloc] initWithRequestConfiguration:configuration delegate:self];
        UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;

        [rootViewController presentViewController:addPaymentVC animated:YES completion:nil];
        self.callback = callback; // store the callback for later use

        RCTLogInfo(@"Can add payment pass");
    } else {
        // Your device can add payment passes
        RCTLogInfo(@"Cannot add payment pass");
    }
}

- (void)addPaymentPassViewController:(PKAddPaymentPassViewController *)controller 
      generateRequestWithCertificateChain:(NSArray<NSData *> *)certificates 
      nonce:(NSData *)nonce 
      nonceSignature:(NSData *)nonceSignature 
      completionHandler:(void (^)(PKAddPaymentPassRequest *request))handler {
        
        NSString *nonceString = [nonce base64EncodedStringWithOptions:0];
        NSString *nonceSignatureString = [nonceSignature base64EncodedStringWithOptions:0];

        NSMutableArray<NSString *> *certificatesBase64 = [NSMutableArray new];

        for (NSData *certificateData in certificates) {
            NSString *base64String = [certificateData base64EncodedStringWithOptions:0];
            [certificatesBase64 addObject:base64String];
        }
        self.paymentPassCompletionHandler = handler;

        self.callback(@[certificatesBase64, nonceString, nonceSignatureString]);
}

- (void)addPaymentPassViewController:(PKAddPaymentPassViewController *)controller 
      didFinishAddingPaymentPass:(PKPaymentPass *)pass 
      error:(NSError *)error {
        if (pass) {
            // Successfully added the card
            RCTLogInfo(@"Successfully added payment pass.");
        } else {
            // Handle the error - send to react native or backend here
            RCTLogInfo(@"Error adding payment pass: %@", error.localizedDescription);
        }
        // dismiss the view
        [controller dismissViewControllerAnimated:YES completion:nil];
}


// This method is once we get the response from the server we call to complete payment pass
RCT_EXPORT_METHOD(completeAddPaymentPass:(NSDictionary *)response) {
    NSData *encryptedPassData = [[NSData alloc] initWithBase64EncodedString:response[@"encryptedPassData"] options:0];
    NSData *activationData = [[NSData alloc] initWithBase64EncodedString:response[@"activationData"] options:0];
    NSData *ephemeralPublicKey = [[NSData alloc] initWithBase64EncodedString:response[@"ephemeralPublicKey"] options:0];
    
    PKAddPaymentPassRequest *request = [[PKAddPaymentPassRequest alloc] init];
    request.encryptedPassData = encryptedPassData;
    request.activationData = activationData;
    request.ephemeralPublicKey = ephemeralPublicKey;
    
    // Check our handler was correctly instantiated
    if (self.paymentPassCompletionHandler) {
        self.paymentPassCompletionHandler(request);
    } else {
        RCTLogInfo(@"PaymentPassCompletionHandler is null - SHOULD NEVER HAPPEN");
    }
}

@end
