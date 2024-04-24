//
//  XGCURLManagerCenter.m
//  XGCMain
//
//  Created by 凌志 on 2023/12/21.
//

#import "XGCURLManagerCenter.h"

NSString *const XGCURLManagerNameDefault = @"Default";

@interface XGCURLManagerCenter ()

@property(nonatomic, strong) NSMutableArray<XGCURLManager *> *allManagers;
@end

@implementation XGCURLManagerCenter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static XGCURLManagerCenter *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        instance.allManagers = NSMutableArray.new;
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

+ (XGCURLManager *)URLManagerWithName:(__kindof NSObject<NSCopying> *)name {
    XGCURLManagerCenter *center = [XGCURLManagerCenter sharedInstance];
    for (XGCURLManager *manager in center.allManagers) {
        if ([manager.name isEqual:name]) return manager;
    }
    XGCURLManager *manager = [[XGCURLManager alloc] initWithName:name];
    [center.allManagers addObject:manager];
    return manager;
}

+ (XGCURLManager *)defaultURLManager {
    return [XGCURLManagerCenter URLManagerWithName:XGCURLManagerNameDefault];
}

+ (NSArray<XGCURLManager *> *)URLManagers {
    return [XGCURLManagerCenter sharedInstance].allManagers.copy;
}

@end
