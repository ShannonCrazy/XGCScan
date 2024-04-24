//
//  XGCMainFormRowTableViewCell.m
//  iPadDemo
//
//  Created by 凌志 on 2023/12/21.
//

#import "XGCMainFormRowTableViewCell.h"
// model
#import "XGCMainFormRowDescriptor.h"
//
#import "XGCMainTextView.h"
#import "XGCMainTextField.h"
#import "XGCMainMediaFileJsonContainerView.h"
//
#import "NSDate+XGCDate.h"
#import "XGCUserManager.h"
#import "UIImage+XGCImage.h"
#import "XGCConfiguration.h"
//#import "XGCComponentRoute.h"
#import "NSString+XGCString.h"
//
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
//
#import "XGCMainFormRowDictMapCollectionViewCell.h"

#pragma mark XGCMainFormRowTableViewCell

@implementation XGCMainFormRowTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = XGCCMI.whiteColor;
        // 左侧文本
        self.cTextLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = XGCCMI.secondaryLabelColor;
            [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.mas_equalTo(self.contentView);
                make.height.mas_equalTo(label.font.lineHeight);
            }];
            label;
        });
        // 必填
        self.cRequiredLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"*";
            label.textColor = XGCCMI.redColor;
            [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.cTextLabel);
                make.right.mas_equalTo(self.cTextLabel.mas_left).offset(-3.0);
            }];
            label;
        });
        ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = XGCCMI.backgroundColor;
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.contentView);
                make.bottom.mas_equalTo(self.contentView).priorityLow();
                make.height.mas_equalTo(1.0);
            }];
        });
    }
    return self;
}

- (void)setDescriptor:(XGCMainFormRowDescriptor *)descriptor {
    _descriptor = descriptor;
    if (![_descriptor isKindOfClass:[XGCMainFormRowDescriptor class]]) {
        return;
    }
    self.cRequiredLabel.font = _descriptor.font;
    self.cRequiredLabel.hidden = !_descriptor.isRequired;
    self.cTextLabel.font = _descriptor.font;
    self.cTextLabel.text = _descriptor.cDescription;
    _descriptor.addTextLabelWithConfigurationHandler ? _descriptor.addTextLabelWithConfigurationHandler(self.cTextLabel) : nil;
    // 约束
    [self.cTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.cTextLabel.font.lineHeight);
        make.top.mas_equalTo(self.contentView).offset(_descriptor.contentEdgeInsets.top);
        make.left.mas_equalTo(self.contentView).offset(_descriptor.contentEdgeInsets.left);
    }];
}

@end

#pragma mark XGCMainFormRowTextFieldTableViewCell
@interface XGCMainFormRowTextFieldTableViewCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) XGCMainTextField *cTextField;
@end

@implementation XGCMainFormRowTextFieldTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.containerView = ({
            UIView *view = [[UIView alloc] init];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.cTextLabel.mas_right).offset(10.0);
                make.bottom.mas_equalTo(self.contentView).priorityMedium();
            }];
            view;
        });
        self.cTextField = ({
            XGCMainTextField *textField = [[XGCMainTextField alloc] init];
            textField.textAlignment = NSTextAlignmentRight;
            textField.textColor = XGCCMI.textFieldTextColor;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [textField addTarget:self action:@selector(UITextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            [self.containerView addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.containerView);
            }];
            textField;
        });
    }
    return self;
}
- (void)setTextFieldDescriptor:(XGCMainFormRowTextFieldDescriptor *)textFieldDescriptor {
    [super setDescriptor:textFieldDescriptor];
    if (![textFieldDescriptor isKindOfClass:[XGCMainFormRowTextFieldDescriptor class]]) {
        return;
    }
    _textFieldDescriptor = textFieldDescriptor;
    // 控件
    CGFloat height = _textFieldDescriptor.contentEdgeInsets.top + _textFieldDescriptor.contentEdgeInsets.bottom + _textFieldDescriptor.font.lineHeight;
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ceil(height));
    }];
    // 输入框
    self.cTextField.font = _textFieldDescriptor.font;
    self.cTextField.placeholder = _textFieldDescriptor.placeholder;
    self.cTextField.text = _textFieldDescriptor.text;
    self.cTextField.contentInset = UIEdgeInsetsMake(_textFieldDescriptor.contentEdgeInsets.top, 0, _textFieldDescriptor.contentEdgeInsets.bottom, _textFieldDescriptor.contentEdgeInsets.right);
    self.cTextField.keyboardType = UIKeyboardTypeDefault;
    _textFieldDescriptor.addTextFieldWithConfigurationHandler ? _textFieldDescriptor.addTextFieldWithConfigurationHandler(self.cTextField) : nil;
    self.cTextField.maximumFractionDigits = _textFieldDescriptor.maximumFractionDigits;
}

