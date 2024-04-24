//
//  XGCDatePickerView.m
//  iPadDemo
//
//  Created by 凌志 on 2023/12/19.
//

#import "XGCDatePickerView.h"
//
#import "NSDate+XGCDate.h"
#import "XGCConfiguration.h"

static CGFloat const UIDatePickerHeight = 310;

@interface XGCDatePickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIControl *backgroundControl;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIView *toolbar;
@property (nonatomic, strong) UIButton *leftBarButton;
@property (nonatomic, strong) UIButton *rightBarButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, assign, getter=isBeingPresented) BOOL beingPresented;
@property (nonatomic, assign, getter=isEndPresented) BOOL endPresented;
@property (nonatomic, assign, getter=isBeingDismissed) BOOL beingDismissed;
@end

@implementation XGCDatePickerView
#pragma mark lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        // 创建日历
        self.calendar = [NSCalendar currentCalendar];
        self.calendar.firstWeekday = 2;
        self.calendar.timeZone = [NSTimeZone systemTimeZone];
        self.calendar.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        // UI
        self.backgroundControl = ({
            UIControl *control = [[UIControl alloc] initWithFrame:self.bounds];
            control.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.0];
            [control addTarget:self action:@selector(backgroundControlTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:control];
            control;
        });
        self.containerView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - UIDatePickerHeight, CGRectGetWidth(frame), UIDatePickerHeight)];
            view.backgroundColor = UIColor.whiteColor;
            [self addSubview:view];
            view;
        });
        self.toolbar = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), 40.0)];
            [self.containerView addSubview:view];
            view;
        });
        self.leftBarButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitle:@"取消" forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 44.0, CGRectGetHeight(self.toolbar.frame));
            [button setTitleColor:XGCCMI.blueColor forState:UIControlStateNormal];
            [button addTarget:self action:@selector(backgroundControlTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [self.toolbar addSubview:button];
            button;
        });
        self.rightBarButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            [button setTitle:@"确定" forState:UIControlStateNormal];
            [button setTitleColor:XGCCMI.blueColor forState:UIControlStateNormal];
            button.frame = CGRectMake(CGRectGetWidth(self.toolbar.frame) - 44.0, 0, 44.0, CGRectGetHeight(self.toolbar.frame));
            [button addTarget:self action:@selector(rightBarButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
            [self.toolbar addSubview:button];
            button;
        });
        self.titleLabel = ({
            CGFloat x = CGRectGetMaxX(self.leftBarButton.frame);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 0, CGRectGetMinX(self.rightBarButton.frame) - x, CGRectGetHeight(self.toolbar.frame))];
            label.textColor = XGCCMI.labelColor;
            label.font = [UIFont systemFontOfSize:13];
            label.textAlignment = NSTextAlignmentCenter;
            [self.toolbar addSubview:label];
            label;
        });
        ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.toolbar.frame) - 1.0, CGRectGetWidth(self.toolbar.frame), 1.0)];
            view.backgroundColor = UIColor.groupTableViewBackgroundColor;
            [self.toolbar addSubview:view];
        });
        self.pickerView = ({
            CGFloat y = CGRectGetMaxY(self.toolbar.frame);
            UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.containerView.frame), CGRectGetHeight(self.containerView.frame) - y)];
            pickerView.hidden = YES;
            pickerView.delegate = self;
            pickerView.dataSource = self;
            [self.containerView addSubview:pickerView];
            pickerView;
        });
        self.datePicker = ({
            UIDatePicker *picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.containerView.frame), 270)];
            if (@available(iOS 13.4, *)) {
                picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
            }
            picker.locale = self.calendar.locale;
            picker.timeZone = self.calendar.timeZone;
            picker.center = CGPointMake(CGRectGetMidX(self.containerView.bounds), CGRectGetMidY(self.containerView.bounds) + CGRectGetHeight(self.toolbar.frame) / 2.0);
            [picker addTarget:self action:@selector(UIDatePickerValueChangedAction:) forControlEvents:UIControlEventValueChanged];
            [self.containerView addSubview:picker];
            picker;
        });
        // 默认日期
        self.date = [NSDate date];
        self.dateFormat = @"yyyy-MM-dd";
    }
    return self;
}

- (void)safeAreaInsetsDidChange {
    [super safeAreaInsetsDidChange];
    self.containerView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - UIDatePickerHeight - self.safeAreaInsets.bottom, CGRectGetWidth(self.frame), UIDatePickerHeight + self.safeAreaInsets.bottom);
}

- (void)drawRect:(CGRect)rect {
    if (isnan(rect.origin.x) || isnan(rect.origin.y)) {
        return;
    }
    if (self.isBeingPresented) {
        return;
    }
    if (self.isEndPresented) {
        return;
    }
    if (self.isBeingDismissed) {
        return;
    }
    // 默认选中日期
    if (!self.date) {
        self.date = [NSDate date];
    }
    [self selectRowByDate:self.date animated:NO];
    self.datePicker.date = self.date;
    self.datePicker.maximumDate = self.maximumDate;
    self.datePicker.minimumDate = self.minimumDate;
    // 视图动画
    self.beingPresented = YES;
    self.containerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.containerView.frame));
    // 将视图上的键盘回收
    [UIApplication.sharedApplication sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [NSNotificationCenter.defaultCenter postNotificationName:UIKeyboardWillShowNotification object:self];
    void (^animations)(void) = ^(void) {
        self.containerView.transform = CGAffineTransformIdentity;
        self.backgroundControl.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.5];
    };
    void (^completion)(BOOL finished) = ^(BOOL finished) {
        self.beingPresented = NO;
        self.endPresented = YES;
        [NSNotificationCenter.defaultCenter postNotificationName:UIKeyboardDidShowNotification object:self];
    };
    [UIView animateWithDuration:0.25 animations:animations completion:completion];
}

