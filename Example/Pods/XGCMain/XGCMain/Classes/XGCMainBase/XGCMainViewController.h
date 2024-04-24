//
//  XGCMainViewController.h
//  xinggc
//
//  Created by 凌志 on 2023/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

struct XGCMainViewConfiguration {
    /// 是否可以左滑返回，默认NO
    bool interactivePopGestureDisable;
    /// 是否需要隐藏导航栏, 默认NO
    bool prefersNavigationBarHidden;
    /// 导航栏背景颜色，默认white
    UIColor *prefersNavigationBarBackgroundColor;
    /// 导航栏阴影颜色，默认black
    UIColor *prefersNavigationBarShadowColor;
};

@interface XGCMainViewController : UIViewController
/// 返回事件
/// - Parameter sender: 返回按钮
- (void)goBackAction:(UIBarButtonItem *)sender;

@property (nonatomic, assign) struct XGCMainViewConfiguration configuration;
@end

NS_ASSUME_NONNULL_END
