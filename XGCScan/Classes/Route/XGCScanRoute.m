//
//  XGCScanRoute.m
//  xinggc
//
//  Created by 凌志 on 2023/12/5.
//

#import "XGCScanRoute.h"
// viewController
#import "XGCScanViewController.h"

@implementation XGCScanRoute

- (BOOL)canRouteURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    return [URL.host isEqualToString:@"XGCScan"];
}

- (__kindof UIViewController *)routeControllerForURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    if (![self canRouteURL:URL withParameters:parameters]) {
        return nil;
    }
    if ([URL.host isEqualToString:@"XGCScan"]) {
        return [XGCScanViewController new];
    }
    return nil;
}

@end
