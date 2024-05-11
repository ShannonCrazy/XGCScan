//
//  XGCMainNavigationController.m
//  xinggc
//
//  Created by 凌志 on 2023/11/14.
//

#import "XGCMainNavigationController.h"
// 
#import "XGCConfiguration.h"
// delegate
#import "XGCMainNavigationControllerDelegate.h"

@interface XGCMainNavigationController ()
@property (nonatomic, strong) XGCMainNavigationControllerDelegate *delegator;
@end

@implementation XGCMainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegator = [[XGCMainNavigationControllerDelegate alloc] init];
    self.delegator.navigationController = self;
    self.delegate = self.delegator;
    self.interactivePopGestureRecognizer.delegate = self.delegator;
    // 颜色
    UINavigationBar *navigationBar = self.navigationBar;
    // 标题
    NSMutableDictionary <NSAttributedStringKey, id> *titleTextAttributes = [NSMutableDictionary dictionary];
    [titleTextAttributes setObject:XGCCMI.navBarTitleFont forKey:NSFontAttributeName];
    [titleTextAttributes setObject:XGCCMI.navBarTitleColor forKey:NSForegroundColorAttributeName];
    
    UIColor *backgroundColor = XGCCMI.navBarBackgroundColor ?: UIColor.whiteColor;
    UIColor *shadowColor = XGCCMI.navBarShadowColor ?: UIColor.clearColor;
    
    // 字体
    UIFont *navBarButtonFont = XGCCMI.navBarButtonFont;
    // 字体颜色
    UIColor *navBarButtonColor = XGCCMI.navBarButtonColor;
    UIColor *navBarButtonDisabledColor = XGCCMI.navBarButtonDisabledColor;
    
    NSDictionary <NSAttributedStringKey, id> *attributes = [NSDictionary dictionaryWithObjects:@[navBarButtonFont, navBarButtonColor] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
    NSDictionary <NSAttributedStringKey, id> *attributes1 = [NSDictionary dictionaryWithObjects:@[navBarButtonFont, navBarButtonDisabledColor] forKeys:@[NSFontAttributeName, NSForegroundColorAttributeName]];
    if (@available(iOS 13.0, *)) {
        // buttonAppearance
        UIBarButtonItemAppearance *buttonAppearance = [[UIBarButtonItemAppearance alloc] init];
        buttonAppearance.normal.titleTextAttributes = attributes;
        buttonAppearance.disabled.titleTextAttributes = attributes1;
        //
        UINavigationBarAppearance *standardAppearance = navigationBar.standardAppearance;
        standardAppearance.backgroundEffect = nil;
        if (!standardAppearance) {
            standardAppearance = [[UINavigationBarAppearance alloc] init];
        }
        standardAppearance.backgroundColor = backgroundColor;
        standardAppearance.shadowColor = shadowColor;
        standardAppearance.titleTextAttributes = titleTextAttributes;
        standardAppearance.buttonAppearance = buttonAppearance;
        navigationBar.standardAppearance = standardAppearance;
        
        UINavigationBarAppearance *scrollEdgeAppearance = navigationBar.scrollEdgeAppearance;
        scrollEdgeAppearance.backgroundEffect = nil;
        if (!scrollEdgeAppearance) {
            scrollEdgeAppearance = [[UINavigationBarAppearance alloc] init];
        }
        scrollEdgeAppearance.backgroundColor = backgroundColor;
        scrollEdgeAppearance.shadowColor = shadowColor;
        scrollEdgeAppearance.titleTextAttributes = titleTextAttributes;
        scrollEdgeAppearance.buttonAppearance = buttonAppearance;
        navigationBar.scrollEdgeAppearance = scrollEdgeAppearance;
    } else {
        UIBarButtonItem *appearance = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[self class]]];
        [appearance setTitleTextAttributes:attributes forState:UIControlStateNormal];
        [appearance setTitleTextAttributes:attributes1 forState:UIControlStateDisabled];
        
        navigationBar.titleTextAttributes = titleTextAttributes;
        navigationBar.shadowImage = [self imageWithUIColor:shadowColor rect:CGRectMake(0, 0, CGRectGetWidth(navigationBar.frame), 1.0)];
        [navigationBar setBackgroundImage:[self imageWithUIColor:backgroundColor rect:navigationBar.frame] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
    navigationBar.translucent = YES;
    navigationBar.barTintColor = UIColor.whiteColor;
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

#pragma mark UIViewControllerRotation
- (BOOL)shouldAutorotate {
    UIViewController *viewController = self.presentedViewController;
    if (!viewController || viewController.isBeingDismissed || [viewController isKindOfClass:[UIAlertController class]]) {
        viewController = self.topViewController;
    }
    if ([viewController isKindOfClass:NSClassFromString([NSString stringWithFormat:@"%@%@", @"AV", @"FullScreenViewController"])]) {
        return viewController.shouldAutorotate;
    }
    return viewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIViewController *viewController = self.presentedViewController;
    if (!viewController || viewController.isBeingDismissed || [viewController isKindOfClass:[UIAlertController class]]) {
        viewController = self.topViewController;
    }
    if ([viewController isKindOfClass:NSClassFromString([NSString stringWithFormat:@"%@%@", @"AV", @"FullScreenViewController"])]) {
        return viewController.supportedInterfaceOrientations;
    }
    return viewController.supportedInterfaceOrientations;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    UIViewController *viewController = self.presentedViewController;
    if (!viewController || viewController.isBeingDismissed || [viewController isKindOfClass:[UIAlertController class]]) {
        viewController = self.topViewController;
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
        viewController = self.topViewController;
    }
    if ([viewController isKindOfClass:NSClassFromString([NSString stringWithFormat:@"%@%@", @"AV", @"FullScreenViewController"])]) {
        return viewController.preferredStatusBarStyle;
    }
    return viewController.preferredStatusBarStyle;
}

- (BOOL)prefersStatusBarHidden {
    UIViewController *viewController = self.presentedViewController;
    if (!viewController || viewController.isBeingDismissed || [viewController isKindOfClass:[UIAlertController class]]) {
        viewController = self.topViewController;
    }
    if ([viewController isKindOfClass:NSClassFromString([NSString stringWithFormat:@"%@%@", @"AV", @"FullScreenViewController"])]) {
        return viewController.prefersStatusBarHidden;
    }
    return viewController.prefersStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    UIViewController *viewController = self.presentedViewController;
    if (!viewController || viewController.isBeingDismissed || [viewController isKindOfClass:[UIAlertController class]]) {
        viewController = self.topViewController;
    }
    if ([viewController isKindOfClass:NSClassFromString([NSString stringWithFormat:@"%@%@", @"AV", @"FullScreenViewController"])]) {
        return viewController.preferredStatusBarUpdateAnimation;
    }
    return viewController.preferredStatusBarUpdateAnimation;
}

@end
