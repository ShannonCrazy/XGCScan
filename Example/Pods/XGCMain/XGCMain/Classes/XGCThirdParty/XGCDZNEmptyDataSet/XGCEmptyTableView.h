//
//  XGCEmptyTableView.h
//  xinggc
//
//  Created by 凌志 on 2023/12/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XGCEmptyTableView : UITableView
/// 空白图片
@property (nonatomic, copy) UIImage *(^imageForEmptyDataSet)(UIScrollView *scrollView);
/// 空白文字
@property (nonatomic, copy) NSAttributedString *(^titleForEmptyDataSet)(UIScrollView *scrollView);
/// 空白图片和文字之间间距
@property (nonatomic, copy) CGFloat(^spaceHeightForEmptyDataSet) (UIScrollView *scrollView);
/// 是否要显示空白图片，默认NO
@property (nonatomic, copy) BOOL(^emptyDataSetShouldDisplay)(UIScrollView *scrollView);
/// 项目数量大于0时是否仍应显示空数据集，默认NO
@property (nonatomic, copy) BOOL(^emptyDataSetShouldBeForcedToDisplay)(UIScrollView *scrollView);
@end

NS_ASSUME_NONNULL_END
