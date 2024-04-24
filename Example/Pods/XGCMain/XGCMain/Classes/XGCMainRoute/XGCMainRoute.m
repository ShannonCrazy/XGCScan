//
//  XGCMainRoute.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/17.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCMainRoute.h"

@interface XGCMainRoute ()
@property (nonatomic, strong) UIWindowScene *windowScene API_AVAILABLE(ios(13.0));
@property (nonatomic, strong) NSMutableDictionary <NSString *, id <XGCMainRouteProtocol>> *maps;
@end

@implementation XGCMainRoute

+ (instancetype)shareInstance {
    static XGCMainRoute *route = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        route = [[XGCMainRoute alloc] init];
    });
    return route;
}

- (instancetype)init {
    if (self = [super init]) {
        self.maps = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark func
+ (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions {
    [XGCMainRoute shareInstance].windowScene = (UIWindowScene *)scene;
}

+ (void)registerRoute:(id<XGCMainRouteProtocol>)route {
    if (!route || ![route conformsToProtocol:@protocol(XGCMainRouteProtocol)]) {
        return;
    }
    [[XGCMainRoute shareInstance].maps setObject:route forKey:NSStringFromClass([route class])];
}

+ (BOOL)canRouteURL:(NSURL *)URL {
    return [self canRouteURL:URL withParameters:nil];
}

+ (BOOL)canRouteURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    for (id <XGCMainRouteProtocol> route in [[XGCMainRoute shareInstance].maps.allValues copy]) {
        if (![route respondsToSelector:@selector(canRouteURL:withParameters:)]) {
            continue;
        }
        if ([route canRouteURL:URL withParameters:parameters]) {
            return YES;
        }
    }
    return NO;
}

+ (void)routeURL:(NSURL *)URL {
    [self routeURL:URL withParameters:nil];
}

+ (void)routeURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    return [[XGCMainRoute shareInstance] routeURL:URL withParameters:parameters];
}

+ (__kindof UIViewController *)routeControllerForURL:(NSURL *)URL {
    return [self routeControllerForURL:URL withParameters:nil];
}

+ (__kindof UIViewController *)routeControllerForURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    return [[XGCMainRoute shareInstance] routeControllerForURL:URL withParameters:parameters];
}

#pragma mark private
- (void)routeURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    __kindof UIViewController *viewController = [self routeControllerForURL:URL withParameters:parameters];
    if (!viewController) {
        return;
    }
    UIWindow *keyWindow = nil;
    if (@available(iOS 15.0, *)) {
        keyWindow = self.windowScene.keyWindow;
    } else if (@available(iOS 13.0, *)) {
        for (UIWindow *window in self.windowScene.windows) {
            if (window.isKeyWindow) {
                keyWindow = window;
                break;
            }
        }
    } else {
        keyWindow = UIApplication.sharedApplication.keyWindow;
    }
    if (!keyWindow) {
        return;
    }
    __kindof UIViewController *rootViewController = keyWindow.rootViewController;
    while ([rootViewController isKindOfClass:[UITabBarController class]] || [rootViewController isKindOfClass:[UINavigationController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        if ([tabBarController isKindOfClass:[UITabBarController class]]) {
            rootViewController = tabBarController.selectedViewController;
        }
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        if ([navigationController isKindOfClass:[UINavigationController class]]) {
            rootViewController = navigationController.topViewController;
        }
    }
    if (!rootViewController.navigationController) {
        return;
    }
    [rootViewController.navigationController pushViewController:viewController animated:YES];
}

- (__kindof UIViewController *)routeControllerForURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    __kindof UIViewController *viewController = nil;
    for (id <XGCMainRouteProtocol> route in [self.maps.allValues copy]) {
        if (![route respondsToSelector:@selector(routeControllerForURL:withParameters:)]) {
            continue;
        }
        viewController = [route routeControllerForURL:URL withParameters:parameters];
        if (viewController) {
            break;
        }
    }
    return viewController;
}

@end
