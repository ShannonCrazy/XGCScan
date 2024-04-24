//
//  XGCUserManager.m
//  xinggc
//
//  Created by 凌志 on 2023/11/23.
//

#import "XGCUserManager.h"
// model
#import "XGCUserModel.h"
#import "XGCUserMapModel.h"
#import "XGCMenuAndFuncListModel.h"
//
//#import "XGCMobClickManager.h"
//
#import "XGCURLSession.h"
#import "NSArray+XGCArray.h"
//
#import <MJExtension/MJExtension.h>

static NSString * const XGCUserHistoriesKey = @"kXGCUserHistoriesKey";

static NSTimeInterval const tokenExpiredSecond = 2 * 24.0 * 60.0 * 60.0;

/// 用户成功获取token通知
NSString * const XGCUserGetTokenNotification = @"kXGCUserGetTokenNotification";
/// 用户成功登录通知
NSString * const XGCUserLoginNotification = @"kXGCUserLoginNotification";
/// 用户单点登录被踢下线通知
NSString * const XGCUserKickOutNotification = @"kXGCUserKickOutNotification";
/// 用户主动退出通知
NSString * const XGCUserLogoutNotification = @"kXGCUserLogoutNotification";
/// 用户切换账号通知
NSString * const XGCUserSwitchAccountsNotification = @"kXGCUserSwitchAccountsNotification";

@interface XGCUserManager ()

@end

@implementation XGCUserManager

+ (instancetype)sharedManager {
    static XGCUserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XGCUserManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        // 获取本地数据
        self.cUser = self.histories.firstObject;
        // 通知
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(cUserLogoutNotification) name:XGCUserLogoutNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(cUserLogoutNotification) name:XGCUserKickOutNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(cUserSwitchAccountsNotification) name:XGCUserSwitchAccountsNotification object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(cUserLoginNotification) name:XGCUserLoginNotification object:nil];
    }
    return self;
}

- (NSArray<XGCUserModel *> *)histories {
    NSArray <XGCUserModel *> *temps = [XGCUserModel mj_objectArrayWithKeyValuesArray:[NSUserDefaults.standardUserDefaults objectForKey:XGCUserHistoriesKey]];
    temps = [temps sortedArrayUsingComparator:^NSComparisonResult(XGCUserModel *obj1, XGCUserModel *obj2) {
        return obj1.loginTimeStamp < obj2.loginTimeStamp;
    }];
    [temps enumerateObjectsUsingBlock:^(XGCUserModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.token = [obj tokenAvailable] ? obj.token : nil;
    }];
    return temps;
}

#pragma mark public
- (void)setUser:(NSDictionary *)cUser {
    if (![cUser isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.cUser = [XGCUserModel mj_objectWithKeyValues:cUser];
    XGCUserModel *result = [self.histories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.userMap.cId == %@", self.cUser.userMap.cId]].firstObject;
    if (result) {
        self.cUser.userMap.faceID = result.userMap.faceID;
        self.cUser.userMap.touchID = result.userMap.touchID;
        self.cUser.userMap.gestureID = result.userMap.gestureID;
    }
    self.cUser.loginTimeStamp = [NSDate date].timeIntervalSince1970;
    // 存储
    [self storageUser:self.cUser];
}

- (void)setMenuAndFuncList:(NSDictionary *)cMenuAndFuncList {
    if (![cMenuAndFuncList isKindOfClass:[NSDictionary class]]) {
        return;
    }
    self.cMenu = [XGCMenuAndFuncListModel mj_objectWithKeyValues:cMenuAndFuncList];
    // 用户信息
    XGCUserMapModel *userMap = [XGCUserMapModel mj_objectWithKeyValues:cMenuAndFuncList[@"userMap"]];
    XGCUserModel *result = [self.histories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.userMap.cId == %@", self.cUser.userMap.cId]].firstObject;
    if (result) {
        userMap.faceID = result.userMap.faceID;
        userMap.touchID = result.userMap.touchID;
        userMap.gestureID = result.userMap.gestureID;
    }
    self.cUser.userMap = userMap;
    // 刷新token
    [self refreshToken];
    // 存储
    [self storageUser:self.cUser];
}

- (void)setMenuAndFuncList:(NSDictionary *)cMenuAndFuncList forUuid:(NSString *)cUuid {
    XGCMenuDataModel *model = [self.cMenu.menuData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.cUuid MATCHES %@", cUuid]].firstObject;
    if (!model) {
        return;
    }
    NSMutableArray <XGCMenuDataModel *> *temps = [NSMutableArray arrayWithArray:self.cMenu.menuData];
    [temps replaceObjectIn:model withObject:[XGCMenuDataModel mj_objectWithKeyValues:cMenuAndFuncList]];
    self.cMenu.menuData = [temps copy];
    // 存储
    [self storageUser:self.cUser];
}

#pragma mark private
- (void)storageUser:(XGCUserModel *)cUser {
    if (!cUser) {
        return;
    }
    NSMutableArray <XGCUserModel *> *histories = [NSMutableArray arrayWithArray:self.histories ?: @[]];
    XGCUserModel *temp = [histories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.userMap.cId == %@", cUser.userMap.cId]].firstObject;
    if (temp) {
        [histories replaceObjectAtIndex:[histories indexOfObject:temp] withObject:cUser];
    } else {
        [histories addObject:cUser];
    }
    [NSUserDefaults.standardUserDefaults setObject:[NSArray mj_keyValuesArrayWithObjectArray:histories] forKey:XGCUserHistoriesKey];
}

/// 刷新token
- (void)refreshToken {
    if (self.cUser.token.length == 0) {
        return;
    }
    NSTimeInterval difference = [NSDate date].timeIntervalSince1970 - self.cUser.begTimeStamp / 1000.0;
    if (difference <= tokenExpiredSecond) {
        return;
    }
    // 大于两天
    __weak typeof(self) this = self;
    [XGCURLSession POST:@"token/refreshToken" parameters:[NSDictionary dictionaryWithObject:self.cUser.token forKey:@"token"] aTarget:self callback:^(id  _Nullable responseObject, NSError * _Nullable error) {
        if (responseObject) {
            XGCUserModel *temp = [XGCUserModel mj_objectWithKeyValues:responseObject];
            // 更新现有数据
            this.cUser.token = temp.token;
            this.cUser.tokenExpiredSecond = temp.tokenExpiredSecond;
            this.cUser.begTimeStamp = temp.begTimeStamp;
            this.cUser.endTimeStamp = temp.endTimeStamp;
            // 存储
            [this storageUser:this.cUser];
        }
    }];
}

#pragma mark Notification
- (void)cUserLogoutNotification {
    self.cUser.token = nil;
    // 存储
    [self storageUser:self.cUser];
    // 告知友盟下线
//    [XGCMobClickManager profileSignOff];
    // 清空applicationIcon角标
    UIApplication.sharedApplication.applicationIconBadgeNumber = 0;
}

- (void)cUserSwitchAccountsNotification {
    self.cUser = nil;
    // 告知友盟下线
//    [XGCMobClickManager profileSignOff];
    // 清空applicationIcon角标
    UIApplication.sharedApplication.applicationIconBadgeNumber = 0;
}

- (void)cUserLoginNotification {
//    [XGCMobClickManager profileSignInWithPUID:self.cUser.userMap.cName];
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

@end
