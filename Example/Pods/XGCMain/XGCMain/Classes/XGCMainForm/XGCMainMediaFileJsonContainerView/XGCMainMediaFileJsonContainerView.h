//
//  XGCMainMediaFileJsonContainerView.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/17.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>
// model
#import "XGCMainMediaFileJsonModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainMediaFileJsonContainerView : UIView
/// 对象
@property (nonatomic, weak) __kindof UIViewController *aTarget;
/// 是否可以编辑
@property(nonatomic, assign, getter=isEditable) BOOL editable;
/// 附件数组
@property (nonatomic, strong) NSMutableArray <XGCMainMediaFileJsonModel *> *fileJsons;
/// 缩进 default UIEdgeInsetsZero. 
@property (nonatomic, assign) UIEdgeInsets contentInset;
@end

NS_ASSUME_NONNULL_END
