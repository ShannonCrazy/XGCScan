//
//  XGCMainViewController.m
//  xinggc
//
//  Created by 凌志 on 2023/11/14.
//

#import "XGCMainViewController.h"
// category
#import "XGCConfiguration.h"

@implementation XGCMainViewController

- (struct XGCMainViewConfiguration)configuration {
    struct XGCMainViewConfiguration configuration;
    configuration.prefersNavigationBarShadowColor = XGCCMI.navBarShadowColor;
    configuration.prefersNavigationBarBackgroundColor = XGCCMI.navBarBackgroundColor;
    configuration.prefersNavigationBarHidden = false;
    configuration.interactivePopGestureDisable = false;
    return configuration;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    // 隐藏返回按钮
    self.navigationItem.hidesBackButton = YES;
    // 如果是二级页面
    if (self.hidesBottomBarWhenPushed) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:XGCCMI.navBackButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(goBackAction:)];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [XGCMobClickManager beginLogPageView:NSStringFromClass([self class])];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [XGCMobClickManager endLogPageView:NSStringFromClass([self class])];
}

#pragma mark action
- (void)goBackAction:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
#if DEBUG
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
#endif
}

#pragma mark UIViewControllerRotation
- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle {
    return XGCCMI.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

@end
