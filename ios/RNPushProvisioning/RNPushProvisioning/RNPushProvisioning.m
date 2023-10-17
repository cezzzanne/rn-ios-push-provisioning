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

RCT_EXPORT_METHOD(createCalendarEvent:(NSString *)name location:(NSString *)location) {
     RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
}

RCT_EXPORT_METHOD(checkAvailability:(NSString *)name location:(NSString *)location) {
    if (![PKAddPaymentPassViewController canAddPaymentPass]) {
        // Your device cannot add payment passes
        RCTLogInfo("Cannot add payment pass");
    } else {
        // Your device can add payment passes
        RCTLogInfo("Can add payment pass");
    }
}

@end
