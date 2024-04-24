//
//  XGCAFNetworkingDelegate.m
//  xinggc
//
//  Created by 凌志 on 2023/11/16.
//

#import "XGCAFNetworkingDelegate.h"

@implementation XGCAFNetworkingDelegate

+ (instancetype)method:(NSString *)method URLString:(NSString *)URLString parameters:(id)parameters headers:(NSDictionary<NSString *,NSString *> *)headers aTarget:(NSObject *)aTarget completionHandler:(void (^)(NSURLSessionDataTask * _Nullable, id _Nullable, NSError * _Nonnull))completionHandler {
    XGCAFNetworkingDelegate *delegate = [XGCAFNetworkingDelegate new];
    delegate.method = method;
    delegate.URLString = URLString;
    delegate.parameters = parameters;
    delegate.headers = headers;
    delegate.aTarget = aTarget;
    delegate.completionHandler = completionHandler;
    return delegate;
}

+ (instancetype)download:(NSString *)URLString destination:(NSURL *)destination aTarget:(NSObject *)aTarget completionHandler:(void (^)(NSURL * _Nullable, NSError * _Nonnull))completionHandler {
    XGCAFNetworkingDelegate *delegate = [XGCAFNetworkingDelegate new];
    delegate.URLString = URLString;
    delegate.destination = destination;
    delegate.aTarget = aTarget;
    delegate.download = completionHandler;
    return delegate;
}

- (XGCAFNetworkingDelegate *)isEqual:(NSString *)URLString aTarget:(NSObject *)aTarget {
    BOOL flag = [URLString isEqualToString:self.URLString];
    if (aTarget && flag) {
        flag = [aTarget isEqual:self.aTarget];
    }
    return flag ? self : nil;
}

- (void)cancelByUser {
    self.isCancelByUser = YES;
    if (self.dataTask.state == NSURLSessionTaskStateRunning) {
        [self.dataTask cancel];
    }
}

- (void)cancelByCellular {
    if (self.dataTask.state == NSURLSessionTaskStateRunning) {
        [self.dataTask cancel];
    }
}

@end