#pragma mark action
- (void)UITextFieldEditingChanged:(UITextField *)textField {
    self.textFieldDescriptor.text = textField.text;
    self.textFieldDescriptor.UITextFieldTextDidChangeAction ? self.textFieldDescriptor.UITextFieldTextDidChangeAction(self.textFieldDescriptor, textField) : nil;
}

@end

#pragma mark XGCMainFormRowTextFieldSelectorTableViewCell
@interface XGCMainFormRowTextFieldSelectorTableViewCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIButton *selectorButton;
@property (nonatomic, strong) XGCMainTextField *cTextField;
@end

@implementation XGCMainFormRowTextFieldSelectorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.containerView = ({
            UIView *view = [[UIView alloc] init];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.cTextLabel.mas_right).offset(10.0);
                make.bottom.mas_equalTo(self.contentView).priorityMedium();
            }];
            view;
        });
        self.selectorButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.layer.borderWidth = 1.0;
            button.layer.cornerRadius = 4.0;
            button.layer.borderColor = XGCCMI.blueColor.CGColor;
            [button setTitle:@"选择" forState:UIControlStateNormal];
            [button setTitle:@"清除" forState:UIControlStateSelected];
            button.contentEdgeInsets = UIEdgeInsetsMake(5.0, 8.0, 5.0, 8.0);
            [button setTitleColor:XGCCMI.blueColor forState:UIControlStateNormal];
            [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [button setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [button addTarget:self action:@selector(selectorButtonTouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
            [self.containerView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.right.mas_equalTo(self.containerView);
            }];
            button;
        });
        self.cTextField = ({
            XGCMainTextField *textField = [[XGCMainTextField alloc] init];
            textField.textAlignment = NSTextAlignmentRight;
            textField.textColor = XGCCMI.textFieldTextColor;
            textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            [textField addTarget:self action:@selector(UITextFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
            [self.containerView addSubview:textField];
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.mas_equalTo(self.containerView);
                make.right.mas_equalTo(self.selectorButton.mas_left).offset(-10.0);
            }];
            textField;
        });
    }
    return self;
}
- (void)setTextFieldSelectorDescriptor:(XGCMainFormRowTextFieldSelectorDescriptor *)textFieldSelectorDescriptor {
    [super setDescriptor:textFieldSelectorDescriptor];
    if (![textFieldSelectorDescriptor isKindOfClass:[XGCMainFormRowTextFieldSelectorDescriptor class]]) {
        return;
    }
    _textFieldSelectorDescriptor = textFieldSelectorDescriptor;
    // 右侧按钮
    [self.selectorButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.containerView).offset(-_textFieldSelectorDescriptor.contentEdgeInsets.right);
    }];
    self.selectorButton.titleLabel.font = _textFieldSelectorDescriptor.font;
    [_textFieldSelectorDescriptor.titleMaps enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.selectorButton setTitle:obj forState:key.unsignedIntegerValue];
    }];
    [_textFieldSelectorDescriptor.colorMaps enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, UIColor * _Nonnull obj, BOOL * _Nonnull stop) {
        [self.selectorButton setTitleColor:obj forState:key.unsignedIntegerValue];
    }];
    self.selectorButton.selected = _textFieldSelectorDescriptor.selected;
    // 控件高度
    CGFloat height = _textFieldSelectorDescriptor.contentEdgeInsets.top + _textFieldSelectorDescriptor.contentEdgeInsets.bottom + _textFieldSelectorDescriptor.font.lineHeight;
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(ceil(height));
    }];
    // 输入框
    self.cTextField.font = _textFieldSelectorDescriptor.font;
    self.cTextField.text = _textFieldSelectorDescriptor.text;
    self.cTextField.placeholder = _textFieldSelectorDescriptor.placeholder;
    self.cTextField.contentInset = UIEdgeInsetsMake(_textFieldSelectorDescriptor.contentEdgeInsets.top, 0, _textFieldSelectorDescriptor.contentEdgeInsets.bottom, 0);
    _textFieldSelectorDescriptor.addTextFieldWithConfigurationHandler ? _textFieldSelectorDescriptor.addTextFieldWithConfigurationHandler(self.cTextField) : nil;
    //
    self.cTextField.enabled = !_textFieldSelectorDescriptor.selected;
}

