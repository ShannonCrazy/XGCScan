//
//  XGCURLManagerCenter.h
//  XGCMain
//
//  Created by 凌志 on 2023/12/21.
//

#import <Foundation/Foundation.h>
//
#import "XGCURLManager.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const XGCURLManagerNameDefault;

@interface XGCURLManagerCenter : NSObject

@property(class, nonatomic, strong, readonly) XGCURLManager *defaultURLManager;
@property(class, nonatomic, copy, readonly) NSArray<XGCURLManager *> *URLManagers;
+ (nullable XGCURLManager *)URLManagerWithName:(__kindof NSObject<NSCopying> *)name;

@end

NS_ASSUME_NONNULL_END
