//
//  XGCMainTextFieldDelegator.m
//  XGCMain
//
//  Created by 凌志 on 2024/2/6.
//

#import "XGCMainTextFieldDelegator.h"
// view
#import "XGCMainTextField.h"

@implementation XGCMainTextFieldDelegator

- (BOOL)textField:(XGCMainTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.markedTextRange) {
        return YES;
    }
    if (![textField isKindOfClass:[XGCMainTextField class]]) {
        return YES;
    }
    if (textField.maximumFractionDigits == NSUIntegerMax) {
        return YES;
    }
    BOOL isDeleting = range.length > 0 && string.length <= 0;
    if (isDeleting) {
        // https://github.com/Tencent/QMUI_iOS/issues/377
        return NSMaxRange(range) <= textField.text.length;
    }
    // 如果复制的文字 类似 3.4.5 这样是不允许粘贴的
    if ([string componentsSeparatedByString:@"."].count > 2) {
        return NO;
    }
    // 只允许输入一个小数点
    if ([textField.text containsString:@"."] && [string containsString:@"."]) {
        return NO ;
    }
    NSArray <NSString *> *temp = [textField.text componentsSeparatedByString:@"."];
    if (temp.count > 1 && temp.lastObject.length + string.length > textField.maximumFractionDigits) {
        return NO;
    }
    return YES;
}

@end