#pragma mark action
- (void)UITextFieldEditingChanged:(UITextField *)textField {
    self.textFieldSelectorDescriptor.text = textField.text;
    self.textFieldSelectorDescriptor.UITextFieldTextDidChangeAction ? self.textFieldSelectorDescriptor.UITextFieldTextDidChangeAction(self.textFieldSelectorDescriptor, textField) : nil;
}

- (void)selectorButtonTouchUpInsideAction:(UIButton *)sender {
    self.textFieldSelectorDescriptor.UIButtonTouchUpInsideAction ? self.textFieldSelectorDescriptor.UIButtonTouchUpInsideAction(self.textFieldSelectorDescriptor, sender) : nil;
}

@end

#pragma mark XGCMainFormRowTextViewTableViewCell
@interface XGCMainFormRowTextViewTableViewCell ()<XGCMainTextViewDelegate>
@property (nonatomic, strong) XGCMainTextView *cTextView;
@end

@implementation XGCMainFormRowTextViewTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cTextView = ({
            XGCMainTextView *textView = [[XGCMainTextView alloc] init];
            textView.delegate = self;
            textView.scrollEnabled = NO;
            textView.textColor = XGCCMI.textFieldTextColor;
            [self.contentView addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.cTextLabel.mas_bottom);
                make.left.right.mas_equalTo(self.contentView);
                make.bottom.mas_equalTo(self.contentView).offset(-1.0).priorityMedium();
                make.height.mas_equalTo(textView.font.lineHeight);
            }];
            textView;
        });
    }
    return self;
}
- (void)setTextViewDescriptor:(XGCMainFormRowTextViewDescriptor *)textViewDescriptor {
    [super setDescriptor:textViewDescriptor];
    if (![textViewDescriptor isKindOfClass:[XGCMainFormRowTextViewDescriptor class]]) {
        return;
    }
    _textViewDescriptor = textViewDescriptor;
    // 输入框
    self.cTextView.font = _textViewDescriptor.font;
    CGFloat height = self.cTextView.font.lineHeight + _textViewDescriptor.spacePadding + _textViewDescriptor.contentEdgeInsets.bottom;
    [self.cTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    self.cTextView.text = _textViewDescriptor.text;
    self.cTextView.placeholder = _textViewDescriptor.placeholder;
    self.cTextView.textContainerInset = UIEdgeInsetsMake(_textViewDescriptor.spacePadding, _textViewDescriptor.contentEdgeInsets.left, _textViewDescriptor.contentEdgeInsets.bottom, _textViewDescriptor.contentEdgeInsets.right);
    _textViewDescriptor.addTextViewWithConfigurationHandler ? _textViewDescriptor.addTextViewWithConfigurationHandler(self.cTextView) : nil;
}

#pragma mark - UITextViewDelegate
- (void)textView:(XGCMainTextView *)textView newHeightAfterTextChanged:(CGFloat)height {
    [self.tableView beginUpdates];
    [self.cTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    [self.tableView endUpdates];
}

- (void)textViewDidChange:(XGCMainTextView *)textView {
    if (textView.markedTextRange) {
        return;
    }
    self.textViewDescriptor.text = textView.text;
    self.textViewDescriptor.UITextViewTextDidChangeAction ? self.textViewDescriptor.UITextViewTextDidChangeAction(self.textViewDescriptor, textView) : nil;
}

@end

#pragma mark XGCMainFormRowActionTableViewCell
@interface XGCMainFormRowActionTableViewCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *cImageView;
@property (nonatomic, strong) UILabel *placeholderTextLabel;
@property (nonatomic, strong) UILabel *cDetailTextLabel;
@end

@implementation XGCMainFormRowActionTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.containerView = ({
            UIView *view = [[UIView alloc] init];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.cTextLabel.mas_right).offset(10.0);
            }];
            view;
        });
        self.cImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            [imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
            [imageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.containerView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.containerView);
                make.centerY.mas_equalTo(self.containerView);
            }];
            imageView;
        });
        // 提示文本
        self.placeholderTextLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = XGCCMI.placeholderTextColor;
            [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.containerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.containerView);
                make.left.mas_equalTo(self.containerView).priority(999);
                make.right.mas_equalTo(self.cImageView.mas_left).offset(-10.0);
            }];
            label;
        });
        // 右侧文本
        self.cDetailTextLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.textColor = XGCCMI.labelColor;
            [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.containerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.containerView);
                make.left.mas_equalTo(self.containerView).priority(999);
                make.height.mas_greaterThanOrEqualTo(label.font.lineHeight);
                make.right.mas_equalTo(self.placeholderTextLabel);
            }];
            label;
        });
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.cImageView).priorityHigh();
        }];
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView).priorityMedium();
        }];
        ({
            UIControl *control = [[UIControl alloc] init];
            [control addTarget:self action:@selector(UIControlTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            [self.containerView addSubview:control];
            [control mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(self.containerView);
                make.bottom.mas_equalTo(self.containerView).priorityMedium();
            }];
        });
    }
    return self;
}

