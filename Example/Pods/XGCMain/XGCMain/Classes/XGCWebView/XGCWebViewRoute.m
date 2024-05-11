//
//  XGCWebViewRoute.m
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/22.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import "XGCWebViewRoute.h"
//
#import "XGCWebViewController.h"

@implementation XGCWebViewRoute 
- (BOOL)canRouteURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    return [URL.host isEqualToString:@"XGCWebView"];
}

- (__kindof UIViewController *)routeControllerForURL:(NSURL *)URL withParameters:(NSDictionary<NSString *,id> *)parameters {
    if (![self canRouteURL:URL withParameters:parameters]) {
        return nil;
    }
    return [XGCWebViewController XGCWebView:parameters[@"URL"]];
}
@end
