//
//  XGCMainAppFuncCodeFormViewController.h
//  iPadDemo
//
//  Created by 凌志 on 2023/12/19.
//

#import "XGCMainAppFuncCodeViewController.h"
//
#import <UIKit/UIKit.h>
// model
#import "XGCMainFormDescriptor.h"

NS_ASSUME_NONNULL_BEGIN

/// 表单提交功能
@interface XGCMainAppFuncCodeFormViewController : XGCMainAppFuncCodeViewController <UITableViewDelegate, UITableViewDataSource>
/// 缩进
@property (nonatomic, assign) UIEdgeInsets contentInset;
/// 表单样式
@property (nonatomic, strong) XGCMainFormDescriptor *descriptor;

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;

- (void)registerClass:(Class)aClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier;

- (void)reloadData;
- (void)beginUpdates;
- (void)endUpdates;

- (void)reloadSection:(__kindof XGCMainFormSectionDescriptor *)section withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadSections:(NSArray <__kindof XGCMainFormSectionDescriptor * > *)sections withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadRowsAtRow:(__kindof XGCMainFormRowDescriptor *)row withRowAnimation:(UITableViewRowAnimation)animation;

- (void)reloadRowsAtRows:(NSArray <__kindof XGCMainFormRowDescriptor *> *)rows withRowAnimation:(UITableViewRowAnimation)animation;

- (void)scrollToRowAtRow:(__kindof XGCMainFormRowDescriptor *)row atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated;

/// 检测数据是否填写
- (BOOL)detectionDescriptor;

- (void)uploadingDescriptor:(void(^)(void))completion;

- (void)uploadingMediasBy:(NSMutableArray <XGCMainFormRowMediaDescriptor *> *)temps firstObject:(XGCMainFormRowMediaDescriptor *)firstObject completion:(void(^)(void))completion;
@end

NS_ASSUME_NONNULL_END
