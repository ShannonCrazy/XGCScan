//
//  XGCMainNavigationControllerDelegate.m
//  xinggc
//
//  Created by 凌志 on 2023/11/15.
//

#import "XGCMainNavigationControllerDelegate.h"
// viewController
#import "XGCMainViewController.h"

@implementation XGCMainNavigationControllerDelegate

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (!animated && navigationController.viewControllers.count == 1) {
        [self renderGlobalAppearances:viewController];
    }
    XGCMainViewController *topViewController = (XGCMainViewController *)viewController;
    BOOL hidden = NO;
    if ([topViewController isKindOfClass:[XGCMainViewController class]]) {
        hidden = topViewController.configuration.prefersNavigationBarHidden;
    }
    [navigationController setNavigationBarHidden:hidden animated:animated];
    if (navigationController.transitionCoordinator == nil) {
        return;
    }
    void (^animation) (id <UIViewControllerTransitionCoordinatorContext> context) = ^(id <UIViewControllerTransitionCoordinatorContext> context){
        void (^animations) (void) = ^(void) { [self renderGlobalAppearances:viewController]; };
        [UIView animateWithDuration:context.transitionDuration animations:animations];
    };
    void (^completion) (id <UIViewControllerTransitionCoordinatorContext> context)= ^(id <UIViewControllerTransitionCoordinatorContext> context){
        if (context.isCancelled) {
            [self renderGlobalAppearances:navigationController.visibleViewController];
        }
    };
    [navigationController.transitionCoordinator animateAlongsideTransition:animation completion:completion];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

#pragma mark func
- (void)renderGlobalAppearances:(UIViewController *)viewController {
    if (![viewController isKindOfClass:[XGCMainViewController class]]) {
        return;
    }
    XGCMainViewController *topViewController = (XGCMainViewController *)viewController;
    UIColor *shadowColor = topViewController.configuration.prefersNavigationBarShadowColor;
    UIColor *backgroundColor = topViewController.configuration.prefersNavigationBarBackgroundColor;
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *apperance = navigationBar.standardAppearance.copy;
        apperance.shadowColor = shadowColor;
        apperance.backgroundColor = backgroundColor;
        self.navigationController.navigationBar.standardAppearance = apperance;
        self.navigationController.navigationBar.scrollEdgeAppearance = apperance;
    } else {
        navigationBar.shadowImage = [self imageWithUIColor:shadowColor rect:CGRectMake(0, 0, navigationBar.frame.size.width, 1)];
        [navigationBar setBackgroundImage:[self imageWithUIColor:backgroundColor rect:CGRectMake(0, 0, navigationBar.frame.size.width, 1)] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    }
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

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    XGCMainViewController *topViewController = (XGCMainViewController *)self.navigationController.topViewController;
    if ([topViewController isKindOfClass:[XGCMainViewController class]]) {
        bool result = topViewController.configuration.interactivePopGestureDisable;
        return !result;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UISlider class]]) {
        return NO;
    }
    return YES;
}

@end
