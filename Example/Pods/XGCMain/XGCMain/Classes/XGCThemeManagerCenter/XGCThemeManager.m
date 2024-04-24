//
//  XGCThemeManager.m
//  XGCMain
//
//  Created by 凌志 on 2023/12/21.
//

#import "XGCThemeManager.h"

NSString *const XGCThemeDidChangeNotification = @"XGCThemeDidChangeNotification";

@interface XGCThemeManager ()
@property(nonatomic, strong) NSMutableArray <NSObject <NSCopying> *> *_themeIdentifiers;
@property(nonatomic, strong) NSMutableArray <NSObject *> *_themes;
@end

@implementation XGCThemeManager

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@, name = %@, themes = %@", [super description], self.name, self.themes];
}

- (instancetype)initWithName:(__kindof NSObject<NSCopying> *)name {
    if (self = [super init]) {
        _name = name;
        self._themeIdentifiers = NSMutableArray.new;
        self._themes = NSMutableArray.new;
    }
    return self;
}

- (void)handleUserInterfaceStyleWillChangeEvent:(UITraitCollection *)traitCollection {
    if (!_respondsSystemStyleAutomatically) return;
    if (@available(iOS 13.0, *)) {
        if (traitCollection && self.identifierForTrait) {
            self.currentThemeIdentifier = self.identifierForTrait(traitCollection);
        }
    }
}

- (void)setRespondsSystemStyleAutomatically:(BOOL)respondsSystemStyleAutomatically {
    _respondsSystemStyleAutomatically = respondsSystemStyleAutomatically;
    if (_respondsSystemStyleAutomatically && self.identifierForTrait) {
         self.currentThemeIdentifier = self.identifierForTrait([UITraitCollection currentTraitCollection]);
    }
}

- (void)setCurrentThemeIdentifier:(NSObject<NSCopying> *)currentThemeIdentifier {
    BOOL themeChanged = _currentThemeIdentifier && ![_currentThemeIdentifier isEqual:currentThemeIdentifier];
    
    _currentThemeIdentifier = currentThemeIdentifier;
    _currentTheme = [self themeForIdentifier:currentThemeIdentifier];
    
    if (themeChanged) {
        [self notifyThemeChanged];
    }
}

- (void)setCurrentTheme:(__kindof NSObject<XGCThemeTemplateProtocol> *)currentTheme {
    BOOL themeChanged = _currentTheme && ![_currentTheme isEqual:currentTheme];
    
    _currentTheme = currentTheme;
    _currentThemeIdentifier = [self identifierForTheme:currentTheme];
    
    if (themeChanged) {
        [self notifyThemeChanged];
    }
}

- (NSArray<NSObject <NSCopying> *> *)themeIdentifiers {
    return self._themeIdentifiers.count ? self._themeIdentifiers.copy : nil;
}

- (NSArray<__kindof NSObject <XGCThemeTemplateProtocol> *> *)themes {
    return self._themes.count ? self._themes.copy : nil;
}

- (__kindof NSObject *)themeForIdentifier:(__kindof NSObject<NSCopying> *)identifier {
    NSUInteger index = [self._themeIdentifiers indexOfObject:identifier];
    if (index != NSNotFound) return self._themes[index];
    return nil;
}

- (__kindof NSObject<NSCopying> *)identifierForTheme:(__kindof NSObject <XGCThemeTemplateProtocol> *)theme {
    NSUInteger index = [self._themes indexOfObject:theme];
    if (index != NSNotFound) return self._themeIdentifiers[index];
    return nil;
}

- (void)addThemeIdentifier:(NSObject<NSCopying> *)identifier theme:(NSObject <XGCThemeTemplateProtocol> *)theme {
    [self._themeIdentifiers addObject:identifier];
    [self._themes addObject:theme];
}

- (void)removeThemeIdentifier:(NSObject<NSCopying> *)identifier {
    [self._themeIdentifiers removeObject:identifier];
}

- (void)removeTheme:(NSObject <XGCThemeTemplateProtocol> *)theme {
    [self._themes removeObject:theme];
}

- (void)notifyThemeChanged {
    [[NSNotificationCenter defaultCenter] postNotificationName:XGCThemeDidChangeNotification object:self];
}

@end
