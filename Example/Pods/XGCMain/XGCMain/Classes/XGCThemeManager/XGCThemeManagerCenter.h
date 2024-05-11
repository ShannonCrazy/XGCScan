//
//  XGCThemeManagerCenter.h
//  XGCMain
//
//  Created by 凌志 on 2023/12/21.
//

#import <Foundation/Foundation.h>
//
#import "XGCThemeManager.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const XGCThemeManagerNameDefault;

@interface XGCThemeManagerCenter : NSObject

@property(class, nonatomic, strong, readonly) XGCThemeManager *defaultThemeManager;
@property(class, nonatomic, copy, readonly) NSArray<XGCThemeManager *> *themeManagers;
+ (nullable XGCThemeManager *)themeManagerWithName:(__kindof NSObject<NSCopying> *)name;

@end

NS_ASSUME_NONNULL_END
