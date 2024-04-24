//
//  XGCUserAclMapModel.h
//  XGCMain
//
//  Created by 凌志 on 2023/12/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCUserAclMapModel : NSObject
/// 发布权限
@property (nonatomic, assign) BOOL isSave;
/// 管理权限
@property (nonatomic, assign) BOOL isMng;
/// 是否可以实名认证
@property (nonatomic, assign) BOOL isAuth;
@end

NS_ASSUME_NONNULL_END
