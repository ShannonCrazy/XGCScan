//
//  XGCURLSession.h
//  xinggc
//
//  Created by 凌志 on 2023/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCURLSession : NSObject

/// POST请求
/// - Parameters:
///   - URLString: 请求地址
///   - parameters: 请求携带参数
///   - headers: 请求携带头部信息
///   - aTarget: 请求对象持有者
///   - callback: 请求完成回调
+ (void)POST:(NSString *)URLString parameters:(nullable id)parameters aTarget:(nullable NSObject *)aTarget callback:(nullable void (^)(id _Nullable responseObject, NSError * _Nullable error))callback;

/// JSONPOST请求
/// - Parameters:
///   - URLString: 请求地址
///   - parameters: 请求携带参数
///   - headers: 请求携带头部信息
///   - aTarget: 请求对象持有者
///   - callback: 请求完成回调
+ (void)JSONPOST:(NSString *)URLString parameters:(nullable id)parameters aTarget:(nullable NSObject *)aTarget callback:(nullable void (^)(id _Nullable responseObject, NSError * _Nullable error))callback;

/// 取消请求
/// - Parameters:
///   - URLString: 请求地址
///   - aTarget: 请求对象持有者
+ (void)cancel:(NSString *)URLString aTarget:(nullable NSObject *)aTarget;
@end

NS_ASSUME_NONNULL_END
