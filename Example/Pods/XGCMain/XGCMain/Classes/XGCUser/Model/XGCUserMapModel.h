//
//  XGCUserMapModel.h
//  xinggc
//
//  Created by 凌志 on 2023/11/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCUserMapModel : NSObject
/// 用户id
@property (nonatomic, copy) NSString *cId;
/// 用户名称
@property (nonatomic, copy) NSString *cName;
/// 头像
@property (nonatomic, copy) NSString *cImageUrl;
/// 手机号码
@property (nonatomic, copy) NSString *cPhone;
/// 真实姓名
@property (nonatomic, copy) NSString *cRealname;
/// 用户类型
@property (nonatomic, copy) NSString *cUserType;
/// 公司ID
@property (nonatomic, copy) NSString *companyId;
/// 公司名称
@property (nonatomic, copy) NSString *companyName;
/// 职位
@property (nonatomic, copy) NSString *positionName;
/// 官网地址
@property (nonatomic, copy) NSString *cWebsite;
/// 所属组织id
@property (nonatomic, copy) NSString *pOrgId;
/// 所属组织名称
@property (nonatomic, copy) NSString *pOrgName;
/// 部门id
@property (nonatomic, copy) NSString *orgId;
/// 部门名称
@property (nonatomic, copy) NSString *orgName;
/// 公司logo
@property (nonatomic, copy) NSString *cLogoUrl;
/// 是否使用了touchID
@property (nonatomic, assign) BOOL touchID;
/// 是否使用了faceID
@property (nonatomic, assign) BOOL faceID;
/// 手势解锁图形
@property (nonatomic, copy, nullable) NSString *gestureID;
@end

NS_ASSUME_NONNULL_END