- (void)setActionDescriptor:(XGCMainFormRowActionDescriptor *)actionDescriptor {
    [super setDescriptor:actionDescriptor];
    if (![actionDescriptor isKindOfClass:[XGCMainFormRowActionDescriptor class]]) {
        return;
    }
    _dateDescriptor = nil; _dictMapDescriptor = nil;
    _actionDescriptor = actionDescriptor;
    // 图片
    self.cImageView.image = _actionDescriptor.image;
    _actionDescriptor.addImageViewWithConfigurationHandler ? _actionDescriptor.addImageViewWithConfigurationHandler(_actionDescriptor, self.cImageView) : nil;
    [self.cImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.containerView).offset(-_actionDescriptor.contentEdgeInsets.right);
        make.size.mas_equalTo(self.cImageView.image.size);
    }];
    // 提示文本
    self.placeholderTextLabel.font = _actionDescriptor.font;
    self.placeholderTextLabel.text = _actionDescriptor.placeholder;
    self.placeholderTextLabel.alpha = _actionDescriptor.text.length == 0 ? 1.0 : 0.0;
    // 是否是空图片
    BOOL flag = _actionDescriptor.image;
    [self.placeholderTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView).offset(_actionDescriptor.contentEdgeInsets.top);
        make.right.mas_equalTo(self.cImageView.mas_left).offset(flag ? -10.0 : 0);
    }];
    // 文字
    self.cDetailTextLabel.font = _actionDescriptor.font;
    self.cDetailTextLabel.text = _actionDescriptor.text;
    self.cDetailTextLabel.textColor = _actionDescriptor.textColor ?: XGCCMI.labelColor;
    _actionDescriptor.addDetailTextLabelWithConfigurationHandler ? _actionDescriptor.addDetailTextLabelWithConfigurationHandler(_actionDescriptor, self.cDetailTextLabel) : nil;
    [self.cDetailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(self.cDetailTextLabel.font.lineHeight);
        make.top.mas_equalTo(self.containerView).offset(_actionDescriptor.contentEdgeInsets.top);
    }];
    
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cDetailTextLabel.mas_bottom).offset(_actionDescriptor.contentEdgeInsets.bottom).priorityHigh();
    }];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).priorityLow();
    }];
}

- (void)setDateDescriptor:(XGCMainFormRowDateActionDescriptor *)dateDescriptor {
    [super setDescriptor:dateDescriptor];
    if (![dateDescriptor isKindOfClass:[XGCMainFormRowDateActionDescriptor class]]) {
        return;
    }
    _actionDescriptor = nil; _dictMapDescriptor = nil;
    _dateDescriptor = dateDescriptor;
    // 图片
    self.cImageView.image = [UIImage imageNamed:@"main_arrow_blue_right" inResource:@"XGCMain"];
    [self.cImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.containerView).offset(-_dateDescriptor.contentEdgeInsets.right);
    }];
    // 提示文本
    self.placeholderTextLabel.font = _dateDescriptor.font;
    self.placeholderTextLabel.text = _dateDescriptor.placeholder;
    self.placeholderTextLabel.alpha = _dateDescriptor.date ? 0.0 : 1.0;
    [self.placeholderTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView).offset(_dateDescriptor.contentEdgeInsets.top);
    }];
    // 文字
    self.cDetailTextLabel.font = _dateDescriptor.font;
    self.cDetailTextLabel.textColor = _actionDescriptor.textColor ?: XGCCMI.labelColor;
    self.cDetailTextLabel.text = [_dateDescriptor.date stringFromDateFormat:_dateDescriptor.dateFormat];
    [self.cDetailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(self.cDetailTextLabel.font.lineHeight);
        make.top.mas_equalTo(self.containerView).offset(_dateDescriptor.contentEdgeInsets.top);
        make.bottom.mas_equalTo(self.containerView).offset(-_dateDescriptor.contentEdgeInsets.bottom).priorityHigh();
    }];
    
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cDetailTextLabel.mas_bottom).offset(_dateDescriptor.contentEdgeInsets.bottom).priorityHigh();
    }];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).priorityLow();
    }];
}

