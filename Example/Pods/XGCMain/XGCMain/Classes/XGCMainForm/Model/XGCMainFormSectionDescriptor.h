//
//  XGCMainFormSectionDescriptor.h
//  iPadDemo
//
//  Created by 凌志 on 2023/12/19.
//

#import <Foundation/Foundation.h>
// model
#import "XGCMainFormRowDescriptor.h"
@class XGCMainFormSectionConfigDescriptor;

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainFormSectionDescriptor : NSObject
@property (nullable, nonatomic, strong) __kindof XGCMainFormSectionConfigDescriptor *headerInSection;
@property (nullable, nonatomic, strong) __kindof XGCMainFormSectionConfigDescriptor *footerInSection;
@property (nullable, nonatomic, strong) NSMutableArray <__kindof XGCMainFormRowDescriptor *> *rows;

+ (instancetype)formSectionDescriptor;
@end

@interface XGCMainFormSectionConfigDescriptor : NSObject
/// default is UITableViewAutomaticDimension
@property (nonatomic, assign) CGFloat rowHeight;
/// 缩进量 default UIEdgeInsetsMake(14.0, 20.0, 14.0, 20.0)
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;
/// 背景颜色
@property (nonatomic, strong, nullable) UIColor *backgroundColor;
@end

@interface XGCMainFormSectionDefaultConfigDescriptor : XGCMainFormSectionConfigDescriptor
/// 字体 default 15
@property (nonatomic, strong) UIFont *font;
/// 标题
@property (nonatomic, copy, nullable) NSString *cDescription;
/// 新增按钮文本，默认 ”新增“
@property (nonatomic, copy, nullable) NSString *title;
/// 新增点击事件
@property (nonatomic, copy, nullable) void(^addButtonTouchUpInsideAction)(XGCMainFormSectionDefaultConfigDescriptor *descriptor);
@end

@interface XGCMainFormSectionCustomConfigDescriptor : XGCMainFormSectionConfigDescriptor
/// 自定义类
@property (nonatomic, strong) Class aClass;
/// 配置HeaderFooterView样式
@property (nonatomic, copy) void(^setupCustomHeaderFooterView)(XGCMainFormSectionCustomConfigDescriptor *descriptor, __kindof UITableViewHeaderFooterView *headerFooterView, NSInteger section);
@end
NS_ASSUME_NONNULL_END
