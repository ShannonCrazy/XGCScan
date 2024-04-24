//
//  XGCMenuDataModel.h
//  xinggc
//
//  Created by 凌志 on 2023/11/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCMenuDataModel : NSObject
/// 菜单编码
@property (nonatomic, copy) NSString *cUuid;
/// APP权限编码
@property (nonatomic, copy, nullable) NSString *cAppFuncCode;
/// 菜单名称
@property (nonatomic, copy, nullable) NSString *cName;
/// 图片
@property (nonatomic, copy, nullable) NSString *cImageUrl;
/// 小红点数量
@property (nonatomic, assign) NSInteger badgeValue;
/// 子菜单
@property (nonatomic, strong) NSMutableArray <XGCMenuDataModel *> *children;
/// 是否展开
@property (nonatomic, assign, getter=isOpen) BOOL open;
/// 层级
@property (nonatomic, assign) NSInteger level;

+ (instancetype)cUuid:(nullable NSString *)cUuid cAppFuncCode:(nullable NSString *)cAppFuncCode cName:(nullable NSString *)cName cImageUrl:(nullable NSString *)cImageUrl;
@end

NS_ASSUME_NONNULL_END
