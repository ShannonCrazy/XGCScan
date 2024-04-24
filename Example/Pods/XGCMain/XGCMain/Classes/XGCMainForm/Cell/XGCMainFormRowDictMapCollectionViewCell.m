//
//  XGCMainFormRowDictMapCollectionViewCell.m
//  XGCMain
//
//  Created by 凌志 on 2024/1/15.
//

#import "XGCMainFormRowDictMapCollectionViewCell.h"
//
#import "XGCConfiguration.h"
#import "UIImage+XGCImage.h"
#import "XGCUserDictMapModel.h"
//
#import <Masonry/Masonry.h>

@interface XGCMainFormRowDictMapCollectionViewCell ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *cName;
@end

@implementation XGCMainFormRowDictMapCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.imageView = ({
            UIImage *image = [UIImage imageNamed:@"main_xuanze_n" inResource:@"XGCMain"];
            UIImage *highlightedImage = [UIImage imageNamed:@"main_xuanze_s" inResource:@"XGCMain"];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image highlightedImage:highlightedImage];
            [imageView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView).offset(10.0);
                make.centerY.mas_equalTo(self.contentView);
            }];
            imageView;
        });
        self.cName = ({
            UILabel *label = [[UILabel alloc] init];
            label.textColor = XGCCMI.labelColor;
            label.font = [UIFont systemFontOfSize:13];
            [self.contentView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.contentView);
                make.left.mas_equalTo(self.imageView.mas_right).offset(10.0);
            }];
            label;
        });
    }
    return self;
}

- (void)setModel:(XGCUserDictMapModel *)model {
    _model = model;
    self.cName.text = _model.cName;
    self.imageView.highlighted = _model.selected;
}

- (void)setSelected:(BOOL)selected { }

- (void)setHighlighted:(BOOL)highlighted { }
@end
