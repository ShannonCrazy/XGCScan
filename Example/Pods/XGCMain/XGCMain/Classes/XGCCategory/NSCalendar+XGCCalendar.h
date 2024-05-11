//
//  NSCalendar+XGCCalendar.h
//  xinggc
//
//  Created by 凌志 on 2023/11/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSCalendar (XGCCalendar)

/// 返回包含给定日期的给定日历组件的开始时间和持续时间
/// - Parameters:
///   - unit: NSCalendarUnit
///   - date: 指定的日期
+ (nullable NSDateInterval *)dateInterval:(NSCalendarUnit)unit fromDate:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
