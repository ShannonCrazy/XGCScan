//
//  XGCMenuDataModel.m
//  xinggc
//
//  Created by 凌志 on 2023/11/28.
//

#import "XGCMenuDataModel.h"
#import <MJExtension/MJExtension.h>

@implementation XGCMenuDataModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"children" : [XGCMenuDataModel class]};
}

+ (instancetype)cUuid:(NSString *)cUuid cAppFuncCode:(NSString *)cAppFuncCode cName:(NSString *)cName cImageUrl:(NSString *)cImageUrl {
    XGCMenuDataModel *model = [[XGCMenuDataModel alloc] init];
    model.cUuid = cUuid;
    model.cAppFuncCode = cAppFuncCode;
    model.cName = cName;
    model.cImageUrl = cImageUrl;
    model.children = [NSMutableArray array];
    return model;
}
@end
