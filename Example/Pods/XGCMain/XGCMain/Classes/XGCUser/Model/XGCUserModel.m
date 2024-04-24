//
//  XGCUserModel.m
//  xinggc
//
//  Created by 凌志 on 2023/11/23.
//

#import "XGCUserModel.h"

@implementation XGCUserModel

- (BOOL)tokenAvailable {
    if (self.token.length == 0) {
        self.token = nil;
        return NO;
    }
    if (self.endTimeStamp - [NSDate date].timeIntervalSince1970 * 1000.0 <= 20.0 * 60.0 * 1000.0) {
        self.token = nil;
        return NO;
    }
    return YES;
}

- (BOOL)biometricsAvailable {
    if (!self.userMap) {
        return NO;
    }
    return self.userMap.faceID || self.userMap.touchID || self.userMap.gestureID.length > 0;
}

@end
