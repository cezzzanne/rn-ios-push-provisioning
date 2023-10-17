//
//  RNPushProvisioning.m
//  RNPushProvisioning
//
//  Created by Pablo Arellano on 10/17/23.
//

#import "RNPushProvisioning.h"
#import <React/RCTLog.h>

@implementation RNPushProvisioning

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(createCalendarEvent:(NSString *)name location:(NSString *)location) {
     RCTLogInfo(@"Pretending to create an event %@ at %@", name, location);
}

@end
