//
//  XGCAlertTableViewCell.h
//  iPadDemo
//
//  Created by 凌志 on 2023/12/26.
//

#import <UIKit/UIKit.h>
@class XGCUserDictMapModel;

NS_ASSUME_NONNULL_BEGIN

@interface XGCAlertTableViewCell : UITableViewCell
/// 模型
@property (nonatomic, strong) XGCUserDictMapModel *model;
@end

NS_ASSUME_NONNULL_END
