//
//  XGCThemeManagerCenter.m
//  XGCMain
//
//  Created by 凌志 on 2023/12/21.
//

#import "XGCThemeManagerCenter.h"

NSString *const XGCThemeManagerNameDefault = @"Default";

@interface XGCThemeManagerCenter ()

@property(nonatomic, strong) NSMutableArray<XGCThemeManager *> *allManagers;
@end

@implementation XGCThemeManagerCenter

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static XGCThemeManagerCenter *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
        instance.allManagers = NSMutableArray.new;
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

+ (XGCThemeManager *)themeManagerWithName:(__kindof NSObject<NSCopying> *)name {
    XGCThemeManagerCenter *center = [XGCThemeManagerCenter sharedInstance];
    for (XGCThemeManager *manager in center.allManagers) {
        if ([manager.name isEqual:name]) return manager;
    }
    XGCThemeManager *manager = [[XGCThemeManager alloc] initWithName:name];
    [center.allManagers addObject:manager];
    return manager;
}

+ (XGCThemeManager *)defaultThemeManager {
    return [XGCThemeManagerCenter themeManagerWithName:XGCThemeManagerNameDefault];
}

+ (NSArray<XGCThemeManager *> *)themeManagers {
    return [XGCThemeManagerCenter sharedInstance].allManagers.copy;
}

@end
