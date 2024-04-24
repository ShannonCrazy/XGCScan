//
//  XGCScanInfosViewController.m
//  xinggc
//
//  Created by 凌志 on 2023/11/29.
//

#import "XGCScanInfosViewController.h"
// XGCMain
#import "NSDate+XGCDate.h"
// thirdparty
#import <Masonry/Masonry.h>

@interface XGCScanInfosViewController ()
/// 文字信息
@property (nonatomic, copy) NSString *stringValue;
@end

@implementation XGCScanInfosViewController

+ (instancetype)XGCScanInfos:(NSString *)stringValue {
    XGCScanInfosViewController *viewController = [[XGCScanInfosViewController alloc] init];
    viewController.stringValue = stringValue;
    return viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray <NSString *> *temps = [self.stringValue componentsSeparatedByString:@","];
    if ([temps.firstObject isEqualToString:@"01"]) {
        UIView *containerView = ({
            UIView *view = [[UIView alloc] init];
            [self.view addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.center.mas_equalTo(self.view);
                make.left.mas_equalTo(self.view).offset(40.0);
                make.right.mas_equalTo(self.view).offset(-40.0);
            }];
            view;
        });
        UILabel *title = ({
            UILabel *label = [[UILabel alloc] init];
            label.text = @"发票信息";
            label.font = [UIFont systemFontOfSize:19];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorNamed:@"222222"];
            [containerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.mas_equalTo(containerView);
            }];
            label;
        });
        UILabel *message = ({
            UILabel *label = [[UILabel alloc] init];
            label.numberOfLines = 0;
            label.font = [UIFont systemFontOfSize:17];
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [UIColor colorNamed:@"222222"];
            label.text = @"以下信息仅为发票二维码所含信息，并不代表查验发票真伪的结果";
            [containerView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(containerView);
                make.top.mas_equalTo(title.mas_bottom).offset(10.0);
            }];
            label;
        });
        UIView *separator = ({
            UIView *view = [[UIView alloc] init];
            [containerView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.mas_equalTo(containerView);
                make.top.mas_equalTo(message.mas_bottom);
                make.height.mas_equalTo(18.0);
            }];
            view;
        });
        MASViewAttribute *attribute = separator.mas_bottom;
        if (temps.count > 2) {
            UILabel *desc = ({
                UILabel *label = [[UILabel alloc] init];
                label.text = @"发票代码";
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor colorNamed:@"222222"];
                [containerView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(containerView);
                    make.top.mas_equalTo(attribute).offset(16.0);
                }];
                label;
            });
            UILabel *fpdm = ({
                UILabel *label = [[UILabel alloc] init];
                label.text = temps[2];
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor colorNamed:@"222222"];
                [containerView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(desc);
                    make.left.mas_equalTo(containerView).offset(100.0);
                }];
                label;
            });
            attribute = fpdm.mas_bottom;
        }
        if (temps.count > 3) {
            UILabel *desc = ({
                UILabel *label = [[UILabel alloc] init];
                label.text = @"发票号码";
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor colorNamed:@"222222"];
                [containerView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(containerView);
                    make.top.mas_equalTo(attribute).offset(16.0);
                }];
                label;
            });
            UILabel *fphm = ({
                UILabel *label = [[UILabel alloc] init];
                label.text = temps[3];
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor colorNamed:@"222222"];
                [containerView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(desc);
                    make.left.mas_equalTo(containerView).offset(100.0);
                }];
                label;
            });
            attribute = fphm.mas_bottom;
        }
        if (temps.count > 4) {
            UILabel *desc = ({
                UILabel *label = [[UILabel alloc] init];
                label.text = @"合计金额";
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor colorNamed:@"222222"];
                [containerView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(containerView);
                    make.top.mas_equalTo(attribute).offset(16.0);
                }];
                label;
            });
            UILabel *hjje = ({
                UILabel *label = [[UILabel alloc] init];
                label.text = temps[4];
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor colorNamed:@"222222"];
                [containerView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(desc);
                    make.left.mas_equalTo(containerView).offset(100.0);
                }];
                label;
            });
            attribute = hjje.mas_bottom;
        }
        if (temps.count > 5) {
            UILabel *desc = ({
                UILabel *label = [[UILabel alloc] init];
                label.text = @"开票日期";
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor colorNamed:@"222222"];
                [containerView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(containerView);
                    make.top.mas_equalTo(attribute).offset(16.0);
                }];
                label;
            });
            UILabel *kprq = ({
                UILabel *label = [[UILabel alloc] init];
                label.text = [[NSDate dateFromString:temps[5] dateFormat:@"yyyyMMdd"] stringFromDateFormat:@"yyyy-MM-dd"];
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor colorNamed:@"222222"];
                [containerView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(desc);
                    make.left.mas_equalTo(containerView).offset(100.0);
                }];
                label;
            });
            attribute = kprq.mas_bottom;
        }
        if (temps.count > 6) {
            UILabel *desc = ({
                UILabel *label = [[UILabel alloc] init];
                label.text = @"发票校验码";
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor colorNamed:@"222222"];
                [containerView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(containerView);
                    make.top.mas_equalTo(attribute).offset(16.0);
                }];
                label;
            });
            UILabel *fpjym = ({
                UILabel *label = [[UILabel alloc] init];
                label.text = temps[6];
                label.font = [UIFont systemFontOfSize:13];
                label.textColor = [UIColor colorNamed:@"222222"];
                [containerView addSubview:label];
                [label mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(desc);
                    make.left.mas_equalTo(containerView).offset(100.0);
                }];
                label;
            });
            attribute = fpjym.mas_bottom;
        }
        [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(attribute);
        }];
    } else {
        UIScrollView *containerScrollView = ({
            UIScrollView *scrollView = [[UIScrollView alloc] init];
            [self.view addSubview:scrollView];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(self.view);
            }];
            scrollView;
        });
        UITextView *textView = ({
            UITextView *textView = [[UITextView alloc] init];
            textView.editable = NO;
            textView.scrollEnabled = NO;
            textView.text = self.stringValue;
            textView.layer.cornerRadius = 4.0;
            textView.font = [UIFont systemFontOfSize:13];
            textView.textAlignment = NSTextAlignmentCenter;
            textView.textContainer.lineFragmentPadding = 0;
            textView.textColor = [UIColor colorNamed:@"222222"];
            textView.backgroundColor = [UIColor colorNamed:@"F2F1F6"];
            textView.textContainerInset = UIEdgeInsetsMake(5.0, 5.0, 5.0, 5.0);
            [textView setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
            [containerScrollView addSubview:textView];
            [textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(containerScrollView).offset(20.0);
                make.width.mas_equalTo(containerScrollView).offset(-40.0);
            }];
            textView;
        });
        [containerScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(textView);
        }];
    }
}

@end
