//
//  XGCUserManager.h
//  xinggc
//
//  Created by 凌志 on 2023/11/23.
//

#import <UIKit/UIKit.h>
#import "XGCUserModel.h"
#import "XGCUserMapModel.h"
#import "XGCMenuDataModel.h"
#import "XGCMenuAndFuncListModel.h"

NS_ASSUME_NONNULL_BEGIN

#define XGCUM XGCUserManager.sharedManager

/// 用户成功获取token
UIKIT_EXTERN NSString * const XGCUserGetTokenNotification;
/// 用户成功登录通知
UIKIT_EXTERN NSString * const XGCUserLoginNotification;
/// 用户单点登录被踢下线通知
UIKIT_EXTERN NSString * const XGCUserKickOutNotification;
/// 用户主动退出通知
UIKIT_EXTERN NSString * const XGCUserLogoutNotification;
/// 用户切换账号通知
UIKIT_EXTERN NSString * const XGCUserSwitchAccountsNotification;

@interface XGCUserManager : NSObject
/// 单例
@property (class, readonly, strong) XGCUserManager *sharedManager;
/// 历史账号
@property (nonatomic, strong, readonly, nullable) NSArray <XGCUserModel *> *histories;
/// 当前登录的用户
@property (nonatomic, strong, nullable) XGCUserModel *cUser;
/// 菜单信息
@property (nonatomic, strong, nullable) XGCMenuAndFuncListModel *cMenu;

/// 登录存储用户信息
/// - Parameter cUser: 用户信息
- (void)setUser:(NSDictionary *)cUser;

/// 存储菜单信息
/// - Parameter cMenuAndFuncList: 菜单信息
- (void)setMenuAndFuncList:(NSDictionary *)cMenuAndFuncList;

/// 存储菜单信息
/// - Parameters:
///   - cMenuAndFuncList: 菜单信息
///   - cUuid: 需要覆盖的cUuid
- (void)setMenuAndFuncList:(NSDictionary *)cMenuAndFuncList forUuid:(NSString *)cUuid;

/// 存储用户信息
/// - Parameter cUser: 用户信息
- (void)storageUser:(XGCUserModel *)cUser;
@end

NS_ASSUME_NONNULL_END