#pragma mark func
- (void)selectRowByDate:(NSDate *)date animated:(BOOL)animated {
    if (!date) {
        return;
    }
    NSDateComponents *components = [self.calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [self.pickerView selectRow:components.year - 1 inComponent:0 animated:animated];
    if ([self.dateFormat containsString:@"MM"]) {
        [self.pickerView selectRow:components.month - 1 inComponent:1 animated:animated];
    } else if ([self.dateFormat containsString:@"qqqq"]) {
        NSInteger quarter = (components.month + 2) / 3;
        [self.pickerView selectRow:quarter - 1 inComponent:1 animated:animated];
    }
}

#pragma mark action
- (void)backgroundControlTouchUpInside {
    self.beingDismissed = YES;
    void (^animations)(void) = ^(void) {
        self.containerView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(self.containerView.frame));
        self.backgroundControl.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.0];
    };
    [UIView animateWithDuration:0.25 animations:animations completion:^(BOOL finished) { [self removeFromSuperview]; }];
}

- (void)rightBarButtonTouchUpInside {
    if (!self.date && !self.datePicker.hidden) {
        self.date = self.datePicker.date;
    }
    self.date = [NSDate dateFromString:[self.date stringFromDateFormat:self.dateFormat] dateFormat:self.dateFormat];
    // 回调
    self.didSelectDateAction ? self.didSelectDateAction(self, self.date) : nil;
    // 销毁页面
    [self backgroundControlTouchUpInside];
}

- (void)UIDatePickerValueChangedAction:(UIDatePicker *)sender {
    self.date = sender.date;
}

#pragma mark - UIPickerViewDelegate, UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if ([self.dateFormat isEqualToString:@"yyyy"]) {
        return 1;
    }
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 10000;
    }
    return [self.dateFormat containsString:@"MM"] ? 12 : 4;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 34.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (component == 0) {
        return [NSString stringWithFormat:@"%zd年", row + 1];
    }
    return [self.dateFormat containsString:@"MM"] ? [NSString stringWithFormat:@"%zd月", row + 1] : [NSString stringWithFormat:@"第%zd季度", row + 1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = [pickerView selectedRowInComponent:0] + 1;
    NSCalendarUnit unit = NSCalendarUnitYear;
    if ([self.dateFormat containsString:@"MM"]) {
        unit = NSCalendarUnitMonth;
        components.month = [pickerView selectedRowInComponent:1] + 1;
    } else if ([self.dateFormat containsString:@"qqqq"]) {
        unit = NSCalendarUnitQuarter;
        components.month = [pickerView selectedRowInComponent:1] * 3 + 1;
    }
    self.date = [self rangeOfUnit:unit forDate:[self.calendar dateFromComponents:components]];
    // 选中
    [self selectRowByDate:self.date animated:YES];
}

/// 判断当前传入的日期是否在允许范围内
- (NSDate *)rangeOfUnit:(NSCalendarUnit)unit forDate:(NSDate *)date {
    if (self.minimumDate && self.maximumDate && [self.maximumDate compare:self.minimumDate] == NSOrderedAscending) {
        return date;
    }
    NSDate *startDate = nil;
    NSTimeInterval duration = 0;
    if (![self.calendar rangeOfUnit:unit startDate:&startDate interval:&duration forDate:date]) {
        return date;
    }
    NSDateInterval *dateInterval = [[NSDateInterval alloc] initWithStartDate:startDate duration:duration];
    // 如果时间范围内的最大值小于最小允许时间
    if (self.minimumDate && [dateInterval.endDate dateByAddingTimeInterval:-1] .timeIntervalSince1970 < self.minimumDate.timeIntervalSince1970) {
        return self.minimumDate;
    }
    // 如果时间范围内的最小值大于最大允许时间
    if (self.maximumDate && dateInterval.startDate.timeIntervalSince1970 > self.maximumDate.timeIntervalSince1970) {
        return self.maximumDate;
    }
    return date;
}

#pragma mark public
- (void)setDateFormat:(NSString *)dateFormat {
    _dateFormat = dateFormat;
    if ([_dateFormat isEqualToString:@"HH:mm"]) {
        self.datePicker.hidden = !(self.pickerView.hidden = YES);
        self.datePicker.datePickerMode = UIDatePickerModeTime;
    } else if ([_dateFormat isEqualToString:@"yyyy-MM-dd"]) {
        self.datePicker.hidden = !(self.pickerView.hidden = YES);
        self.datePicker.datePickerMode = UIDatePickerModeDate;
    } else if ([_dateFormat isEqualToString:@"yyyy-MM-dd HH:mm"]) {
        self.datePicker.hidden = !(self.pickerView.hidden = YES);
        self.datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    } else if ([_dateFormat isEqualToString:@"yyyy"]) { // 年
        self.pickerView.hidden = !(self.datePicker.hidden = YES);
        [self.pickerView reloadAllComponents];
    } else if ([_dateFormat isEqualToString:@"yyyy-MM"]) { // 年-月
        self.pickerView.hidden = !(self.datePicker.hidden = YES);
        [self.pickerView reloadAllComponents];
    } else if ([_dateFormat isEqualToString:@"yyyy-qqqq"]) { // 年-季度
        self.pickerView.hidden = !(self.datePicker.hidden = YES);
        [self.pickerView reloadAllComponents];
    }
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = _title;
}

@end
