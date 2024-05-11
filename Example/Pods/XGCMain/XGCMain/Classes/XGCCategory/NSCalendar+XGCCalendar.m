//
//  NSCalendar+XGCCalendar.m
//  xinggc
//
//  Created by 凌志 on 2023/11/24.
//

#import "NSCalendar+XGCCalendar.h"
#import "NSDate+XGCDate.h"

@implementation NSCalendar (XGCCalendar)

+ (NSDateInterval *)dateInterval:(NSCalendarUnit)unit fromDate:(NSDate *)date {
    NSDate *startDate = nil;
    NSTimeInterval duration = 0;
    if (![NSDate.currentCalendar rangeOfUnit:unit startDate:&startDate interval:&duration forDate:date]) {
        return nil;
    }
    return [[NSDateInterval alloc] initWithStartDate:startDate duration:duration];
}

@end
