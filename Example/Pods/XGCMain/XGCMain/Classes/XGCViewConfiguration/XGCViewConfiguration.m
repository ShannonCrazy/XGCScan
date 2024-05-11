//
//  XGCViewConfiguration.m
//  xinggc
//
//  Created by 凌志 on 2023/12/6.
//

#import "XGCViewConfiguration.h"

@implementation XGCViewConfiguration

- (nonnull id)copyWithZone:(nullable NSZone *)zone { 
    return [XGCViewConfiguration new];
}

@end

@implementation XGCViewBorderConfiguration
- (instancetype)init {
    if (self = [super init]) {
        self.lineWidth = 1.0;
        self.position = UIRectEdgeAll;
        self.lineDashPattern = @[@3, @1];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    XGCViewBorderConfiguration *configuration = [XGCViewBorderConfiguration new];
    configuration.position = self.position;
    configuration.borderColor = self.borderColor;
    configuration.lineWidth = self.lineWidth;
    configuration.lineDashPattern = [self.lineDashPattern copy];
    return configuration;
}

@end

@implementation XGCViewGradientConfiguration
- (instancetype)init {
    if (self = [super init]) {
        self.startPoint = CGPointMake(0.5, 0);
        self.endPoint = CGPointMake(0.5, 1.0);
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    XGCViewGradientConfiguration *configuration = [XGCViewGradientConfiguration new];
    configuration.colors = [self.colors copy];
    configuration.locations = [self.locations copy];
    configuration.startPoint = self.startPoint;
    configuration.endPoint = self.endPoint;
    return configuration;
}
@end

@implementation XGCViewCornerRadiusConfiguration

- (id)copyWithZone:(NSZone *)zone {
    XGCViewCornerRadiusConfiguration *configuration = [XGCViewCornerRadiusConfiguration new];
    configuration.cornerRadii = self.cornerRadii;
    configuration.roundingCorners = self.roundingCorners;
    return configuration;
}

@end
