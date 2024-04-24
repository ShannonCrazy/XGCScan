//
//  XGCMainTextField.h
//  iPadDemo
//
//  Created by 凌志 on 2023/12/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainTextField : UITextField
/// 缩进
@property (nonatomic, assign) UIEdgeInsets contentInset;
/// 小数分隔符后的最大位数 默认不限制
@property (nonatomic, assign) NSUInteger maximumFractionDigits;
@end

NS_ASSUME_NONNULL_END
