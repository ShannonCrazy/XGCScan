//
//  XGCAlertTableViewCell.m
//  iPadDemo
//
//  Created by 凌志 on 2023/12/26.
//

#import "XGCAlertTableViewCell.h"
// XGCMain
#import "XGCConfiguration.h"
#import "UIImage+XGCImage.h"
#import "XGCUserDictMapModel.h"

@interface XGCAlertTableViewCell ()
/// 左侧约束
@property (nonatomic, strong) NSLayoutConstraint *leading;
/// 图片
@property (nonatomic, strong) UIImageView *cImageView;
/// 文本
@property (nonatomic, strong) UILabel *cTextLabel;
@end

@implementation XGCAlertTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.cImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_xuanze_n" inResource:@"XGCMain"] highlightedImage:[UIImage imageNamed:@"main_xuanze_s" inResource:@"XGCMain"]];
            imageView.translatesAutoresizingMaskIntoConstraints = NO;
            [imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.contentView addSubview:imageView];
            NSLayoutConstraint *centerY = [imageView.centerYAnchor constraintEqualToAnchor:self.contentView.centerYAnchor];
            NSLayoutConstraint *trailing = [imageView.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-20.0];
            NSLayoutConstraint *width = [imageView.widthAnchor constraintEqualToConstant:imageView.image.size.width];
            NSLayoutConstraint *height = [imageView.heightAnchor constraintEqualToConstant:imageView.image.size.height];
            [NSLayoutConstraint activateConstraints:@[centerY, trailing, width, height]];
            imageView;
        });
        self.cTextLabel = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.textColor = XGCCMI.labelColor;
            label.highlightedTextColor = XGCCMI.blueColor;
            label.font = [UIFont systemFontOfSize:13];
            label.translatesAutoresizingMaskIntoConstraints = NO;
            [self.contentView addSubview:label];
            NSLayoutConstraint *top = [label.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:14.0];
            self.leading = [label.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor constant:20.0];
            NSLayoutConstraint *bottom = [label.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor constant:-14.0];
            bottom.priority = 500;
            NSLayoutConstraint *trailing = [label.trailingAnchor constraintEqualToAnchor:self.cImageView.leadingAnchor constant:-10.0];
            NSLayoutConstraint *height = [label.heightAnchor constraintGreaterThanOrEqualToConstant:label.font.lineHeight];
            [NSLayoutConstraint activateConstraints:@[top, self.leading, bottom, trailing, height]];
            label;
        });
    }
    return self;
}

- (void)setModel:(XGCUserDictMapModel *)model {
    _model = model;
    self.cTextLabel.text = _model.cName;
    self.cTextLabel.highlighted = _model.selected;
    self.cTextLabel.textColor = _model.enabled ? XGCCMI.labelColor : XGCCMI.secondaryLabelColor;
    self.cImageView.highlighted = _model.selected;
    self.cImageView.hidden = !_model.enabled;
    self.contentView.backgroundColor = [XGCCMI.blackColor colorWithAlphaComponent:(_model.level * 0.05)];
    self.leading.constant = 20.0 + _model.level * 8.0;
}

@end
