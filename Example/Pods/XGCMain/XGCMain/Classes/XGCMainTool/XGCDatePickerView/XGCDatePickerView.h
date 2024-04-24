//
//  XGCDatePickerView.h
//  iPadDemo
//
//  Created by 凌志 on 2023/12/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCDatePickerView : UIView
/// 日期 default NSDate date
@property (nonatomic, strong) NSDate *date;
/// 格式 default yyyy-MM-dd
@property (nonatomic, copy) NSString *dateFormat;
/// 标题 default nil
@property (nonatomic, copy, nullable) NSString *title;
/// specify min/max date range. default is nil. When min > max, the values are ignored.
@property (nonatomic, strong, nullable) NSDate *minimumDate;
/// default is nil
@property (nonatomic, strong, nullable) NSDate *maximumDate;
/// 点击确定事件
@property (nonatomic, copy) void(^didSelectDateAction)(XGCDatePickerView *pickerView, NSDate *date);
@end

NS_ASSUME_NONNULL_END
