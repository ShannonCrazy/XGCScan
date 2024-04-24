//
//  XGCAliyunOSSiOS.h
//  xinggc
//
//  Created by 凌志 on 2023/11/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XGCAliyunOSSiOSProtocol <NSObject>
@required
/// 鉴权地址
- (NSString *)authServerUrl;
/// 桶名
- (NSString *)bucketName;
@end

typedef void (^XGCOSSNetworkingUploadProgressBlock) (int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend);
typedef void (^XGCOSSNetworkingCompletionHandler) (NSString * _Nullable destination, NSError * _Nullable error);

@interface XGCAliyunOSSiOS : NSObject
/// 注册AliyunOSS配置协议
/// - Parameter protocol: 协议
+ (void)registerProtocol:(NSObject <XGCAliyunOSSiOSProtocol> *)protocol;
/// 单例对象
@property (class, nonatomic, strong, readonly) XGCAliyunOSSiOS *shareInstance;

/// 上传文件
/// - Parameters:
///   - uploadingData: 文件二进制
///   - fileName: 文件名称
///   - pathExtension: 文件后缀
///   - uploadProgress: 上传回调
///   - completionHandler: 完成回调
- (void)putObject:(NSData *)uploadingData fileName:(NSString *)fileName pathExtension:(NSString *)pathExtension
   uploadProgress:(nullable XGCOSSNetworkingUploadProgressBlock)uploadProgress completionHandler:(nullable XGCOSSNetworkingCompletionHandler)completionHandler;

@end

NS_ASSUME_NONNULL_END
