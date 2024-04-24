//
//  XGCViewLayer.h
//  xinggc
//
//  Created by 凌志 on 2023/12/6.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "XGCViewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN
#pragma mark CALayer 普通图层
@interface XGCViewLayer : CALayer

@end

#pragma mark CAShapeLayer 形状图层
@interface XGCViewBorderLayer : CAShapeLayer
/// 配置边框数据
/// - Parameter aTarget: 对象
/// - Parameter configuration: 配置信息
- (void)setTarget:(UIView *)aTarget configuration:(XGCViewBorderConfiguration *)configuration;
@end

#pragma mark CAGradientLayer 渐变图层
@interface XGCViewGradientLayer : CAGradientLayer
/// 配置渐变数据
/// - Parameters:
///   - aTarget: 对象
///   - configuration: 配置信息
///   - state: 状态
- (void)setTarget:(UIControl *)aTarget configuration:(nullable XGCViewGradientConfiguration *)configuration forState:(UIControlState)state;
@end

#pragma mark CAGradientLayer 圆角图层
@interface XGCViewCornerRadiusLayer : CAShapeLayer

- (void)setTarget:(UIView *)aTarget configuration:(XGCViewCornerRadiusConfiguration *)configuration;
@end
NS_ASSUME_NONNULL_END
