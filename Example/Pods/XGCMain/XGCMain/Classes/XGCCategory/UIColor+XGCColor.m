//
//  UIColor+XGCColor.m
//  xinggc
//
//  Created by 凌志 on 2023/12/11.
//

#import "UIColor+XGCColor.h"

@implementation UIColor (XGCColor)

+ (UIColor *)randomColor {
    return [UIColor colorWithRed:arc4random_uniform(256) / 255.0f green:arc4random_uniform(256) / 255.0f blue:arc4random_uniform(256) / 255.0f alpha:1];
}

+ (UIColor *)xgc_colorNamed:(NSString *)name {
    NSString *rgbaString = [name copy];
    if ([rgbaString hasPrefix:@"#"]) {
        rgbaString = [rgbaString substringFromIndex:1];
    }
    if (rgbaString.length == 6) {
        rgbaString = [rgbaString stringByAppendingString:@"FF"];
    }
    if (rgbaString.length != 8) {
        return nil;
    }
    uint32_t rgba;
    NSScanner *scanner = [NSScanner scannerWithString:rgbaString];
    [scanner scanHexInt:&rgba];
    return [UIColor colorWithRed:((rgba >> 24) & 0xFF) / 255.0 green:((rgba >> 16) & 0xFF) / 255.0 blue:((rgba >> 8) & 0xFF) / 255.0 alpha:(rgba & 0xFF) / 255.0];
}

@end
