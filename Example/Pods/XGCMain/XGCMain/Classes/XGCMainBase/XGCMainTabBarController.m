//
//  XGCMainTabBarController.m
//  xinggc
//
//  Created by 凌志 on 2023/11/14.
//

#import "XGCMainTabBarController.h"
//
#import "XGCConfiguration.h"

@interface XGCMainTabBarController ()<UITabBarDelegate>

@end

@implementation XGCMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 背景色
    self.tabBar.backgroundColor = UIColor.whiteColor;
    self.tabBar.translucent = YES;
    // 字体
    UITabBar *tabBar = self.tabBar;
    // 颜色
    UIColor *backgroundColor = XGCCMI.tabBarBackgroundColor ?: UIColor.whiteColor;
    UIColor *shadowColor = XGCCMI.tabBarShadowColor ?: UIColor.clearColor;
    // 字体
    UIFont *tabBarItemTitleFont = XGCCMI.tabBarItemTitleFont;
    UIFont *tabBarItemTitleFontSelected = XGCCMI.tabBarItemTitleFontSelected;
    // 字体颜色
    UIColor *tabBarItemTitleColor = XGCCMI.tabBarItemTitleColor;
    UIColor *tabBarItemTitleColorSelected = XGCCMI.tabBarItemTitleColorSelected;
    
    NSDictionary <NSAttributedStringKey, id> *attributes = [NSDictionary dictionaryWithObjects:@[tabBarItemTitleFont, tabBarItemTitleColor] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
    NSDictionary <NSAttributedStringKey, id> *attributes1 = [NSDictionary dictionaryWithObjects:@[tabBarItemTitleFontSelected, tabBarItemTitleColorSelected] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
    if (@available(iOS 13.0, *)) {
        UITabBarAppearance *appearance = [[UITabBarAppearance alloc] init];
        [appearance configureWithDefaultBackground];
        appearance.backgroundColor = backgroundColor;
        appearance.shadowColor = shadowColor;
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = attributes;
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = attributes1;
        tabBar.standardAppearance = appearance;
        if (@available(iOS 15.0, *)) {
            tabBar.scrollEdgeAppearance = appearance;
        }
    } else {
        tabBar.backgroundImage = [self imageWithUIColor:backgroundColor rect:CGRectMake(0, 0, CGRectGetWidth(tabBar.frame), 1.0)];
        tabBar.shadowImage = [self imageWithUIColor:shadowColor rect:CGRectMake(0, 0, CGRectGetWidth(tabBar.frame), 1.0)];
        
        UITabBarItem *appearance = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:[NSArray arrayWithObject:[self class]]];
        [appearance setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [appearance setTitleTextAttributes:attributes1 forState:UIControlStateSelected];
    }
    tabBar.translucent = YES;
}

- (nullable UIImage *)imageWithUIColor:(UIColor *)color rect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef c = UIGraphicsGetCurrentContext();
    if (!c) {
        return nil;
    }
    CGContextSetFillColorWithColor(c, color.CGColor);
    CGContextFillRect(c, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
}

#pragma mark UIViewControllerRotation
- (BOOL)shouldAutorotate {
    UIViewController *viewController = self.presentedViewController;
    if (!viewController || viewController.isBeingDismissed || [viewController isKindOfClass:[UIAlertController class]]) {
        viewController = self.selectedViewController;
    }
    if ([viewController isKindOfClass:NSClassFromString([NSString stringWithFormat:@"%@%@", @"AV", @"FullScreenViewController"])]) {
        return viewController.shouldAutorotate;
    }
    return viewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *viewController = self.presentedViewController;
    if (!viewController || viewController.isBeingDismissed || [viewController isKindOfClass:[UIAlertController class]]) {
        viewController = self.selectedViewController;
    }
    if ([viewController isKindOfClass:NSClassFromString([NSString stringWithFormat:@"%@%@", @"AV", @"FullScreenViewController"])]) {
        return viewController.supportedInterfaceOrientations;
    }
    return viewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIViewController *viewController = self.presentedViewController;
    if (!viewController || viewController.isBeingDismissed || [viewController isKindOfClass:[UIAlertController class]]) {
        viewController = self.selectedViewController;
    }
    if ([viewController isKindOfClass:NSClassFromString([NSString stringWithFormat:@"%@%@", @"AV", @"FullScreenViewController"])]) {
        return viewController.preferredInterfaceOrientationForPresentation;
    }
    return viewController.preferredInterfaceOrientationForPresentation;
}

#pragma mark UIStatusBar
- (UIStatusBarStyle)preferredStatusBarStyle {
    UIViewController *viewController = self.presentedViewController;
    if (!viewController || viewController.isBeingDismissed || [viewController isKindOfClass:[UIAlertController class]]) {
        viewController = self.selectedViewController;
    }
    if ([viewController isKindOfClass:NSClassFromString([NSString stringWithFormat:@"%@%@", @"AV", @"FullScreenViewController"])]) {
        return viewController.preferredStatusBarStyle;
    }
    return viewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    UIViewController *viewController = self.presentedViewController;
    if (!viewController || viewController.isBeingDismissed || [viewController isKindOfClass:[UIAlertController class]]) {
        viewController = self.selectedViewController;
    }
    if ([viewController isKindOfClass:NSClassFromString([NSString stringWithFormat:@"%@%@", @"AV", @"FullScreenViewController"])]) {
        return viewController.prefersStatusBarHidden;
    }
    return viewController.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    UIViewController *viewController = self.presentedViewController;
    if (!viewController || viewController.isBeingDismissed || [viewController isKindOfClass:[UIAlertController class]]) {
        viewController = self.selectedViewController;
    }
    if ([viewController isKindOfClass:NSClassFromString([NSString stringWithFormat:@"%@%@", @"AV", @"FullScreenViewController"])]) {
        return viewController.preferredStatusBarUpdateAnimation;
    }
    return viewController.preferredStatusBarUpdateAnimation;
}

@end
