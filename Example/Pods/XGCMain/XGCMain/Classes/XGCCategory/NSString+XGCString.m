//
//  NSString+XGCString.m
//  xinggc
//
//  Created by 凌志 on 2023/11/24.
//

#import "NSString+XGCString.h"

@implementation NSString (XGCString)

- (NSString *)URLEncoding {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
}

- (NSString *)removeMagicalChar {
    if (self.length == 0) {
        return self;
    }
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\u0300-\u036F]" options:NSRegularExpressionCaseInsensitive error:nil];
    return [regex stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length) withTemplate:@""];
}

- (NSString *)adding:(NSString *)addend roundingMode:(NSRoundingMode)roundingMode scale:(NSUInteger)scale {
    NSDecimalNumber *augend = [NSDecimalNumber decimalNumberWithString:self];
    if (augend == NSDecimalNumber.notANumber) {
        return self;
    }
    NSDecimalNumber *numberAddend = [NSDecimalNumber decimalNumberWithString:addend];
    if (numberAddend == NSDecimalNumber.notANumber) {
        return self;
    }
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    return [augend decimalNumberByAdding:numberAddend withBehavior:behavior].stringValue;
}

- (NSString *)subtracting:(NSString *)subtrahend roundingMode:(NSRoundingMode)roundingMode scale:(NSUInteger)scale {
    NSDecimalNumber *minuend = [NSDecimalNumber decimalNumberWithString:self];
    if (minuend == NSDecimalNumber.notANumber) {
        return self;
    }
    NSDecimalNumber *numberSubtrahend = [NSDecimalNumber decimalNumberWithString:subtrahend];
    if (numberSubtrahend == NSDecimalNumber.notANumber) {
        return self;
    }
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    return [minuend decimalNumberBySubtracting:numberSubtrahend withBehavior:behavior].stringValue;
}

- (NSString *)multiplying:(NSString *)multiplier roundingMode:(NSRoundingMode)roundingMode scale:(NSUInteger)scale {
    NSDecimalNumber *multiplicand = [NSDecimalNumber decimalNumberWithString:self];
    if (multiplicand == NSDecimalNumber.notANumber) {
        return self;
    }
    NSDecimalNumber *numberMultiplier = [NSDecimalNumber decimalNumberWithString:multiplier];
    if (numberMultiplier == NSDecimalNumber.notANumber) {
        return self;
    }
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    return [multiplicand decimalNumberByMultiplyingBy:numberMultiplier withBehavior:behavior].stringValue;
}

- (NSString *)dividing:(NSString *)divisor roundingMode:(NSRoundingMode)roundingMode scale:(NSUInteger)scale {
    NSDecimalNumber *dividend = [NSDecimalNumber decimalNumberWithString:self];
    if (dividend == NSDecimalNumber.notANumber) {
        return self;
    }
    NSDecimalNumber *numberDivisor = [NSDecimalNumber decimalNumberWithString:divisor];
    if (numberDivisor == NSDecimalNumber.notANumber || numberDivisor == NSDecimalNumber.zero) {
        return self;
    }
    NSDecimalNumberHandler *behavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    return [dividend decimalNumberByDividingBy:numberDivisor withBehavior:behavior].stringValue;
}

#pragma mark NSNumberFormatter
- (nullable NSString *)defaultDecimalString {
    return [self addNumberFormatterWithConfigurationHandler:nil];
}

- (NSString *)decimalStringWithFractionDigits:(NSUInteger)length {
    return [self addNumberFormatterWithConfigurationHandler:^(NSNumberFormatter * _Nonnull formatter) {
        formatter.minimumFractionDigits = 0;
        formatter.maximumFractionDigits = length;
        formatter.zeroSymbol = @"0";
    }];
}

- (NSString *)decimalStringWithSuffix:(NSString *)suffix {
    return [self addNumberFormatterWithConfigurationHandler:^(NSNumberFormatter * _Nonnull formatter) {
        formatter.negativeSuffix = suffix;
        formatter.positiveSuffix = suffix;
        formatter.zeroSymbol = [@"0.00" stringByAppendingString:suffix];
    }];
}

- (nullable NSString *)addNumberFormatterWithConfigurationHandler:(void(^)(NSNumberFormatter *formatter))configurationHandler {
    NSDecimalNumber *number = [NSDecimalNumber decimalNumberWithString:self];
    if ([number isEqualToNumber:NSDecimalNumber.notANumber]) {
        return nil;
    }
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"];
    formatter.minimumFractionDigits = 2; // 最小小数位数
    formatter.maximumFractionDigits = 2; // 最大小数位数
    formatter.minimumIntegerDigits = 1; // iOS13以上，0的话会显示 0.00 ， iOS13以下，0显示 .00，所以这里指定最小整数位数
    formatter.negativePrefix = @"-";
    formatter.negativeSuffix = @"";
    formatter.positivePrefix = @"";
    formatter.positiveSuffix = @"";
    formatter.zeroSymbol = @"0.00";
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    configurationHandler ? configurationHandler(formatter) : nil;
    return [formatter stringFromNumber:number];
}

#pragma mark PinYin
- (NSString *)pinyin {
    if (self.length == 0) {
        return self;
    }
    NSMutableString *string = [NSMutableString stringWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)string, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [string uppercaseString];
}

- (NSString *)prefix:(NSUInteger)len {
    if (self.length < len) {
        return self;
    }
    return [self substringToIndex:len];
}

- (NSString *)suffix:(NSUInteger)len {
    if (self.length < len) {
        return self;
    }
    return [self substringFromIndex:(self.length - len)];
}

#pragma mark pathExtension
- (BOOL)isImageFormat {
    NSString *suffix = self.pathExtension.length > 0 ? self.pathExtension : self;
    return [@[@"bmp", @"jpg", @"jpeg", @"png", @"tif", @"gif", @"pcx", @"tga", @"svg", @"psd", @"webp"] containsObject:suffix.lowercaseString];
}

- (BOOL)isPdfFormat {
    NSString *suffix = self.pathExtension.length > 0 ? self.pathExtension : self;
    return [suffix.lowercaseString isEqualToString:@"pdf"];
}

- (BOOL)isWordFormat {
    NSString *suffix = self.pathExtension.length > 0 ? self.pathExtension : self;
    return [@[@"doc", @"docx", @"dotx", @"dotm"] containsObject:suffix.lowercaseString];
}

- (BOOL)isExcelFormat {
    NSString *suffix = self.pathExtension.length > 0 ? self.pathExtension : self;
    return [@[@"xls", @"xlsx", @"xlsm", @"xlt", @"xlsb", @"xltx", @"xltm", @"xlam", @"csv"] containsObject:suffix.lowercaseString];
}

- (BOOL)isPowerpointFormat {
    NSString *suffix = self.pathExtension.length > 0 ? self.pathExtension : self;
    return [@[@"ppt", @"pptx", @"pptm", @"potx", @"potm", @"ppsx", @"ppsm"] containsObject:suffix.lowercaseString];
}

- (BOOL)isOfficeFormat {
    return self.isWordFormat || self.isExcelFormat || self.isPowerpointFormat;
}

- (BOOL)isTextFormat {
    NSString *suffix = self.pathExtension.length > 0 ? self.pathExtension : self;
    return [@[@"txt", @"rtf"] containsObject:suffix.lowercaseString];
}

- (BOOL)isArchiveFormat {
    NSString *suffix = self.pathExtension.length > 0 ? self.pathExtension : self;
    return [@[@"zip", @"rar"] containsObject:suffix.lowercaseString];
}

#pragma mark NSCharacterSet
- (NSString *)removeWhitespace {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
