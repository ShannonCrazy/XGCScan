//
//  XGCMainRoute.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/17.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XGCMainRouteProtocol <NSObject>
@optional
/// 是否可以导航到传入的URL，可以传入参数
/// - Parameter URL: URL链接
- (BOOL)canRouteURL:(nullable NSURL *)URL withParameters:(nullable NSDictionary <NSString *, id> *)parameters;

/// 获取URL导航的实例，可以传入参数
/// - Parameter URL: 需要导航的URL
- (__kindof UIViewController *)routeControllerForURL:(NSURL *)URL withParameters:(nullable NSDictionary <NSString *, id> *)parameters;
@end

@interface XGCMainRoute : NSObject

+ (void)scene:(UIScene *)scene willConnectToSession:(UISceneSession *)session options:(UISceneConnectionOptions *)connectionOptions API_AVAILABLE(ios(13.0));

/// 注册路由
/// - Parameter connector: 子路由
+ (void)registerRoute:(id <XGCMainRouteProtocol>)route;

/// 是否可以导航到传入的URL，可以传入参数
/// - Parameter URL: URL链接
+ (BOOL)canRouteURL:(nullable NSURL *)URL;
+ (BOOL)canRouteURL:(nullable NSURL *)URL withParameters:(nullable NSDictionary <NSString *, id> *)parameters;

/// 直接导航到传入的URL，可以传入参数
/// - Parameter URL: 需要导航的URL
+ (void)routeURL:(nullable NSURL *)URL;
+ (void)routeURL:(nullable NSURL *)URL withParameters:(nullable NSDictionary <NSString *, id> *)parameters;
+ (void)routeURL:(nullable NSURL *)URL withParameters:(nullable NSDictionary <NSString *, id> *)parameters method:(NSString *)method animated:(BOOL)animated;

/// 获取URL导航的实例，可以传入参数
/// - Parameter URL: 需要导航的URL
+ (__kindof UIViewController *)routeControllerForURL:(NSURL *)URL;
+ (__kindof UIViewController *)routeControllerForURL:(NSURL *)URL withParameters:(nullable NSDictionary <NSString *, id> *)parameters;
@end

NS_ASSUME_NONNULL_END
