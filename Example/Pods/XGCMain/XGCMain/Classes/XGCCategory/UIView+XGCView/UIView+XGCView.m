//
//  UIView+XGCView.m
//  xinggc
//
//  Created by 凌志 on 2023/11/27.
//

#import "UIView+XGCView.h"
// layer
#import "XGCViewLayer.h"
// tool
#import <objc/runtime.h>
// view
#import "XGCActivityIndicatorView.h"
// thirdparty
#import <Toast/Toast.h>
#import <SVProgressHUD/SVProgressHUD.h>

#pragma mark UIView+XGCView
static NSString * const XGCViewBorderLayerKey = @"kXGCViewBorderLayer";
static NSString * const XGCViewCornerRadiusLayerKey = @"kXGCViewCornerRadiusLayerKey";
@implementation UIView (XGCView)
- (void)setViewConfiguration:(XGCViewConfiguration *)configuration {
    if ([configuration isKindOfClass:[XGCViewBorderConfiguration class]]) {
        XGCViewBorderLayer *layer = objc_getAssociatedObject(self, &XGCViewBorderLayerKey);
        if (!layer) {
            objc_setAssociatedObject(self, &XGCViewBorderLayerKey, (layer = [XGCViewBorderLayer layer]), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [layer setTarget:self configuration:(XGCViewBorderConfiguration *)configuration];
    } else if ([configuration isKindOfClass:[XGCViewCornerRadiusConfiguration class]]) {
        XGCViewCornerRadiusLayer *layer = objc_getAssociatedObject(self, &XGCViewCornerRadiusLayerKey);
        if (!layer) {
            objc_setAssociatedObject(self, &XGCViewCornerRadiusLayerKey, (layer = [XGCViewCornerRadiusLayer layer]), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        [layer setTarget:self configuration:(XGCViewCornerRadiusConfiguration *)configuration];
    }
}
@end

#pragma mark UIView+XGCToast
@implementation UIView (XGCToast)

- (void)makeToast:(NSString *)message position:(XGCToastViewPosition)position {
    [self makeToast:message position:position completion:nil];
}

- (void)makeToast:(NSString *)message position:(XGCToastViewPosition)position completion:(void(^)(BOOL didTap))completion {
    CSToastStyle *style = [self didInitDefaultToastStyle];
    switch (position) {
        case XGCToastViewPositionTop: {
            [self makeToast:message duration:1.0 position:CSToastPositionTop title:nil image:nil style:style completion:completion];
        } break;
        case XGCToastViewPositionCenter: {
            [self makeToast:message duration:1.0 position:CSToastPositionCenter title:nil image:nil style:style completion:completion];
        } break;
        case XGCToastViewPositionBottom: {
            [self makeToast:message duration:1.0 position:CSToastPositionBottom title:nil image:nil style:style completion:completion];
        } break;
        default: {
        } break;
    }
}

- (CSToastStyle *)didInitDefaultToastStyle {
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.cornerRadius = 8;
    style.verticalPadding = 10.0;
    style.horizontalPadding = 10.0;
    style.messageFont = [UIFont systemFontOfSize:13];
    style.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
    return style;
}

@end

#pragma mark UIView+XGCHUD
@implementation UIView (XGCHUD)
- (void)showProgress:(float)progress {
    [self showProgress:progress status:nil];
}
- (void)showProgress:(float)progress status:(NSString *)status {
    [SVProgressHUD setContainerView:self];
    [SVProgressHUD showProgress:progress status:status];
}
- (void)dismiss {
    [SVProgressHUD dismiss];
}
@end

#pragma mark UIView+XGCActivity
static NSString * const XGCActivityIndicatorViewKey = @"kXGCActivityIndicatorViewKey";
@implementation UIView (XGCActivity)
- (void)startAnimating {
    XGCActivityIndicatorView *indicator = objc_getAssociatedObject(self, &XGCActivityIndicatorViewKey);
    if (!indicator) {
        objc_setAssociatedObject(self, &XGCActivityIndicatorViewKey, (indicator = [[XGCActivityIndicatorView alloc] init]), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self addSubview:indicator];
}
- (void)stopAnimating {
    XGCActivityIndicatorView *indicator = objc_getAssociatedObject(self, &XGCActivityIndicatorViewKey);
    if (!indicator) {
        return;
    }
    [indicator removeFromSuperview];
}
@end
