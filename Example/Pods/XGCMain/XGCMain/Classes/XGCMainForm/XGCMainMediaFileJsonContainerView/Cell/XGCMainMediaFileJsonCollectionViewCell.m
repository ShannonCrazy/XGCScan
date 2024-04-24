//
//  XGCMainMediaFileJsonCollectionViewCell.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/17.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCMainMediaFileJsonCollectionViewCell.h"
//
#import <Masonry/Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>
//
#import "UIImage+XGCImage.h"
#import "XGCConfiguration.h"
#import "NSString+XGCString.h"
#import "XGCMainMediaFileJsonModel.h"

@interface XGCMainMediaFileJsonCollectionViewCell ()
/// 图片
@property (nonatomic, strong, readwrite) UIImageView *fileUrlImageView;
/// 流水布局
@property (nonatomic, strong) UIStackView *stackView;
/// 图标
@property (nonatomic, strong) UIImageView *iconImageView;
/// 名称
@property (nonatomic, strong) UILabel *fileName;
/// 点击操作View
@property (nonatomic, strong) UIView *containerView;
/// 查看详情
@property (nonatomic, strong) UIButton *detailButon;
/// 替换
@property (nonatomic, strong) UIButton *replaceButton;
/// 删除
@property (nonatomic, strong) UIButton *deleteButton;
@end

@implementation XGCMainMediaFileJsonCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = XGCCMI.whiteColor;
        self.fileUrlImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
            imageView.layer.cornerRadius = 6.0;
            imageView.layer.masksToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView);
            }];
            imageView;
        });
        self.iconImageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView;
        });
        self.fileName = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = XGCCMI.labelColor;
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            label;
        });
        self.stackView = ({
            UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.iconImageView, self.fileName]];
            stackView.spacing = 8.0;
            stackView.axis = UILayoutConstraintAxisVertical;
            stackView.alignment = UIStackViewAlignmentCenter;
            [self.contentView addSubview:stackView];
            [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.contentView).offset(5.0);
                make.right.mas_equalTo(self.contentView).offset(-5.0);
            }];
            stackView;
        });
        self.contentView.layer.borderWidth = 1.0;
        self.contentView.layer.cornerRadius = 6.0;
        self.contentView.layer.borderColor = XGCCMI.backgroundColor.CGColor;
        
        self.containerView = ({
            UIView *view = [[UIView alloc] init];
            view.hidden = YES;
            view.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.2];
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.contentView);
            }];
            view;
        });
        self.detailButon = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.imageView.contentMode = UIViewContentModeScaleAspectFit;
            [button addTarget:self action:@selector(detailButonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"main_amplify" inResource:@"XGCMain"] forState:UIControlStateNormal];
            [self.containerView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.mas_equalTo(self.containerView);
                make.bottom.mas_equalTo(self.containerView.mas_centerY);
            }];
            button;
        });
        self.replaceButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(replaceButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"main_replace" inResource:@"XGCMain"] forState:UIControlStateNormal];
            [self.containerView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.bottom.mas_equalTo(self.containerView);
                make.top.mas_equalTo(self.containerView.mas_centerY);
                make.right.mas_equalTo(self.containerView.mas_centerX);
            }];
            button;
        });
        self.deleteButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button addTarget:self action:@selector(deleteButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [button setImage:[UIImage imageNamed:@"main_delete" inResource:@"XGCMain"] forState:UIControlStateNormal];
            [self.containerView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.mas_equalTo(self.containerView);
                make.top.mas_equalTo(self.containerView.mas_centerY);
                make.left.mas_equalTo(self.containerView.mas_centerX);
            }];
            button;
        });
    }
    return self;
}

- (void)setFileJson:(XGCMainMediaFileJsonModel *)fileJson {
    _fileJson = fileJson;
    BOOL flag = [_fileJson.suffix isImageFormat] || _fileJson.image;
    self.fileUrlImageView.hidden = !(self.stackView.hidden = flag);
    if (_fileJson.image) {
        self.fileUrlImageView.image = _fileJson.image;
    } else if ([_fileJson.suffix isImageFormat]) {
        [self.fileUrlImageView sd_setImageWithURL:[NSURL URLWithString:_fileJson.fileUrl]];
    } else if ([_fileJson.suffix isWordFormat]) {
        self.iconImageView.image = [UIImage imageNamed:@"main_word" inResource:@"XGCMain"];
    } else if ([_fileJson.suffix isExcelFormat]) {
        self.iconImageView.image = [UIImage imageNamed:@"main_excel" inResource:@"XGCMain"];
    } else if ([_fileJson.suffix isPdfFormat]) {
        self.iconImageView.image = [UIImage imageNamed:@"main_pdf" inResource:@"XGCMain"];
    } else if ([_fileJson.suffix isArchiveFormat]) {
        if ([_fileJson.suffix isEqualToString:@"rar"]) {
            self.iconImageView.image = [UIImage imageNamed:@"main_rar" inResource:@"XGCMain"];
        } else if ([_fileJson.suffix isEqualToString:@"zip"]) {
            self.iconImageView.image = [UIImage imageNamed:@"main_zip" inResource:@"XGCMain"];
        }
    }
    self.fileName.text = _fileJson.fileName;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.contentView.layer.borderColor = selected ? XGCCMI.blueColor.CGColor : XGCCMI.backgroundColor.CGColor;
    if (!self.isEditable) {
        return;
    }
    self.containerView.hidden = !selected;
}

#pragma mark action
- (void)detailButonTouchUpInside {
    self.detailButonTouchUpInsideAction ? self.detailButonTouchUpInsideAction(self, self.fileJson) : nil;
}

- (void)replaceButtonTouchUpInside {
    self.replaceButtonTouchUpInsideAction ? self.replaceButtonTouchUpInsideAction(self, self.fileJson) : nil;
}

- (void)deleteButtonTouchUpInside {
    self.deleteButtonTouchUpInsideAction ? self.deleteButtonTouchUpInsideAction(self, self.fileJson) : nil;
}

@end
