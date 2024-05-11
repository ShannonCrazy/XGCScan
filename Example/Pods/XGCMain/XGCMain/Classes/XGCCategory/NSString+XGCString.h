//
//  NSString+XGCString.h
//  xinggc
//
//  Created by 凌志 on 2023/11/24.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

CG_INLINE NSString *NSStringValue (NSObject *object) {
    if ([object isKindOfClass:NSNumber.class]) {
        return [NSString stringWithFormat:@"%@",(NSNumber *)object];
    }
    if ([object isKindOfClass:NSString.class]) {
        return (NSString *)object;
    }
    return @"";
};

@interface NSString (XGCString)
/// URL编码
@property (copy, readonly) NSString *URLEncoding;

/// 用正则表达式匹配的方式去除字符串里一些特殊字符，避免UI上的展示问题
/// link: http://www.croton.su/en/uniblock/Diacriticals.html
@property (copy, readonly) NSString *removeMagicalChar;

#pragma mark NSDecimalNumber
/// 加法
/// - Parameters:
///   - addend: 加数
///   - roundingMode: 舍入策略
///   - scale: 保留几位小数
- (NSString *)adding:(NSString *)addend roundingMode:(NSRoundingMode)roundingMode scale:(NSUInteger)scale;

/// 减法
/// - Parameters:
///   - addend: 减数
///   - roundingMode: 舍入策略
///   - scale: 保留几位小数
- (NSString *)subtracting:(NSString *)subtrahend roundingMode:(NSRoundingMode)roundingMode scale:(NSUInteger)scale;

/// 乘法
/// - Parameters:
///   - multiplier: 乘数
///   - roundingMode: 舍入策略
///   - scale: 保留几位小数
- (NSString *)multiplying:(NSString *)multiplier roundingMode:(NSRoundingMode)roundingMode scale:(NSUInteger)scale;

/// 除法
/// - Parameters:
///   - divisor: 除数
///   - roundingMode: 舍入策略
///   - scale: 保留几位小数
- (NSString *)dividing:(NSString *)divisor roundingMode:(NSRoundingMode)roundingMode scale:(NSUInteger)scale;

#pragma mark NSNumberFormatter
@property (nonatomic, copy, readonly, nullable) NSString *defaultDecimalString;
/// 最多保留多少位小数
/// - Parameter length: 小数长度
- (nullable NSString *)decimalStringWithFractionDigits:(NSUInteger)length;
- (nullable NSString *)decimalStringWithSuffix:(NSString *)suffix;
- (nullable NSString *)addNumberFormatterWithConfigurationHandler:(nullable void(^)(NSNumberFormatter *formatter))configurationHandler;

#pragma mark PinYin
/// 如果是中文，那么就是中文的拼音
- (nullable NSString *)pinyin;

/// 前面多少个字符
- (nullable NSString *)prefix:(NSUInteger)len;

/// 后面多少个字符
- (nullable NSString *)suffix:(NSUInteger)len;

#pragma mark pathExtension
/// 是否是图片类型
- (BOOL)isImageFormat;

/// 是否是PDF文件
- (BOOL)isPdfFormat;

/// 是否是Word文件
- (BOOL)isWordFormat;

/// 是否是Excel文件
- (BOOL)isExcelFormat;

/// 是否是Powerpoint文件
- (BOOL)isPowerpointFormat;

/// 是否是office文件
- (BOOL)isOfficeFormat;

/// 是否是纯文本文件
- (BOOL)isTextFormat;

/// 是否是纯压缩包文件
- (BOOL)isArchiveFormat;

/// 是否是视频文件
- (BOOL)isVideoFormat;

#pragma mark NSCharacterSet
- (NSString *)removeWhitespace;
@end

NS_ASSUME_NONNULL_END
