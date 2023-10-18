//
//  RNPushProvisioning.h
//  RNPushProvisioning
//
//  Created by Pablo Arellano on 10/17/23.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <PassKit/PassKit.h>

@interface RNPushProvisioning : NSObject <RCTBridgeModule, PKAddPaymentPassViewControllerDelegate>
@property (nonatomic, copy) RCTResponseSenderBlock callback;
@property (nonatomic, copy) void (^paymentPassCompletionHandler)(PKAddPaymentPassRequest *request);

@end
