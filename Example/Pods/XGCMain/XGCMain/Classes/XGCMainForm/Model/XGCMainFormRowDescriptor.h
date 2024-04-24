//
//  XGCMainFormRowDescriptor.h
//  iPadDemo
//
//  Created by 凌志 on 2023/12/19.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
// view
#import "XGCDatePickerView.h"
// model
#import "XGCUserDictMapModel.h"
#import "XGCMainMediaFileJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainFormRowDescriptor : NSObject
/// 是否必填
@property (nonatomic, assign, getter=isRequired) BOOL required;
/// 缩进量 default UIEdgeInsetsMake(14.0, 20.0, 14.0, 20.0)
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
/// default is UITableViewAutomaticDimension
@property (nonatomic, assign) CGFloat rowHeight;
/// 字体 default 13
@property (nonatomic, strong) UIFont *font;
/// 左侧提示文本
@property (nonatomic, copy) NSString *cDescription;
/// 左侧文本创建
@property (nonatomic, copy) void(^addTextLabelWithConfigurationHandler)(UILabel *textLabel);
/// 初始化
+ (instancetype)formRowDescriptor;
@end

@interface XGCMainFormRowTextFieldDescriptor : XGCMainFormRowDescriptor
/// 文字
@property (nullable, nonatomic, copy) NSString *text;
/// 提示语
@property (nullable, nonatomic, copy) NSString *placeholder;
/// 小数分隔符后的最大位数 默认不限制
@property (nonatomic, assign) NSUInteger maximumFractionDigits;
/// 输入框创建
@property (nullable, nonatomic, copy) void(^addTextFieldWithConfigurationHandler)(UITextField *textField);
/// 输入框文字发生改变事件
@property (nullable, nonatomic, copy) void(^UITextFieldTextDidChangeAction)(XGCMainFormRowTextFieldDescriptor *descriptor, UITextField *textField);
@end

@interface XGCMainFormRowTextFieldSelectorDescriptor : XGCMainFormRowTextFieldDescriptor
/// 图层
@property (nonatomic, strong, readonly) CALayer *layer;
/// 是否可用
@property (nonatomic, assign, getter=isSelected) BOOL selected;

- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state;

- (void)setTitleColor:(nullable UIColor *)color forState:(UIControlState)state;
/// 按钮点击事件
@property (nullable, nonatomic, copy) void(^UIButtonTouchUpInsideAction)(XGCMainFormRowTextFieldSelectorDescriptor *descriptor, UIButton *button);
@property (nonatomic, strong, readonly) NSMutableDictionary <NSNumber *, NSString *> *titleMaps;
@property (nonatomic, strong, readonly) NSMutableDictionary <NSNumber *, UIColor *> *colorMaps;
@end

@interface XGCMainFormRowTextViewDescriptor : XGCMainFormRowDescriptor
/// 文字
@property (nullable, nonatomic, copy) NSString *text;
/// 提示语
@property (nullable, nonatomic, copy) NSString *placeholder;
/// 顶部文字和底部输入框之间的间距
@property (nonatomic, assign) CGFloat spacePadding;
/// 输入框创建
@property (nullable, nonatomic, copy) void(^addTextViewWithConfigurationHandler)(UITextView *textView);
/// 输入框文字发生改变事件
@property (nullable, nonatomic, copy) void(^UITextViewTextDidChangeAction)(XGCMainFormRowTextViewDescriptor *descriptor, UITextView *textView);
@end

@interface XGCMainFormRowActionDescriptor : XGCMainFormRowDescriptor
/// 文字
@property (nullable, nonatomic, copy) NSString *text;
/// 文字颜色
@property (nonatomic, strong) UIColor *textColor;
/// 提示语
@property (nullable, nonatomic, copy) NSString *placeholder;
/// 右侧图像，default
@property (nullable, nonatomic, strong) UIImage *image;
/// 图片配置
@property (nullable, nonatomic, copy) void(^addImageViewWithConfigurationHandler)(XGCMainFormRowActionDescriptor *descriptor, UIImageView *imageView);
/// 文字配置
@property (nullable, nonatomic, copy) void(^addDetailTextLabelWithConfigurationHandler)(XGCMainFormRowActionDescriptor *descriptor, UILabel *detailTextLabel);
/// 按钮点击事件
@property (nullable, nonatomic, copy) void(^UIControlTouchUpInsideAction)(XGCMainFormRowActionDescriptor *descriptor);
@end

