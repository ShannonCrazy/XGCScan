//
//  XGCAFNetworking.h
//  xinggc
//
//  Created by 凌志 on 2023/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCAFNetworking : NSObject

/// 双向验证时使用的 客户端证书
/// - Parameters:
///   - pkcs12_data: 客户端证书
///   - password: 客户端证书密码
+ (void)pkcs12_data:(NSData *)pkcs12_data password:(NSString *)password;

/// GET请求
/// - Parameters:
///   - URLString: 请求地址
///   - parameters: 请求携带参数
///   - headers: 请求携带头部信息
///   - aTarget: 请求对象持有者
///   - callback: 请求完成回调
+ (nullable NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(nullable id)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers aTarget:(nullable NSObject *)aTarget completionHandler:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

/// POST请求
/// - Parameters:
///   - URLString: 请求地址
///   - parameters: 请求携带参数
///   - headers: 请求携带头部信息
///   - aTarget: 请求对象持有者
///   - callback: 请求完成回调
+ (nullable NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(nullable id)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers aTarget:(nullable NSObject *)aTarget completionHandler:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

/// JSONPOST请求
/// - Parameters:
///   - URLString: 请求地址
///   - parameters: 请求携带参数
///   - headers: 请求携带头部信息
///   - aTarget: 请求对象持有者
///   - callback: 请求完成回调
+ (nullable NSURLSessionDataTask *)JSONPOST:(NSString *)URLString parameters:(nullable id)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers aTarget:(nullable NSObject *)aTarget completionHandler:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

/// PUT请求
/// - Parameters:
///   - URLString: 请求地址
///   - parameters: 请求携带参数
///   - headers: 请求携带头部信息
///   - aTarget: 请求对象持有者
///   - callback: 请求完成回调
+ (nullable NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(nullable id)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers aTarget:(nullable NSObject *)aTarget completionHandler:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

/// PATCH请求
/// - Parameters:
///   - URLString: 请求地址
///   - parameters: 请求携带参数
///   - headers: 请求携带头部信息
///   - aTarget: 请求对象持有者
///   - callback: 请求完成回调
+ (nullable NSURLSessionDataTask *)PATCH:(NSString *)URLString parameters:(nullable id)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers aTarget:(nullable NSObject *)aTarget completionHandler:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

/// DELETE请求
/// - Parameters:
///   - URLString: 请求地址
///   - parameters: 请求携带参数
///   - headers: 请求携带头部信息
///   - aTarget: 请求对象持有者
///   - callback: 请求完成回调
+ (nullable NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(nullable id)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers aTarget:(nullable NSObject *)aTarget completionHandler:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject, NSError * _Nullable error))completionHandler;

/// 下载文件
/// - Parameters:
///   - URLString: 下载地址
///   - destination: 存放路径
///   - progress: 下载进度
///   - aTarget: 下载对象拥有者
///   - callback: 下载完成回调
+ (nullable NSURLSessionDownloadTask *)download:(NSString *)URLString destination:(NSURL *)destination progress:(nullable void (^)(NSProgress *downloadProgress))progress aTarget:(nullable NSObject *)aTarget completionHandler:(nullable void (^)(NSURL * _Nullable filePath, NSError * _Nullable error))completionHandler;

/// 取消请求
/// - Parameters:
///   - URLString: 请求地址
///   - aTarget: 请求对象持有者
+ (void)cancel:(NSString *)URLString aTarget:(nullable NSObject *)aTarget;
@end

NS_ASSUME_NONNULL_END
