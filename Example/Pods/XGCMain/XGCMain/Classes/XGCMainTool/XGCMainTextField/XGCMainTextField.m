//
//  XGCMainTextField.m
//  iPadDemo
//
//  Created by 凌志 on 2023/12/25.
//

#import "XGCMainTextField.h"
// delegator
#import "XGCMainTextFieldDelegator.h"

@interface XGCMainTextField ()
/// 代理着
@property (nonatomic, strong) XGCMainTextFieldDelegator *delegator;
@end

@implementation XGCMainTextField

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _didInitialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _didInitialize];
    }
    return self;
}

- (void)_didInitialize {
    self.delegator = [[XGCMainTextFieldDelegator alloc] init];
    self.returnKeyType = UIReturnKeyDone;
    self.contentInset = UIEdgeInsetsZero;
    self.maximumFractionDigits = NSUIntegerMax;
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    _contentInset = contentInset;
    [self setNeedsDisplay];
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    [super setKeyboardType:keyboardType];
    self.delegate = (keyboardType == UIKeyboardTypeDecimalPad) ? self.delegator : nil;
}

#pragma mark - drawing and positioning overrides
- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    bounds.origin.x -= self.contentInset.right;
    return [super rightViewRectForBounds:bounds];
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds {
    bounds.origin.x += self.contentInset.left;
    return [super leftViewRectForBounds:bounds];
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds {
    bounds.origin.x -= self.contentInset.right;
    return [super clearButtonRectForBounds:bounds];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, self.contentInset)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, self.contentInset)];
}

@end
