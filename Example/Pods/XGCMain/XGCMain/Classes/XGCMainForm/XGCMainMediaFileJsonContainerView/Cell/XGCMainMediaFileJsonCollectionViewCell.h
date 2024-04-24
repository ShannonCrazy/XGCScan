//
//  XGCMainMediaFileJsonCollectionViewCell.h
//  XGCMain_Example
//
//  Created by 凌志 on 2024/4/17.
//  Copyright © 2024 ShannonCrazy. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XGCMainMediaFileJsonModel;

NS_ASSUME_NONNULL_BEGIN

@interface XGCMainMediaFileJsonCollectionViewCell : UICollectionViewCell
/// 附件
@property (nonatomic, strong) XGCMainMediaFileJsonModel *fileJson;
/// 是否可以编辑
@property(nonatomic, assign, getter=isEditable) BOOL editable;
/// 图片
@property (nonatomic, strong, readonly) UIImageView *fileUrlImageView;
/// 查看详情
@property (nonatomic, copy) void (^detailButonTouchUpInsideAction)(XGCMainMediaFileJsonCollectionViewCell *cell, XGCMainMediaFileJsonModel *fileJson);
/// 替换
@property (nonatomic, copy) void (^replaceButtonTouchUpInsideAction)(XGCMainMediaFileJsonCollectionViewCell *cell, XGCMainMediaFileJsonModel *fileJson);
/// 删除
@property (nonatomic, copy) void (^deleteButtonTouchUpInsideAction)(XGCMainMediaFileJsonCollectionViewCell *cell, XGCMainMediaFileJsonModel *fileJson);
@end

NS_ASSUME_NONNULL_END