@interface XGCMainFormRowDateActionDescriptor : XGCMainFormRowDescriptor
/// 日期
@property (nullable, nonatomic, strong) NSDate *date;
/// 提示语
@property (nullable, nonatomic, copy) NSString *placeholder;
/// 日期格式
@property (nullable, nonatomic, copy) NSString *dateFormat;
/// 日期弹窗配置样式事件
@property (nullable, nonatomic, copy) void(^addDatePickerViewWithConfigurationHandler)(XGCMainFormRowDateActionDescriptor *descriptor, XGCDatePickerView *datePickerView);
/// 日期发生改变事件
@property (nullable, nonatomic, copy) void(^NSDateDidChangeAction)(XGCMainFormRowDateActionDescriptor *descriptor, NSDate *date);
@end

@interface XGCMainFormRowDictMapActionDescriptor : XGCMainFormRowDescriptor
/// 父编码
@property (nullable, nonatomic, copy) NSString *cCoder;
/// 子编码
@property (nullable, nonatomic, copy) NSString *cCode;
/// 提示语
@property (nullable, nonatomic, copy) NSString *placeholder;
/// 自定义编码
@property (nullable, nonatomic, strong) NSArray <XGCUserDictMapModel *> *dictMaps;
/// 是否允许多选
@property (nonatomic, assign) BOOL allowsMultipleSelection;
/// 编码发生改变事件
@property (nullable, nonatomic, copy) void(^cCodeDidChangeAction)(XGCMainFormRowDictMapActionDescriptor *descriptor, NSString *cCode);
@end

@interface XGCMainFormRowDictMapSelectorDescriptor : XGCMainFormRowDescriptor
/// 提示语
@property (nullable, nonatomic, copy) NSString *placeholder;
/// 父编码
@property (nullable, nonatomic, copy) NSString *cCoder;
/// 子编码
@property (nullable, nonatomic, copy) NSString *cCode;
/// 自定义编码
@property (nullable, nonatomic, strong) NSArray <XGCUserDictMapModel *> *dictMaps;
/// 编码发生改变事件
@property (nullable, nonatomic, copy) void(^cCodeDidChangeAction)(XGCMainFormRowDictMapSelectorDescriptor *descriptor, NSString *cCode);
@end

@interface XGCMainFormRowStyleValue1Descriptor : XGCMainFormRowDescriptor
/// 右侧文本
@property (nullable, nonatomic, copy) NSString *cDetailText;
/// 右侧文本颜色
@property (nullable, nonatomic, strong) UIColor *cDetailTextColor;
@end

@interface XGCMainFormRowStyleSubtitleDescriptor : XGCMainFormRowDescriptor
/// 右侧文本
@property (nullable, nonatomic, copy) NSString *cDetailText;
/// 右侧富文本
@property (nullable, nonatomic, copy) __kindof NSAttributedString *cDetailAttributed;
@end

@interface XGCMainFormRowMediaDescriptor : XGCMainFormRowDescriptor
/// 提示语
@property (nullable, nonatomic, copy) NSString *placeholder;
/// 是否可用
@property(nonatomic, assign, getter=isEditable) BOOL editable;
/// 附件
@property (nonatomic, strong) NSMutableArray <XGCMainMediaFileJsonModel *> *fileJsons;
@end

@interface XGCMainFormRowCustiomDescriptor : XGCMainFormRowDescriptor
/// Class
@property (nonatomic, strong) Class aClass;
/// 配置cell样式
@property (nonatomic, copy) void(^setupCustomCell)(XGCMainFormRowCustiomDescriptor *descriptor, __kindof UITableViewCell *cell, NSIndexPath *indexPath);
@end


NS_ASSUME_NONNULL_END