- (void)setDictMapDescriptor:(XGCMainFormRowDictMapActionDescriptor *)dictMapDescriptor{
    [super setDescriptor:dictMapDescriptor];
    if (![dictMapDescriptor isKindOfClass:[XGCMainFormRowDictMapActionDescriptor class]]) {
        return;
    }
    _actionDescriptor = nil; _dateDescriptor = nil;
    _dictMapDescriptor = dictMapDescriptor;
    // 图片
    self.cImageView.image = [UIImage imageNamed:@"main_arrow_blue_right" inResource:@"XGCMain"];
    [self.cImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.cImageView.image.size);
        make.right.mas_equalTo(self.containerView).offset(-_dictMapDescriptor.contentEdgeInsets.right);
    }];
    // 提示文本
    self.placeholderTextLabel.font = _dictMapDescriptor.font;
    self.placeholderTextLabel.text = _dictMapDescriptor.placeholder;
    self.placeholderTextLabel.alpha = _dictMapDescriptor.cCode.length == 0 ? 1.0 : 0.0;
    [self.placeholderTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.containerView).offset(_dictMapDescriptor.contentEdgeInsets.top);
    }];
    // 文字
    self.cDetailTextLabel.font = _dictMapDescriptor.font;
    NSArray <NSString *> *cCodes = [_dictMapDescriptor.cCode componentsSeparatedByString:@","];
    __block NSMutableArray <NSString *> *temps = [NSMutableArray array];
    if (_dictMapDescriptor.cCoder.length > 0) {
        [cCodes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *cName = [XGCUM.cMenu cDictMap:_dictMapDescriptor.cCoder cCode:obj].cName;
            cName.length > 0 ? [temps addObject:cName] : nil;
        }];
    } else if (_dictMapDescriptor.dictMaps.count > 0) {
        [cCodes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [_dictMapDescriptor.dictMaps enumerateObjectsUsingBlock:^(XGCUserDictMapModel * _Nonnull obj1, NSUInteger idx1, BOOL * _Nonnull stop1) {
                if ([obj1.cCode isEqualToString:obj]) {
                    [temps addObject:obj1.cName];
                    *stop1 = YES;
                }
            }];
        }];
    }
    self.cDetailTextLabel.text = [temps componentsJoinedByString:@","];
    [self.cDetailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(self.cDetailTextLabel.font.lineHeight);
        make.top.mas_equalTo(self.containerView).offset(_dictMapDescriptor.contentEdgeInsets.top);
    }];
    
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cDetailTextLabel.mas_bottom).offset(_dictMapDescriptor.contentEdgeInsets.bottom).priorityHigh();
    }];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).priorityMedium();
    }];
}

#pragma mark action
- (void)UIControlTouchUpInside:(UIControl *)sender {
    if (self.actionDescriptor.UIControlTouchUpInsideAction) {
        self.actionDescriptor.UIControlTouchUpInsideAction(self.actionDescriptor);
    } else if (self.UIControlTouchUpInside) {
        self.UIControlTouchUpInside(self.actionDescriptor ?: self.dateDescriptor ?: self.dictMapDescriptor);
    }
}

@end

#pragma mark XGCMainFormRowDictMapSelectorTableViewCell
@interface XGCMainFormRowDictMapSelectorTableViewCell ()<UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray <XGCUserDictMapModel *> *lists;
@end

