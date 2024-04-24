//
//  XGCURLSessionDelegate.h
//  xinggc
//
//  Created by 凌志 on 2023/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCURLSessionDelegate : NSObject
/// 请求地址
@property (nonatomic, copy) NSString *URLString;
/// 请求参数
@property (nonatomic, strong, nullable) id parameters;
/// 请求拥有者
@property (nonatomic, weak, nullable) NSObject *aTarget;
/// 回调
@property (nonatomic, copy) void (^callback)(id _Nullable responseObject, NSError * _Nullable error);
/// 任务
@property (nonatomic, strong) __kindof NSURLSessionTask *task;
/// 创建代理
+ (instancetype)delegate:(__kindof NSURLSessionTask *)task URLString:(NSString *)URLString parameters:(nullable id)parameters aTarget:(nullable NSObject *)aTarget callback:(void(^)(id _Nullable responseObject, NSError * _Nullable error))callback;
@end

NS_ASSUME_NONNULL_END
