//
//  XGCRefreshTableView.m
//  xinggc
//
//  Created by 凌志 on 2023/12/11.
//

#import "XGCRefreshTableView.h"
//
#import "UIImage+XGCImage.h"
// thirdparty
#if __has_include (<MJRefresh/MJRefresh.h>)
#import <MJRefresh/MJRefresh.h>
#endif

#if __has_include (<DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>)
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#endif

@interface XGCRefreshTableView ()
#if __has_include (<DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>)
<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
#endif
@end

@implementation XGCRefreshTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    if (self = [super initWithFrame:frame style:style]) {
#if __has_include (<MJRefresh/MJRefresh.h>)
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshingAction)];
        self.mj_header.automaticallyChangeAlpha = YES;
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefreshingAction)];
#endif
#if __has_include (<DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>)
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
#endif
        self.beginRefreshingWhenDidMoveToSuperView = YES;
        self.startRow = 0;
        self.rows = 10;
    }
    return self;
}

#pragma mark action
- (void)headerRefreshingAction {
    if (!self.refreshDelegate || ![self.refreshDelegate respondsToSelector:@selector(mj_headerRefreshingAction:)]) {
        return;
    }
    [self.refreshDelegate mj_headerRefreshingAction:self];
}

- (void)footerRefreshingAction {
    if (!self.refreshDelegate || ![self.refreshDelegate respondsToSelector:@selector(mj_footerRefreshingAction:)]) {
        return;
    }
    [self.refreshDelegate mj_footerRefreshingAction:self];
}

- (BOOL)isRefreshing {
    return self.mj_header.isRefreshing || self.mj_footer.isRefreshing;
}

- (void)beginRefreshing {
#if __has_include (<MJRefresh/MJRefresh.h>)
    [self.mj_header beginRefreshing];
#endif
}

- (void)endRefreshing {
#if __has_include (<MJRefresh/MJRefresh.h>)
    [self.mj_header endRefreshing];
    self.mj_footer.hidden = NO;
    [self.mj_footer endRefreshing];
#endif
}

- (void)endRefreshingWithNoMoreData {
#if __has_include (<MJRefresh/MJRefresh.h>)
    [self.mj_footer endRefreshingWithNoMoreData];
#endif
}

#pragma mark Lifecycle
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    if (!self.superview) {
        return;
    }
    if (!self.beginRefreshingWhenDidMoveToSuperView) {
        return;
    }
    [self beginRefreshing];
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

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.y >= 0) {
        [scrollView setContentOffset:CGPointZero animated:NO];
    }
    self.mj_footer.hidden = YES;
}

@end
