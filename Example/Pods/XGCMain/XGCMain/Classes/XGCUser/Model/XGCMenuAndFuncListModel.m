//
//  XGCMenuAndFuncListModel.m
//  xinggc
//
//  Created by 凌志 on 2023/11/28.
//

#import "XGCMenuAndFuncListModel.h"
// thirdparty
#import <MJExtension/MJExtension.h>

@implementation XGCMenuAndFuncListModel

+ (NSDictionary *)mj_objectClassInArray {
    return @{@"menuData" : [XGCMenuDataModel class]};
}

- (XGCMenuDataModel *)cMenuData:(NSString *)cUuid cAppFuncCode:(NSString *)cAppFuncCode filter:(BOOL)filter {
    if (cUuid.length == 0 && cAppFuncCode.length == 0) {
        return nil;
    }
    XGCMenuDataModel *object = nil;
    if (cUuid.length > 0) {
        object = [self.menuData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.cUuid MATCHES %@", cUuid]].firstObject;
    }
    if (cAppFuncCode.length > 0) {
        object = [self first:(object.children ?: self.menuData) predicate:^BOOL(XGCMenuDataModel *obj) {
            return [obj.cAppFuncCode isEqualToString:cAppFuncCode];
        }];
    }
    // 深拷贝一份
    object = [XGCMenuDataModel mj_objectWithKeyValues:[object mj_keyValues]];
    // 权限过滤
    if (object && filter) {
        if ([object.cUuid isEqualToString:@"cd_gongzuotai"]) {
            object = [self filterGroup:object];
        } else {
            __block NSMutableArray <XGCMenuDataModel *> *deletes = [NSMutableArray array];
            [object.children enumerateObjectsUsingBlock:^(XGCMenuDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XGCMenuDataModel *model = [self filterGroup:obj];
                (model.children.count == 0) ? [deletes addObject:obj] : nil;
            }];
            [object.children removeObjectsInArray:deletes];
        }
    }
    return object;
}


- (nullable XGCMenuDataModel *)first:(NSArray <XGCMenuDataModel *> *)children predicate:(BOOL(^)(XGCMenuDataModel *obj))predicate {
    __block XGCMenuDataModel *result = nil;
    [children enumerateObjectsUsingBlock:^(XGCMenuDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        result = predicate(obj) ? obj : [self first:obj.children predicate:predicate];
        *stop = result ? YES : NO;
    }];
    return result;
}

- (nullable XGCMenuDataModel *)filterGroup:(nullable XGCMenuDataModel *)group {
    if (!group) {
        return nil;
    }
    NSArray <NSString *> *aclMap = self.aclMap.allKeys;
    // 子项过滤权限
    group.children = [self filter:group.children aclMap:aclMap];
    return group.children.count > 0 ? group : nil;
}

/// 子项权限过滤
/// 如果子项过滤完为空数组，那么返回 nil
/// - Parameter model: 模型
- (nullable NSMutableArray <XGCMenuDataModel *> *)filter:(NSMutableArray <XGCMenuDataModel *> *)children aclMap:(nullable NSArray <NSString *> *)aclMap {
    aclMap = aclMap ?: self.aclMap.allKeys;
    NSMutableArray <XGCMenuDataModel *> *deletes = [NSMutableArray array];
    [children enumerateObjectsUsingBlock:^(XGCMenuDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [aclMap containsObject:obj.cAppFuncCode] ? nil : [deletes addObject:obj];
    }];
    [children removeObjectsInArray:deletes];
    return children.count > 0 ? children : nil;
}

- (NSMutableArray <XGCUserDictMapModel *> *)cDictMap:(NSString *)cCoder {
    if (cCoder.length == 0) {
        return nil;
    }
    NSArray <NSDictionary *> *keyValuesArray = [self.dictMap objectForKey:cCoder];
    if (!keyValuesArray || ![keyValuesArray isKindOfClass:[NSArray class]]) {
        return nil;
    }
    XGCUserDictMapModel *model = [XGCUserDictMapModel new];
    model.cIsShow = @"0";
    model.children = [XGCUserDictMapModel mj_objectArrayWithKeyValuesArray:keyValuesArray];
    // 过滤
    model = [self filterUserDictMap:model];
    return model.children;
}

- (nullable XGCUserDictMapModel *)filterUserDictMap:(XGCUserDictMapModel *)object {
    if (![object.cIsShow isEqualToString:@"0"]) {
        return nil;
    }
    __block NSMutableArray <XGCUserDictMapModel *> *children = [NSMutableArray array];
    [object.children enumerateObjectsUsingBlock:^(XGCUserDictMapModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XGCUserDictMapModel *result = [self filterUserDictMap:obj];
        result ? [children addObject:result] : nil;
    }];
    object.children = children;
    return object;
}

- (XGCUserDictMapModel *)cDictMap:(NSString *)cCoder cCode:(NSString *)cCode {
    if (cCoder.length == 0 || cCode.length == 0) {
        return nil;
    }
    NSArray <NSDictionary *> *temps = [self.dictMap objectForKey:cCoder];
    if (!temps || ![temps isKindOfClass:[NSArray class]]) {
        return nil;
    }
    NSDictionary *keyValues = [self filteredArray:temps cCode:cCode];
    if (!keyValues) {
        return nil;
    }
    return [XGCUserDictMapModel mj_objectWithKeyValues:keyValues];
}

- (nullable NSDictionary *)filteredArray:(NSArray <NSDictionary *> *)array cCode:(NSString *)cCode {
    __block NSDictionary *keyValues = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.cCode CONTAINS %@", cCode]].firstObject;
    if (keyValues) {
        return keyValues;
    }
    for (NSDictionary *dictionary in array) {
        [dictionary.allValues enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[NSArray class]]) {
                keyValues = [self filteredArray:(NSArray *)obj cCode:cCode];
                *stop = keyValues ? YES : NO;
            }
        }];
        if (keyValues) {
            break;
        }
    }
    return keyValues;
}

- (XGCUserAclMapModel *)cAclMap:(NSString *)cAppFuncCode {
    id keyValues = [self.aclMap objectForKey:cAppFuncCode];
    if (!keyValues) {
        return nil;
    }
    return [XGCUserAclMapModel mj_objectWithKeyValues:keyValues];
}

@end
