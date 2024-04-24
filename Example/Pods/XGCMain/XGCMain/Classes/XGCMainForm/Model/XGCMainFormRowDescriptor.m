//
//  XGCMainFormRowDescriptor.m
//  iPadDemo
//
//  Created by 凌志 on 2023/12/19.
//

#import "XGCMainFormRowDescriptor.h"
//
#import "UIImage+XGCImage.h"

@implementation XGCMainFormRowDescriptor
+ (instancetype)formRowDescriptor {
    return [self new];
}
- (instancetype)init {
    if (self = [super init]) {
        self.font = [UIFont systemFontOfSize:13];
        self.rowHeight = UITableViewAutomaticDimension;
        self.contentEdgeInsets = UIEdgeInsetsMake(14.0, 20.0, 14.0, 20.0);
    }
    return self;
}
@end

@implementation XGCMainFormRowTextFieldDescriptor
- (instancetype)init {
    if (self = [super init]) {
        self.maximumFractionDigits = NSUIntegerMax;
    }
    return self;
}
@end

@interface XGCMainFormRowTextFieldSelectorDescriptor ()
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSNumber *, NSString *> *titleMaps;
@property (nonatomic, strong, readwrite) NSMutableDictionary <NSNumber *, UIColor *> *colorMaps;
@end

@implementation XGCMainFormRowTextFieldSelectorDescriptor
- (instancetype)init {
    if (self = [super init]) {
        self.titleMaps = [NSMutableDictionary dictionary];
        self.colorMaps = [NSMutableDictionary dictionary];
    }
    return self;
}
- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    NSNumber *key = [NSNumber numberWithUnsignedInteger:state];
    if (title) {
        [self.titleMaps setObject:title forKey:key];
    } else {
        [self.titleMaps removeObjectForKey:key];
    }
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
    NSNumber *key = [NSNumber numberWithUnsignedInteger:state];
    if (color) {
        [self.colorMaps setObject:color forKey:key];
    } else {
        [self.colorMaps removeObjectForKey:key];
    }
}

- (CALayer *)layer {
    return [CALayer layer];
}
@end

@implementation XGCMainFormRowTextViewDescriptor
- (instancetype)init {
    if (self = [super init]) {
        self.spacePadding = 10.0;
    }
    return self;
}
@end

@implementation XGCMainFormRowActionDescriptor
- (instancetype)init {
    if (self = [super init]) {
        self.image = [UIImage imageNamed:@"main_arrow_blue_right" inResource:@"XGCMain"];
    }
    return self;
}
@end

@implementation XGCMainFormRowDateActionDescriptor

@end

@implementation XGCMainFormRowDictMapActionDescriptor

@end

@implementation XGCMainFormRowDictMapSelectorDescriptor

@end

@implementation XGCMainFormRowStyleValue1Descriptor

@end

@implementation XGCMainFormRowStyleSubtitleDescriptor

@end

@implementation XGCMainFormRowMediaDescriptor

@end

@implementation XGCMainFormRowCustiomDescriptor

@end
