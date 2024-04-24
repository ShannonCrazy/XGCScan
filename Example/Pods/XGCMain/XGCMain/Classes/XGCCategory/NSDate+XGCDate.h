//
//  NSDate+XGCDate.h
//  xinggc
//
//  Created by 凌志 on 2023/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (XGCDate)
/// 毫秒
@property (assign, readonly) NSTimeInterval mescTimeIntervalSince1970;

+ (nullable NSDate *)dateWithMsecTimeIntervalSince1970:(NSTimeInterval)msec;

#pragma mark NSDateFormatter
/// 日期转字符串
- (nullable NSString *)stringFromDateFormat:(NSString *)dateFormat;

/// 毫秒转字符串
+ (nullable NSString *)stringFromMsec:(NSTimeInterval)msec dateFormat:(NSString *)dateFormat;

/// 字符串转时间对象
+ (nullable NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat;

#pragma mark NSCalendar
/// 日历对象
@property (class, strong, readonly) NSCalendar *currentCalendar;

/// 是否是今天
@property (assign, readonly) BOOL isDateInToday;

/// 判断是否是昨天
@property (assign, readonly) BOOL isDateInYesterday;

/// 判断是否是明天
@property (assign, readonly) BOOL isDateInTomorrow;

/// 判断是否是今年
@property (assign, readonly) BOOL isDateInThisYear;

/// 判断两个日期是否是同一天
+ (BOOL)isDate:(NSDate *)date1 inSameDayAsDate:(NSDate *)date2;

/// 根据给定的NSCalendarUnit单位比较两个时间对象
+ (BOOL)isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 toUnitGranularity:(NSCalendarUnit)unit;

/// 给定单位(NSCalendarUnit)和数值(value)，获得偏移的日期
- (nullable NSDate *)dateByAddingUnit:(NSCalendarUnit)unit value:(NSInteger)value;

#pragma mark NSDateComponents
/// 给定时间组件对象，偏移时间
- (nullable NSDate *)dateByAddingComponents:(NSDateComponents *)comps;

#pragma mark NSCalendarIdentifierChinese
/// 中国日历
@property (class, strong, readonly) NSCalendar *chineseCalendar;
@end

NS_ASSUME_NONNULL_END
