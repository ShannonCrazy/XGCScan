//
//  UIView+XGCView.h
//  xinggc
//
//  Created by 凌志 on 2023/11/27.
//

#import <UIKit/UIKit.h>
// configuration
#import "XGCViewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark UIView+XGCView
@interface UIView (XGCView)
/// 配置样式
/// - Parameters:
///   - configuration: 渐变信息
///   - state: 状态
- (void)setViewConfiguration:(XGCViewConfiguration *)configuration;
@end

#pragma mark UIView+XGCToast
typedef NS_ENUM(NSInteger, XGCToastViewPosition) {
    XGCToastViewPositionTop = 0,
    XGCToastViewPositionCenter,
    XGCToastViewPositionBottom,
};

@interface UIView (XGCToast)
/// 弹窗
/// - Parameters:
///   - message: 内容
///   - position: 位置
- (void)makeToast:(NSString *)message position:(XGCToastViewPosition)position;

/// 弹窗
/// - Parameters:
///   - message: 内容
///   - position: 位置
///   - completion: 完成回调
- (void)makeToast:(NSString *)message position:(XGCToastViewPosition)position completion:(nullable void(^)(BOOL didTap))completion;
@end

#pragma mark UIView+XGCHUD
@interface UIView (XGCHUD)
/// Shows the HUD with a progress indicator.
/// @param progress A float value between 0.0 and 1.0 indicating the progress.
- (void)showProgress:(float)progress;

/// Shows the HUD with a progress indicator and a provided status message.
/// @param progress A float value between 0.0 and 1.0 indicating the progress.
/// @param status The message to be displayed alongside the progress indicator.
- (void)showProgress:(float)progress status:(nullable NSString*)status;

/// Dismisses the HUD immediately.
- (void)dismiss;
@end

#pragma mark UIView+XGCActivity
@interface UIView (XGCActivity)
/// 开始加载动画
- (void)startAnimating;

/// 结束加载动画
- (void)stopAnimating;
@end
NS_ASSUME_NONNULL_END
