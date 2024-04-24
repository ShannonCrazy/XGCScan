//
//  XGCAFNetworkingDelegate.h
//  xinggc
//
//  Created by 凌志 on 2023/11/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCAFNetworkingDelegate : NSObject

/// 请求方式
@property (nonatomic, copy) NSString *method;
/// 请求地址
@property (nonatomic, copy) NSString *URLString;
/// 请求参数
@property (nonatomic, strong, nullable) id parameters;
/// 请求头
@property (nonatomic, strong, nullable) NSDictionary <NSString *, NSString *> *headers;
/// 请求拥有者
@property (nonatomic, weak, nullable) NSObject *aTarget;

/// 成功
@property (nonatomic, copy, nullable) void (^success) (NSURLSessionDataTask *task, id responseObject);
/// 失败
@property (nonatomic, copy, nullable) void (^failure) (NSURLSessionDataTask *task, NSError *error);

/// 回调
@property (nonatomic, copy, nullable) void(^completionHandler)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError * _Nullable error);

/// 下载地址
@property (nonatomic, strong) NSURL *destination;
/// 下载回调
@property (nonatomic, copy, nullable) void(^download)(NSURL  * _Nullable filePath, NSError * _Nullable error);

/// 是否是用户主动取消的请求
@property (nonatomic, assign) BOOL isCancelByUser;
/// 失败次数， 默认从1开始
@property (nonatomic, assign) NSInteger previousFailureCount;

/// 第一次发起请求的时候生成的请求对象
@property (nonatomic, strong) __kindof NSURLSessionTask *firstDataTask;
/// 请求任务对象
@property (nonatomic, strong) __kindof NSURLSessionTask *dataTask;

+ (instancetype)method:(NSString *)method URLString:(NSString *)URLString parameters:(nullable id)parameters headers:(NSDictionary <NSString *, NSString *> *)headers aTarget:(nullable NSObject *)aTarget completionHandler:(nullable void (^)(NSURLSessionDataTask * _Nullable task, id _Nullable responseObject, NSError *error))completionHandler;

+ (instancetype)download:(NSString *)URLString destination:(NSURL *)destination aTarget:(nullable NSObject *)aTarget completionHandler:(nullable void (^)(NSURL * _Nullable filePath, NSError *error))completionHandler;

- (nullable XGCAFNetworkingDelegate *)isEqual:(NSString *)URLString aTarget:(nullable NSObject *)aTarget;
// 用户主动取消
- (void)cancelByUser;
// 网络切换导致请求取消
- (void)cancelByCellular;
@end

NS_ASSUME_NONNULL_END
