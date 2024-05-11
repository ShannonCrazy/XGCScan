//
//  UIColor+XGCColor.h
//  xinggc
//
//  Created by 凌志 on 2023/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (XGCColor)
/// 随机色
@property (class, nonatomic, readonly) UIColor *arc4randomColor;
/// 获取颜色
+ (UIColor *)xgc_colorNamed:(NSString *)name;
@end
NS_ASSUME_NONNULL_END
