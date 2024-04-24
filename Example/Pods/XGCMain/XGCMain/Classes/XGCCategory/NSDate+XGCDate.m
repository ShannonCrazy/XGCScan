//
//  NSDate+XGCDate.m
//  xinggc
//
//  Created by 凌志 on 2023/11/24.
//

#import "NSDate+XGCDate.h"

@implementation NSDate (XGCDate)

- (NSTimeInterval)mescTimeIntervalSince1970 {
    return ceil(self.timeIntervalSince1970 * 1000);
}

+ (NSDate *)dateWithMsecTimeIntervalSince1970:(NSTimeInterval)msec {
    if (msec == 0) {
        return nil;
    }
    return [NSDate dateWithTimeIntervalSince1970:msec / 1000.0];
}

- (NSString *)stringFromDateFormat:(NSString *)dateFormat {
    if (dateFormat.length == 0) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = NSTimeZone.systemTimeZone;
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:self];
}

+ (NSString *)stringFromMsec:(NSTimeInterval)msec dateFormat:(NSString *)dateFormat {
    if (msec == 0 || dateFormat.length == 0) {
        return nil;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:msec / 1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = NSTimeZone.systemTimeZone;
    formatter.dateFormat = dateFormat;
    return [formatter stringFromDate:date];
}

+ (NSDate *)dateFromString:(NSString *)string dateFormat:(NSString *)dateFormat {
    if (string.length == 0 || dateFormat.length == 0) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = NSTimeZone.systemTimeZone;
    formatter.dateFormat = dateFormat;
    return [formatter dateFromString:string];
}

#pragma mark NSCalendar
+ (NSCalendar *)currentCalendar {
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = NSCalendar.currentCalendar;
        calendar.locale = NSLocale.currentLocale;
        calendar.timeZone = NSTimeZone.systemTimeZone;
        calendar.firstWeekday = 2;
    });
    return calendar;
}

- (BOOL)isDateInToday {
    return [NSDate.currentCalendar isDateInToday:self];
}

- (BOOL)isDateInYesterday {
    return [NSDate.currentCalendar isDateInYesterday:self];
}

- (BOOL)isDateInTomorrow {
    return [NSDate.currentCalendar isDateInTomorrow:self];
}

- (BOOL)isDateInThisYear {
    return [NSDate isDate:self equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitYear];
}

+ (BOOL)isDate:(NSDate *)date1 inSameDayAsDate:(NSDate *)date2 {
    return [self isDate:date1 equalToDate:date2 toUnitGranularity:NSCalendarUnitDay];
}

+ (BOOL)isDate:(NSDate *)date1 equalToDate:(NSDate *)date2 toUnitGranularity:(NSCalendarUnit)unit {
    return [NSDate.currentCalendar isDate:date1 equalToDate:date2 toUnitGranularity:unit];
}

- (NSDate *)dateByAddingUnit:(NSCalendarUnit)unit value:(NSInteger)value {
    return [NSDate.currentCalendar dateByAddingUnit:unit value:value toDate:self options:NSCalendarMatchStrictly];
}

#pragma mark NSDateComponents
- (NSDate *)dateByAddingComponents:(NSDateComponents *)comps {
    return [NSDate.currentCalendar dateByAddingComponents:comps toDate:self options:NSCalendarMatchStrictly];
}

#pragma mark NSCalendarIdentifierChinese
+ (NSCalendar *)chineseCalendar {
    static NSCalendar *calendar = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierChinese];
        calendar.timeZone = [NSTimeZone systemTimeZone];
        calendar.firstWeekday = 2;
    });
    return calendar;
}


@end
