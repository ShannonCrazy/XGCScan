//
//  XGCEmptyTableView.m
//  xinggc
//
//  Created by 凌志 on 2023/12/11.
//

#import "XGCEmptyTableView.h"
// tool
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
//
#import "UIImage+XGCImage.h"

@interface XGCEmptyTableView ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@end

@implementation XGCEmptyTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
    }
    return self;
}

#pragma mark DZNEmptyDataSetSource, DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return self.imageForEmptyDataSet ? self.imageForEmptyDataSet(scrollView) : [UIImage imageNamed:@"main_default" inResource:@"XGCMain"];
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return self.titleForEmptyDataSet ? self.titleForEmptyDataSet(scrollView) : nil;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return self.spaceHeightForEmptyDataSet ? self.spaceHeightForEmptyDataSet(scrollView) : 0;
}

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView {
    return self.emptyDataSetShouldDisplay ? self.emptyDataSetShouldDisplay(scrollView) : YES;
}

- (BOOL)emptyDataSetShouldBeForcedToDisplay:(UIScrollView *)scrollView {
    return self.emptyDataSetShouldBeForcedToDisplay ? self.emptyDataSetShouldBeForcedToDisplay(scrollView) : NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return YES;
}

@end
