//
//  UIControl+XGCControl.h
//  xinggc
//
//  Created by 凌志 on 2023/12/6.
//

#import <UIKit/UIKit.h>
// configuration
#import "XGCViewConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (XGCControl)
/// 设置渐变信息
/// - Parameters:
///   - configuration: 渐变信息
///   - state: 状态
- (void)setConfiguration:(nullable XGCViewGradientConfiguration *)configuration forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
