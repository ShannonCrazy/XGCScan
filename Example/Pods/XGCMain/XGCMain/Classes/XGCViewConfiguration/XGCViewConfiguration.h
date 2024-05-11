//
//  XGCViewConfiguration.h
//  xinggc
//
//  Created by 凌志 on 2023/12/6.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCViewConfiguration : NSObject <NSCopying>

@end

@interface XGCViewBorderConfiguration : XGCViewConfiguration
/// 边框位置
@property (nonatomic, assign) UIRectEdge position;
/// 边框颜色
@property (nonatomic, strong) UIColor *borderColor;
/// 边框宽度 Defaults 0.5
@property (nonatomic, assign) CGFloat lineWidth;
/// 边框的虚线样式
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *lineDashPattern;
@end

@interface XGCViewGradientConfiguration : XGCViewConfiguration
/// 渐变色数组 The array of CGColorRef objects, Defaults to nil
@property (nonatomic, nullable, copy) NSArray *colors;
/// 渐变路径 Defaults to nil
@property (nonatomic, nullable, copy) NSArray<NSNumber *> *locations;
/// 渐变起始位置 default [.5,0]
@property (nonatomic, assign) CGPoint startPoint;
/// 渐变结束位置 default [.5,1]
@property (nonatomic, assign) CGPoint endPoint;
@end

/// 圆角处理
@interface XGCViewCornerRadiusConfiguration : XGCViewConfiguration
/// 圆角半径
@property (nonatomic, assign) CGFloat cornerRadii;
/// 圆角位置
@property (nonatomic, assign) UIRectCorner roundingCorners;
@end
NS_ASSUME_NONNULL_END
