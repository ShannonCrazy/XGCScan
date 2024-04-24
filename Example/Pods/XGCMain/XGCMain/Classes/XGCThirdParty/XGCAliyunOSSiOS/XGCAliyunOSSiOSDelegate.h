//
//  XGCAliyunOSSiOSDelegate.h
//  XGCMain
//
//  Created by 凌志 on 2024/1/9.
//

#import <Foundation/Foundation.h>
#import <AliyunOSSiOS/AliyunOSSiOS.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCAliyunOSSiOSDelegate : NSObject
/// 便捷初始化
/// - Parameters:
///   - task: 任务
///   - destination: 路径
///   - completionHandler: 完成回调
+ (instancetype)task:(OSSTask *)task destination:(NSString *)destination completionHandler:(void(^)(NSString * _Nullable destination, NSError * _Nullable error))completionHandler;
@property (nonatomic, strong) OSSTask *task;
@property (nonatomic, copy) NSString *destination;
@property (nonatomic, copy) void(^completionHandler) (NSString * _Nullable destination, NSError * _Nullable error);
@end

NS_ASSUME_NONNULL_END
