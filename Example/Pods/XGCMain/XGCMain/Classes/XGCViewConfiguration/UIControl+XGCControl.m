//
//  UIControl+XGCControl.m
//  xinggc
//
//  Created by 凌志 on 2023/12/6.
//

#import "UIControl+XGCControl.h"
// framework
#import <objc/runtime.h>
// layer
#import "XGCViewLayer.h"

static const NSString *XGCViewGradientLayerKey = @"kXGCViewGradientLayer";

@implementation UIControl (XGCControl)

- (void)setConfiguration:(XGCViewGradientConfiguration *)configuration forState:(UIControlState)state {
    XGCViewGradientLayer *layer = objc_getAssociatedObject(self, &XGCViewGradientLayerKey) ?: [XGCViewGradientLayer layer];
    objc_setAssociatedObject(self, &XGCViewGradientLayerKey, layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [layer setTarget:self configuration:configuration forState:state];
}

@end
