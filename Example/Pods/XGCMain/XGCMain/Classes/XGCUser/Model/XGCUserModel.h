//
//  XGCUserModel.h
//  xinggc
//
//  Created by 凌志 on 2023/11/23.
//

#import <Foundation/Foundation.h>
#import "XGCUserMapModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCUserModel : NSObject
/// token
@property (nonatomic, copy, nullable) NSString *token;
/// token有效时间
@property (nonatomic, assign) NSTimeInterval begTimeStamp;
/// token结束时间
@property (nonatomic, assign) NSTimeInterval endTimeStamp;
/// token过期时间
@property (nonatomic, assign) NSTimeInterval tokenExpiredSecond;
/// 上次登录时间
@property (nonatomic, assign) NSTimeInterval loginTimeStamp;
/// 用户信息
@property (nonatomic, strong) XGCUserMapModel *userMap;
/// token是否有效
- (BOOL)tokenAvailable;
/// 是否需要身份验证
- (BOOL)biometricsAvailable;
@end

NS_ASSUME_NONNULL_END
