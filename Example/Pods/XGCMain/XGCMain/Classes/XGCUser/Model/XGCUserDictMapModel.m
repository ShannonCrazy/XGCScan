//
//  XGCUserDictMapModel.m
//  XGCMain
//
//  Created by 凌志 on 2023/12/25.
//

#import "XGCUserDictMapModel.h"
//
#import <MJExtension/MJExtension.h>

@implementation XGCUserDictMapModel

+ (instancetype)cCode:(NSString *)cCode cName:(NSString *)cName {
    XGCUserDictMapModel *model = [[XGCUserDictMapModel alloc] init];
    model.cCode = cCode;
    model.cName = cName;
    return model;
}

+ (NSDictionary *)mj_objectClassInArray {
    return [NSDictionary dictionaryWithObject:[XGCUserDictMapModel class] forKey:@"children"];
}

@end
