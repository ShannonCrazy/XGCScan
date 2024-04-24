//
//  XGCMainTextFieldDelegator.h
//  XGCMain
//
//  Created by 凌志 on 2024/2/6.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class XGCMainTextField;

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainTextFieldDelegator : NSObject <UITextFieldDelegate>
/// 输入框
@property (nonatomic, weak) XGCMainTextField *textField;
@end

NS_ASSUME_NONNULL_END
