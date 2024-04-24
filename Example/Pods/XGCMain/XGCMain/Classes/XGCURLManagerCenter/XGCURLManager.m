//
//  XGCURLManager.m
//  XGCMain
//
//  Created by 凌志 on 2023/12/22.
//

#import "XGCURLManager.h"

@interface XGCURLManager ()
@property(nonatomic, strong) NSMutableArray <NSString *> *_identifiers;
@property(nonatomic, strong) NSMutableArray <__kindof NSObject <XGCURLProtocol> *> *_configurations;
@end

@implementation XGCURLManager

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        _name = name;
        self._identifiers = NSMutableArray.new;
        self._configurations = NSMutableArray.new;
    }
    return self;
}

- (void)setCurrentConfigurationIdentifier:(NSString *)currentConfigurationIdentifier {
    _currentConfigurationIdentifier = currentConfigurationIdentifier;
    _currentConfiguration = [self configurationForIdentifier:currentConfigurationIdentifier];
}

- (void)setCurrentConfiguration:(__kindof NSObject<XGCURLProtocol> *)currentConfiguration {
    _currentConfiguration = currentConfiguration;
    _currentConfigurationIdentifier = [self identifierForConfiguration:currentConfiguration];
}

- (NSArray <NSString *> *)configurationIdentifiers {
    return self._identifiers.count ? self._identifiers.copy : nil;
}

- (NSArray <__kindof NSObject<XGCURLProtocol> *> *)configurations {
    return self._configurations.count ? self._configurations.copy : nil;
}

- (__kindof NSObject *)configurationForIdentifier:(NSString *)identifier {
    NSUInteger index = [self._identifiers indexOfObject:identifier];
    if (index != NSNotFound) return self._configurations[index];
    return nil;
}

- (NSString *)identifierForConfiguration:(__kindof NSObject<XGCURLProtocol> *)configuration {
    NSUInteger index = [self._configurations indexOfObject:configuration];
    if (index != NSNotFound) return self._identifiers[index];
    return nil;
}

- (void)addConfigurationIdentifier:(NSString *)identifier configuration:(__kindof NSObject<XGCURLProtocol> *)configuration {
    [self._identifiers addObject:identifier];
    [self._configurations addObject:configuration];
    if (!self.currentConfiguration) {
        self.currentConfiguration = configuration;
    }
}

- (void)removeConfigurationIdentifier:(NSString *)identifier {
    [self._identifiers removeObject:identifier];
}

- (void)removeConfiguration:(__kindof NSObject<XGCURLProtocol> *)configuration {
    [self._configurations removeObject:configuration];
}

@end
