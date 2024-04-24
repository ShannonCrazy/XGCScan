//
//  XGCMenuAndFuncListModel.h
//  xinggc
//
//  Created by 凌志 on 2023/11/28.
//

#import <Foundation/Foundation.h>
//
#import "XGCMenuDataModel.h"
#import "XGCUserAclMapModel.h"
#import "XGCUserDictMapModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCMenuAndFuncListModel : NSObject
/// 菜单编码
@property (nonatomic, strong) NSDictionary *aclMap;
/// "不可编辑菜单编码"
@property (nonatomic, strong) NSArray <NSString *> *mustCodeList;
/// 字典码
@property (nonatomic, strong) NSDictionary *dictMap;
/// 菜单信息
@property (nonatomic, strong) NSArray <XGCMenuDataModel *> *menuData;
/// 菜单
- (XGCMenuDataModel *)cMenuData:(nullable NSString *)cUuid cAppFuncCode:(nullable NSString *)cAppFuncCode filter:(BOOL)filter;
/// 过滤子项菜单
/// - Parameters:
///   - children: 子项数组
///   - aclMap: 权限编码，可为空
- (nullable NSMutableArray <XGCMenuDataModel *> *)filter:(NSMutableArray <XGCMenuDataModel *> *)children aclMap:(nullable NSArray <NSString *> *)aclMap;
/// 字典
- (nullable NSMutableArray <XGCUserDictMapModel *> *)cDictMap:(NSString *)cCoder;
- (nullable XGCUserDictMapModel *)cDictMap:(NSString *)cCoder cCode:(NSString *)cCode;
/// 权限
- (nullable XGCUserAclMapModel *)cAclMap:(NSString *)cAppFuncCode;
@end
NS_ASSUME_NONNULL_END
