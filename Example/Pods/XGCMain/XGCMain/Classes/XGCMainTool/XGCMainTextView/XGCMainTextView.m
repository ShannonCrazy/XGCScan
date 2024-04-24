//
//  XGCMainTextView.m
//  iPadDemo
//
//  Created by 凌志 on 2023/12/25.
//

#import "XGCMainTextView.h"

@interface XGCMainTextView ()<UITextViewDelegate>
@property (nonatomic, strong) UILabel *placeholderLabel;
@end

@implementation XGCMainTextView

@dynamic delegate;

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
    // 基本设置
    self.scrollsToTop = NO;
    self.returnKeyType = UIReturnKeyDone;
    self.textContainerInset = UIEdgeInsetsZero;
    self.textContainer.lineFragmentPadding = 0.0;
    self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    // 提示文字
    self.placeholderLabel = ({
        UILabel *label = [[UILabel alloc] init];
        label.alpha = 0;
        label.numberOfLines = 0;
        label.textColor = [[UIColor systemGrayColor] colorWithAlphaComponent:0.7];
        [self addSubview:label];
        label;
    });
    self.shouldResponseToProgrammaticallyTextChanges = YES;
    // 通知中心
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(UITextViewTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark publick
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.placeholderLabel.text = _placeholder;
    [self sendSubviewToBack:self.placeholderLabel];
    [self setNeedsLayout];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    _attributedPlaceholder = attributedPlaceholder;
    self.placeholderLabel.attributedText = _attributedPlaceholder;
    _placeholder = _attributedPlaceholder.string;
    [self sendSubviewToBack:self.placeholderLabel];
    [self setNeedsLayout];
}

#pragma mark system
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeholderLabel.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    self.placeholderLabel.textAlignment = textAlignment;
}

- (void)setText:(NSString *)text {
    NSString *textBeforeChange = self.text;
    BOOL textDifferent = [self isCurrentTextDifferentOfText:text];
    // 如果前后文字没变化，则什么都不做
    if (!textDifferent) {
        [super setText:text];
        return;
    }
    // 前后文字发生变化，则要根据是否主动接管 delegate 来决定是否要询问 delegate
    if (self.shouldResponseToProgrammaticallyTextChanges) {
        BOOL shouldChangeText = YES;
        if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            shouldChangeText = [self.delegate textView:self shouldChangeTextInRange:NSMakeRange(0, textBeforeChange.length) replacementText:text];
        }
        
        if (!shouldChangeText) {
            // 不应该改变文字，所以连 super 都不调用，直接结束方法
            return;
        }
        
        // 应该改变文字，则调用 super 来改变文字，然后主动调用 textViewDidChange:
        [super setText:text];
        if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [self.delegate textViewDidChange:self];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
        
    } else {
        [super setText:text];
        
        // 如果不需要主动接管事件，则只要触发内部的监听即可，不用调用 delegate 系列方法
        [self UITextViewTextDidChange:self];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    NSString *textBeforeChange = self.attributedText.string;
    BOOL textDifferent = [self isCurrentTextDifferentOfText:attributedText.string];
    
    // 如果前后文字没变化，则什么都不做
    if (!textDifferent) {
        [super setAttributedText:attributedText];
        return;
    }
    
    // 前后文字发生变化，则要根据是否主动接管 delegate 来决定是否要询问 delegate
    if (self.shouldResponseToProgrammaticallyTextChanges) {
        BOOL shouldChangeText = YES;
        if ([self.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
            shouldChangeText = [self.delegate textView:self shouldChangeTextInRange:NSMakeRange(0, textBeforeChange.length) replacementText:attributedText.string];
        }
        
        if (!shouldChangeText) {
            // 不应该改变文字，所以连 super 都不调用，直接结束方法
            return;
        }
        
        // 应该改变文字，则调用 super 来改变文字，然后主动调用 textViewDidChange:
        [super setAttributedText:attributedText];
        if ([self.delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [self.delegate textViewDidChange:self];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UITextViewTextDidChangeNotification object:self];
        
    } else {
        [super setAttributedText:attributedText];
        
        // 如果不需要主动接管事件，则只要触发内部的监听即可，不用调用 delegate 系列方法
        [self UITextViewTextDidChange:self];
    }
}

- (BOOL)isCurrentTextDifferentOfText:(NSString *)text {
    NSString *textBeforeChange = self.text;// UITextView 如果文字为空，self.text 永远返回 @"" 而不是 nil（即便你设置为 nil 后立即 get 出来也是）
    if ([textBeforeChange isEqualToString:text] || (textBeforeChange.length == 0 && !text)) {
        return NO;
    }
    return YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.placeholder.length > 0) {
        CGFloat limitWidth = CGRectGetWidth(self.bounds) - self.contentInset.left - self.contentInset.right - self.textContainerInset.left - self.textContainerInset.right;
        CGFloat limitHeight = CGRectGetHeight(self.bounds) - self.contentInset.top - self.contentInset.bottom - self.textContainerInset.top - self.textContainerInset.bottom;
        CGSize labelSize = [self.placeholderLabel.text boundingRectWithSize:CGSizeMake(limitWidth, limitHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.placeholderLabel.font} context:nil].size;
        labelSize.height = fmin(limitHeight, labelSize.height);
        self.placeholderLabel.frame = CGRectMake(self.contentInset.left + self.textContainerInset.left, self.contentInset.top + self.textContainerInset.top, limitWidth, labelSize.height);
    }
}

- (void)drawRect:(CGRect)rect {
    [self updatePlaceholderLabelAlpha];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - NSNotificationName
- (void)UITextViewTextDidChange:(id)sender {
    if (self.placeholder.length > 0) {
        [self updatePlaceholderLabelAlpha];
    }
    XGCMainTextView *textView = nil;
    if ([sender isKindOfClass:[NSNotification class]]) {
        textView = ((NSNotification *)sender).object;
    } else if ([sender isKindOfClass:[XGCMainTextView class]]) {
        textView = (XGCMainTextView *)sender;
    }
    if (![textView isKindOfClass:[XGCMainTextView class]]) {
        return;
    }
    if (!textView.editable) {
        return;
    }
    // 计算高度
    if ([textView.delegate respondsToSelector:@selector(textView:newHeightAfterTextChanged:)]) {
        if (CGSizeEqualToSize(textView.bounds.size, CGSizeZero)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                CGFloat resultHeight = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.bounds), CGFLOAT_MAX)].height;
                // 通知delegate去更新textView的高度
                if (ceil(resultHeight) != ceil(CGRectGetHeight(textView.bounds))) {
                    [textView.delegate textView:textView newHeightAfterTextChanged:resultHeight];
                }
            });
        } else {
            CGFloat resultHeight = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.bounds), CGFLOAT_MAX)].height;
            // 通知delegate去更新textView的高度
            if (ceil(resultHeight) != ceil(CGRectGetHeight(textView.bounds))) {
                [textView.delegate textView:textView newHeightAfterTextChanged:resultHeight];
            }
        }
    }
}

#pragma mark func
- (void)updatePlaceholderLabelAlpha {
    if (self.text.length == 0 && self.placeholder.length > 0) {
        self.placeholderLabel.alpha = 1;
    } else {
        self.placeholderLabel.alpha = 0;// 用alpha来让placeholder隐藏，从而尽量避免因为显隐 placeholder 导致 layout
    }
}

@end