@implementation XGCMainFormRowDictMapSelectorTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.collectionView = ({
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0;
            
            UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
            collectionView.bounces = NO;
            collectionView.delegate = self;
            collectionView.dataSource = self;
            collectionView.showsHorizontalScrollIndicator = NO;
            collectionView.backgroundColor = UIColor.clearColor;
            [collectionView registerClass:[XGCMainFormRowDictMapCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([XGCMainFormRowDictMapCollectionViewCell class])];
            [self.contentView addSubview:collectionView];
            [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.cTextLabel.mas_right).offset(8.0);
                make.bottom.mas_equalTo(self.contentView).priorityLow();
            }];
            collectionView;
        });
    }
    return self;
}

- (void)setDictMapSelectorDescriptor:(XGCMainFormRowDictMapSelectorDescriptor *)dictMapSelectorDescriptor {
    [super setDescriptor:dictMapSelectorDescriptor];
    if ([dictMapSelectorDescriptor isKindOfClass:[XGCMainFormRowDictMapActionDescriptor class]]) {
        return;
    }
    _dictMapSelectorDescriptor = dictMapSelectorDescriptor;
    // 约束
    UIEdgeInsets contentInset = _dictMapSelectorDescriptor.contentEdgeInsets;
    CGFloat height = contentInset.top + contentInset.bottom + dictMapSelectorDescriptor.font.lineHeight;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, contentInset.right);
    // 数据
    self.lists = _dictMapSelectorDescriptor.dictMaps ?: [XGCUM.cMenu cDictMap:_dictMapSelectorDescriptor.cCoder];
    [self.lists enumerateObjectsUsingBlock:^(XGCUserDictMapModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = [obj.cCode isEqualToString:_dictMapSelectorDescriptor.cCode];
    }];
    [self.collectionView reloadData];
}

#pragma mark - <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.lists.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCMainFormRowDictMapCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([XGCMainFormRowDictMapCollectionViewCell class]) forIndexPath:indexPath];
    cell.model = self.lists[indexPath.item];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCUserDictMapModel *row = self.lists[indexPath.item];
    CGFloat width = [row.cName sizeWithAttributes:[NSDictionary dictionaryWithObject:self.dictMapSelectorDescriptor.font forKey:NSFontAttributeName]].width;
    width += 10.0 * 3 + 20.0;
    return CGSizeMake(width, CGRectGetHeight(collectionView.frame));
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    XGCUserDictMapModel *row = self.lists[indexPath.item];
    self.dictMapSelectorDescriptor.cCode = row.cCode;
    [self.lists enumerateObjectsUsingBlock:^(XGCUserDictMapModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    row.selected = YES;
    [collectionView reloadData];
    self.dictMapSelectorDescriptor.cCodeDidChangeAction ? self.dictMapSelectorDescriptor.cCodeDidChangeAction(self.dictMapSelectorDescriptor, row.cCode) : nil;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    __block CGFloat width = 0;
    [self.lists enumerateObjectsUsingBlock:^(XGCUserDictMapModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:idx inSection:section];
        if (indexPath) {
            width += [self collectionView:collectionView layout:collectionViewLayout sizeForItemAtIndexPath:indexPath].width;
        }
    }];
    CGFloat maximum = CGRectGetWidth(collectionView.frame) - self.dictMapSelectorDescriptor.contentEdgeInsets.right;
    if (width < maximum) {
        return UIEdgeInsetsMake(0, floor(maximum - width), 0, 0);
    }
    return UIEdgeInsetsZero;
}
@end

#pragma mark XGCMainFormRowStyleValue1TableViewCell
@interface XGCMainFormRowStyleValue1TableViewCell()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *cDetailTextLabel;
@end

@implementation XGCMainFormRowStyleValue1TableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.containerView = ({
            UIView *view = [[UIView alloc] init];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.cTextLabel.mas_right).offset(10.0);
                make.bottom.mas_equalTo(self.contentView).priorityMedium();
            }];
            view;
        });
        self.cDetailTextLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.textColor = XGCCMI.labelColor;
            [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [label setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisHorizontal];
            [self.containerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.mas_equalTo(self.containerView);
                make.height.mas_greaterThanOrEqualTo(label.font.lineHeight);
                make.left.mas_equalTo(self.containerView).priority(998);
            }];
            label;
        });
        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.cDetailTextLabel);
        }];
    }
    return self;
}

