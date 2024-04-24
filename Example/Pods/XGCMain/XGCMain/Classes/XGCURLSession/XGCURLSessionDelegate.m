//
//  XGCURLSessionDelegate.m
//  xinggc
//
//  Created by 凌志 on 2023/11/23.
//

#import "XGCURLSessionDelegate.h"

@implementation XGCURLSessionDelegate

+ (instancetype)delegate:(__kindof NSURLSessionTask *)task URLString:(NSString *)URLString parameters:(id)parameters aTarget:(NSObject *)aTarget callback:(void (^)(id _Nullable, NSError * _Nullable))callback {
    XGCURLSessionDelegate *delegate = [XGCURLSessionDelegate new];
    delegate.task = task;
    delegate.URLString = URLString;
    delegate.parameters = parameters;
    delegate.aTarget = aTarget;
    delegate.callback = callback;
    return delegate;
}

@end
