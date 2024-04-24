//
//  XGCAlertView.h
//  iPadDemo
//
//  Created by 凌志 on 2023/12/26.
//

#import <UIKit/UIKit.h>
#import "XGCUserDictMapModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCAlertView : UIView
/// 标题
@property (nonatomic, copy) NSString *title;
/// 是否允许多选
@property (nonatomic, assign) BOOL allowsMultipleSelection;
/// 是否在有孩子节点的时候可以选择 默认 NO
@property (nonatomic, assign) BOOL enabledWhenHasChildren;
/// 数据源
@property (nonatomic, strong) NSArray <XGCUserDictMapModel *> *dictMaps;
/// 默认值 cCode
@property (nonatomic, strong) NSArray <NSString *> *cCodes;
/// 默认值 cId
@property (nonatomic, strong) NSArray <NSString *> *cIds;
/// 点击确定事件
@property (nonatomic, copy) void(^didSelectDictMapsAction)(XGCAlertView *alertView, NSArray <XGCUserDictMapModel *> *dictMaps);
@end

NS_ASSUME_NONNULL_END