- (void)setValue1Descriptor:(XGCMainFormRowStyleValue1Descriptor *)value1Descriptor {
    [super setDescriptor:value1Descriptor];
    if (![value1Descriptor isKindOfClass:[XGCMainFormRowStyleValue1Descriptor class]]) {
        return;
    }
    _value1Descriptor = value1Descriptor;
    self.cDetailTextLabel.font = _value1Descriptor.font;
    self.cDetailTextLabel.text = _value1Descriptor.cDetailText;
    self.cDetailTextLabel.textColor = _value1Descriptor.cDetailTextColor ?: XGCCMI.labelColor;
    // 约束
    [self.cDetailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_greaterThanOrEqualTo(self.cDetailTextLabel.font.lineHeight);
        make.top.mas_equalTo(self.containerView).offset(_value1Descriptor.contentEdgeInsets.top);
        make.right.mas_equalTo(self.containerView).offset(-_value1Descriptor.contentEdgeInsets.right);
    }];
    [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.cDetailTextLabel).offset(value1Descriptor.contentEdgeInsets.bottom);
    }];
}

@end

#pragma mark XGCMainFormRowStyleSubtitleTableViewCell
@interface XGCMainFormRowStyleSubtitleTableViewCell()
@property (nonatomic, strong) UILabel *cDetailTextLabel;
@end

@implementation XGCMainFormRowStyleSubtitleTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cDetailTextLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.textColor = XGCCMI.labelColor;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.cTextLabel.mas_bottom).offset(10.0);
                make.left.right.mas_equalTo(self.contentView);
                make.height.mas_greaterThanOrEqualTo(label.font.lineHeight);
                make.bottom.mas_equalTo(self.contentView).priorityMedium();
            }];
            label;
        });
    }
    return self;
}

- (void)setSubtitleDescriptor:(XGCMainFormRowStyleSubtitleDescriptor *)subtitleDescriptor {
    [super setDescriptor:subtitleDescriptor];
    if (![subtitleDescriptor isKindOfClass:[XGCMainFormRowStyleSubtitleDescriptor class]]) {
        return;
    }
    _subtitleDescriptor = subtitleDescriptor;
    self.cDetailTextLabel.font = _subtitleDescriptor.font;
    if (_subtitleDescriptor.cDetailText) {
        self.cDetailTextLabel.text = _subtitleDescriptor.cDetailText;
    } else if (_subtitleDescriptor.cDetailAttributed) {
        self.cDetailTextLabel.attributedText = _subtitleDescriptor.cDetailAttributed;
    } else {
        self.cDetailTextLabel.text = @"";
    }
    // 约束
    [self.cDetailTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(_subtitleDescriptor.contentEdgeInsets.left);
        make.right.mas_equalTo(self.contentView).offset(-_subtitleDescriptor.contentEdgeInsets.left);
        make.height.mas_greaterThanOrEqualTo(self.cDetailTextLabel.font.lineHeight);
        make.bottom.mas_equalTo(self.contentView).offset(-_subtitleDescriptor.contentEdgeInsets.bottom).priorityMedium();
    }];
}

@end

#pragma mark XGCMainFormRowMediaTableViewCell
@interface XGCMainFormRowMediaTableViewCell ()
@property (nonatomic, strong) XGCMainMediaFileJsonContainerView *containerView;
@end

@implementation XGCMainFormRowMediaTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.containerView = ({
            XGCMainMediaFileJsonContainerView *view = [[XGCMainMediaFileJsonContainerView alloc] init];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(self.contentView);
                make.top.mas_equalTo(self.cTextLabel.mas_bottom);
                make.bottom.mas_equalTo(self.contentView).priorityMedium();
            }];
            view;
        });
    }
    return self;
}

- (void)setATarget:(__kindof UIViewController *)aTarget {
    _aTarget = aTarget;
    self.containerView.aTarget = _aTarget;
}

- (void)setMediaDescriptor:(XGCMainFormRowMediaDescriptor *)mediaDescriptor {
    [super setDescriptor:mediaDescriptor];
    if (![mediaDescriptor isKindOfClass:[XGCMainFormRowMediaDescriptor class]]) {
        return;
    }
    _mediaDescriptor = mediaDescriptor;
    self.containerView.editable = _mediaDescriptor.editable;
    self.containerView.fileJsons = _mediaDescriptor.fileJsons;
    self.containerView.contentInset = UIEdgeInsetsMake(10.0, _mediaDescriptor.contentEdgeInsets.left, _mediaDescriptor.contentEdgeInsets.bottom, _mediaDescriptor.contentEdgeInsets.right);
}

@end

