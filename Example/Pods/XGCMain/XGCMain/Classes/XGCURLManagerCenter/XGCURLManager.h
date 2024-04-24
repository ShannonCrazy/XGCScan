//
//  XGCURLManager.h
//  XGCMain
//
//  Created by 凌志 on 2023/12/22.
//

#import <Foundation/Foundation.h>
// protocol
#import "XGCURLProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface XGCURLManager : NSObject

- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name;

@property(nonatomic, copy, readonly) __kindof NSString *name;

/// 获取所有请求环境的 identifier
@property(nonatomic, copy, readonly, nullable) NSArray <NSString *> *configurationIdentifiers;

/// 获取所有请求环境的对象
@property(nonatomic, copy, readonly, nullable) NSArray <__kindof NSObject <XGCURLProtocol> *> *configurations;

/// 获取当前请求环境的 identifier
@property(nonatomic, copy, nullable) NSString *currentConfigurationIdentifier;

/// 获取当前请求环境的对象
@property(nonatomic, strong, nullable) __kindof NSObject <XGCURLProtocol> *currentConfiguration;

/**
 添加请求环境，不允许重复添加
 @param identifier 请求环境的 identifier，一般用 NSString 即可，不允许重复
 @param configuration 请求环境的对象，允许任意 class 类型
 */
- (void)addConfigurationIdentifier:(NSString *)identifier configuration:(__kindof NSObject <XGCURLProtocol> *)configuration;

/**
 移除指定 identifier 的请求环境
 @param identifier 要移除的 identifier
 */
- (void)removeConfigurationIdentifier:(__kindof NSObject<NSCopying> *)identifier;

/**
 移除指定的请求环境对象
 @param configuration 要移除的请求环境对象
 */
- (void)removeConfiguration:(__kindof NSObject <XGCURLProtocol> *)configuration;

/**
 根据指定的 identifier 获取对应的请求环境对象
 @param identifier 请求环境的 identifier
 @return identifier 对应的请求环境对象
 */
- (nullable __kindof NSObject *)configurationForIdentifier:(NSString *)identifier;

/**
 获取请求环境对应的 identifier
 @param configuration 请求环境对象
 @return 请求环境的 identifier
 */
- (nullable NSString *)identifierForConfiguration:(__kindof NSObject <XGCURLProtocol> *)configuration;
@end

NS_ASSUME_NONNULL_END
