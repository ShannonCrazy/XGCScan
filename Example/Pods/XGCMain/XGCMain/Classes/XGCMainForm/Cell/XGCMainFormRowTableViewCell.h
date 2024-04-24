//
//  XGCMainFormRowTableViewCell.h
//  iPadDemo
//
//  Created by 凌志 on 2023/12/21.
//

#import <UIKit/UIKit.h>
@class XGCMainFormRowDescriptor;
@class XGCMainFormRowTextFieldDescriptor;
@class XGCMainFormRowTextFieldSelectorDescriptor;
@class XGCMainFormRowTextViewDescriptor;
@class XGCMainFormRowActionDescriptor;
@class XGCMainFormRowDateActionDescriptor;
@class XGCMainFormRowDictMapActionDescriptor;
@class XGCMainFormRowDictMapSelectorDescriptor;
@class XGCMainFormRowStyleValue1Descriptor;
@class XGCMainFormRowStyleSubtitleDescriptor;
@class XGCMainFormRowMediaDescriptor;
@class XGCMainMediaFileJsonModel;

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainFormRowTableViewCell : UITableViewCell
/// 红色的 *
@property (nonatomic, strong) UILabel *cRequiredLabel;
/// 左侧文本
@property (nonatomic, strong) UILabel *cTextLabel;
/// 列表
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong, nullable) XGCMainFormRowDescriptor *descriptor;
@end

@interface XGCMainFormRowTextFieldTableViewCell : XGCMainFormRowTableViewCell
@property (nonatomic, strong, nullable) XGCMainFormRowTextFieldDescriptor *textFieldDescriptor;
@end

@interface XGCMainFormRowTextFieldSelectorTableViewCell : XGCMainFormRowTableViewCell
@property (nonatomic, strong, nullable) XGCMainFormRowTextFieldSelectorDescriptor *textFieldSelectorDescriptor;
@end

@interface XGCMainFormRowTextViewTableViewCell : XGCMainFormRowTableViewCell
@property (nonatomic, strong, nullable) XGCMainFormRowTextViewDescriptor *textViewDescriptor;
@end

@interface XGCMainFormRowActionTableViewCell : XGCMainFormRowTableViewCell
@property (nonatomic, strong, nullable) XGCMainFormRowActionDescriptor *actionDescriptor;

@property (nonatomic, strong, nullable) XGCMainFormRowDateActionDescriptor *dateDescriptor;

@property (nonatomic, strong, nullable) XGCMainFormRowDictMapActionDescriptor *dictMapDescriptor;

@property (nonatomic, copy, nullable) void(^UIControlTouchUpInside)(__kindof XGCMainFormRowDescriptor *descriptor);
@end

@interface XGCMainFormRowDictMapSelectorTableViewCell : XGCMainFormRowTableViewCell
@property (nonatomic, strong, nullable) XGCMainFormRowDictMapSelectorDescriptor *dictMapSelectorDescriptor;
@end

@interface XGCMainFormRowStyleValue1TableViewCell : XGCMainFormRowTableViewCell
@property (nonatomic, strong, nullable) XGCMainFormRowStyleValue1Descriptor *value1Descriptor;
@end

@interface XGCMainFormRowStyleSubtitleTableViewCell : XGCMainFormRowTableViewCell
@property (nonatomic, strong, nullable) XGCMainFormRowStyleSubtitleDescriptor *subtitleDescriptor;
@end

@interface XGCMainFormRowMediaTableViewCell : XGCMainFormRowTableViewCell
@property (nonatomic, strong, nullable) XGCMainFormRowMediaDescriptor *mediaDescriptor;
@property (nonatomic, weak) __kindof UIViewController *aTarget;
@end

NS_ASSUME_NONNULL_END
