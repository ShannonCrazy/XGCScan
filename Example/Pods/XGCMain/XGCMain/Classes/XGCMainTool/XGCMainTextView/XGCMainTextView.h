//
//  XGCMainTextView.h
//  iPadDemo
//
//  Created by 凌志 on 2023/12/25.
//

#import <UIKit/UIKit.h>
@class XGCMainTextView;

NS_ASSUME_NONNULL_BEGIN

@protocol XGCMainTextViewDelegate <UITextViewDelegate>
@optional
/**
 *  输入框高度发生变化时的回调，当实现了这个方法后，文字输入过程中就会不断去计算输入框新内容的高度，并通过这个方法通知到 delegate
 *  @note 只有当内容高度与当前输入框的高度不一致时才会调用到这里，所以无需在内部做高度是否变化的判断。
 */
- (void)textView:(XGCMainTextView *)textView newHeightAfterTextChanged:(CGFloat)height;
@end

@interface XGCMainTextView : UITextView
@property (nullable, nonatomic, weak) id <XGCMainTextViewDelegate> delegate;
@property (nullable, nonatomic, copy) NSString *placeholder;          // default is nil. string is drawn 70% gray
@property (nullable, nonatomic, copy) NSAttributedString *attributedPlaceholder; // default is nil
/// 当通过 `setText:`、`setAttributedText:`等方式修改文字时，是否应该自动触发 `UITextViewDelegate` 里的 `textView:shouldChangeTextInRange:replacementText:`、 `textViewDidChange:` 方法
/// 默认为YES（注意系统的 UITextView 对这种行为默认是 NO）
@property(assign, nonatomic) BOOL shouldResponseToProgrammaticallyTextChanges;
@end

NS_ASSUME_NONNULL_END
