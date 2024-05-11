//
//  XGCThemeManager.h
//  XGCMain
//
//  Created by 凌志 on 2023/12/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UITraitCollection.h>
#import "XGCThemeTemplateProtocol.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const XGCThemeDidChangeNotification;

@interface XGCThemeManager : NSObject

- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)initWithName:(__kindof NSObject<NSCopying> *)name;

@property(nonatomic, copy, readonly) __kindof NSObject<NSCopying> *name;

/// 自动响应 iOS 13 里的 Dark Mode 切换，默认为 NO。当为 YES 时，能自动监听系统 Dark Mode 的切换，并通过询问 identifierForTrait 来将当前的系统界面样式转换成业务定义的主题，剩下的事情就跟 iOS 12 及以下的系统相同了。
/// @warning 当设置这个属性为 YES 之前，请先为 identifierForTrait 赋值。
@property(nonatomic, assign) BOOL respondsSystemStyleAutomatically API_AVAILABLE(ios(13.0));

/// 当 respondsSystemStyleAutomatically 为 YES 并且系统样式发生变化时，会通过这个 block 将当前的 UITraitCollection.userInterfaceStyle 转换成对应的业务主题 identifier
@property(nonatomic, copy, nullable) __kindof NSObject <NSCopying> *(^identifierForTrait)(UITraitCollection *trait) API_AVAILABLE(ios(13.0));

/// 获取所有主题的 identifier
@property(nonatomic, copy, readonly, nullable) NSArray <__kindof NSObject<NSCopying> *> *themeIdentifiers;

/// 获取所有主题的对象
@property(nonatomic, copy, readonly, nullable) NSArray <__kindof NSObject <XGCThemeTemplateProtocol> *> *themes;

/// 获取当前主题的 identifier
@property(nonatomic, copy, nullable) __kindof NSObject <NSCopying> *currentThemeIdentifier;

/// 获取当前主题的对象
@property(nonatomic, strong, nullable) __kindof NSObject <XGCThemeTemplateProtocol> *currentTheme;

/**
 添加主题，不允许重复添加
 @param identifier 主题的 identifier，一般用 NSString 即可，不允许重复
 @param theme 主题的对象，允许任意 class 类型
 */
- (void)addThemeIdentifier:(__kindof NSObject<NSCopying> *)identifier theme:(__kindof NSObject <XGCThemeTemplateProtocol> *)theme;

/**
 移除指定 identifier 的主题
 @param identifier 要移除的 identifier
 */
- (void)removeThemeIdentifier:(__kindof NSObject<NSCopying> *)identifier;

/**
 移除指定的主题对象
 @param theme 要移除的主题对象
 */
- (void)removeTheme:(__kindof NSObject <XGCThemeTemplateProtocol> *)theme;

/**
 根据指定的 identifier 获取对应的主题对象
 @param identifier 主题的 identifier
 @return identifier 对应的主题对象
 */
- (nullable __kindof NSObject *)themeForIdentifier:(__kindof NSObject<NSCopying> *)identifier;

/**
 获取主题对应的 identifier
 @param theme 主题对象
 @return 主题的 identifier
 */
- (nullable __kindof NSObject<NSCopying> *)identifierForTheme:(__kindof NSObject <XGCThemeTemplateProtocol> *)theme;
@end

NS_ASSUME_NONNULL_END
