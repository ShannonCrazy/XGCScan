//
//  XGCAliyunOSSiOSDelegate.m
//  XGCMain
//
//  Created by 凌志 on 2024/1/9.
//

#import "XGCAliyunOSSiOSDelegate.h"

@implementation XGCAliyunOSSiOSDelegate

+ (instancetype)task:(OSSTask *)task destination:(NSString *)destination completionHandler:(void (^)(NSString * _Nullable, NSError * _Nullable))completionHandler {
    XGCAliyunOSSiOSDelegate *delegate = [[XGCAliyunOSSiOSDelegate alloc] init];
    delegate.task = task;
    delegate.destination = destination;
    delegate.completionHandler = completionHandler;
    return delegate;
}

@end
