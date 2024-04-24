//
//  XGCMainFormSectionTableHeaderView.m
//  iPadDemo
//
//  Created by 凌志 on 2023/12/21.
//

#import "XGCMainFormSectionTableHeaderView.h"
// XGCMain
#import "XGCConfiguration.h"
#import "XGCMainFormSectionDescriptor.h"
//
#import <Masonry/Masonry.h>

@interface XGCMainFormSectionTableHeaderView ()
@property (nonatomic, strong) UILabel *cTextLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) MASConstraint *trailing;
@end

@implementation XGCMainFormSectionTableHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = XGCCMI.backgroundColor;
        self.addButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.contentEdgeInsets = UIEdgeInsetsMake(10.0, 20.0, 10.0, 20.0);
            [button setTitleColor:XGCCMI.blueColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [button setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.centerY.mas_equalTo(self.contentView);
            }];
            button;
        });
        self.cTextLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.textColor = XGCCMI.secondaryLabelColor;
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(self.contentView);
                make.bottom.mas_equalTo(self.contentView).priorityMedium();
                self.trailing = make.right.mas_equalTo(self.addButton.mas_left);
            }];
            label;
        });
    }
    return self;
}

- (void)setHeaderInSection:(XGCMainFormSectionDefaultConfigDescriptor *)headerInSection {
    _headerInSection = headerInSection;
    self.cTextLabel.text = _headerInSection.cDescription;
    // 按钮
    [self.addButton setTitle:_headerInSection.title ?: @"新增" forState:UIControlStateNormal];
    BOOL flag = _headerInSection.addButtonTouchUpInsideAction ? YES : NO;
    self.addButton.hidden = !flag;
    // 布局
    [self.trailing uninstall];
    [self.cTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(headerInSection.contentEdgeInsets.top);
        make.left.mas_equalTo(self.contentView).offset(headerInSection.contentEdgeInsets.left);
        if (flag) {
            self.trailing = make.right.mas_equalTo(self.addButton.mas_left);
        } else {
            self.trailing = make.right.mas_equalTo(self.contentView).offset(-headerInSection.contentEdgeInsets.right);
        }
        make.bottom.mas_equalTo(self.contentView).offset(-headerInSection.contentEdgeInsets.bottom).priorityMedium();
    }];
    // 背景色
    self.contentView.backgroundColor = _headerInSection.backgroundColor ?: XGCCMI.backgroundColor;
}

#pragma mark action
- (void)addButtonTouchUpInside {
    self.headerInSection.addButtonTouchUpInsideAction ? self.headerInSection.addButtonTouchUpInsideAction(self.headerInSection) : nil;
}

@end

@interface XGCMainFormSectionTableFooterView ()
@property (nonatomic, strong) UILabel *cTextLabel;
@property (nonatomic, strong) NSLayoutConstraint *top;
@property (nonatomic, strong) NSLayoutConstraint *leading;
@property (nonatomic, strong) NSLayoutConstraint *bottom;
@property (nonatomic, strong) NSLayoutConstraint *trailing;
@end

@implementation XGCMainFormSectionTableFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        // 左侧文本
        self.cTextLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.textColor = XGCCMI.secondaryLabelColor;
            [label setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [label setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(UIEdgeInsetsZero);
            }];
            label;
        });
    }
    return self;
}

- (void)setFooterInSection:(XGCMainFormSectionDefaultConfigDescriptor *)footerInSection {
    _footerInSection = footerInSection;
    self.cTextLabel.text = _footerInSection.cDescription;
    [self.cTextLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_footerInSection.contentEdgeInsets);
    }];
}

@end
